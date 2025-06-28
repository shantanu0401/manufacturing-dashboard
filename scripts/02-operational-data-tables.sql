-- Operational Data Tables for Manufacturing Analytics

-- Production Planning
CREATE TABLE production_plans (
    plan_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    product_id INTEGER REFERENCES products(product_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    plan_date DATE NOT NULL,
    planned_quantity DECIMAL(10,2),
    planned_hours DECIMAL(8,2),
    shift VARCHAR(10),
    priority INTEGER DEFAULT 1,
    status VARCHAR(20) DEFAULT 'PLANNED', -- PLANNED, IN_PROGRESS, COMPLETED, CANCELLED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for production plans
CREATE INDEX idx_production_plans_date ON production_plans(plan_date);
CREATE INDEX idx_production_plans_plant ON production_plans(plant_id);
CREATE INDEX idx_production_plans_machine ON production_plans(machine_id);
CREATE INDEX idx_production_plans_status ON production_plans(status);

-- Production Actuals
CREATE TABLE production_actuals (
    actual_id SERIAL PRIMARY KEY,
    plan_id INTEGER REFERENCES production_plans(plan_id),
    plant_id INTEGER REFERENCES plants(plant_id),
    product_id INTEGER REFERENCES products(product_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    operator_id INTEGER REFERENCES employees(employee_id),
    production_date DATE NOT NULL,
    shift VARCHAR(10),
    actual_quantity DECIMAL(10,2),
    good_quantity DECIMAL(10,2),
    rejected_quantity DECIMAL(10,2),
    rework_quantity DECIMAL(10,2),
    actual_hours DECIMAL(8,2),
    setup_time_minutes INTEGER,
    changeover_time_minutes INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for production actuals
CREATE INDEX idx_production_actuals_date ON production_actuals(production_date);
CREATE INDEX idx_production_actuals_plant ON production_actuals(plant_id);
CREATE INDEX idx_production_actuals_machine ON production_actuals(machine_id);
CREATE INDEX idx_production_actuals_plan ON production_actuals(plan_id);

-- Machine Downtime Records
CREATE TABLE machine_downtime (
    downtime_id SERIAL PRIMARY KEY,
    machine_id INTEGER REFERENCES machines(machine_id),
    plant_id INTEGER REFERENCES plants(plant_id),
    downtime_start TIMESTAMP NOT NULL,
    downtime_end TIMESTAMP,
    duration_minutes INTEGER,
    downtime_category VARCHAR(50), -- Mechanical, Electrical, Instrumentation, Setting
    downtime_reason VARCHAR(200),
    loss_type VARCHAR(50), -- Breakdown, Setup, Minor Stoppage, Speed Loss, etc.
    impact_on_production DECIMAL(10,2),
    operator_id INTEGER REFERENCES employees(employee_id),
    maintenance_person_id INTEGER REFERENCES employees(employee_id),
    spare_parts_used TEXT,
    cost_impact DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'OPEN', -- OPEN, UNDER_REPAIR, CLOSED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for machine downtime
CREATE INDEX idx_downtime_machine ON machine_downtime(machine_id);
CREATE INDEX idx_downtime_start_time ON machine_downtime(downtime_start);
CREATE INDEX idx_downtime_category ON machine_downtime(downtime_category);
CREATE INDEX idx_downtime_status ON machine_downtime(status);

-- Quality Control Records
CREATE TABLE quality_control (
    qc_id SERIAL PRIMARY KEY,
    production_actual_id INTEGER REFERENCES production_actuals(actual_id),
    plant_id INTEGER REFERENCES plants(plant_id),
    product_id INTEGER REFERENCES products(product_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    inspection_date DATE NOT NULL,
    inspector_id INTEGER REFERENCES employees(employee_id),
    batch_number VARCHAR(50),
    sample_size INTEGER,
    defects_found INTEGER,
    defect_category VARCHAR(100),
    defect_description TEXT,
    corrective_action TEXT,
    cp_value DECIMAL(6,3),
    cpk_value DECIMAL(6,3),
    first_pass_yield DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for quality control
CREATE INDEX idx_qc_date ON quality_control(inspection_date);
CREATE INDEX idx_qc_product ON quality_control(product_id);
CREATE INDEX idx_qc_machine ON quality_control(machine_id);
CREATE INDEX idx_qc_batch ON quality_control(batch_number);

-- Market Complaints
CREATE TABLE market_complaints (
    complaint_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    product_id INTEGER REFERENCES products(product_id),
    complaint_date DATE NOT NULL,
    customer_name VARCHAR(200),
    complaint_category VARCHAR(100),
    complaint_description TEXT,
    severity VARCHAR(20), -- Low, Medium, High, Critical
    batch_number VARCHAR(50),
    quantity_affected DECIMAL(10,2),
    cost_impact DECIMAL(10,2),
    root_cause TEXT,
    corrective_action TEXT,
    preventive_action TEXT,
    status VARCHAR(20) DEFAULT 'OPEN', -- OPEN, INVESTIGATING, RESOLVED, CLOSED
    assigned_to INTEGER REFERENCES employees(employee_id),
    resolution_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for market complaints
CREATE INDEX idx_complaints_date ON market_complaints(complaint_date);
CREATE INDEX idx_complaints_product ON market_complaints(product_id);
CREATE INDEX idx_complaints_severity ON market_complaints(severity);
CREATE INDEX idx_complaints_status ON market_complaints(status);
