-- Views and Functions for Manufacturing Analytics

-- OEE Calculation View
CREATE OR REPLACE VIEW v_oee_calculation AS
SELECT 
    pa.plant_id,
    pa.machine_id,
    pa.production_date,
    pa.shift,
    pa.product_id,
    -- Availability Calculation
    (pa.actual_hours / NULLIF(pp.planned_hours, 0)) * 100 as availability_percentage,
    
    -- Performance Calculation  
    ((pa.actual_quantity * pmm.cycle_time_seconds / 3600) / NULLIF(pa.actual_hours, 0)) * 100 as performance_percentage,
    
    -- Quality Calculation
    (pa.good_quantity / NULLIF(pa.actual_quantity, 0)) * 100 as quality_percentage,
    
    -- OEE Calculation
    ((pa.actual_hours / NULLIF(pp.planned_hours, 0)) * 
     ((pa.actual_quantity * pmm.cycle_time_seconds / 3600) / NULLIF(pa.actual_hours, 0)) * 
     (pa.good_quantity / NULLIF(pa.actual_quantity, 0))) * 100 as oee_percentage,
     
    pa.actual_quantity,
    pa.good_quantity,
    pa.rejected_quantity,
    pa.actual_hours,
    pp.planned_hours
FROM production_actuals pa
LEFT JOIN production_plans pp ON pa.plan_id = pp.plan_id
LEFT JOIN product_machine_mapping pmm ON pa.product_id = pmm.product_id AND pa.machine_id = pmm.machine_id
WHERE pa.actual_hours > 0 AND pp.planned_hours > 0;

-- 5S Score Summary View
CREATE OR REPLACE VIEW v_5s_score_summary AS
SELECT 
    plant_id,
    area_name,
    DATE_TRUNC('month', audit_date) as audit_month,
    AVG(sort_score) as avg_sort_score,
    AVG(set_in_order_score) as avg_set_in_order_score,
    AVG(shine_score) as avg_shine_score,
    AVG(standardize_score) as avg_standardize_score,
    AVG(sustain_score) as avg_sustain_score,
    AVG(overall_score) as avg_overall_score,
    COUNT(*) as audit_count
FROM five_s_audits
GROUP BY plant_id, area_name, DATE_TRUNC('month', audit_date);

-- Abnormality Status Summary View
CREATE OR REPLACE VIEW v_abnormality_summary AS
SELECT 
    plant_id,
    category,
    DATE_TRUNC('month', identified_date) as month_year,
    COUNT(*) as total_identified,
    COUNT(CASE WHEN status = 'CLOSED' THEN 1 END) as total_closed,
    COUNT(CASE WHEN status != 'CLOSED' THEN 1 END) as total_open,
    SUM(estimated_cost) as total_estimated_cost,
    AVG(CASE WHEN actual_closure_date IS NOT NULL 
        THEN actual_closure_date - identified_date END) as avg_closure_days
FROM abnormalities
GROUP BY plant_id, category, DATE_TRUNC('month', identified_date);

-- Cost Analysis View
CREATE OR REPLACE VIEW v_cost_analysis AS
SELECT 
    plant_id,
    cost_date,
    'LABOR' as cost_category,
    SUM(CASE WHEN cost_type = 'VARIABLE' THEN total_cost ELSE 0 END) as variable_cost,
    SUM(CASE WHEN cost_type = 'FIXED' THEN total_cost ELSE 0 END) as fixed_cost,
    SUM(total_cost) as total_cost
FROM labor_costs
GROUP BY plant_id, cost_date

UNION ALL

SELECT 
    plant_id,
    consumption_date as cost_date,
    'POWER' as cost_category,
    SUM(CASE WHEN cost_type = 'VARIABLE' THEN total_cost ELSE 0 END) as variable_cost,
    SUM(CASE WHEN cost_type = 'FIXED' THEN total_cost ELSE 0 END) as fixed_cost,
    SUM(total_cost) as total_cost
FROM power_consumption
GROUP BY plant_id, consumption_date

UNION ALL

SELECT 
    plant_id,
    consumption_date as cost_date,
    'FUEL' as cost_category,
    SUM(CASE WHEN cost_type = 'VARIABLE' THEN total_cost ELSE 0 END) as variable_cost,
    SUM(CASE WHEN cost_type = 'FIXED' THEN total_cost ELSE 0 END) as fixed_cost,
    SUM(total_cost) as total_cost
FROM fuel_consumption
GROUP BY plant_id, consumption_date

UNION ALL

SELECT 
    plant_id,
    maintenance_date as cost_date,
    'MAINTENANCE' as cost_category,
    0 as variable_cost,
    SUM(total_cost) as fixed_cost,
    SUM(total_cost) as total_cost
FROM maintenance_costs
GROUP BY plant_id, maintenance_date;

-- MTBF/MTTR Calculation Function
CREATE OR REPLACE FUNCTION calculate_mtbf_mttr(
    p_machine_id INTEGER,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS TABLE(
    machine_id INTEGER,
    mtbf_hours DECIMAL(10,2),
    mttr_hours DECIMAL(10,2),
    total_downtime_hours DECIMAL(10,2),
    breakdown_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p_machine_id,
        CASE 
            WHEN COUNT(*) > 0 THEN 
                (EXTRACT(EPOCH FROM (p_end_date - p_start_date)) / 3600.0) / COUNT(*)
            ELSE 0
        END as mtbf_hours,
        CASE 
            WHEN COUNT(*) > 0 THEN 
                AVG(duration_minutes / 60.0)
            ELSE 0
        END as mttr_hours,
        COALESCE(SUM(duration_minutes / 60.0), 0) as total_downtime_hours,
        COUNT(*)::INTEGER as breakdown_count
    FROM machine_downtime
    WHERE machine_downtime.machine_id = p_machine_id
    AND downtime_start::date BETWEEN p_start_date AND p_end_date
    AND status = 'CLOSED';
END;
$$ LANGUAGE plpgsql;

-- Individual Performance Summary View
CREATE OR REPLACE VIEW v_individual_performance AS
SELECT 
    e.employee_id,
    e.employee_code,
    e.employee_name,
    e.plant_id,
    e.department,
    
    -- Abnormalities
    COUNT(DISTINCT a.abnormality_id) as abnormalities_identified,
    COUNT(DISTINCT CASE WHEN a.status = 'CLOSED' THEN a.abnormality_id END) as abnormalities_closed,
    
    -- Kaizens
    COUNT(DISTINCT k.kaizen_id) as kaizens_suggested,
    COUNT(DISTINCT CASE WHEN k.status = 'IMPLEMENTED' THEN k.kaizen_id END) as kaizens_implemented,
    
    -- Training
    COUNT(DISTINCT tr.training_id) as trainings_attended,
    SUM(DISTINCT tr.duration_hours) as total_training_hours,
    
    -- Tags
    COUNT(DISTINCT CASE WHEN tm.tag_type = 'RED' THEN tm.tag_id END) as red_tags_identified,
    COUNT(DISTINCT CASE WHEN tm.tag_type = 'WHITE' AND tm.status = 'CLOSED' THEN tm.tag_id END) as white_tags_closed,
    
    -- Skills
    COUNT(DISTINCT sm.skill_id) as total_skills,
    AVG(sm.current_level) as avg_skill_level
    
FROM employees e
LEFT JOIN abnormalities a ON e.employee_id = a.identified_by
LEFT JOIN kaizens k ON e.employee_id = k.suggested_by
LEFT JOIN training_records tr ON e.employee_id = tr.employee_id
LEFT JOIN tag_management tm ON e.employee_id = tm.tagged_by
LEFT JOIN skill_matrix sm ON e.employee_id = sm.employee_id
WHERE e.is_active = true
GROUP BY e.employee_id, e.employee_code, e.employee_name, e.plant_id, e.department;
