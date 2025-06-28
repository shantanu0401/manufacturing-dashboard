-- TPM (Total Productive Maintenance) Specific Tables

-- 5S Audit Records
CREATE TABLE five_s_audits (
    audit_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    area_name VARCHAR(100) NOT NULL,
    audit_date DATE NOT NULL,
    auditor_id INTEGER REFERENCES employees(employee_id),
    sort_score INTEGER CHECK (sort_score >= 0 AND sort_score <= 100),
    set_in_order_score INTEGER CHECK (set_in_order_score >= 0 AND set_in_order_score <= 100),
    shine_score INTEGER CHECK (shine_score >= 0 AND shine_score <= 100),
    standardize_score INTEGER CHECK (standardize_score >= 0 AND standardize_score <= 100),
    sustain_score INTEGER CHECK (sustain_score >= 0 AND sustain_score <= 100),
    overall_score INTEGER CHECK (overall_score >= 0 AND overall_score <= 100),
    observations TEXT,
    action_items TEXT,
    next_audit_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for 5S audits
CREATE INDEX idx_5s_audits_date ON five_s_audits(audit_date);
CREATE INDEX idx_5s_audits_plant ON five_s_audits(plant_id);
CREATE INDEX idx_5s_audits_area ON five_s_audits(area_name);

-- Abnormalities/Issues Tracking
CREATE TABLE abnormalities (
    abnormality_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    identified_by INTEGER REFERENCES employees(employee_id),
    identified_date DATE NOT NULL,
    category VARCHAR(50) NOT NULL, -- Minor Flaws, Basic Conditions, Inaccessible Places, etc.
    subcategory VARCHAR(100),
    description TEXT NOT NULL,
    location VARCHAR(200),
    severity VARCHAR(20), -- Low, Medium, High, Critical
    estimated_cost DECIMAL(10,2),
    spare_parts_required TEXT,
    assigned_to INTEGER REFERENCES employees(employee_id),
    target_closure_date DATE,
    actual_closure_date DATE,
    closure_remarks TEXT,
    status VARCHAR(20) DEFAULT 'IDENTIFIED', -- IDENTIFIED, ASSIGNED, IN_PROGRESS, CLOSED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for abnormalities
CREATE INDEX idx_abnormalities_date ON abnormalities(identified_date);
CREATE INDEX idx_abnormalities_category ON abnormalities(category);
CREATE INDEX idx_abnormalities_status ON abnormalities(status);
CREATE INDEX idx_abnormalities_machine ON abnormalities(machine_id);

-- Red Tag/White Tag Management
CREATE TABLE tag_management (
    tag_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    tag_number VARCHAR(20) UNIQUE NOT NULL,
    tag_type VARCHAR(10) NOT NULL, -- RED, WHITE
    tagged_by INTEGER REFERENCES employees(employee_id),
    tagged_date DATE NOT NULL,
    item_description TEXT NOT NULL,
    location VARCHAR(200),
    reason_for_tagging TEXT,
    estimated_value DECIMAL(10,2),
    disposal_method VARCHAR(100),
    assigned_to INTEGER REFERENCES employees(employee_id),
    target_closure_date DATE,
    actual_closure_date DATE,
    closure_action TEXT,
    status VARCHAR(20) DEFAULT 'TAGGED', -- TAGGED, ASSIGNED, DISPOSED, CLOSED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for tag management
CREATE INDEX idx_tags_date ON tag_management(tagged_date);
CREATE INDEX idx_tags_type ON tag_management(tag_type);
CREATE INDEX idx_tags_status ON tag_management(status);

-- Kaizen Suggestions and Implementation
CREATE TABLE kaizens (
    kaizen_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    suggested_by INTEGER REFERENCES employees(employee_id),
    suggestion_date DATE NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    current_state TEXT,
    proposed_state TEXT,
    category VARCHAR(10) NOT NULL, -- P, Q, C, D, S, E, M (PQCDSEM)
    area_of_impact VARCHAR(100),
    estimated_savings DECIMAL(10,2),
    implementation_cost DECIMAL(10,2),
    assigned_to INTEGER REFERENCES employees(employee_id),
    implementation_date DATE,
    actual_savings DECIMAL(10,2),
    replication_sites TEXT,
    status VARCHAR(20) DEFAULT 'SUBMITTED', -- SUBMITTED, APPROVED, IMPLEMENTED, REPLICATED, REJECTED
    approval_date DATE,
    approved_by INTEGER REFERENCES employees(employee_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for kaizens
CREATE INDEX idx_kaizens_date ON kaizens(suggestion_date);
CREATE INDEX idx_kaizens_category ON kaizens(category);
CREATE INDEX idx_kaizens_status ON kaizens(status);
CREATE INDEX idx_kaizens_suggested_by ON kaizens(suggested_by);

-- Root Cause Analysis
CREATE TABLE root_cause_analysis (
    rca_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    incident_date DATE NOT NULL,
    incident_description TEXT NOT NULL,
    loss_category VARCHAR(50), -- Based on 8 Basic Losses
    initiated_by INTEGER REFERENCES employees(employee_id),
    rca_team_members TEXT,
    problem_statement TEXT,
    root_cause TEXT,
    corrective_actions TEXT,
    preventive_actions TEXT,
    implementation_date DATE,
    verification_date DATE,
    effectiveness_check TEXT,
    is_repeated_failure BOOLEAN DEFAULT false,
    previous_rca_id INTEGER REFERENCES root_cause_analysis(rca_id),
    status VARCHAR(20) DEFAULT 'INITIATED', -- INITIATED, IN_PROGRESS, COMPLETED, VERIFIED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for RCA
CREATE INDEX idx_rca_date ON root_cause_analysis(incident_date);
CREATE INDEX idx_rca_machine ON root_cause_analysis(machine_id);
CREATE INDEX idx_rca_status ON root_cause_analysis(status);
CREATE INDEX idx_rca_loss_category ON root_cause_analysis(loss_category);
