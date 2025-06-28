-- Delivery, Safety, and Environment Tables

-- Dispatch Planning and Actuals
CREATE TABLE dispatch_records (
    dispatch_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    product_id INTEGER REFERENCES products(product_id),
    dispatch_date DATE NOT NULL,
    planned_quantity DECIMAL(10,2),
    actual_quantity DECIMAL(10,2),
    destination_depot VARCHAR(100),
    vehicle_number VARCHAR(20),
    freight_cost DECIMAL(10,2),
    freight_cost_per_unit DECIMAL(8,4),
    dispatch_status VARCHAR(20) DEFAULT 'PLANNED', -- PLANNED, DISPATCHED, IN_TRANSIT, DELIVERED
    delivery_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for dispatch records
CREATE INDEX idx_dispatch_date ON dispatch_records(dispatch_date);
CREATE INDEX idx_dispatch_product ON dispatch_records(product_id);
CREATE INDEX idx_dispatch_depot ON dispatch_records(destination_depot);

-- Stock Availability
CREATE TABLE stock_availability (
    stock_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    product_id INTEGER REFERENCES products(product_id),
    depot_location VARCHAR(100),
    stock_date DATE NOT NULL,
    opening_stock DECIMAL(10,2),
    production_added DECIMAL(10,2),
    dispatched_quantity DECIMAL(10,2),
    closing_stock DECIMAL(10,2),
    minimum_stock_level DECIMAL(10,2),
    maximum_stock_level DECIMAL(10,2),
    stock_availability_percentage DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for stock availability
CREATE INDEX idx_stock_date ON stock_availability(stock_date);
CREATE INDEX idx_stock_product ON stock_availability(product_id);

-- Safety Incidents
CREATE TABLE safety_incidents (
    incident_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    incident_date DATE NOT NULL,
    incident_time TIME,
    incident_type VARCHAR(50), -- NEAR_MISS, FIRST_AID, MEDICAL_TREATMENT, LOST_TIME_INJURY, FATALITY
    location VARCHAR(200),
    description TEXT NOT NULL,
    injured_person_id INTEGER REFERENCES employees(employee_id),
    injury_type VARCHAR(100),
    body_part_affected VARCHAR(100),
    days_lost INTEGER DEFAULT 0,
    immediate_cause TEXT,
    root_cause TEXT,
    corrective_action TEXT,
    preventive_action TEXT,
    reported_by INTEGER REFERENCES employees(employee_id),
    investigated_by INTEGER REFERENCES employees(employee_id),
    status VARCHAR(20) DEFAULT 'REPORTED', -- REPORTED, INVESTIGATING, CLOSED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for safety incidents
CREATE INDEX idx_safety_incidents_date ON safety_incidents(incident_date);
CREATE INDEX idx_safety_incidents_type ON safety_incidents(incident_type);
CREATE INDEX idx_safety_incidents_status ON safety_incidents(status);

-- PPE Compliance Tracking
CREATE TABLE ppe_compliance (
    compliance_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    audit_date DATE NOT NULL,
    auditor_id INTEGER REFERENCES employees(employee_id),
    helmet_compliance BOOLEAN DEFAULT false,
    safety_shoes_compliance BOOLEAN DEFAULT false,
    safety_glasses_compliance BOOLEAN DEFAULT false,
    gloves_compliance BOOLEAN DEFAULT false,
    ear_protection_compliance BOOLEAN DEFAULT false,
    overall_compliance_percentage DECIMAL(5,2),
    non_compliance_reason TEXT,
    corrective_action TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for PPE compliance
CREATE INDEX idx_ppe_compliance_date ON ppe_compliance(audit_date);
CREATE INDEX idx_ppe_compliance_employee ON ppe_compliance(employee_id);

-- Environmental Data
CREATE TABLE environmental_data (
    env_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    measurement_date DATE NOT NULL,
    scope1_emissions DECIMAL(10,3), -- Direct emissions in tCO2e
    scope2_emissions DECIMAL(10,3), -- Indirect emissions in tCO2e
    water_consumption DECIMAL(12,3), -- in liters
    water_discharge DECIMAL(12,3), -- in liters
    hazardous_waste_generated DECIMAL(10,3), -- in kg
    non_hazardous_waste_generated DECIMAL(10,3), -- in kg
    waste_recycled DECIMAL(10,3), -- in kg
    energy_consumption DECIMAL(12,3), -- in kWh
    renewable_energy_used DECIMAL(12,3), -- in kWh
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for environmental data
CREATE INDEX idx_environmental_data_date ON environmental_data(measurement_date);
CREATE INDEX idx_environmental_data_plant ON environmental_data(plant_id);

-- Training Records
CREATE TABLE training_records (
    training_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    training_program VARCHAR(200) NOT NULL,
    training_category VARCHAR(50), -- SAFETY, TECHNICAL, QUALITY, LEADERSHIP
    training_date DATE NOT NULL,
    duration_hours DECIMAL(6,2),
    trainer_name VARCHAR(100),
    training_provider VARCHAR(100),
    certification_obtained BOOLEAN DEFAULT false,
    certification_expiry_date DATE,
    effectiveness_rating INTEGER CHECK (effectiveness_rating >= 1 AND effectiveness_rating <= 5),
    cost DECIMAL(8,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for training records
CREATE INDEX idx_training_date ON training_records(training_date);
CREATE INDEX idx_training_employee ON training_records(employee_id);
CREATE INDEX idx_training_category ON training_records(training_category);

-- Skill Matrix
CREATE TABLE skill_matrix (
    skill_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    skill_name VARCHAR(100) NOT NULL,
    skill_category VARCHAR(50),
    current_level INTEGER CHECK (current_level >= 1 AND current_level <= 5), -- 1=Beginner, 5=Expert
    target_level INTEGER CHECK (target_level >= 1 AND target_level <= 5),
    last_assessed_date DATE,
    assessor_id INTEGER REFERENCES employees(employee_id),
    certification_required BOOLEAN DEFAULT false,
    certification_status VARCHAR(20), -- PENDING, CERTIFIED, EXPIRED
    next_assessment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for skill matrix
CREATE INDEX idx_skill_matrix_employee ON skill_matrix(employee_id);
CREATE INDEX idx_skill_matrix_skill ON skill_matrix(skill_name);
CREATE INDEX idx_skill_matrix_level ON skill_matrix(current_level);
