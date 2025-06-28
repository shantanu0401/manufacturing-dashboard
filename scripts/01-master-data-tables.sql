-- Master Data Tables for Manufacturing Analytics Dashboard

-- Plants/Sites Master
CREATE TABLE plants (
    plant_id SERIAL PRIMARY KEY,
    plant_code VARCHAR(10) UNIQUE NOT NULL,
    plant_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    region VARCHAR(50),
    plant_type VARCHAR(30),
    capacity_rating DECIMAL(10,2),
    established_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Machines/Equipment Master
CREATE TABLE machines (
    machine_id SERIAL PRIMARY KEY,
    machine_code VARCHAR(20) UNIQUE NOT NULL,
    machine_name VARCHAR(100) NOT NULL,
    plant_id INTEGER REFERENCES plants(plant_id),
    machine_type VARCHAR(50),
    manufacturer VARCHAR(100),
    model VARCHAR(50),
    installation_date DATE,
    rated_capacity DECIMAL(10,2),
    power_rating DECIMAL(8,2), -- in KW
    fuel_consumption_rate DECIMAL(8,4), -- liters per hour
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for machines
CREATE INDEX idx_machines_plant_id ON machines(plant_id);
CREATE INDEX idx_machines_type ON machines(machine_type);
CREATE INDEX idx_machines_active ON machines(is_active);

-- Products/SKUs Master
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku_code VARCHAR(30) UNIQUE NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    product_category VARCHAR(50),
    product_family VARCHAR(50),
    unit_of_measure VARCHAR(10),
    standard_cost DECIMAL(10,4),
    target_yield DECIMAL(5,2), -- percentage
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for products
CREATE INDEX idx_products_category ON products(product_category);
CREATE INDEX idx_products_family ON products(product_family);

-- Bill of Materials
CREATE TABLE bill_of_materials (
    bom_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    raw_material_code VARCHAR(30),
    raw_material_name VARCHAR(200),
    standard_quantity DECIMAL(10,4),
    allowed_wastage_percent DECIMAL(5,2),
    unit_cost DECIMAL(10,4),
    supplier_code VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    effective_from DATE,
    effective_to DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for BOM
CREATE INDEX idx_bom_product_id ON bill_of_materials(product_id);
CREATE INDEX idx_bom_material_code ON bill_of_materials(raw_material_code);
CREATE INDEX idx_bom_effective_dates ON bill_of_materials(effective_from, effective_to);

-- Employees Master
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    employee_name VARCHAR(100) NOT NULL,
    plant_id INTEGER REFERENCES plants(plant_id),
    department VARCHAR(50),
    designation VARCHAR(50),
    shift VARCHAR(10),
    hire_date DATE,
    hourly_rate DECIMAL(8,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for employees
CREATE INDEX idx_employees_plant_id ON employees(plant_id);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_shift ON employees(shift);

-- Machine-Operator Mapping
CREATE TABLE machine_operator_mapping (
    mapping_id SERIAL PRIMARY KEY,
    machine_id INTEGER REFERENCES machines(machine_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    skill_level VARCHAR(20), -- Beginner, Intermediate, Expert
    certification_date DATE,
    is_primary_operator BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for machine-operator mapping
CREATE INDEX idx_machine_operator_machine ON machine_operator_mapping(machine_id);
CREATE INDEX idx_machine_operator_employee ON machine_operator_mapping(employee_id);

-- Product-Machine Mapping
CREATE TABLE product_machine_mapping (
    mapping_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    setup_time_minutes INTEGER,
    cycle_time_seconds DECIMAL(8,2),
    changeover_time_minutes INTEGER,
    is_preferred_machine BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for product-machine mapping
CREATE INDEX idx_product_machine_product ON product_machine_mapping(product_id);
CREATE INDEX idx_product_machine_machine ON product_machine_mapping(machine_id);

-- Spare Parts Master
CREATE TABLE spare_parts (
    spare_id SERIAL PRIMARY KEY,
    spare_code VARCHAR(30) UNIQUE NOT NULL,
    spare_name VARCHAR(200) NOT NULL,
    spare_category VARCHAR(50),
    unit_price DECIMAL(10,2),
    lead_time_days INTEGER,
    minimum_stock INTEGER,
    maximum_stock INTEGER,
    supplier_code VARCHAR(20),
    is_critical BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Machine-Spare Mapping
CREATE TABLE machine_spare_mapping (
    mapping_id SERIAL PRIMARY KEY,
    machine_id INTEGER REFERENCES machines(machine_id),
    spare_id INTEGER REFERENCES spare_parts(spare_id),
    quantity_required INTEGER DEFAULT 1,
    replacement_frequency_hours INTEGER,
    is_critical_spare BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for machine-spare mapping
CREATE INDEX idx_machine_spare_machine ON machine_spare_mapping(machine_id);
CREATE INDEX idx_machine_spare_spare ON machine_spare_mapping(spare_id);
