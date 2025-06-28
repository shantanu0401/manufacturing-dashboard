-- Cost and Resource Management Tables

-- Labor Cost Tracking
CREATE TABLE labor_costs (
    cost_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    cost_date DATE NOT NULL,
    shift VARCHAR(10),
    regular_hours DECIMAL(6,2),
    overtime_hours DECIMAL(6,2),
    regular_rate DECIMAL(8,2),
    overtime_rate DECIMAL(8,2),
    total_cost DECIMAL(10,2),
    cost_type VARCHAR(20), -- VARIABLE, FIXED
    allocation_basis VARCHAR(50), -- DIRECT, INDIRECT
    product_id INTEGER REFERENCES products(product_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for labor costs
CREATE INDEX idx_labor_costs_date ON labor_costs(cost_date);
CREATE INDEX idx_labor_costs_employee ON labor_costs(employee_id);
CREATE INDEX idx_labor_costs_type ON labor_costs(cost_type);

-- Power Consumption Tracking
CREATE TABLE power_consumption (
    consumption_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    consumption_date DATE NOT NULL,
    shift VARCHAR(10),
    kwh_consumed DECIMAL(10,3),
    rate_per_kwh DECIMAL(8,4),
    total_cost DECIMAL(10,2),
    cost_type VARCHAR(20), -- VARIABLE, FIXED
    meter_reading_start DECIMAL(12,3),
    meter_reading_end DECIMAL(12,3),
    operating_hours DECIMAL(6,2),
    product_id INTEGER REFERENCES products(product_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for power consumption
CREATE INDEX idx_power_consumption_date ON power_consumption(consumption_date);
CREATE INDEX idx_power_consumption_machine ON power_consumption(machine_id);

-- Fuel Consumption Tracking
CREATE TABLE fuel_consumption (
    consumption_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    consumption_date DATE NOT NULL,
    shift VARCHAR(10),
    fuel_type VARCHAR(30), -- Diesel, Gas, Coal, etc.
    quantity_consumed DECIMAL(10,3),
    rate_per_unit DECIMAL(8,4),
    total_cost DECIMAL(10,2),
    cost_type VARCHAR(20), -- VARIABLE, FIXED
    operating_hours DECIMAL(6,2),
    product_id INTEGER REFERENCES products(product_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for fuel consumption
CREATE INDEX idx_fuel_consumption_date ON fuel_consumption(consumption_date);
CREATE INDEX idx_fuel_consumption_machine ON fuel_consumption(machine_id);

-- Maintenance Costs
CREATE TABLE maintenance_costs (
    maintenance_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    machine_id INTEGER REFERENCES machines(machine_id),
    maintenance_date DATE NOT NULL,
    maintenance_type VARCHAR(30), -- BREAKDOWN, PLANNED, PREVENTIVE
    work_order_number VARCHAR(30),
    description TEXT,
    labor_cost DECIMAL(10,2),
    spare_parts_cost DECIMAL(10,2),
    external_service_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    downtime_hours DECIMAL(6,2),
    performed_by INTEGER REFERENCES employees(employee_id),
    vendor_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for maintenance costs
CREATE INDEX idx_maintenance_costs_date ON maintenance_costs(maintenance_date);
CREATE INDEX idx_maintenance_costs_machine ON maintenance_costs(machine_id);
CREATE INDEX idx_maintenance_costs_type ON maintenance_costs(maintenance_type);

-- Budget and Variance Tracking
CREATE TABLE budget_variance (
    variance_id SERIAL PRIMARY KEY,
    plant_id INTEGER REFERENCES plants(plant_id),
    budget_period VARCHAR(20), -- MONTHLY, QUARTERLY, YEARLY
    budget_year INTEGER,
    budget_month INTEGER,
    cost_category VARCHAR(50), -- LABOR, POWER, FUEL, MAINTENANCE, MATERIAL
    budgeted_amount DECIMAL(12,2),
    actual_amount DECIMAL(12,2),
    variance_amount DECIMAL(12,2),
    variance_percentage DECIMAL(6,2),
    variance_type VARCHAR(20), -- FAVORABLE, UNFAVORABLE
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for budget variance
CREATE INDEX idx_budget_variance_period ON budget_variance(budget_year, budget_month);
CREATE INDEX idx_budget_variance_category ON budget_variance(cost_category);
