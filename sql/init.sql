-- =====================================================================
-- COMPREHENSIVE SQL TRAINING DATABASE
-- Enhanced init.sql for SQL Training with Real-World Business Scenarios
-- Supports: Beginners to Advanced SQL practitioners
-- =====================================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop tables if they exist to start fresh (order matters due to FK constraints)
DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customer_preferences CASCADE;
DROP TABLE IF EXISTS product_reviews CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;
DROP TABLE IF EXISTS employee_territories CASCADE;
DROP TABLE IF EXISTS territories CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS promotions CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS price_tiers CASCADE;

-- =====================================================================
-- LOOKUP TABLES
-- =====================================================================

-- Price tiers for tier-based analysis
CREATE TABLE price_tiers (
    tier_id SERIAL PRIMARY KEY,
    tier_name VARCHAR(20) NOT NULL,
    min_price DECIMAL(10, 2) NOT NULL,
    max_price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Product categories with hierarchy support
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    parent_category_id INTEGER REFERENCES categories(category_id),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Departments for employee management
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    budget DECIMAL(12, 2),
    manager_id INTEGER, -- Will be populated after employees table
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Territories for sales analysis
CREATE TABLE territories (
    territory_id SERIAL PRIMARY KEY,
    territory_name VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    country VARCHAR(50) DEFAULT 'USA',
    is_active BOOLEAN DEFAULT TRUE
);

-- =====================================================================
-- MAIN BUSINESS TABLES
-- =====================================================================

-- Enhanced Customers table with comprehensive fields
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    
    -- Address information
    street_address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    
    -- Account information
    customer_type VARCHAR(20) DEFAULT 'Individual' CHECK (customer_type IN ('Individual', 'Business', 'Premium')),
    credit_limit DECIMAL(10, 2) DEFAULT 1000.00,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP,
    
    -- JSON field for flexible data (PostgreSQL specific)
    preferences JSONB,
    
    -- Additional fields for analytics
    acquisition_channel VARCHAR(50),
    lifetime_value DECIMAL(10, 2) DEFAULT 0,
    
    -- Indexes will be created separately
    CONSTRAINT customers_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Enhanced Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_code VARCHAR(20) UNIQUE,
    category_id INTEGER REFERENCES categories(category_id),
    
    -- Pricing information
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    cost DECIMAL(10, 2) CHECK (cost >= 0),
    list_price DECIMAL(10, 2),
    discount_percentage DECIMAL(5, 2) DEFAULT 0 CHECK (discount_percentage BETWEEN 0 AND 100),
    
    -- Product details
    description TEXT,
    specifications JSONB,
    weight DECIMAL(8, 2),
    dimensions VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(20),
    
    -- Inventory and status
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_point INTEGER DEFAULT 10,
    discontinued BOOLEAN DEFAULT FALSE,
    
    -- SEO and marketing
    tags TEXT[], -- PostgreSQL array
    brand VARCHAR(50),
    model VARCHAR(50),
    sku VARCHAR(50),
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    discontinued_date TIMESTAMP,
    
    -- Rating information
    average_rating DECIMAL(3, 2) DEFAULT 0 CHECK (average_rating BETWEEN 0 AND 5),
    review_count INTEGER DEFAULT 0
);

-- Suppliers table
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    contact_title VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    
    -- Address
    street_address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    
    -- Business details
    tax_id VARCHAR(50),
    payment_terms VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Performance metrics
    quality_rating DECIMAL(3, 2) DEFAULT 0,
    delivery_rating DECIMAL(3, 2) DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- Employees table with hierarchy support
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_code VARCHAR(20) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    
    -- Employment details
    job_title VARCHAR(100),
    department_id INTEGER REFERENCES departments(department_id),
    manager_id INTEGER REFERENCES employees(employee_id),
    salary DECIMAL(10, 2),
    commission_rate DECIMAL(5, 4) DEFAULT 0,
    
    -- Dates
    hire_date DATE NOT NULL,
    birth_date DATE,
    termination_date DATE,
    
    -- Address
    street_address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    employment_type VARCHAR(20) DEFAULT 'Full-time' 
        CHECK (employment_type IN ('Full-time', 'Part-time', 'Contract', 'Intern')),
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- Employee territories (many-to-many relationship)
CREATE TABLE employee_territories (
    employee_id INTEGER REFERENCES employees(employee_id),
    territory_id INTEGER REFERENCES territories(territory_id),
    assigned_date DATE DEFAULT CURRENT_DATE,
    is_primary BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (employee_id, territory_id)
);

-- Enhanced Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    employee_id INTEGER REFERENCES employees(employee_id),
    
    -- Order dates
    order_date TIMESTAMP DEFAULT NOW(),
    required_date DATE,
    shipped_date TIMESTAMP,
    
    -- Financial information
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    shipping_cost DECIMAL(10, 2) DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    
    -- Status and shipping
    order_status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Returned')),
    payment_method VARCHAR(30),
    payment_status VARCHAR(20) DEFAULT 'Pending'
        CHECK (payment_status IN ('Pending', 'Authorized', 'Paid', 'Failed', 'Refunded')),
    
    -- Shipping information
    ship_name VARCHAR(100),
    ship_address VARCHAR(200),
    ship_city VARCHAR(50),
    ship_state VARCHAR(50),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50) DEFAULT 'USA',
    shipping_method VARCHAR(50),
    tracking_number VARCHAR(100),
    
    -- Additional fields
    notes TEXT,
    internal_notes TEXT,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Enhanced Order Details table
CREATE TABLE order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    
    -- Quantity and pricing
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    discount_percentage DECIMAL(5, 2) DEFAULT 0 CHECK (discount_percentage BETWEEN 0 AND 100),
    line_total DECIMAL(10, 2) GENERATED ALWAYS AS (
        quantity * unit_price * (1 - discount_percentage / 100)
    ) STORED,
    
    -- Additional details
    product_name VARCHAR(100), -- Snapshot of product name at time of order
    notes TEXT,
    
    UNIQUE(order_id, product_id)
);

-- Promotions table for marketing analysis
CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    promotion_name VARCHAR(100) NOT NULL,
    promotion_code VARCHAR(20) UNIQUE,
    description TEXT,
    
    -- Dates
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    
    -- Discount details
    discount_type VARCHAR(20) CHECK (discount_type IN ('Percentage', 'Fixed Amount', 'BOGO')),
    discount_value DECIMAL(10, 2),
    min_order_amount DECIMAL(10, 2) DEFAULT 0,
    max_discount_amount DECIMAL(10, 2),
    
    -- Usage limits
    usage_limit INTEGER,
    usage_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT NOW(),
    
    CHECK (end_date > start_date)
);

-- Inventory tracking
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    
    -- Quantity tracking
    quantity_on_hand INTEGER NOT NULL DEFAULT 0,
    quantity_allocated INTEGER DEFAULT 0,
    quantity_available INTEGER GENERATED ALWAYS AS (
        quantity_on_hand - quantity_allocated
    ) STORED,
    
    -- Cost information
    unit_cost DECIMAL(10, 2),
    total_cost DECIMAL(10, 2) GENERATED ALWAYS AS (
        quantity_on_hand * unit_cost
    ) STORED,
    
    -- Dates
    last_updated TIMESTAMP DEFAULT NOW(),
    last_restock_date DATE,
    next_restock_date DATE,
    
    -- Location
    warehouse_location VARCHAR(50),
    bin_location VARCHAR(20)
);

-- Product reviews for sentiment analysis
CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_id INTEGER REFERENCES orders(order_id),
    
    -- Review content
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(200),
    review_text TEXT,
    
    -- Metadata
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_votes INTEGER DEFAULT 0,
    total_votes INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    
    -- Moderation
    status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Hidden')),
    moderated_by INTEGER REFERENCES employees(employee_id),
    moderated_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(product_id, customer_id, order_id)
);

-- Customer preferences for personalization
CREATE TABLE customer_preferences (
    preference_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    
    -- Communication preferences
    email_marketing BOOLEAN DEFAULT TRUE,
    sms_marketing BOOLEAN DEFAULT FALSE,
    phone_marketing BOOLEAN DEFAULT FALSE,
    
    -- Shopping preferences
    preferred_categories INTEGER[] DEFAULT '{}',
    preferred_brands TEXT[] DEFAULT '{}',
    price_range_min DECIMAL(10, 2),
    price_range_max DECIMAL(10, 2),
    
    -- Delivery preferences
    preferred_shipping_method VARCHAR(50),
    preferred_delivery_time VARCHAR(50),
    
    -- Other preferences stored as JSON
    other_preferences JSONB DEFAULT '{}',
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(customer_id)
);

-- =====================================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================================

-- Customer indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_name ON customers(last_name, first_name);
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_created_at ON customers(created_at);
CREATE INDEX idx_customers_active ON customers(customer_id) WHERE is_active = TRUE;

-- Product indexes
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_name_search ON products USING gin(to_tsvector('english', product_name));
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_active ON products(product_id) WHERE discontinued = FALSE;

-- Order indexes
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_orders_number ON orders(order_number);

-- Order details indexes
CREATE INDEX idx_order_details_order ON order_details(order_id);
CREATE INDEX idx_order_details_product ON order_details(product_id);

-- Employee indexes
CREATE INDEX idx_employees_manager ON employees(manager_id);
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_active ON employees(employee_id) WHERE is_active = TRUE;

-- Review indexes
CREATE INDEX idx_reviews_product ON product_reviews(product_id);
CREATE INDEX idx_reviews_customer ON product_reviews(customer_id);
CREATE INDEX idx_reviews_rating ON product_reviews(rating);

-- =====================================================================
-- UPDATE FOREIGN KEY CONSTRAINTS
-- =====================================================================

-- Add department manager foreign key (circular reference handled after data insertion)
-- ALTER TABLE departments ADD CONSTRAINT fk_departments_manager 
--     FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- =====================================================================
-- SAMPLE DATA INSERTION
-- =====================================================================

-- Insert Price Tiers
INSERT INTO price_tiers (tier_name, min_price, max_price, description) VALUES
('Budget', 0.00, 50.00, 'Affordable products for cost-conscious consumers'),
('Mid-Range', 50.01, 200.00, 'Quality products with good value'),
('Premium', 200.01, 1000.00, 'High-quality products with premium features'),
('Luxury', 1000.01, 9999999.99, 'Top-tier luxury items and professional equipment');

-- Insert Categories (with hierarchy)
INSERT INTO categories (category_name, parent_category_id, description) VALUES
('Electronics', NULL, 'Electronic devices and accessories'),
('Books', NULL, 'Physical and digital books'),
('Clothing', NULL, 'Apparel and fashion items'),
('Home & Garden', NULL, 'Home improvement and garden supplies'),
('Sports & Outdoors', NULL, 'Sports equipment and outdoor gear'),
('Health & Beauty', NULL, 'Health, wellness, and beauty products'),
('Toys & Games', NULL, 'Children toys and games'),
('Automotive', NULL, 'Car parts and automotive accessories');

-- Electronics subcategories
INSERT INTO categories (category_name, parent_category_id, description) VALUES
('Computers', 1, 'Laptops, desktops, and computer accessories'),
('Mobile Devices', 1, 'Smartphones, tablets, and mobile accessories'),
('Audio & Video', 1, 'Headphones, speakers, cameras, and entertainment devices'),
('Gaming', 1, 'Gaming consoles, games, and gaming accessories');

-- Books subcategories
INSERT INTO categories (category_name, parent_category_id, description) VALUES
('Fiction', 2, 'Novels, short stories, and fictional literature'),
('Non-Fiction', 2, 'Educational, biographical, and factual books'),
('Technical', 2, 'Programming, engineering, and technical manuals'),
('Business', 2, 'Business, management, and entrepreneurship books');

-- Insert Departments
INSERT INTO departments (department_name, budget, location) VALUES
('Sales', 500000.00, 'New York, NY'),
('Marketing', 300000.00, 'Los Angeles, CA'),
('Customer Service', 200000.00, 'Chicago, IL'),
('IT', 400000.00, 'Austin, TX'),
('Operations', 350000.00, 'Seattle, WA'),
('Human Resources', 150000.00, 'Atlanta, GA'),
('Finance', 250000.00, 'New York, NY');

-- Insert Territories
INSERT INTO territories (territory_name, region, country) VALUES
('Northeast', 'East Coast', 'USA'),
('Southeast', 'East Coast', 'USA'),
('Midwest', 'Central', 'USA'),
('Southwest', 'West Coast', 'USA'),
('Northwest', 'West Coast', 'USA'),
('California', 'West Coast', 'USA'),
('Texas', 'Central', 'USA'),
('Florida', 'East Coast', 'USA');

-- Insert Suppliers
INSERT INTO suppliers (company_name, contact_name, contact_title, email, phone, 
                      street_address, city, state, postal_code, quality_rating, delivery_rating) VALUES
('TechSupply Corp', 'Alice Johnson', 'Sales Manager', 'alice@techsupply.com', '555-0101',
 '123 Tech Street', 'San Francisco', 'CA', '94105', 4.5, 4.2),
('BookWorks Publishing', 'Bob Wilson', 'Account Manager', 'bob@bookworks.com', '555-0102',
 '456 Literary Ave', 'New York', 'NY', '10001', 4.8, 4.6),
('Fashion Forward Ltd', 'Carol Davis', 'Sales Director', 'carol@fashionforward.com', '555-0103',
 '789 Style Boulevard', 'Los Angeles', 'CA', '90210', 4.3, 4.1),
('HomeLife Supplies', 'David Miller', 'Regional Manager', 'david@homelife.com', '555-0104',
 '321 Garden Way', 'Portland', 'OR', '97201', 4.6, 4.4),
('SportsPro Equipment', 'Emma Garcia', 'Sales Rep', 'emma@sportspro.com', '555-0105',
 '654 Athletic Drive', 'Denver', 'CO', '80202', 4.4, 4.3);

-- Insert Employees (hierarchical structure)
INSERT INTO employees (employee_code, first_name, last_name, email, phone, job_title, 
                      department_id, salary, hire_date, birth_date, 
                      street_address, city, state, postal_code) VALUES
-- Senior Management
('EMP001', 'Michael', 'Thompson', 'michael.thompson@company.com', '555-1001', 'CEO', 7, 200000.00, '2020-01-15', '1975-03-20', '100 Executive Blvd', 'New York', 'NY', '10001'),
('EMP002', 'Sarah', 'Chen', 'sarah.chen@company.com', '555-1002', 'VP of Sales', 1, 150000.00, '2020-03-01', '1978-07-15', '200 Sales Street', 'New York', 'NY', '10002'),
('EMP003', 'Robert', 'Martinez', 'robert.martinez@company.com', '555-1003', 'VP of Operations', 5, 145000.00, '2020-04-15', '1980-11-30', '300 Operations Ave', 'Seattle', 'WA', '98101'),

-- Department Managers
('EMP004', 'Jennifer', 'Davis', 'jennifer.davis@company.com', '555-1004', 'Sales Manager', 1, 85000.00, '2021-01-10', '1985-09-12', '400 Sales Lane', 'Chicago', 'IL', '60601'),
('EMP005', 'James', 'Wilson', 'james.wilson@company.com', '555-1005', 'Marketing Manager', 2, 80000.00, '2021-02-15', '1983-12-08', '500 Marketing St', 'Los Angeles', 'CA', '90210'),
('EMP006', 'Lisa', 'Anderson', 'lisa.anderson@company.com', '555-1006', 'IT Manager', 4, 90000.00, '2021-03-20', '1982-06-25', '600 Tech Road', 'Austin', 'TX', '78701'),

-- Sales Representatives
('EMP007', 'Kevin', 'Brown', 'kevin.brown@company.com', '555-1007', 'Senior Sales Rep', 1, 65000.00, '2021-06-01', '1988-02-14', '700 Commerce Dr', 'Boston', 'MA', '02101'),
('EMP008', 'Amanda', 'Taylor', 'amanda.taylor@company.com', '555-1008', 'Sales Representative', 1, 55000.00, '2022-01-15', '1990-08-20', '800 Business Ave', 'Miami', 'FL', '33101'),
('EMP009', 'Christopher', 'Lee', 'christopher.lee@company.com', '555-1009', 'Sales Representative', 1, 52000.00, '2022-04-01', '1991-04-10', '900 Revenue Rd', 'Dallas', 'TX', '75201'),
('EMP010', 'Michelle', 'White', 'michelle.white@company.com', '555-1010', 'Sales Representative', 1, 54000.00, '2022-07-15', '1989-10-05', '1000 Profit Place', 'Phoenix', 'AZ', '85001'),

-- Customer Service
('EMP011', 'Daniel', 'Harris', 'daniel.harris@company.com', '555-1011', 'Customer Service Manager', 3, 60000.00, '2021-05-01', '1986-01-30', '1100 Service St', 'Chicago', 'IL', '60602'),
('EMP012', 'Nicole', 'Clark', 'nicole.clark@company.com', '555-1012', 'Customer Service Rep', 3, 40000.00, '2022-03-01', '1992-07-18', '1200 Support Ave', 'Chicago', 'IL', '60603'),
('EMP013', 'Ryan', 'Lewis', 'ryan.lewis@company.com', '555-1013', 'Customer Service Rep', 3, 38000.00, '2022-09-15', '1993-11-22', '1300 Help Desk Dr', 'Chicago', 'IL', '60604'),

-- IT Department
('EMP014', 'Stephanie', 'Walker', 'stephanie.walker@company.com', '555-1014', 'Senior Developer', 4, 95000.00, '2021-04-01', '1984-05-15', '1400 Code Lane', 'Austin', 'TX', '78702'),
('EMP015', 'Andrew', 'Hall', 'andrew.hall@company.com', '555-1015', 'Database Administrator', 4, 85000.00, '2021-08-15', '1987-09-08', '1500 Data Drive', 'Austin', 'TX', '78703');

-- Update manager relationships
UPDATE employees SET manager_id = 1 WHERE employee_id IN (2, 3); -- VPs report to CEO
UPDATE employees SET manager_id = 2 WHERE employee_id = 4; -- Sales Manager reports to VP Sales
UPDATE employees SET manager_id = 4 WHERE employee_id IN (7, 8, 9, 10); -- Sales reps report to Sales Manager
UPDATE employees SET manager_id = 3 WHERE employee_id = 11; -- CS Manager reports to VP Operations
UPDATE employees SET manager_id = 11 WHERE employee_id IN (12, 13); -- CS reps report to CS Manager
UPDATE employees SET manager_id = 6 WHERE employee_id IN (14, 15); -- IT staff report to IT Manager

-- Update department managers
UPDATE departments SET manager_id = 4 WHERE department_id = 1; -- Sales
UPDATE departments SET manager_id = 5 WHERE department_id = 2; -- Marketing
UPDATE departments SET manager_id = 11 WHERE department_id = 3; -- Customer Service
UPDATE departments SET manager_id = 6 WHERE department_id = 4; -- IT
UPDATE departments SET manager_id = 3 WHERE department_id = 5; -- Operations

-- Insert Employee Territories
INSERT INTO employee_territories (employee_id, territory_id, is_primary) VALUES
(7, 1, TRUE), (7, 2, FALSE), -- Kevin covers Northeast primarily, Southeast secondarily
(8, 3, TRUE), -- Amanda covers Midwest
(9, 7, TRUE), -- Christopher covers Texas
(10, 4, TRUE), (10, 5, FALSE); -- Michelle covers Southwest primarily, Northwest secondarily

-- Insert Customers (diverse, realistic data)
INSERT INTO customers (first_name, last_name, middle_name, email, phone, date_of_birth, gender,
                      street_address, city, state, postal_code, customer_type, credit_limit,
                      created_at, acquisition_channel, preferences) VALUES
('John', 'Smith', 'Michael', 'john.smith@email.com', '555-0201', '1985-03-15', 'M',
 '123 Oak Street', 'New York', 'NY', '10001', 'Individual', 2000.00,
 '2022-01-15 10:30:00', 'Website', '{"theme": "light", "notifications": true, "language": "en"}'),

('Jane', 'Doe', 'Elizabeth', 'jane.doe@gmail.com', '555-0202', '1990-07-22', 'F',
 '456 Pine Avenue', 'Los Angeles', 'CA', '90210', 'Premium', 5000.00,
 '2022-02-20 14:15:00', 'Referral', '{"theme": "dark", "notifications": false, "language": "en"}'),

('Peter', 'Jones', NULL, 'peter.jones@yahoo.com', '555-0203', '1978-11-08', 'M',
 '789 Maple Drive', 'Chicago', 'IL', '60601', 'Business', 10000.00,
 '2022-03-10 09:45:00', 'Google Ads', '{"theme": "auto", "notifications": true, "language": "en"}'),

('Mary', 'Williams', 'Catherine', 'mary.williams@hotmail.com', '555-0204', '1992-05-30', 'F',
 '321 Elm Street', 'Houston', 'TX', '77001', 'Individual', 1500.00,
 '2022-05-01 16:20:00', 'Social Media', '{"theme": "light", "notifications": true, "language": "es"}'),

('David', 'Brown', 'James', 'david.brown@outlook.com', '555-0205', '1983-09-12', 'M',
 '654 Cedar Lane', 'Phoenix', 'AZ', '85001', 'Individual', 2500.00,
 '2022-06-11 11:10:00', 'Email Campaign', '{"theme": "dark", "notifications": false, "language": "en"}'),

('Sarah', 'Johnson', 'Marie', 'sarah.johnson@company.com', '555-0206', '1988-12-03', 'F',
 '987 Birch Road', 'Philadelphia', 'PA', '19101', 'Business', 8000.00,
 '2022-07-15 13:30:00', 'Website', '{"theme": "light", "notifications": true, "language": "en"}'),

('Michael', 'Davis', 'Robert', 'michael.davis@personal.net', '555-0207', '1975-04-18', 'M',
 '147 Spruce Circle', 'San Antonio', 'TX', '78201', 'Premium', 15000.00,
 '2022-08-20 08:45:00', 'Referral', '{"theme": "auto", "notifications": true, "language": "en"}'),

('Emily', 'Wilson', 'Grace', 'emily.wilson@email.org', '555-0208', '1994-02-14', 'F',
 '258 Willow Way', 'San Diego', 'CA', '92101', 'Individual', 1000.00,
 '2022-09-25 15:00:00', 'Social Media', '{"theme": "light", "notifications": false, "language": "en"}'),

('Robert', 'Miller', 'Charles', 'robert.miller@business.co', '555-0209', '1980-10-07', 'M',
 '369 Poplar Place', 'Dallas', 'TX', '75201', 'Business', 12000.00,
 '2022-10-30 12:15:00', 'Trade Show', '{"theme": "dark", "notifications": true, "language": "en"}'),

('Jessica', 'Moore', 'Lynn', 'jessica.moore@provider.com', '555-0210', '1987-08-25', 'F',
 '741 Ash Boulevard', 'San Jose', 'CA', '95101', 'Individual', 3000.00,
 '2022-11-05 14:30:00', 'Google Ads', '{"theme": "light", "notifications": true, "language": "en"}'),

('Christopher', 'Taylor', 'Andrew', 'chris.taylor@domain.net', '555-0211', '1991-01-16', 'M',
 '852 Hickory Street', 'Austin', 'TX', '78701', 'Individual', 2200.00,
 '2022-12-12 10:00:00', 'Website', '{"theme": "auto", "notifications": false, "language": "en"}'),

('Amanda', 'Anderson', 'Nicole', 'amanda.anderson@mail.com', '555-0212', '1986-06-09', 'F',
 '963 Chestnut Avenue', 'Jacksonville', 'FL', '32201', 'Premium', 6000.00,
 '2023-01-18 16:45:00', 'Email Campaign', '{"theme": "dark", "notifications": true, "language": "en"}'),

('Daniel', 'Thomas', 'Scott', 'daniel.thomas@tech.io', '555-0213', '1979-03-21', 'M',
 '159 Walnut Drive', 'Fort Worth', 'TX', '76101', 'Business', 9000.00,
 '2023-02-22 09:20:00', 'Referral', '{"theme": "light", "notifications": true, "language": "en"}'),

('Michelle', 'Jackson', 'Renee', 'michelle.jackson@service.org', '555-0214', '1993-11-04', 'F',
 '357 Sycamore Lane', 'Columbus', 'OH', '43201', 'Individual', 1800.00,
 '2023-03-15 13:55:00', 'Social Media', '{"theme": "auto", "notifications": false, "language": "en"}'),

('Ryan', 'White', 'Patrick', 'ryan.white@network.co', '555-0215', '1982-07-13', 'M',
 '468 Magnolia Court', 'Charlotte', 'NC', '28201', 'Individual', 2800.00,
 '2023-04-10 11:40:00', 'Website', '{"theme": "dark", "notifications": true, "language": "en"}'),

-- International customers
('Maria', 'Garcia', 'Isabella', 'maria.garcia@email.mx', '555-0216', '1989-09-28', 'F',
 '579 Palm Street', 'El Paso', 'TX', '79901', 'Individual', 2000.00,
 '2023-05-20 15:25:00', 'Social Media', '{"theme": "light", "notifications": true, "language": "es"}'),

('James', 'Lee', 'William', 'james.lee@connect.com', '555-0217', '1984-12-11', 'M',
 '680 Bamboo Road', 'Seattle', 'WA', '98101', 'Premium', 7500.00,
 '2023-06-08 08:30:00', 'Google Ads', '{"theme": "auto", "notifications": true, "language": "en"}'),

('Lisa', 'Rodriguez', 'Sofia', 'lisa.rodriguez@platform.net', '555-0218', '1990-04-02', 'F',
 '791 Coral Avenue', 'Miami', 'FL', '33101', 'Individual', 2500.00,
 '2023-07-03 12:50:00', 'Email Campaign', '{"theme": "light", "notifications": false, "language": "es"}'),

('Kevin', 'Martinez', 'Antonio', 'kevin.martinez@solutions.io', '555-0219', '1977-08-17', 'M',
 '802 Sunset Boulevard', 'Los Angeles', 'CA', '90028', 'Business', 11000.00,
 '2023-08-14 14:15:00', 'Trade Show', '{"theme": "dark", "notifications": true, "language": "en"}'),

('Nicole', 'Clark', 'Michelle', 'nicole.clark@digital.org', '555-0220', '1995-10-26', 'F',
 '913 Rainbow Drive', 'Las Vegas', 'NV', '89101', 'Individual', 1200.00,
 '2023-09-09 17:05:00', 'Website', '{"theme": "auto", "notifications": true, "language": "en"}');

-- Insert Products (comprehensive catalog)
INSERT INTO products (product_name, product_code, category_id, price, cost, list_price, 
                     description, brand, model, sku, stock_quantity, 
                     specifications, tags, weight, color, size) VALUES

-- Electronics - Computers
('MacBook Pro 16-inch', 'MBP-16-2023', 9, 2499.00, 1899.00, 2499.00,
 'Professional laptop with M2 Pro chip, 16GB RAM, 512GB SSD', 'Apple', 'MacBook Pro', 'APL-MBP16-001', 25,
 '{"processor": "M2 Pro", "ram": "16GB", "storage": "512GB SSD", "display": "16-inch Retina"}',
 '{"laptop", "professional", "apple", "m2"}', 2.15, 'Space Gray', '16-inch'),

('Dell XPS 13', 'XPS-13-2023', 9, 1299.00, 899.00, 1399.00,
 'Ultra-portable laptop with Intel i7, 16GB RAM, 256GB SSD', 'Dell', 'XPS 13', 'DEL-XPS13-001', 30,
 '{"processor": "Intel i7-1260P", "ram": "16GB", "storage": "256GB SSD", "display": "13.4-inch FHD+"}',
 '{"laptop", "ultrabook", "dell", "intel"}', 1.27, 'Platinum Silver', '13-inch'),

('Gaming Desktop PC', 'GAME-PC-001', 9, 1899.00, 1299.00, 1999.00,
 'High-performance gaming desktop with RTX 4070, AMD Ryzen 7', 'Custom Build', 'Gaming Rig', 'CST-GAME-001', 15,
 '{"processor": "AMD Ryzen 7 5800X", "gpu": "RTX 4070", "ram": "32GB DDR4", "storage": "1TB NVMe SSD"}',
 '{"desktop", "gaming", "ryzen", "rtx"}', 18.50, 'Black', 'Full Tower'),

-- Electronics - Mobile Devices  
('iPhone 15 Pro', 'IPH-15-PRO', 10, 999.00, 699.00, 999.00,
 'Latest iPhone with A17 Pro chip, 128GB storage, ProRAW camera', 'Apple', 'iPhone 15 Pro', 'APL-IP15P-001', 50,
 '{"processor": "A17 Pro", "storage": "128GB", "camera": "48MP Pro", "display": "6.1-inch Super Retina XDR"}',
 '{"smartphone", "iphone", "apple", "5g"}', 0.187, 'Titanium Natural', '6.1-inch'),

('Samsung Galaxy S24', 'SGS-24-001', 10, 849.00, 599.00, 899.00,
 'Android flagship with Snapdragon 8 Gen 3, 256GB storage', 'Samsung', 'Galaxy S24', 'SAM-GS24-001', 40,
 '{"processor": "Snapdragon 8 Gen 3", "storage": "256GB", "camera": "50MP Triple", "display": "6.2-inch Dynamic AMOLED"}',
 '{"smartphone", "android", "samsung", "5g"}', 0.168, 'Phantom Black', '6.2-inch'),

('iPad Air', 'IPAD-AIR-2023', 10, 599.00, 429.00, 599.00,
 'Versatile tablet with M1 chip, 64GB storage, 10.9-inch display', 'Apple', 'iPad Air', 'APL-IPAD-001', 35,
 '{"processor": "M1", "storage": "64GB", "display": "10.9-inch Liquid Retina", "connectivity": "Wi-Fi"}',
 '{"tablet", "ipad", "apple", "m1"}', 0.461, 'Sky Blue', '10.9-inch'),

-- Electronics - Audio & Video
('Sony WH-1000XM5', 'SONY-WH5-001', 11, 399.00, 249.00, 429.00,
 'Premium noise-canceling headphones with 30-hour battery', 'Sony', 'WH-1000XM5', 'SNY-WH5-001', 60,
 '{"type": "Over-ear", "noise_canceling": true, "battery": "30 hours", "connectivity": "Bluetooth 5.2"}',
 '{"headphones", "noise-canceling", "sony", "bluetooth"}', 0.250, 'Black', 'One Size'),

('AirPods Pro 2nd Gen', 'APP-2GEN-001', 11, 249.00, 149.00, 249.00,
 'Wireless earbuds with active noise cancellation and spatial audio', 'Apple', 'AirPods Pro', 'APL-APP2-001', 80,
 '{"type": "In-ear", "noise_canceling": true, "battery": "6 hours + 24 with case", "connectivity": "Bluetooth"}',
 '{"earbuds", "wireless", "apple", "noise-canceling"}', 0.056, 'White', 'One Size'),

('4K Webcam', 'CAM-4K-001', 11, 199.00, 119.00, 229.00,
 'Professional 4K webcam with auto-focus and noise reduction', 'Logitech', 'Brio 4K', 'LOG-BR4K-001', 45,
 '{"resolution": "4K UHD", "fps": "30", "field_of_view": "90°", "features": "Auto-focus, Noise reduction"}',
 '{"webcam", "4k", "logitech", "streaming"}', 0.063, 'Black', 'Compact'),

-- Books - Technical
('Learning SQL', 'BOOK-SQL-001', 15, 45.99, 23.00, 49.99,
 'Comprehensive guide to SQL programming for beginners and professionals', 'O''Reilly Media', 'Learning SQL 3rd Ed', 'ORL-SQL-001', 100,
 '{"pages": 416, "edition": "3rd", "format": "Paperback", "isbn": "978-0596520830"}',
 '{"sql", "database", "programming", "learning"}', 0.680, 'Multi-color', 'Standard'),

('Python Crash Course', 'BOOK-PY-001', 15, 39.99, 20.00, 44.99,
 'Hands-on introduction to Python programming', 'No Starch Press', 'Python Crash Course 2nd Ed', 'NSP-PY-001', 75,
 '{"pages": 544, "edition": "2nd", "format": "Paperback", "isbn": "978-1593279288"}',
 '{"python", "programming", "beginner", "coding"}', 0.907, 'Blue/Yellow', 'Standard'),

('Clean Code', 'BOOK-CC-001', 15, 42.99, 22.00, 47.99,
 'A handbook of agile software craftsmanship', 'Prentice Hall', 'Clean Code', 'PH-CC-001', 60,
 '{"pages": 464, "edition": "1st", "format": "Paperback", "isbn": "978-0132350884"}',
 '{"software", "development", "clean-code", "best-practices"}', 0.771, 'Blue/White', 'Standard'),

-- Books - Business  
('Good to Great', 'BOOK-GTG-001', 16, 27.99, 14.00, 29.99,
 'Why some companies make the leap and others don''t', 'HarperBusiness', 'Good to Great', 'HB-GTG-001', 80,
 '{"pages": 320, "edition": "1st", "format": "Paperback", "isbn": "978-0066620992"}',
 '{"business", "leadership", "management", "strategy"}', 0.408, 'Blue/White', 'Standard'),

('The Lean Startup', 'BOOK-LS-001', 16, 26.99, 13.50, 28.99,
 'How today''s entrepreneurs use continuous innovation to create radically successful businesses', 'Crown Business', 'The Lean Startup', 'CB-LS-001', 65,
 '{"pages": 336, "edition": "1st", "format": "Paperback", "isbn": "978-0307887894"}',
 '{"startup", "entrepreneurship", "innovation", "business"}', 0.454, 'Orange/Black', 'Standard'),

-- Home & Garden
('Dyson V15 Detect', 'DYS-V15-001', 4, 749.99, 449.00, 799.99,
 'Cordless vacuum with laser dust detection and powerful suction', 'Dyson', 'V15 Detect', 'DYS-V15D-001', 20,
 '{"type": "Cordless Stick", "battery": "60 minutes", "features": "Laser detection, HEPA filtration", "weight": "6.8 lbs"}',
 '{"vacuum", "cordless", "dyson", "cleaning"}', 3.08, 'Yellow/Purple', 'Standard'),

('Instant Pot Duo 7-in-1', 'IP-DUO7-001', 4, 99.99, 59.00, 119.99,
 'Multi-use pressure cooker with 7 appliances in 1', 'Instant Pot', 'Duo 7-in-1', 'IP-DUO7-001', 50,
 '{"capacity": "6 Quart", "functions": 7, "features": "Pressure cook, slow cook, rice cooker, steamer, sauté, yogurt maker, warmer"}',
 '{"pressure-cooker", "instant-pot", "kitchen", "cooking"}', 5.44, 'Stainless Steel', '6 Quart'),

-- Clothing
('Levi''s 501 Original Jeans', 'LEV-501-001', 3, 89.99, 45.00, 98.00,
 'Classic straight-leg jeans in original indigo wash', 'Levi''s', '501 Original', 'LEV-501-001', 200,
 '{"fit": "Straight", "material": "100% Cotton", "wash": "Original Indigo", "care": "Machine wash"}',
 '{"jeans", "denim", "levis", "classic"}', 0.680, 'Indigo Blue', '32x32'),

('Nike Air Max 90', 'NIKE-AM90-001', 3, 129.99, 65.00, 139.99,
 'Iconic sneakers with visible Air Max cushioning', 'Nike', 'Air Max 90', 'NK-AM90-001', 150,
 '{"type": "Sneakers", "material": "Leather/Mesh", "sole": "Rubber", "cushioning": "Air Max"}',
 '{"sneakers", "nike", "airmax", "shoes"}', 0.907, 'White/Black', 'US 10'),

-- Add some budget and premium items
('Wireless Mouse', 'MOUSE-WL-001', 9, 24.99, 12.00, 29.99,
 'Ergonomic wireless mouse with long battery life', 'Generic Tech', 'Wireless Pro', 'GT-WM-001', 300,
 '{"connectivity": "2.4GHz Wireless", "battery": "12 months", "dpi": "1600", "buttons": 3}',
 '{"mouse", "wireless", "computer", "accessory"}', 0.113, 'Black', 'Standard'),

('Premium Leather Jacket', 'JACKET-LTH-001', 3, 599.99, 299.00, 699.99,
 'Genuine leather motorcycle jacket with premium craftsmanship', 'Premium Leather Co', 'Biker Classic', 'PLC-BC-001', 25,
 '{"material": "Genuine Leather", "style": "Motorcycle", "lining": "Quilted", "hardware": "YKK Zippers"}',
 '{"jacket", "leather", "motorcycle", "premium"}', 1.814, 'Black', 'Large');

-- Insert Promotions
INSERT INTO promotions (promotion_name, promotion_code, description, start_date, end_date,
                       discount_type, discount_value, min_order_amount, usage_limit) VALUES
('Summer Sale 2023', 'SUMMER23', 'Get 15% off orders over $100', '2023-06-01', '2023-08-31', 'Percentage', 15.00, 100.00, 1000),
('Back to School', 'SCHOOL23', '$50 off orders over $300', '2023-08-15', '2023-09-15', 'Fixed Amount', 50.00, 300.00, 500),
('Black Friday Deal', 'BLACKFRI23', '25% off everything', '2023-11-24', '2023-11-27', 'Percentage', 25.00, 0.00, 10000),
('New Customer Welcome', 'WELCOME10', '10% off first order', '2023-01-01', '2024-12-31', 'Percentage', 10.00, 50.00, NULL),
('Tech Enthusiast', 'TECH20', '20% off electronics over $500', '2023-01-01', '2023-12-31', 'Percentage', 20.00, 500.00, 200);

-- Update customer last login dates for some customers
UPDATE customers SET last_login = NOW() - INTERVAL '1 day' WHERE customer_id IN (1, 2, 3, 7, 10);
UPDATE customers SET last_login = NOW() - INTERVAL '1 week' WHERE customer_id IN (4, 5, 8, 12);
UPDATE customers SET last_login = NOW() - INTERVAL '1 month' WHERE customer_id IN (6, 9, 11);

-- Insert Orders (realistic order patterns)
INSERT INTO orders (order_number, customer_id, employee_id, order_date, required_date, shipped_date,
                   subtotal, tax_amount, shipping_cost, discount_amount, total_amount,
                   order_status, payment_method, payment_status,
                   ship_name, ship_address, ship_city, ship_state, ship_postal_code,
                   shipping_method, notes) VALUES

-- January 2023 Orders
('ORD-2023-0001', 1, 7, '2023-01-15 10:30:00', '2023-01-20', '2023-01-17 14:00:00',
 2499.00, 199.92, 0.00, 0.00, 2698.92, 'Delivered', 'Credit Card', 'Paid',
 'John Michael Smith', '123 Oak Street', 'New York', 'NY', '10001',
 'Express', 'Customer requested expedited delivery'),

('ORD-2023-0002', 2, 8, '2023-01-22 14:15:00', '2023-01-27', '2023-01-25 11:30:00',
 849.00, 67.92, 15.99, 84.90, 848.01, 'Delivered', 'Credit Card', 'Paid',
 'Jane Elizabeth Doe', '456 Pine Avenue', 'Los Angeles', 'CA', '90210',
 'Standard', 'Applied WELCOME10 discount'),

-- February 2023 Orders  
('ORD-2023-0003', 3, 7, '2023-02-05 09:45:00', '2023-02-12', '2023-02-08 16:20:00',
 1899.00, 151.92, 0.00, 0.00, 2050.92, 'Delivered', 'Business Account', 'Paid',
 'Peter Jones', '789 Maple Drive', 'Chicago', 'IL', '60601',
 'Express', 'Business customer - priority shipping'),

('ORD-2023-0004', 4, 9, '2023-02-18 16:20:00', '2023-02-25', '2023-02-22 13:45:00',
 45.99, 3.68, 9.99, 0.00, 59.66, 'Delivered', 'PayPal', 'Paid',
 'Mary Catherine Williams', '321 Elm Street', 'Houston', 'TX', '77001',
 'Standard', 'First book purchase'),

-- March 2023 Orders
('ORD-2023-0005', 5, 10, '2023-03-12 11:10:00', '2023-03-19', '2023-03-15 10:00:00',
 399.00, 31.92, 0.00, 0.00, 430.92, 'Delivered', 'Credit Card', 'Paid',
 'David James Brown', '654 Cedar Lane', 'Phoenix', 'AZ', '85001',
 'Express', 'Premium headphones for work'),

('ORD-2023-0006', 6, 7, '2023-03-28 13:30:00', '2023-04-04', '2023-04-01 15:30:00',
 1948.00, 155.84, 0.00, 389.60, 1714.24, 'Delivered', 'Business Account', 'Paid',
 'Sarah Marie Johnson', '987 Birch Road', 'Philadelphia', 'PA', '19101',
 'Express', 'Applied TECH20 discount - bulk electronics order'),

-- April 2023 Orders
('ORD-2023-0007', 1, 8, '2023-04-10 15:45:00', '2023-04-17', '2023-04-14 12:00:00',
 599.00, 47.92, 0.00, 0.00, 646.92, 'Delivered', 'Credit Card', 'Paid',
 'John Michael Smith', '123 Oak Street', 'New York', 'NY', '10001',
 'Standard', 'iPad for personal use'),

('ORD-2023-0008', 7, 7, '2023-04-25 08:45:00', '2023-05-02', '2023-04-28 14:20:00',
 2499.00, 199.92, 0.00, 624.75, 2074.17, 'Delivered', 'Credit Card', 'Paid',
 'Michael Robert Davis', '147 Spruce Circle', 'San Antonio', 'TX', '78201',
 'Express', 'Applied TECH20 discount - MacBook Pro'),

-- May 2023 Orders
('ORD-2023-0009', 8, 9, '2023-05-15 17:00:00', '2023-05-22', '2023-05-19 11:45:00',
 249.00, 19.92, 9.99, 0.00, 278.91, 'Delivered', 'Credit Card', 'Paid',
 'Emily Grace Wilson', '258 Willow Way', 'San Diego', 'CA', '92101',
 'Standard', 'AirPods for commuting'),

('ORD-2023-0010', 9, 10, '2023-05-30 12:15:00', '2023-06-06', '2023-06-03 16:00:00',
 1329.00, 106.32, 0.00, 0.00, 1435.32, 'Delivered', 'Business Account', 'Paid',
 'Robert Charles Miller', '369 Poplar Place', 'Dallas', 'TX', '75201',
 'Express', 'Dell laptop for business use'),

-- June 2023 Orders (Summer Sale period)
('ORD-2023-0011', 2, 7, '2023-06-15 14:30:00', '2023-06-22', '2023-06-20 13:15:00',
 847.99, 67.84, 0.00, 127.20, 788.63, 'Delivered', 'Credit Card', 'Paid',
 'Jane Elizabeth Doe', '456 Pine Avenue', 'Los Angeles', 'CA', '90210',
 'Standard', 'Applied SUMMER23 discount - Dyson vacuum'),

('ORD-2023-0012', 10, 8, '2023-06-28 10:00:00', '2023-07-05', '2023-07-02 14:30:00',
 172.98, 13.84, 15.99, 25.95, 176.86, 'Delivered', 'PayPal', 'Paid',
 'Jessica Lynn Moore', '741 Ash Boulevard', 'San Jose', 'CA', '95101',
 'Standard', 'Applied SUMMER23 discount - books bundle'),

-- July 2023 Orders
('ORD-2023-0013', 11, 9, '2023-07-20 16:45:00', '2023-07-27', '2023-07-25 10:20:00',
 24.99, 2.00, 9.99, 0.00, 36.98, 'Delivered', 'Credit Card', 'Paid',
 'Christopher Andrew Taylor', '852 Hickory Street', 'Austin', 'TX', '78701',
 'Standard', 'Wireless mouse for home office'),

('ORD-2023-0014', 12, 7, '2023-07-31 13:55:00', '2023-08-07', '2023-08-04 15:40:00',
 999.00, 79.92, 0.00, 0.00, 1078.92, 'Delivered', 'Credit Card', 'Paid',
 'Amanda Nicole Anderson', '963 Chestnut Avenue', 'Jacksonville', 'FL', '32201',
 'Express', 'iPhone 15 Pro upgrade'),

-- August 2023 Orders (Back to School period)
('ORD-2023-0015', 13, 10, '2023-08-20 09:20:00', '2023-08-27', '2023-08-25 12:10:00',
 325.97, 26.08, 0.00, 50.00, 301.05, 'Delivered', 'Business Account', 'Paid',
 'Daniel Scott Thomas', '159 Walnut Drive', 'Fort Worth', 'TX', '76101',
 'Standard', 'Applied SCHOOL23 discount - textbooks and supplies'),

('ORD-2023-0016', 14, 8, '2023-08-25 11:40:00', '2023-09-01', '2023-08-30 16:25:00',
 129.99, 10.40, 9.99, 0.00, 150.38, 'Delivered', 'Credit Card', 'Paid',
 'Michelle Renee Jackson', '357 Sycamore Lane', 'Columbus', 'OH', '43201',
 'Standard', 'Nike sneakers for back to school'),

-- September 2023 Orders
('ORD-2023-0017', 15, 9, '2023-09-15 15:25:00', '2023-09-22', '2023-09-20 11:50:00',
 599.99, 48.00, 0.00, 0.00, 647.99, 'Delivered', 'Credit Card', 'Paid',
 'Ryan Patrick White', '468 Magnolia Court', 'Charlotte', 'NC', '28201',
 'Express', 'Premium leather jacket'),

('ORD-2023-0018', 16, 7, '2023-09-28 08:30:00', '2023-10-05', '2023-10-02 14:15:00',
 199.00, 15.92, 15.99, 0.00, 230.91, 'Delivered', 'PayPal', 'Paid',
 'Maria Isabella Garcia', '579 Palm Street', 'El Paso', 'TX', '79901',
 'Standard', '4K webcam for remote work'),

-- October 2023 Orders
('ORD-2023-0019', 17, 8, '2023-10-12 12:50:00', '2023-10-19', '2023-10-16 13:30:00',
 1899.00, 151.92, 0.00, 0.00, 2050.92, 'Delivered', 'Credit Card', 'Paid',
 'James William Lee', '680 Bamboo Road', 'Seattle', 'WA', '98101',
 'Express', 'Gaming desktop for entertainment'),

('ORD-2023-0020', 18, 10, '2023-10-25 14:15:00', '2023-11-01', '2023-10-30 10:45:00',
 99.99, 8.00, 0.00, 0.00, 107.99, 'Delivered', 'Credit Card', 'Paid',
 'Lisa Sofia Rodriguez', '791 Coral Avenue', 'Miami', 'FL', '33101',
 'Standard', 'Instant Pot for cooking'),

-- November 2023 Orders (Black Friday period)
('ORD-2023-0021', 1, 7, '2023-11-24 00:15:00', '2023-12-01', '2023-11-27 16:00:00',
 2622.97, 209.84, 0.00, 655.74, 2177.07, 'Delivered', 'Credit Card', 'Paid',
 'John Michael Smith', '123 Oak Street', 'New York', 'NY', '10001',
 'Express', 'Applied BLACKFRI23 discount - Black Friday shopping spree'),

-- December 2023 Orders
('ORD-2023-0022', 19, 9, '2023-12-10 17:05:00', '2023-12-17', '2023-12-15 12:20:00',
 1299.00, 103.92, 0.00, 0.00, 1402.92, 'Delivered', 'Business Account', 'Paid',
 'Kevin Antonio Martinez', '802 Sunset Boulevard', 'Los Angeles', 'CA', '90028',
 'Express', 'Dell XPS for business expansion'),

('ORD-2023-0023', 20, 8, '2023-12-20 14:30:00', '2023-12-27', NULL,
 89.99, 7.20, 9.99, 0.00, 107.18, 'Processing', 'Credit Card', 'Paid',
 'Nicole Michelle Clark', '913 Rainbow Drive', 'Las Vegas', 'NV', '89101',
 'Standard', 'Holiday gift - Levi''s jeans'),

-- 2024 Orders for trend analysis
('ORD-2024-0001', 2, 7, '2024-01-05 10:15:00', '2024-01-12', '2024-01-08 15:30:00',
 749.99, 60.00, 0.00, 74.99, 734.00, 'Delivered', 'Credit Card', 'Paid',
 'Jane Elizabeth Doe', '456 Pine Avenue', 'Los Angeles', 'CA', '90210',
 'Express', 'Applied WELCOME10 discount - Dyson V15'),

('ORD-2024-0002', 5, 8, '2024-02-14 16:20:00', '2024-02-21', '2024-02-18 11:45:00',
 648.00, 51.84, 0.00, 0.00, 699.84, 'Delivered', 'Credit Card', 'Paid',
 'David James Brown', '654 Cedar Lane', 'Phoenix', 'AZ', '85001',
 'Standard', 'Valentine''s Day gift bundle');

-- Insert Order Details
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount_percentage, product_name) VALUES
-- Order 1: MacBook Pro
(1, 1, 1, 2499.00, 0.00, 'MacBook Pro 16-inch'),

-- Order 2: Samsung Galaxy with welcome discount
(2, 5, 1, 849.00, 10.00, 'Samsung Galaxy S24'),

-- Order 3: Gaming Desktop
(3, 3, 1, 1899.00, 0.00, 'Gaming Desktop PC'),

-- Order 4: Learning SQL book
(4, 10, 1, 45.99, 0.00, 'Learning SQL'),

-- Order 5: Sony Headphones
(5, 7, 1, 399.00, 0.00, 'Sony WH-1000XM5'),

-- Order 6: Multiple electronics with tech discount
(6, 1, 1, 2499.00, 20.00, 'MacBook Pro 16-inch'),
(6, 8, 1, 199.00, 20.00, '4K Webcam'),

-- Order 7: iPad Air  
(7, 6, 1, 599.00, 0.00, 'iPad Air'),

-- Order 8: MacBook Pro with tech discount
(8, 1, 1, 2499.00, 25.00, 'MacBook Pro 16-inch'),

-- Order 9: AirPods Pro
(9, 8, 1, 249.00, 0.00, 'AirPods Pro 2nd Gen'),

-- Order 10: Dell XPS
(10, 2, 1, 1299.00, 0.00, 'Dell XPS 13'),

-- Order 11: Dyson with summer discount
(11, 15, 1, 749.99, 15.00, 'Dyson V15 Detect'),

-- Order 12: Books bundle with summer discount
(12, 10, 1, 45.99, 15.00, 'Learning SQL'),
(12, 11, 1, 39.99, 15.00, 'Python Crash Course'),
(12, 12, 1, 42.99, 15.00, 'Clean Code'),
(12, 13, 1, 27.99, 15.00, 'Good to Great'),

-- Order 13: Wireless mouse
(13, 19, 1, 24.99, 0.00, 'Wireless Mouse'),

-- Order 14: iPhone 15 Pro
(14, 4, 1, 999.00, 0.00, 'iPhone 15 Pro'),

-- Order 15: Back to school bundle
(15, 10, 1, 45.99, 0.00, 'Learning SQL'),
(15, 11, 1, 39.99, 0.00, 'Python Crash Course'),
(15, 12, 1, 42.99, 0.00, 'Clean Code'),
(15, 13, 2, 27.99, 0.00, 'Good to Great'),
(15, 14, 1, 26.99, 0.00, 'The Lean Startup'),
(15, 19, 1, 24.99, 0.00, 'Wireless Mouse'),

-- Order 16: Nike sneakers
(16, 18, 1, 129.99, 0.00, 'Nike Air Max 90'),

-- Order 17: Premium leather jacket
(17, 20, 1, 599.99, 0.00, 'Premium Leather Jacket'),

-- Order 18: 4K webcam
(18, 9, 1, 199.00, 0.00, '4K Webcam'),

-- Order 19: Gaming desktop
(19, 3, 1, 1899.00, 0.00, 'Gaming Desktop PC'),

-- Order 20: Instant Pot
(20, 16, 1, 99.99, 0.00, 'Instant Pot Duo 7-in-1'),

-- Order 21: Black Friday shopping spree
(21, 1, 1, 2499.00, 25.00, 'MacBook Pro 16-inch'),
(21, 7, 1, 399.00, 25.00, 'Sony WH-1000XM5'),
(21, 8, 1, 249.00, 25.00, 'AirPods Pro 2nd Gen'),

-- Order 22: Business Dell XPS
(22, 2, 1, 1299.00, 0.00, 'Dell XPS 13'),

-- Order 23: Holiday Levi's jeans
(23, 17, 1, 89.99, 0.00, 'Levi''s 501 Original Jeans'),

-- Order 24: 2024 Dyson purchase
(24, 15, 1, 749.99, 10.00, 'Dyson V15 Detect'),

-- Order 25: Valentine's gift bundle
(25, 8, 1, 249.00, 0.00, 'AirPods Pro 2nd Gen'),
(25, 7, 1, 399.00, 0.00, 'Sony WH-1000XM5');

-- Insert Inventory records
INSERT INTO inventory (product_id, supplier_id, quantity_on_hand, quantity_allocated, unit_cost,
                      warehouse_location, bin_location, last_restock_date, next_restock_date) VALUES
(1, 1, 23, 2, 1899.00, 'Warehouse-West', 'A1-001', '2024-01-15', '2024-03-15'),
(2, 1, 28, 2, 899.00, 'Warehouse-West', 'A1-002', '2024-01-20', '2024-03-20'),
(3, 1, 14, 1, 1299.00, 'Warehouse-Central', 'B2-001', '2024-02-01', '2024-04-01'),
(4, 1, 49, 1, 699.00, 'Warehouse-West', 'A1-003', '2024-01-10', '2024-03-10'),
(5, 1, 39, 1, 599.00, 'Warehouse-West', 'A1-004', '2024-01-25', '2024-03-25'),
(6, 1, 34, 1, 429.00, 'Warehouse-West', 'A1-005', '2024-02-05', '2024-04-05'),
(7, 1, 59, 1, 249.00, 'Warehouse-East', 'C3-001', '2024-01-30', '2024-03-30'),
(8, 1, 79, 1, 149.00, 'Warehouse-East', 'C3-002', '2024-02-10', '2024-04-10'),
(9, 1, 44, 1, 119.00, 'Warehouse-East', 'C3-003', '2024-02-15', '2024-04-15'),
(10, 2, 97, 3, 23.00, 'Warehouse-Central', 'D1-001', '2024-01-05', '2024-04-05');

-- Insert Product Reviews
INSERT INTO product_reviews (product_id, customer_id, order_id, rating, title, review_text,
                           is_verified_purchase, helpful_votes, total_votes, status) VALUES
(1, 1, 1, 5, 'Excellent laptop for professionals', 
 'This MacBook Pro exceeded my expectations. The M2 Pro chip is incredibly fast and the display is stunning. Perfect for development work and video editing. Battery life easily lasts a full work day.', 
 TRUE, 15, 18, 'Approved'),

(5, 2, 2, 4, 'Great phone, but expensive', 
 'The Samsung Galaxy S24 has amazing camera quality and the display is vibrant. Performance is smooth for all apps. Only downside is the price point, but you get what you pay for in terms of quality.', 
 TRUE, 8, 10, 'Approved'),

(3, 3, 3, 5, 'Gaming beast!', 
 'This gaming desktop handles everything I throw at it. Ultra settings on all games, smooth 4K gaming, and the RGB lighting looks fantastic. Assembly was straightforward and customer service was helpful.', 
 TRUE, 22, 25, 'Approved'),

(7, 5, 5, 5, 'Best noise-canceling headphones', 
 'Sony has outdone themselves with the WH-1000XM5. The noise cancellation is industry-leading and sound quality is pristine. Comfortable for long listening sessions. Worth every penny.', 
 TRUE, 31, 35, 'Approved'),

(10, 4, 4, 4, 'Great SQL learning resource', 
 'Learning SQL is well-structured and easy to follow. Examples are practical and relevant. Good for beginners but also has advanced topics. Only wish it had more PostgreSQL-specific content.', 
 TRUE, 12, 14, 'Approved'),

(8, 9, 9, 5, 'Perfect for commuting', 
 'AirPods Pro 2nd gen are fantastic. Great sound quality, excellent noise cancellation, and seamless integration with iPhone. Battery life is impressive and the case is compact.', 
 TRUE, 18, 20, 'Approved'),

(15, 11, 11, 4, 'Powerful vacuum, bit heavy', 
 'The Dyson V15 Detect cleans incredibly well and the laser feature is actually useful for seeing dust. Suction power is excellent. Only complaint is it can be heavy for extended use.', 
 TRUE, 9, 12, 'Approved'),

(2, 10, 10, 5, 'Perfect business laptop', 
 'Dell XPS 13 is ideal for business use. Lightweight, great build quality, and excellent display. Battery easily lasts through meetings and travel. Highly recommend for professionals.', 
 TRUE, 14, 16, 'Approved');

-- Insert Customer Preferences
INSERT INTO customer_preferences (customer_id, email_marketing, sms_marketing, phone_marketing,
                                preferred_categories, preferred_brands, price_range_min, price_range_max,
                                preferred_shipping_method, other_preferences) VALUES
(1, TRUE, FALSE, FALSE, '{9,11}', '{"Apple","Sony"}', 100.00, 3000.00, 'Express',
 '{"newsletter": true, "product_updates": true, "deals": true}'),

(2, TRUE, TRUE, FALSE, '{9,10,3}', '{"Samsung","Apple","Nike"}', 50.00, 1500.00, 'Standard',
 '{"newsletter": true, "product_updates": false, "deals": true}'),

(3, FALSE, FALSE, TRUE, '{9}', '{"Dell","Custom Build"}', 500.00, 5000.00, 'Express',
 '{"newsletter": false, "product_updates": true, "deals": false}'),

(4, TRUE, FALSE, FALSE, '{15,16}', '{"O''Reilly Media"}', 20.00, 100.00, 'Standard',
 '{"newsletter": true, "product_updates": true, "deals": true}'),

(5, TRUE, TRUE, FALSE, '{11}', '{"Sony","Apple"}', 100.00, 800.00, 'Express',
 '{"newsletter": true, "product_updates": false, "deals": true}');

-- Update product average ratings based on reviews
UPDATE products SET average_rating = 5.0, review_count = 1 WHERE product_id = 1;
UPDATE products SET average_rating = 4.0, review_count = 1 WHERE product_id = 2;
UPDATE products SET average_rating = 5.0, review_count = 1 WHERE product_id = 3;
UPDATE products SET average_rating = 5.0, review_count = 1 WHERE product_id = 5;
UPDATE products SET average_rating = 5.0, review_count = 1 WHERE product_id = 7;
UPDATE products SET average_rating = 4.0, review_count = 1 WHERE product_id = 8;
UPDATE products SET average_rating = 4.0, review_count = 1 WHERE product_id = 10;
UPDATE products SET average_rating = 4.0, review_count = 1 WHERE product_id = 15;

-- Update customer lifetime values based on their orders
UPDATE customers SET lifetime_value = (
    SELECT COALESCE(SUM(total_amount), 0)
    FROM orders
    WHERE orders.customer_id = customers.customer_id
);

-- =====================================================================
-- VIEWS FOR BUSINESS INTELLIGENCE
-- =====================================================================

-- Customer summary view (used in lesson plan examples)
CREATE OR REPLACE VIEW customer_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    c.email,
    c.city,
    c.state,
    c.customer_type,
    COUNT(o.order_id) as total_orders,
    COALESCE(SUM(o.total_amount), 0) as lifetime_value,
    COALESCE(AVG(o.total_amount), 0) as avg_order_value,
    MIN(o.order_date) as first_order_date,
    MAX(o.order_date) as last_order_date,
    CASE 
        WHEN MAX(o.order_date) > CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
        WHEN MAX(o.order_date) > CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
        WHEN MAX(o.order_date) IS NOT NULL THEN 'Inactive'
        ELSE 'Prospect'
    END as customer_status,
    c.created_at as customer_since
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.city, c.state, 
         c.customer_type, c.created_at;

-- Product performance view
CREATE OR REPLACE VIEW product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.brand,
    p.price,
    p.average_rating,
    p.review_count,
    COALESCE(SUM(od.quantity), 0) as total_sold,
    COALESCE(SUM(od.line_total), 0) as total_revenue,
    COALESCE(COUNT(DISTINCT od.order_id), 0) as times_ordered,
    CASE 
        WHEN COALESCE(SUM(od.quantity), 0) = 0 THEN 'No Sales'
        WHEN COALESCE(SUM(od.quantity), 0) < 5 THEN 'Low'
        WHEN COALESCE(SUM(od.quantity), 0) < 20 THEN 'Medium'
        ELSE 'High'
    END as sales_performance
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, c.category_name, p.brand, p.price, 
         p.average_rating, p.review_count;

-- Sales summary view for reporting
CREATE OR REPLACE VIEW daily_sales_summary AS
SELECT 
    DATE_TRUNC('day', order_date)::DATE as sale_date,
    COUNT(*) as order_count,
    SUM(total_amount) as revenue,
    AVG(total_amount) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(CASE WHEN order_status = 'Delivered' THEN total_amount ELSE 0 END) as delivered_revenue
FROM orders
GROUP BY DATE_TRUNC('day', order_date)::DATE
ORDER BY sale_date;

-- =====================================================================
-- STORED PROCEDURES AND FUNCTIONS
-- =====================================================================

-- Function to calculate customer lifetime value
CREATE OR REPLACE FUNCTION calculate_customer_ltv(customer_id_param INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    ltv DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(total_amount), 0)
    INTO ltv
    FROM orders
    WHERE customer_id = customer_id_param
      AND order_status IN ('Delivered', 'Shipped');
    
    RETURN ltv;
END;
$$ LANGUAGE plpgsql;

-- Function to get top customers by spending
CREATE OR REPLACE FUNCTION get_top_customers(limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
    customer_id INTEGER,
    customer_name TEXT,
    email VARCHAR(100),
    total_spent DECIMAL(10,2),
    order_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.customer_id,
        (c.first_name || ' ' || c.last_name)::TEXT as customer_name,
        c.email,
        COALESCE(SUM(o.total_amount), 0) as total_spent,
        COUNT(o.order_id) as order_count
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
    ORDER BY total_spent DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================================
-- FINAL SETUP AND ANALYSIS QUERIES
-- =====================================================================

-- Refresh materialized views (if any were created)
-- REFRESH MATERIALIZED VIEW daily_sales_summary;

-- Generate some statistics for verification
-- This query will be useful for lesson plan demonstrations
CREATE OR REPLACE VIEW database_stats AS
SELECT 
    'customers' as table_name,
    COUNT(*) as record_count,
    'Individual customer records' as description
FROM customers
UNION ALL
SELECT 
    'products' as table_name,
    COUNT(*) as record_count,
    'Product catalog items' as description
FROM products
UNION ALL
SELECT 
    'orders' as table_name,
    COUNT(*) as record_count,
    'Customer orders placed' as description
FROM orders
UNION ALL
SELECT 
    'order_details' as table_name,
    COUNT(*) as record_count,
    'Individual order line items' as description
FROM order_details
UNION ALL
SELECT 
    'employees' as table_name,
    COUNT(*) as record_count,
    'Company employees' as description
FROM employees
UNION ALL
SELECT 
    'product_reviews' as table_name,
    COUNT(*) as record_count,
    'Customer product reviews' as description
FROM product_reviews;

-- Add comments to tables for documentation
COMMENT ON TABLE customers IS 'Customer information including contact details, preferences, and account status';
COMMENT ON TABLE products IS 'Product catalog with pricing, inventory, and specifications';
COMMENT ON TABLE orders IS 'Customer orders with shipping and payment information';
COMMENT ON TABLE order_details IS 'Individual line items for each order';
COMMENT ON TABLE employees IS 'Company employees with hierarchy and territory assignments';
COMMENT ON TABLE categories IS 'Product categories with hierarchical structure';
COMMENT ON TABLE departments IS 'Company departments and budget information';
COMMENT ON TABLE product_reviews IS 'Customer reviews and ratings for products';
COMMENT ON TABLE inventory IS 'Current inventory levels and warehouse locations';

-- Final message
SELECT 'Database initialization completed successfully!' as status,
       'Ready for SQL training exercises' as message,
       NOW() as completed_at;
