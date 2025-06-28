-- Sample Data for Manufacturing Analytics Dashboard

-- Insert Sample Plants
INSERT INTO plants (plant_code, plant_name, location, region, plant_type, capacity_rating) VALUES
('P001', 'Manufacturing Plant Alpha', 'Mumbai, Maharashtra', 'West', 'Production', 1000.00),
('P002', 'Manufacturing Plant Beta', 'Chennai, Tamil Nadu', 'South', 'Production', 800.00),
('P003', 'Manufacturing Plant Gamma', 'Pune, Maharashtra', 'West', 'Production', 1200.00);

-- Insert Sample Products
INSERT INTO products (sku_code, product_name, product_category, product_family, unit_of_measure, standard_cost, target_yield) VALUES
('SKU001', 'Product Alpha 500ml', 'Beverages', 'Alpha Series', 'Bottles', 25.50, 98.50),
('SKU002', 'Product Beta 1L', 'Beverages', 'Beta Series', 'Bottles', 45.75, 97.80),
('SKU003', 'Product Gamma 250ml', 'Beverages', 'Gamma Series', 'Bottles', 18.25, 99.20);

-- Insert Sample Machines
INSERT INTO machines (machine_code, machine_name, plant_id, machine_type, manufacturer, model, rated_capacity, power_rating, fuel_consumption_rate) VALUES
('M001', 'Filling Line 1', 1, 'Filling Machine', 'TechCorp', 'FL-2000', 500.00, 75.50, 0.00),
('M002', 'Packaging Line 1', 1, 'Packaging Machine', 'PackTech', 'PL-1500', 400.00, 45.25, 0.00),
('M003', 'Filling Line 2', 2, 'Filling Machine', 'TechCorp', 'FL-2000', 500.00, 75.50, 0.00),
('M004', 'Boiler Unit 1', 1, 'Boiler', 'SteamTech', 'ST-500', 200.00, 0.00, 15.75);

-- Insert Sample Employees
INSERT INTO employees (employee_code, employee_name, plant_id, department, designation, shift, hourly_rate) VALUES
('E001', 'John Smith', 1, 'Production', 'Operator', 'A', 15.50),
('E002', 'Jane Doe', 1, 'Quality', 'QC Inspector', 'A', 18.75),
('E003', 'Mike Johnson', 1, 'Maintenance', 'Technician', 'A', 22.00),
('E004', 'Sarah Wilson', 2, 'Production', 'Supervisor', 'A', 28.50),
('E005', 'David Brown', 1, 'Production', 'Operator', 'B', 15.50);

-- Insert Sample Production Plans
INSERT INTO production_plans (plant_id, product_id, machine_id, plan_date, planned_quantity, planned_hours, shift, priority) VALUES
(1, 1, 1, CURRENT_DATE, 1000.00, 8.00, 'A', 1),
(1, 2, 1, CURRENT_DATE, 800.00, 8.00, 'B', 2),
(2, 1, 3, CURRENT_DATE, 1200.00, 8.00, 'A', 1);

-- Insert Sample Production Actuals
INSERT INTO production_actuals (plan_id, plant_id, product_id, machine_id, operator_id, production_date, shift, actual_quantity, good_quantity, rejected_quantity, actual_hours) VALUES
(1, 1, 1, 1, 1, CURRENT_DATE, 'A', 950.00, 920.00, 30.00, 7.80),
(2, 1, 2, 1, 5, CURRENT_DATE, 'B', 780.00, 765.00, 15.00, 8.20),
(3, 2, 1, 3, 4, CURRENT_DATE, 'A', 1150.00, 1125.00, 25.00, 7.90);

-- Insert Sample 5S Audit Data
INSERT INTO five_s_audits (plant_id, area_name, audit_date, auditor_id, sort_score, set_in_order_score, shine_score, standardize_score, sustain_score, overall_score) VALUES
(1, 'Production Floor A', CURRENT_DATE - INTERVAL '1 day', 2, 85, 72, 80, 75, 78, 78),
(1, 'Packaging Area', CURRENT_DATE - INTERVAL '1 day', 2, 90, 85, 88, 82, 85, 86),
(2, 'Production Floor B', CURRENT_DATE - INTERVAL '1 day', 4, 78, 70, 75, 72, 74, 74);

-- Insert Sample Abnormalities
INSERT INTO abnormalities (plant_id, machine_id, identified_by, identified_date, category, description, severity, estimated_cost, status) VALUES
(1, 1, 1, CURRENT_DATE - INTERVAL '5 days', 'Minor Flaws', 'Oil leak in hydraulic system', 'Medium', 250.00, 'IDENTIFIED'),
(1, 2, 3, CURRENT_DATE - INTERVAL '3 days', 'Basic Conditions', 'Missing safety guard on conveyor', 'High', 150.00, 'ASSIGNED'),
(2, 3, 4, CURRENT_DATE - INTERVAL '7 days', 'Contamination Sources', 'Dust accumulation in control panel', 'Low', 75.00, 'CLOSED');

-- Insert Sample Kaizens
INSERT INTO kaizens (plant_id, suggested_by, suggestion_date, title, description, category, estimated_savings, status) VALUES
(1, 1, CURRENT_DATE - INTERVAL '10 days', 'Reduce Setup Time', 'Implement quick changeover techniques to reduce setup time by 30%', 'P', 5000.00, 'APPROVED'),
(1, 2, CURRENT_DATE - INTERVAL '8 days', 'Quality Check Automation', 'Automate visual inspection to reduce defects', 'Q', 3500.00, 'IMPLEMENTED'),
(2, 4, CURRENT_DATE - INTERVAL '12 days', 'Energy Saving Initiative', 'Install LED lighting to reduce power consumption', 'C', 2000.00, 'IMPLEMENTED');

-- Insert Sample Machine Downtime
INSERT INTO machine_downtime (machine_id, plant_id, downtime_start, downtime_end, duration_minutes, downtime_category, downtime_reason, loss_type, status) VALUES
(1, 1, CURRENT_TIMESTAMP - INTERVAL '2 days 3 hours', CURRENT_TIMESTAMP - INTERVAL '2 days 1 hour', 120, 'Mechanical', 'Bearing failure', 'Breakdown', 'CLOSED'),
(2, 1, CURRENT_TIMESTAMP - INTERVAL '1 day 2 hours', CURRENT_TIMESTAMP - INTERVAL '1 day 1.5 hours', 30, 'Electrical', 'Motor overheating', 'Minor Stoppage', 'CLOSED'),
(3, 2, CURRENT_TIMESTAMP - INTERVAL '3 days 4 hours', CURRENT_TIMESTAMP - INTERVAL '3 days 2 hours', 120, 'Instrumentation', 'Sensor calibration', 'Setup', 'CLOSED');

-- Insert Sample Safety Incidents
INSERT INTO safety_incidents (plant_id, incident_date, incident_type, location, description, injured_person_id, reported_by, status) VALUES
(1, CURRENT_DATE - INTERVAL '15 days', 'NEAR_MISS', 'Production Floor A', 'Worker almost slipped on wet floor', NULL, 1, 'CLOSED'),
(2, CURRENT_DATE - INTERVAL '20 days', 'FIRST_AID', 'Packaging Area', 'Minor cut on hand while handling materials', 4, 4, 'CLOSED'),
(1, CURRENT_DATE - INTERVAL '5 days', 'NEAR_MISS', 'Maintenance Shop', 'Tool fell from height, no injury', NULL, 3, 'INVESTIGATING');

-- Insert Sample Environmental Data
INSERT INTO environmental_data (plant_id, measurement_date, scope1_emissions, scope2_emissions, water_consumption, hazardous_waste_generated, energy_consumption) VALUES
(1, CURRENT_DATE - INTERVAL '1 month', 125.50, 89.25, 15000.00, 2.50, 45000.00),
(2, CURRENT_DATE - INTERVAL '1 month', 98.75, 72.50, 12000.00, 1.80, 38000.00),
(1, CURRENT_DATE, 118.25, 85.75, 14500.00, 2.20, 43500.00);

-- Insert Sample Training Records
INSERT INTO training_records (plant_id, employee_id, training_program, training_category, training_date, duration_hours, effectiveness_rating) VALUES
(1, 1, 'Safety Procedures', 'SAFETY', CURRENT_DATE - INTERVAL '30 days', 8.00, 4),
(1, 2, 'Quality Control Methods', 'QUALITY', CURRENT_DATE - INTERVAL '25 days', 16.00, 5),
(1, 3, 'Preventive Maintenance', 'TECHNICAL', CURRENT_DATE - INTERVAL '20 days', 12.00, 4),
(2, 4, 'Leadership Skills', 'LEADERSHIP', CURRENT_DATE - INTERVAL '15 days', 24.00, 4);

-- Insert Sample Skill Matrix
INSERT INTO skill_matrix (employee_id, skill_name, skill_category, current_level, target_level, last_assessed_date) VALUES
(1, 'Machine Operation', 'Technical', 4, 5, CURRENT_DATE - INTERVAL '60 days'),
(1, 'Quality Inspection', 'Quality', 3, 4, CURRENT_DATE - INTERVAL '60 days'),
(2, 'Statistical Process Control', 'Quality', 5, 5, CURRENT_DATE - INTERVAL '45 days'),
(3, 'Electrical Troubleshooting', 'Technical', 4, 4, CURRENT_DATE - INTERVAL '30 days'),
(4, 'Team Leadership', 'Leadership', 4, 5, CURRENT_DATE - INTERVAL '90 days');
