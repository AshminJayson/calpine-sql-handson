# Module 2: SQL for Data Scientists & AI Professionals – Lesson Plan

**Total Duration:** 8 Hours  
**Target Audience:** Freshers and veteran IT professionals with varying SQL experience levels  
**Instructor:** Corporate Trainer / Senior Data Professional

> **Note for Mixed Audiences:** This lesson plan includes foundational concepts for beginners alongside advanced insights for experienced professionals. Veterans can mentor newcomers during hands-on exercises.

---

## Hour 1: Introduction to Databases & SQL

**Objective:** Participants will understand the fundamental concepts of relational databases, their importance in data science, and how to set up a basic database environment.

### Key Concepts:
- **Database vs. File Systems:** Structured storage, concurrent access, data integrity
- **RDBMS Fundamentals:** ACID properties, transaction management, concurrency control
- **Database Architecture:** Physical vs. logical data independence, three-schema architecture
- **Core Terminology:** Tables, Rows (Records), Columns (Fields), Constraints, Indexes
- **Database Schema:** The blueprint of the database, normalization levels (1NF, 2NF, 3NF)
- **Keys & Relationships:** Primary Key, Foreign Key, Composite Keys, Referential Integrity
- **Data Types:** Numeric, String, Date/Time, Boolean, JSON (PostgreSQL specific)

### Teaching Activities & Content (60 mins):

#### [0-20 mins] The "Why": SQL in the Age of AI & Big Data

**Real-World Context:**
- **Industry Examples:** 
  - Netflix uses SQL to analyze viewing patterns across 200M+ users
  - Uber processes 15+ billion GPS coordinates daily through SQL queries
  - Financial institutions rely on SQL for real-time fraud detection
  
- **Data Volume Reality Check:**
  - Excel limitation: ~1M rows, SQL handles billions efficiently
  - Concurrent users: Excel = 1, SQL databases = thousands simultaneously
  - Data integrity: Excel has no built-in validation, SQL enforces constraints

**The Modern Data Stack:**
```
Data Sources → SQL Databases → Analytics Tools → AI/ML Models
    ↓              ↓               ↓              ↓
  APIs, IoT    PostgreSQL,     Python/R,    TensorFlow,
  Sensors,     MySQL,          Tableau,     PyTorch,
  Web Apps     BigQuery        Power BI     Scikit-learn
```

**For Veterans:** Discuss how SQL has evolved with NoSQL, NewSQL, and cloud-native databases while maintaining its core relevance.

#### [20-45 mins] Deep Dive: Database Architecture & Concepts

**ACID Properties Explained:**
- **Atomicity:** All-or-nothing transactions
  ```sql
  BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
  COMMIT; -- Both updates succeed or both fail
  ```

- **Consistency:** Data integrity rules are maintained
- **Isolation:** Concurrent transactions don't interfere
- **Durability:** Committed changes survive system failures

**Normalization with Real Examples:**

**Un-normalized (Problematic):**
| order_id | customer_name | customer_email | product_name | price | quantity |
|----------|---------------|----------------|--------------|-------|----------|
| 1        | John Doe      | john@email.com | Laptop       | 999   | 1        |
| 2        | John Doe      | john@email.com | Mouse        | 25    | 2        |

**Problems:** Data redundancy, update anomalies, storage waste

**Normalized (Efficient):**

**Customers Table:**
| customer_id | name     | email          |
|-------------|----------|----------------|
| 1           | John Doe | john@email.com |

**Products Table:**
| product_id | name   | price |
|------------|--------|-------|
| 1          | Laptop | 999   |
| 2          | Mouse  | 25    |

**Orders Table:**
| order_id | customer_id | product_id | quantity |
|----------|-------------|------------|----------|
| 1        | 1           | 1          | 1        |
| 2        | 1           | 2          | 2        |

**Advanced Relationship Types:**
- **One-to-One:** User ↔ Profile
- **One-to-Many:** Customer → Orders (most common)
- **Many-to-Many:** Students ↔ Courses (requires junction table)

#### [45-55 mins] Production-Grade Environment Setup
- Introduce options (MySQL, PostgreSQL, etc.) and explain that we'll be using PostgreSQL as it's a powerful, open-source RDBMS widely used in the industry.
- **Why PostgreSQL?** 
  - ACID compliant, highly extensible
  - Advanced features: JSON support, window functions, CTEs
  - Used by: Instagram, Spotify, Netflix, Reddit
- We will run it using Docker to ensure a consistent and isolated environment for everyone.

**Enterprise Considerations:**
- **Development vs. Production:** Local Docker for learning, managed services (AWS RDS, Azure Database) for production
- **High Availability:** Read replicas, failover clustering, backup strategies
- **Security:** SSL connections, role-based access control, encryption at rest

**Instructions for Participants:**

1. **Install Docker Desktop:** Ensure you have Docker Desktop installed and running on your machine.

2. **Pull the PostgreSQL Image:** Open your terminal or command prompt and run:
   ```bash
   docker pull postgres:15
   ```

3. **Start the Container with Production-like Settings:**
   ```bash
   # Windows PowerShell
   docker run --name sql-training `
     -e POSTGRES_DB=company_db `
     -e POSTGRES_USER=training_user `
     -e POSTGRES_PASSWORD=SecurePass123! `
     -e POSTGRES_INITDB_ARGS="--auth-local=scram-sha-256" `
     -p 5432:5432 `
     -v ${PWD}/db_data:/var/lib/postgresql/data `
     -d postgres:15
   
   # Linux/Mac
   docker run --name sql-training \
     -e POSTGRES_DB=company_db \
     -e POSTGRES_USER=training_user \
     -e POSTGRES_PASSWORD=SecurePass123! \
     -e POSTGRES_INITDB_ARGS="--auth-local=scram-sha-256" \
     -p 5432:5432 \
     -v $(pwd)/db_data:/var/lib/postgresql/data \
     -d postgres:15
   ```

4. **Install Professional GUI Tools:** 
   - **Primary:** DBeaver Community (free, multi-platform, feature-rich)
   - **Alternatives:** pgAdmin, DataGrip (JetBrains), Azure Data Studio
   - **Command Line:** psql (included with PostgreSQL)

5. **Connect to the Database with Enhanced Security:**
   - **Host:** localhost
   - **Port:** 5432
   - **Database:** company_db
   - **Username:** training_user
   - **Password:** SecurePass123!
   - **SSL Mode:** Prefer (for production: Require)

6. **Load Comprehensive Sample Data:**
   ```sql
   -- Execute the enhanced_sample_dataset.sql
   -- Includes: customers, products, orders, employees, departments
   -- Advanced features: constraints, indexes, triggers, views
   ```

**Docker Management Commands:**
```bash
# Check container status
docker ps

# View logs
docker logs sql-training

# Stop container
docker stop sql-training

# Restart container
docker start sql-training

# Execute commands inside container
docker exec -it sql-training psql -U training_user -d company_db
```

#### [55-60 mins] Advanced Hands-on Exercise

**For Beginners:**
- Use GUI to explore the schema structure
- **Task:** "Navigate the customers and orders tables. Identify the Primary Key in each table and the Foreign Key that links them."

**For Veterans:**
- Explore using both GUI and command line
- **Advanced Tasks:**
  1. "Examine the table constraints using SQL: `\d+ table_name` in psql"
  2. "Identify indexes on tables using: `SELECT * FROM pg_indexes WHERE tablename = 'orders';`"
  3. "Check foreign key relationships: `SELECT * FROM information_schema.key_column_usage WHERE table_name = 'orders';`"

**Discussion Points:**
- Compare PostgreSQL's system catalogs with other databases (SQL Server's sys tables, MySQL's information_schema)
- Discuss when to use GUI vs. command line tools in different scenarios

---

## Hour 2: Basic SQL Queries

**Objective:** Participants will learn to retrieve data from a single table using fundamental SQL commands, understand data types, handle NULL values, and apply performance considerations.

### Key Concepts:
- **Core Clauses:** SELECT, FROM, WHERE, ORDER BY, LIMIT/OFFSET
- **Data Types:** Understanding PostgreSQL types (INTEGER, VARCHAR, TIMESTAMP, BOOLEAN, JSON, ARRAY)
- **Operators:** Comparison (=, !=, >, <, >=, <=), Logical (AND, OR, NOT), Pattern Matching (LIKE, ILIKE, REGEX)
- **NULL Handling:** IS NULL, IS NOT NULL, COALESCE, NULL behavior in comparisons
- **Functions:** String functions, Date functions, Mathematical functions
- **Performance:** Query execution plans, indexing basics

### Teaching Activities & Content (60 mins):

#### [0-15 mins] The Anatomy of a Query & Data Types

**SQL Query Structure:**
```sql
-- Basic anatomy
SELECT column1, column2          -- Projection: What columns to return
FROM table_name                 -- Data source: Which table to query
WHERE condition                 -- Filter: Which rows to include
ORDER BY column                 -- Sorting: How to order results
LIMIT number;                   -- Pagination: How many rows to return
```

**PostgreSQL Data Types in Action:**
```sql
-- Explore our sample data types
SELECT 
    customer_id,                 -- INTEGER
    first_name,                  -- VARCHAR(50)
    email,                       -- VARCHAR(100)
    created_at,                  -- TIMESTAMP
    is_active,                   -- BOOLEAN
    preferences                  -- JSON (PostgreSQL specific)
FROM customers 
LIMIT 3;

-- Working with different data types
SELECT 
    product_name,
    price::MONEY,                -- Type casting to display as currency
    created_at::DATE,            -- Extract date part only
    EXTRACT(YEAR FROM created_at) as creation_year,
    array_length(tags, 1) as tag_count  -- Working with arrays
FROM products;
```

#### [15-35 mins] Advanced Filtering with WHERE

**Comparison Operators:**
```sql
-- Numeric comparisons
SELECT * FROM products WHERE price > 100;
SELECT * FROM products WHERE price BETWEEN 50 AND 200;  -- Inclusive range
SELECT * FROM products WHERE price NOT BETWEEN 50 AND 200;

-- String comparisons (case-sensitive in PostgreSQL)
SELECT * FROM products WHERE category = 'Electronics';
SELECT * FROM products WHERE category != 'Books';
```

**Pattern Matching (Critical for Text Search):**
```sql
-- LIKE for basic pattern matching (case-sensitive)
SELECT * FROM customers WHERE email LIKE '%@gmail.com';
SELECT * FROM customers WHERE first_name LIKE 'J%';     -- Starts with J
SELECT * FROM customers WHERE last_name LIKE '%son';    -- Ends with son
SELECT * FROM customers WHERE phone LIKE '___-___-____'; -- Exact pattern

-- ILIKE for case-insensitive matching (PostgreSQL specific)
SELECT * FROM customers WHERE first_name ILIKE 'john%';

-- Regular expressions (PostgreSQL advanced feature)
SELECT * FROM customers WHERE email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

-- Full-text search (PostgreSQL specific)
SELECT * FROM products WHERE to_tsvector('english', description) @@ to_tsquery('laptop & fast');
```

**NULL Handling (Critical Concept):**
```sql
-- NULL comparisons (common mistake area)
SELECT * FROM customers WHERE phone = NULL;        -- WRONG: Returns no results
SELECT * FROM customers WHERE phone IS NULL;       -- CORRECT
SELECT * FROM customers WHERE phone IS NOT NULL;   -- CORRECT

-- COALESCE for default values
SELECT 
    first_name,
    COALESCE(phone, 'No phone provided') as contact_phone,
    COALESCE(middle_name, '') as middle_name_safe
FROM customers;

-- NULLIF for conditional NULL assignment
SELECT 
    product_name,
    NULLIF(discount_percentage, 0) as actual_discount  -- Returns NULL if discount is 0
FROM products;
```

**Logical Operators with Precedence:**
```sql
-- AND has higher precedence than OR
SELECT * FROM products 
WHERE category = 'Electronics' AND price > 100 OR category = 'Books';
-- This is interpreted as: (category = 'Electronics' AND price > 100) OR category = 'Books'

-- Use parentheses for clarity
SELECT * FROM products 
WHERE (category = 'Electronics' OR category = 'Books') AND price > 100;

-- IN operator for multiple values
SELECT * FROM products WHERE category IN ('Electronics', 'Books', 'Clothing');
SELECT * FROM orders WHERE order_status NOT IN ('Cancelled', 'Refunded');
```

#### [35-50 mins] Sorting, Limiting & Advanced Functions

**Advanced Sorting:**
```sql
-- Multiple column sorting
SELECT * FROM products 
ORDER BY category ASC, price DESC;

-- NULL handling in sorting
SELECT * FROM customers 
ORDER BY phone NULLS LAST, last_name;  -- NULLs appear at the end

-- Custom sorting with CASE
SELECT * FROM orders 
ORDER BY 
    CASE order_status 
        WHEN 'Pending' THEN 1
        WHEN 'Processing' THEN 2
        WHEN 'Shipped' THEN 3
        WHEN 'Delivered' THEN 4
        ELSE 5
    END;
```

**Pagination Strategies:**
```sql
-- Basic pagination
SELECT * FROM products ORDER BY product_id LIMIT 10 OFFSET 0;   -- Page 1
SELECT * FROM products ORDER BY product_id LIMIT 10 OFFSET 10;  -- Page 2

-- Keyset pagination (more efficient for large datasets)
SELECT * FROM products 
WHERE product_id > 1000 
ORDER BY product_id 
LIMIT 10;
```

**Essential Functions:**
```sql
-- String functions
SELECT 
    UPPER(first_name) as first_name_upper,
    LOWER(email) as email_lower,
    CONCAT(first_name, ' ', last_name) as full_name,
    LENGTH(first_name) as name_length,
    TRIM(first_name) as trimmed_name,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1) as username_part
FROM customers;

-- Date/Time functions
SELECT 
    NOW() as current_timestamp,
    CURRENT_DATE as today,
    AGE(birth_date) as customer_age,
    DATE_PART('year', created_at) as creation_year,
    created_at + INTERVAL '30 days' as thirty_days_later
FROM customers;

-- Mathematical functions
SELECT 
    product_name,
    price,
    ROUND(price * 0.8, 2) as discounted_price,
    CEIL(price / 10) as price_tier,
    FLOOR(price) as price_floor
FROM products;
```

#### [50-60 mins] Performance Considerations & Hands-on Exercises

**Query Performance Basics:**
```sql
-- EXPLAIN shows query execution plan
EXPLAIN SELECT * FROM customers WHERE email = 'john@example.com';

-- EXPLAIN ANALYZE shows actual execution statistics
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics';

-- Inefficient query (full table scan)
EXPLAIN SELECT * FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2023;

-- More efficient alternative
EXPLAIN SELECT * FROM orders 
WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01';
```

**Hands-on Exercises:**

**For Beginners:**
1. **Basic Filtering:** "Find all products in the 'Books' category with their names and prices."
2. **Pattern Matching:** "Find all customers whose email addresses end with '.org'."
3. **Date Filtering:** "Find all orders placed in the last 30 days."
4. **Sorting:** "List the top 5 most expensive products."

**For Veterans:**
1. **Complex Filtering:** "Find customers who have a phone number, whose first name starts with 'A' or 'B', and who were created in the last year."
2. **Advanced Functions:** "Create a query that shows customer full names in title case, their email domains, and days since they joined."
3. **Performance Analysis:** "Compare the execution plans of different approaches to find orders from 2023."
4. **JSON Queries:** "Extract specific preferences from the customer preferences JSON column."

**Advanced Example Solutions:**
```sql
-- Complex filtering example
SELECT 
    customer_id,
    CONCAT(INITCAP(first_name), ' ', INITCAP(last_name)) as full_name_title_case,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) as email_domain,
    AGE(created_at) as days_since_joined
FROM customers 
WHERE phone IS NOT NULL 
    AND (first_name ILIKE 'a%' OR first_name ILIKE 'b%')
    AND created_at > NOW() - INTERVAL '1 year'
ORDER BY created_at DESC;

-- JSON query example (PostgreSQL specific)
SELECT 
    customer_id,
    first_name,
    preferences->>'theme' as preferred_theme,
    (preferences->>'notifications')::boolean as wants_notifications
FROM customers 
WHERE preferences ? 'theme'  -- Check if JSON contains 'theme' key
    AND preferences->>'theme' = 'dark';
```

---

## Hour 3: Joins & Relationships

**Objective:** Participants will learn how to combine data from multiple tables, understand join algorithms, and optimize join performance.

### Key Concepts:
- **Join Types:** INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, CROSS JOIN
- **Advanced Joins:** Self-joins, Multiple table joins, Non-equi joins
- **Join Algorithms:** Nested Loop, Hash Join, Sort-Merge Join
- **Performance:** Join order optimization, indexing for joins
- **Table Aliases:** Readability and namespace management

### Teaching Activities & Content (60 mins):

#### [0-25 mins] Join Fundamentals & Real-World Context

**Why We Need Joins - Business Scenario:**
Imagine you're analyzing an e-commerce platform:
- Customer places an order (need customer details + order info)
- Order contains multiple products (need product details + quantities)
- We want to find: "Which customers bought laptops in December 2023?"

This requires combining data from multiple tables that were normalized to avoid redundancy.

**Venn Diagram Visualization:**
```
Table A (Customers)    Table B (Orders)
┌─────────────┐       ┌─────────────┐
│  John (1)   │───────│ Order 101   │  INNER JOIN: Customers who have orders
│  Mary (2)   │   ┌───│ Order 102   │  LEFT JOIN:  All customers + their orders (if any)
│  Bob (3)    │   │   │ Order 103   │  RIGHT JOIN: All orders + customer details (if any)
└─────────────┘   │   └─────────────┘  FULL JOIN:  All customers and all orders
    │  Alice (4)    │       │ Order 104    
    │ (no orders)   │       │ (orphaned)
    └───────────────┘       └────────────
```

**Join Syntax Patterns:**
```sql
-- ANSI SQL Standard (Recommended)
SELECT columns
FROM table1 t1
JOIN table2 t2 ON t1.key = t2.key;

-- Old-style (Avoid - less clear, error-prone)
SELECT columns
FROM table1 t1, table2 t2
WHERE t1.key = t2.key;
```

#### [25-45 mins] Comprehensive Join Examples

**INNER JOIN - Only Matching Records:**
```sql
-- Basic customer-order relationship
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- Multiple table join: Customer → Order → Order Details → Product
SELECT 
    c.first_name || ' ' || c.last_name as customer_name,
    o.order_id,
    p.product_name,
    od.quantity,
    od.unit_price,
    (od.quantity * od.unit_price) as line_total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE o.order_date >= '2023-01-01'
ORDER BY c.last_name, o.order_date;
```

**LEFT JOIN - Include All Left Table Records:**
```sql
-- All customers and their orders (including customers with no orders)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) as order_count,
    COALESCE(SUM(o.total_amount), 0) as total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Find customers who haven't placed any orders
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;  -- The key to finding non-matches
```

**RIGHT JOIN & FULL OUTER JOIN:**
```sql
-- RIGHT JOIN: All orders and customer details (rare in practice)
SELECT 
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- FULL OUTER JOIN: All customers and all orders
SELECT 
    COALESCE(c.first_name, 'Unknown') as first_name,
    COALESCE(o.order_id::text, 'No orders') as order_id
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
```

**Advanced Join Scenarios:**

**Self-Join (Employee-Manager Relationship):**
```sql
-- Find employees and their managers
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name as employee_name,
    e.job_title,
    m.first_name || ' ' || m.last_name as manager_name,
    m.job_title as manager_title
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY m.last_name, e.last_name;

-- Find employees who are managers (have subordinates)
SELECT DISTINCT
    m.employee_id,
    m.first_name || ' ' || m.last_name as manager_name,
    COUNT(e.employee_id) as subordinate_count
FROM employees m
INNER JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id, m.first_name, m.last_name
ORDER BY subordinate_count DESC;
```

**Non-Equi Joins (Range-based Joins):**
```sql
-- Price tier analysis
SELECT 
    p.product_name,
    p.price,
    pt.tier_name,
    pt.description
FROM products p
JOIN price_tiers pt ON p.price BETWEEN pt.min_price AND pt.max_price
ORDER BY p.price;

-- Date range joins for promotional periods
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    pr.promotion_name,
    pr.discount_percentage
FROM orders o
JOIN promotions pr ON o.order_date BETWEEN pr.start_date AND pr.end_date
WHERE o.order_date >= '2023-01-01';
```

#### [45-60 mins] Performance Optimization & Hands-on Exercises

**Understanding Join Algorithms:**
```sql
-- Force different join algorithms (PostgreSQL specific)
SET enable_hashjoin = OFF;   -- Disable hash joins
SET enable_mergejoin = OFF;  -- Disable merge joins
-- This forces nested loop joins

EXPLAIN ANALYZE
SELECT c.first_name, o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- Reset to defaults
RESET enable_hashjoin;
RESET enable_mergejoin;
```

**Join Performance Best Practices:**
```sql
-- 1. Join on indexed columns (Primary/Foreign keys usually indexed)
EXPLAIN ANALYZE
SELECT c.first_name, o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;  -- Fast: indexed columns

-- 2. Filter early to reduce join cost
EXPLAIN ANALYZE
SELECT c.first_name, o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2023-01-01'    -- Filter reduces rows before join
  AND c.is_active = true;

-- 3. Join order matters for performance
-- PostgreSQL optimizer usually handles this, but understanding helps
```

**Hands-on Exercises:**

**For Beginners:**
1. **Basic Join:** "List all order IDs along with the name of the product that was ordered and the quantity."
2. **Customer Orders:** "Find all customers who have placed orders, showing customer name and order date."
3. **Missing Data:** "Find all products that have never been ordered."

**For Veterans:**
1. **Complex Multi-Join:** "Create a report showing customer name, order date, product name, quantity, unit price, and line total for all orders in 2023."
2. **Self-Join Analysis:** "Find all employee pairs where one employee earns more than their manager."
3. **Performance Comparison:** "Compare the execution plans of the same query with different join orders."
4. **Advanced Aggregation:** "Find the top 3 customers by total spending, including their most expensive single order."

**Example Solutions:**
```sql
-- Complex multi-join solution
SELECT 
    c.first_name || ' ' || c.last_name as customer_name,
    o.order_date,
    p.product_name,
    od.quantity,
    od.unit_price,
    ROUND((od.quantity * od.unit_price), 2) as line_total,
    ROUND((od.quantity * od.unit_price * (1 - COALESCE(od.discount_percentage, 0)/100)), 2) as discounted_total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
ORDER BY o.order_date DESC, line_total DESC;

-- Self-join for salary comparison
SELECT 
    e.first_name || ' ' || e.last_name as employee_name,
    e.salary as employee_salary,
    m.first_name || ' ' || m.last_name as manager_name,
    m.salary as manager_salary,
    (e.salary - m.salary) as salary_difference
FROM employees e
INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary
ORDER BY salary_difference DESC;

-- Top customers with most expensive order
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name as customer_name,
        SUM(o.total_amount) as total_spent,
        MAX(o.total_amount) as largest_order
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT 
    customer_name,
    total_spent,
    largest_order,
    ROUND((largest_order / total_spent * 100), 2) as largest_order_percentage
FROM customer_totals
ORDER BY total_spent DESC
LIMIT 3;
```

**Common Join Pitfalls & Solutions:**
1. **Cartesian Product:** Always include JOIN conditions
2. **Duplicate Data:** Understand when joins multiply rows
3. **NULL Handling:** Be aware of how NULLs affect join results
4. **Performance:** Consider index usage and join order

---

## Hour 4: Aggregation & Grouping

**Objective:** Participants will be able to summarize and group data to derive business insights using aggregate functions, window functions, and advanced grouping techniques.

### Key Concepts:
- **Aggregate Functions:** COUNT(), SUM(), AVG(), MIN(), MAX(), STRING_AGG()
- **Grouping:** GROUP BY, HAVING, ROLLUP, CUBE, GROUPING SETS
- **Window Functions:** ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), LEAD()
- **Statistical Functions:** STDDEV(), VARIANCE(), PERCENTILE_CONT()
- **Performance:** Indexing for GROUP BY, avoiding common pitfalls

### Teaching Activities & Content (60 mins):

#### [0-20 mins] Aggregate Functions & Business Context

**Real-World Business Questions:**
- "What's our total revenue this quarter?"
- "Which product category has the highest average price?"
- "How many unique customers placed orders last month?"
- "What's the distribution of order values?"

**Core Aggregate Functions:**
```sql
-- Basic aggregations
SELECT 
    COUNT(*) as total_customers,
    COUNT(phone) as customers_with_phone,  -- Excludes NULLs
    COUNT(DISTINCT city) as unique_cities
FROM customers;

-- Numerical aggregations
SELECT 
    COUNT(*) as total_orders,
    SUM(total_amount) as revenue,
    AVG(total_amount) as average_order_value,
    MIN(total_amount) as smallest_order,
    MAX(total_amount) as largest_order,
    ROUND(STDDEV(total_amount), 2) as standard_deviation
FROM orders;

-- String aggregations (PostgreSQL specific)
SELECT 
    customer_id,
    STRING_AGG(product_name, ', ' ORDER BY order_date) as products_ordered,
    STRING_AGG(DISTINCT category, ' | ') as categories_purchased
FROM customer_order_products  -- Assumed view
GROUP BY customer_id
LIMIT 5;
```

**Advanced Statistical Functions:**
```sql
-- Percentile calculations for business insights
SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_amount) as q1_order_value,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_amount) as median_order_value,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_amount) as q3_order_value,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_amount) as p95_order_value
FROM orders;

-- Mode (most frequent value)
SELECT 
    MODE() WITHIN GROUP (ORDER BY category) as most_popular_category
FROM products;
```

#### [20-40 mins] GROUP BY Mastery & Advanced Grouping

**The Fundamental Rule:**
> **Any non-aggregate column in SELECT must appear in GROUP BY**

```sql
-- Basic grouping
SELECT 
    category,
    COUNT(*) as product_count,
    AVG(price) as average_price,
    MIN(price) as cheapest,
    MAX(price) as most_expensive
FROM products
GROUP BY category
ORDER BY average_price DESC;

-- Multiple column grouping
SELECT 
    EXTRACT(YEAR FROM order_date) as order_year,
    EXTRACT(MONTH FROM order_date) as order_month,
    COUNT(*) as orders_count,
    SUM(total_amount) as monthly_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY order_year, order_month;
```

**HAVING vs WHERE - Critical Distinction:**
```sql
-- WHERE filters rows BEFORE grouping
-- HAVING filters groups AFTER aggregation

-- Find categories with more than 10 products, average price > $50
SELECT 
    category,
    COUNT(*) as product_count,
    ROUND(AVG(price), 2) as average_price
FROM products
WHERE discontinued = false  -- Filter individual products first
GROUP BY category
HAVING COUNT(*) > 10       -- Filter groups after aggregation
   AND AVG(price) > 50
ORDER BY average_price DESC;

-- Common mistake: Using aggregate functions in WHERE
-- SELECT category FROM products WHERE COUNT(*) > 10;  -- ERROR!
-- Correct version uses HAVING
```

**Advanced Grouping: ROLLUP, CUBE, GROUPING SETS:**
```sql
-- ROLLUP: Hierarchical subtotals
SELECT 
    category,
    subcategory,
    COUNT(*) as product_count,
    SUM(price) as total_value
FROM products
GROUP BY ROLLUP(category, subcategory)
ORDER BY category, subcategory;
-- Results include: category+subcategory, category totals, grand total

-- CUBE: All possible combinations
SELECT 
    category,
    brand,
    COUNT(*) as product_count
FROM products
GROUP BY CUBE(category, brand)
ORDER BY category, brand;
-- Results include: category+brand, category only, brand only, grand total

-- GROUPING SETS: Custom grouping combinations
SELECT 
    category,
    brand,
    EXTRACT(YEAR FROM created_date) as year,
    COUNT(*) as count
FROM products
GROUP BY GROUPING SETS (
    (category),           -- Group by category only
    (brand),             -- Group by brand only
    (category, brand),   -- Group by both
    ()                   -- Grand total
);
```

#### [40-55 mins] Window Functions - Advanced Analytics

**Window Functions vs. Aggregates:**
- **Aggregate functions:** Collapse rows into single result
- **Window functions:** Keep all rows, add calculated columns

**Essential Window Functions:**
```sql
-- Ranking functions
SELECT 
    customer_id,
    first_name,
    last_name,
    total_spent,
    ROW_NUMBER() OVER (ORDER BY total_spent DESC) as row_num,
    RANK() OVER (ORDER BY total_spent DESC) as rank,
    DENSE_RANK() OVER (ORDER BY total_spent DESC) as dense_rank,
    NTILE(4) OVER (ORDER BY total_spent DESC) as quartile
FROM customer_spending_summary
ORDER BY total_spent DESC;

-- Difference between RANK() and DENSE_RANK():
-- RANK: 1, 2, 2, 4, 5     (skips 3)
-- DENSE_RANK: 1, 2, 2, 3, 4 (no gaps)
```

**Partitioned Window Functions:**
```sql
-- Running totals and comparisons within groups
SELECT 
    order_date,
    customer_id,
    total_amount,
    -- Running total for each customer
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date 
        ROWS UNBOUNDED PRECEDING
    ) as customer_running_total,
    -- Compare to previous order
    LAG(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as previous_order_amount,
    -- Compare to next order
    LEAD(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as next_order_amount,
    -- Moving average (last 3 orders)
    AVG(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date 
        ROWS 2 PRECEDING
    ) as moving_avg_3_orders
FROM orders
ORDER BY customer_id, order_date;
```

**Business Intelligence with Window Functions:**
```sql
-- Customer segmentation analysis
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name as customer_name,
        COUNT(o.order_id) as order_count,
        SUM(o.total_amount) as total_spent,
        AVG(o.total_amount) as avg_order_value,
        MAX(o.order_date) as last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT 
    customer_name,
    order_count,
    total_spent,
    avg_order_value,
    last_order_date,
    -- Customer value segments
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY total_spent) > 0.8 THEN 'High Value'
        WHEN PERCENT_RANK() OVER (ORDER BY total_spent) > 0.5 THEN 'Medium Value'
        ELSE 'Low Value'
    END as value_segment,
    -- Recency segments
    CASE 
        WHEN last_order_date > CURRENT_DATE - INTERVAL '30 days' THEN 'Recent'
        WHEN last_order_date > CURRENT_DATE - INTERVAL '90 days' THEN 'Moderate'
        ELSE 'Inactive'
    END as recency_segment
FROM customer_metrics
WHERE order_count > 0
ORDER BY total_spent DESC;
```

#### [55-60 mins] Performance & Hands-on Exercises

**Performance Optimization for Aggregations:**
```sql
-- Inefficient: Function in GROUP BY
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    COUNT(*)
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date);

-- More efficient: Pre-computed column or expression index
CREATE INDEX idx_orders_year ON orders (EXTRACT(YEAR FROM order_date));

-- Or use date truncation
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*),
    SUM(total_amount)
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```

**Hands-on Exercises:**

**For Beginners:**
1. **Basic Aggregation:** "Calculate the total quantity of products sold for each product category."
2. **Customer Analysis:** "Find the average order amount for each customer."
3. **Category Analysis:** "Find categories where the average product price is above $150."

**For Veterans:**
1. **Advanced Grouping:** "Create a monthly sales report showing year, month, total orders, revenue, and compare with previous month."
2. **Window Function Challenge:** "Rank customers by total spending within each city, showing top 3 customers per city."
3. **Statistical Analysis:** "Calculate the 25th, 50th, 75th, and 95th percentiles of order values by category."
4. **Complex Aggregation:** "Find products that have above-average sales compared to other products in their category."

**Example Solutions:**
```sql
-- Monthly sales with period-over-period comparison
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        COUNT(*) as orders,
        SUM(total_amount) as revenue,
        AVG(total_amount) as avg_order_value
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    orders,
    revenue,
    avg_order_value,
    LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
    ROUND(
        ((revenue - LAG(revenue) OVER (ORDER BY month)) / 
         LAG(revenue) OVER (ORDER BY month) * 100), 2
    ) as revenue_growth_pct
FROM monthly_sales
ORDER BY month;

-- Top 3 customers per city
WITH customer_city_spending AS (
    SELECT 
        c.city,
        c.customer_id,
        c.first_name || ' ' || c.last_name as customer_name,
        COALESCE(SUM(o.total_amount), 0) as total_spent,
        ROW_NUMBER() OVER (PARTITION BY c.city ORDER BY COALESCE(SUM(o.total_amount), 0) DESC) as city_rank
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city, c.customer_id, customer_name
)
SELECT 
    city,
    city_rank,
    customer_name,
    total_spent
FROM customer_city_spending
WHERE city_rank <= 3
ORDER BY city, city_rank;
```

---

## Hour 5: Subqueries & Advanced Queries

**Objective:** Participants will learn to write complex queries using subqueries, CTEs, and understand performance implications of different approaches.

### Key Concepts:
- **Subquery Types:** Scalar, Row, Table subqueries
- **Subquery Locations:** WHERE, FROM, SELECT clauses
- **Correlated vs. Non-correlated:** Performance and use cases
- **CTEs (Common Table Expressions):** Readability and recursive queries
- **EXISTS vs. IN:** Performance comparison and NULL handling
- **Advanced Techniques:** Recursive CTEs, lateral joins

### Teaching Activities & Content (60 mins):

#### [0-20 mins] Subquery Fundamentals & Types

**Business Context - Complex Questions:**
- "Find customers who spent more than the average customer"
- "Show products that are more expensive than any product in the 'Books' category"
- "List customers who have never placed an order"
- "Find the top-selling product in each category"

**Subquery Classifications:**

**1. Scalar Subqueries (Return Single Value):**
```sql
-- Find products more expensive than average
SELECT 
    product_name,
    price,
    (SELECT AVG(price) FROM products) as avg_price,
    ROUND(price - (SELECT AVG(price) FROM products), 2) as price_difference
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Customer spending compared to average
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    customer_totals.total_spent,
    (SELECT AVG(total_spent) FROM (
        SELECT SUM(total_amount) as total_spent 
        FROM orders 
        GROUP BY customer_id
    ) as customer_averages) as avg_customer_spending
FROM customers c
JOIN (
    SELECT customer_id, SUM(total_amount) as total_spent
    FROM orders
    GROUP BY customer_id
) customer_totals ON c.customer_id = customer_totals.customer_id
WHERE customer_totals.total_spent > (
    SELECT AVG(total_spent) FROM (
        SELECT SUM(total_amount) as total_spent 
        FROM orders 
        GROUP BY customer_id
    ) as customer_averages
);
```

**2. Row Subqueries (Return Single Row, Multiple Columns):**
```sql
-- Find the customer with the highest single order
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE (o.customer_id, o.total_amount) = (
    SELECT customer_id, MAX(total_amount)
    FROM orders
    GROUP BY customer_id
    ORDER BY MAX(total_amount) DESC
    LIMIT 1
);
```

**3. Table Subqueries (Return Multiple Rows/Columns):**
```sql
-- Products that have been ordered (using subquery in FROM)
SELECT 
    product_stats.product_name,
    product_stats.times_ordered,
    product_stats.total_quantity
FROM (
    SELECT 
        p.product_name,
        COUNT(od.order_id) as times_ordered,
        SUM(od.quantity) as total_quantity
    FROM products p
    LEFT JOIN order_details od ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name
    HAVING COUNT(od.order_id) > 0
) as product_stats
ORDER BY product_stats.total_quantity DESC;
```

#### [20-35 mins] Advanced Subquery Techniques

**EXISTS vs. IN - Performance & NULL Handling:**
```sql
-- EXISTS: Generally more efficient, NULL-safe
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.customer_id
);

-- IN: Can be slower with large datasets, NULL issues
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE c.customer_id IN (
    SELECT DISTINCT customer_id 
    FROM orders 
    WHERE customer_id IS NOT NULL  -- Important for NULL safety
);

-- NOT EXISTS vs NOT IN - Critical difference with NULLs
-- NOT EXISTS: NULL-safe
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.customer_id
);

-- NOT IN: Can return unexpected results if subquery contains NULLs
-- If orders.customer_id contains any NULL, this returns NO rows!
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT customer_id FROM orders WHERE customer_id IS NOT NULL
);
```

**Correlated Subqueries:**
```sql
-- Find products with above-average price in their category
SELECT 
    p1.product_name,
    p1.category,
    p1.price,
    (SELECT ROUND(AVG(p2.price), 2) 
     FROM products p2 
     WHERE p2.category = p1.category) as category_avg_price
FROM products p1
WHERE p1.price > (
    SELECT AVG(p2.price) 
    FROM products p2 
    WHERE p2.category = p1.category
)
ORDER BY p1.category, p1.price DESC;

-- Customer's order count vs. customer's average order value
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id,
    o.total_amount,
    (SELECT COUNT(*) FROM orders o2 WHERE o2.customer_id = c.customer_id) as customer_order_count,
    (SELECT ROUND(AVG(total_amount), 2) FROM orders o3 WHERE o3.customer_id = c.customer_id) as customer_avg_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > (
    SELECT AVG(total_amount) 
    FROM orders o4 
    WHERE o4.customer_id = c.customer_id
)
ORDER BY c.customer_id, o.total_amount DESC;
```

#### [35-50 mins] Common Table Expressions (CTEs) - Modern SQL

**Why CTEs? Benefits over Subqueries:**
- **Readability:** Named, sequential logic
- **Reusability:** Reference multiple times in same query
- **Debugging:** Test each CTE independently
- **Recursion:** Enable recursive operations

**Basic CTE Examples:**
```sql
-- Readable customer analysis with multiple CTEs
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(total_amount) as total_spent,
        AVG(total_amount) as avg_order_value,
        MIN(order_date) as first_order,
        MAX(order_date) as last_order
    FROM orders
    GROUP BY customer_id
),
customer_segments AS (
    SELECT 
        customer_id,
        order_count,
        total_spent,
        avg_order_value,
        CASE 
            WHEN total_spent > 1000 THEN 'High Value'
            WHEN total_spent > 500 THEN 'Medium Value'
            ELSE 'Low Value'
        END as value_segment,
        CASE 
            WHEN last_order > CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
            WHEN last_order > CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
            ELSE 'Inactive'
        END as activity_segment
    FROM customer_orders
)
SELECT 
    c.first_name || ' ' || c.last_name as customer_name,
    cs.order_count,
    cs.total_spent,
    cs.avg_order_value,
    cs.value_segment,
    cs.activity_segment
FROM customers c
JOIN customer_segments cs ON c.customer_id = cs.customer_id
ORDER BY cs.total_spent DESC;
```

**Recursive CTEs - Hierarchical Data:**
```sql
-- Employee hierarchy traversal
WITH RECURSIVE employee_hierarchy AS (
    -- Base case: Top-level managers (no manager)
    SELECT 
        employee_id,
        first_name,
        last_name,
        manager_id,
        job_title,
        1 as level,
        first_name || ' ' || last_name as hierarchy_path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: Employees with managers
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        e.job_title,
        eh.level + 1,
        eh.hierarchy_path || ' > ' || e.first_name || ' ' || e.last_name
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT 
    REPEAT('  ', level - 1) || first_name || ' ' || last_name as indented_name,
    job_title,
    level,
    hierarchy_path
FROM employee_hierarchy
ORDER BY hierarchy_path;

-- Category hierarchy with product counts
WITH RECURSIVE category_tree AS (
    -- Root categories
    SELECT 
        category_id,
        category_name,
        parent_category_id,
        1 as level
    FROM categories
    WHERE parent_category_id IS NULL
    
    UNION ALL
    
    -- Subcategories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ct.level + 1
    FROM categories c
    JOIN category_tree ct ON c.parent_category_id = ct.category_id
)
SELECT 
    ct.category_name,
    ct.level,
    COUNT(p.product_id) as product_count,
    SUM(COUNT(p.product_id)) OVER (
        PARTITION BY ct.level
    ) as products_at_level
FROM category_tree ct
LEFT JOIN products p ON ct.category_id = p.category_id
GROUP BY ct.category_id, ct.category_name, ct.level
ORDER BY ct.level, ct.category_name;
```

#### [50-60 mins] Performance Analysis & Hands-on Exercises

**Performance Comparison:**
```sql
-- Compare execution plans
EXPLAIN ANALYZE
SELECT customer_id FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

EXPLAIN ANALYZE  
SELECT DISTINCT customer_id FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

EXPLAIN ANALYZE
SELECT customer_id FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);
```

**Hands-on Exercises:**

**For Beginners:**
1. **Basic Subquery:** "Find the names of customers who have ordered the product with product_id = 5."
2. **Comparison Query:** "Find all orders with a total amount greater than the overall average order amount."
3. **NOT EXISTS:** "Find customers who have never placed an order."

**For Veterans:**
1. **Complex CTE:** "Create a customer lifetime value analysis showing customer segments, purchase patterns, and predicted churn risk."
2. **Recursive Query:** "Build a product recommendation system based on purchase patterns (customers who bought X also bought Y)."
3. **Performance Optimization:** "Compare and optimize different approaches to find the top 3 products in each category by sales volume."
4. **Advanced Analytics:** "Create a cohort analysis showing customer retention rates over time."

**Example Solutions:**
```sql
-- Customer Lifetime Value with CTEs
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name as customer_name,
        c.created_at as acquisition_date,
        COUNT(o.order_id) as total_orders,
        SUM(o.total_amount) as total_spent,
        AVG(o.total_amount) as avg_order_value,
        MIN(o.order_date) as first_order_date,
        MAX(o.order_date) as last_order_date,
        AVG(DATE_PART('days', o.order_date - LAG(o.order_date) OVER (
            PARTITION BY c.customer_id ORDER BY o.order_date
        ))) as avg_days_between_orders
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.created_at
),
customer_segments AS (
    SELECT 
        *,
        CASE 
            WHEN total_spent > 2000 AND total_orders > 10 THEN 'VIP'
            WHEN total_spent > 1000 OR total_orders > 5 THEN 'Loyal'
            WHEN total_orders > 1 THEN 'Regular'
            WHEN total_orders = 1 THEN 'One-time'
            ELSE 'Prospect'
        END as customer_segment,
        CASE 
            WHEN last_order_date > CURRENT_DATE - INTERVAL '30 days' THEN 'Low'
            WHEN last_order_date > CURRENT_DATE - INTERVAL '90 days' THEN 'Medium'
            ELSE 'High'
        END as churn_risk
    FROM customer_metrics
)
SELECT 
    customer_segment,
    churn_risk,
    COUNT(*) as customer_count,
    ROUND(AVG(total_spent), 2) as avg_ltv,
    ROUND(AVG(avg_order_value), 2) as avg_order_value,
    ROUND(AVG(avg_days_between_orders), 1) as avg_purchase_frequency
FROM customer_segments
WHERE total_orders > 0
GROUP BY customer_segment, churn_risk
ORDER BY 
    CASE customer_segment 
        WHEN 'VIP' THEN 1 
        WHEN 'Loyal' THEN 2 
        WHEN 'Regular' THEN 3 
        WHEN 'One-time' THEN 4 
        ELSE 5 
    END,
    CASE churn_risk 
        WHEN 'Low' THEN 1 
        WHEN 'Medium' THEN 2 
        ELSE 3 
    END;

-- Product recommendation using market basket analysis
WITH purchase_pairs AS (
    SELECT 
        od1.product_id as product_a,
        od2.product_id as product_b,
        COUNT(*) as co_occurrence_count
    FROM order_details od1
    JOIN order_details od2 ON od1.order_id = od2.order_id 
        AND od1.product_id < od2.product_id  -- Avoid duplicates
    GROUP BY od1.product_id, od2.product_id
    HAVING COUNT(*) >= 3  -- Minimum co-occurrences
),
product_recommendations AS (
    SELECT 
        pp.product_a,
        pa.product_name as product_a_name,
        pp.product_b,
        pb.product_name as product_b_name,
        pp.co_occurrence_count,
        ROUND(
            pp.co_occurrence_count::DECIMAL / 
            (SELECT COUNT(DISTINCT order_id) FROM order_details WHERE product_id = pp.product_a)
            * 100, 2
        ) as recommendation_strength
    FROM purchase_pairs pp
    JOIN products pa ON pp.product_a = pa.product_id
    JOIN products pb ON pp.product_b = pb.product_id
)
SELECT 
    product_a_name,
    product_b_name,
    co_occurrence_count,
    recommendation_strength || '%' as strength
FROM product_recommendations
WHERE recommendation_strength > 20  -- Strong associations only
ORDER BY recommendation_strength DESC
LIMIT 20;
```

---

## Hour 6: Data Manipulation (DML) & Advanced Topics

**Objective:** Participants will learn how to modify data within the database, understand transactions, implement security best practices, and work with indexes.

### Key Concepts:
- **DML Operations:** INSERT, UPDATE, DELETE, UPSERT (ON CONFLICT)
- **Transaction Management:** BEGIN, COMMIT, ROLLBACK, Savepoints
- **ACID Properties:** Atomicity, Consistency, Isolation, Durability
- **Isolation Levels:** READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE
- **Indexes:** B-tree, Hash, Partial, Expression indexes
- **Security:** SQL injection prevention, role-based access control

### Teaching Activities & Content (60 mins):

#### [0-20 mins] Advanced DML Operations

**Safe Data Modification Practices:**
```sql
-- Always start with a transaction for safety
BEGIN;

-- INSERT with conflict resolution (PostgreSQL UPSERT)
INSERT INTO customers (customer_id, first_name, last_name, email, created_at)
VALUES (1001, 'Jane', 'Smith', 'jane.smith@email.com', NOW())
ON CONFLICT (email) 
DO UPDATE SET 
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    updated_at = NOW();

-- Batch INSERT for efficiency
INSERT INTO products (product_name, category, price, created_at)
VALUES 
    ('Advanced SQL Book', 'Books', 49.99, NOW()),
    ('Data Science Handbook', 'Books', 79.99, NOW()),
    ('SQL Reference Guide', 'Books', 29.99, NOW());

-- UPDATE with JOIN (PostgreSQL syntax)
UPDATE products 
SET discount_percentage = 10
FROM categories c 
WHERE products.category_id = c.category_id 
  AND c.category_name = 'Electronics'
  AND products.created_at < NOW() - INTERVAL '6 months';

-- Safe DELETE with verification
-- First, check what will be deleted
SELECT * FROM customers 
WHERE last_order_date < NOW() - INTERVAL '2 years'
  AND customer_id NOT IN (
      SELECT DISTINCT customer_id 
      FROM orders 
      WHERE order_date > NOW() - INTERVAL '1 year'
  );

-- Then delete if confirmed
DELETE FROM customers 
WHERE customer_id IN (
    SELECT customer_id FROM customers 
    WHERE last_order_date < NOW() - INTERVAL '2 years'
      AND customer_id NOT IN (
          SELECT DISTINCT customer_id 
          FROM orders 
          WHERE order_date > NOW() - INTERVAL '1 year'
      )
);

-- Always verify and commit
COMMIT;
```

**MERGE Operations (PostgreSQL 15+):**
```sql
-- Advanced MERGE for data synchronization
MERGE INTO inventory AS target
USING updated_inventory AS source 
ON target.product_id = source.product_id
WHEN MATCHED AND target.quantity != source.quantity THEN
    UPDATE SET 
        quantity = source.quantity,
        last_updated = NOW()
WHEN NOT MATCHED THEN
    INSERT (product_id, quantity, last_updated)
    VALUES (source.product_id, source.quantity, NOW())
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;  -- Remove discontinued products
```

#### [20-35 mins] Transaction Management & Isolation

**ACID Properties in Practice:**
```sql
-- Atomicity: All-or-nothing example (Bank transfer)
BEGIN;
    UPDATE accounts SET balance = balance - 1000 WHERE account_id = 'ACC001';
    UPDATE accounts SET balance = balance + 1000 WHERE account_id = 'ACC002';
    
    -- If any statement fails, entire transaction rolls back
    -- Consistency: Account balances remain valid
    -- Isolation: Other transactions don't see partial updates
    -- Durability: Changes survive system crashes after COMMIT
COMMIT;
```

**Isolation Levels Demonstration:**
```sql
-- Session 1: Set isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT balance FROM accounts WHERE account_id = 'ACC001';
-- Result: 5000

-- Session 2: (simultaneous)
BEGIN;
UPDATE accounts SET balance = 3000 WHERE account_id = 'ACC001';
COMMIT;

-- Session 1: Read again
SELECT balance FROM accounts WHERE account_id = 'ACC001';
-- Result with READ COMMITTED: 3000 (sees committed changes)
-- Result with REPEATABLE READ: 5000 (consistent snapshot)
COMMIT;
```

**Savepoints for Complex Transactions:**
```sql
BEGIN;
    INSERT INTO orders (customer_id, order_date, total_amount) 
    VALUES (100, NOW(), 500.00);
    
    SAVEPOINT order_created;
    
    INSERT INTO order_details (order_id, product_id, quantity, unit_price)
    VALUES (CURRVAL('orders_order_id_seq'), 1, 2, 100.00);
    
    SAVEPOINT first_item_added;
    
    -- If this fails, we can rollback to savepoint
    INSERT INTO order_details (order_id, product_id, quantity, unit_price)
    VALUES (CURRVAL('orders_order_id_seq'), 999, 1, 300.00);  -- Invalid product
    
    -- On error: ROLLBACK TO first_item_added;
    -- Then continue with valid operations
COMMIT;
```

#### [35-50 mins] Performance Optimization with Indexes

**Index Types and Use Cases:**
```sql
-- B-tree index (default, most common)
CREATE INDEX idx_customers_email ON customers (email);
CREATE INDEX idx_orders_customer_date ON orders (customer_id, order_date);

-- Partial index (PostgreSQL specific)
CREATE INDEX idx_active_customers ON customers (customer_id) 
WHERE is_active = true;

-- Expression index
CREATE INDEX idx_customers_full_name ON customers (
    LOWER(first_name || ' ' || last_name)
);

-- Composite index for complex queries
CREATE INDEX idx_products_category_price ON products (category_id, price DESC)
WHERE discontinued = false;

-- Check index usage
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM customers WHERE email = 'john@example.com';
```

**Index Performance Analysis:**
```sql
-- Index size and usage statistics
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes 
ORDER BY pg_relation_size(indexrelid) DESC;

-- Find unused indexes
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes 
WHERE idx_scan = 0
ORDER BY pg_relation_size(indexrelid) DESC;
```

#### [50-60 mins] Security Best Practices

**SQL Injection Prevention:**
```sql
-- VULNERABLE CODE (Never do this!)
-- query = f"SELECT * FROM users WHERE email = '{user_input}'"

-- SAFE APPROACH: Parameterized queries
-- Using psycopg2 (Python example)
cursor.execute(
    "SELECT * FROM users WHERE email = %s AND status = %s",
    (user_email, 'active')
)

-- Role-based access control
CREATE ROLE data_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO data_analyst;
GRANT USAGE ON SCHEMA public TO data_analyst;

CREATE ROLE data_entry;
GRANT SELECT, INSERT, UPDATE ON customers, orders TO data_entry;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO data_entry;

-- Row Level Security (PostgreSQL)
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY customer_isolation ON customers
    FOR ALL TO application_user
    USING (customer_id = current_setting('app.current_customer_id')::int);
```

**Hands-on Exercise (with extreme caution):**
> **WARNING:** Perform these tasks inside transactions with ROLLBACK capability

**For Beginners:**
1. **Safe Addition:** "Add a new customer 'Alex Johnson' with proper error handling."
2. **Price Update:** "Update all products in 'Electronics' category to have a 5% discount."
3. **Data Cleanup:** "Remove test customers (those with email ending in '.test')."

**For Veterans:**
1. **Complex Transaction:** "Implement a complete order processing workflow with error handling."
2. **Performance Optimization:** "Analyze and optimize the slowest queries in the system."
3. **Security Audit:** "Implement role-based access control for different user types."

---

## Hour 7: Enterprise SQL & Real-World Integration

**Objective:** Apply all learned SQL skills in a comprehensive business scenario, focusing on enterprise patterns and integration with modern data stacks.

### Advanced Topics:
- **Views & Materialized Views:** Abstraction and performance
- **Functions & Procedures:** Code reusability and business logic
- **Triggers:** Automated data management
- **Foreign Data Wrappers:** Cross-database queries
- **JSON/NoSQL Integration:** Hybrid data models
- **Data Pipeline Patterns:** ETL/ELT workflows

### Activity: Comprehensive E-commerce Analytics Project

**Scenario:** Build a complete analytics system for an e-commerce platform

#### Phase 1: Data Modeling & Views (15 mins)
```sql
-- Create business-friendly views
CREATE OR REPLACE VIEW customer_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    c.email,
    c.city,
    c.country,
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
    END as customer_status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.city, c.country;

-- Materialized view for performance
CREATE MATERIALIZED VIEW daily_sales_summary AS
SELECT 
    DATE_TRUNC('day', order_date) as sale_date,
    COUNT(*) as order_count,
    SUM(total_amount) as revenue,
    AVG(total_amount) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
GROUP BY DATE_TRUNC('day', order_date);

CREATE UNIQUE INDEX ON daily_sales_summary (sale_date);
```

#### Phase 2: Business Intelligence Queries (20 mins)
```sql
-- Customer segmentation with RFM analysis
WITH rfm_metrics AS (
    SELECT 
        customer_id,
        MAX(order_date) as last_order_date,
        COUNT(*) as frequency,
        SUM(total_amount) as monetary_value,
        NTILE(5) OVER (ORDER BY MAX(order_date) DESC) as recency_score,
        NTILE(5) OVER (ORDER BY COUNT(*)) as frequency_score,
        NTILE(5) OVER (ORDER BY SUM(total_amount)) as monetary_score
    FROM orders
    GROUP BY customer_id
),
customer_segments AS (
    SELECT 
        customer_id,
        recency_score,
        frequency_score,
        monetary_score,
        CASE 
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 3 AND frequency_score <= 2 THEN 'Potential Loyalists'
            WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
            WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score >= 3 THEN 'Cannot Lose Them'
            ELSE 'Others'
        END as customer_segment
    FROM rfm_metrics
)
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(monetary_score), 2) as avg_monetary_score,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM customer_segments
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- Product performance analysis
WITH product_performance AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.price,
        COUNT(od.order_id) as times_ordered,
        SUM(od.quantity) as total_quantity_sold,
        SUM(od.quantity * od.unit_price) as total_revenue,
        AVG(od.unit_price) as avg_selling_price,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.quantity) DESC) as category_rank
    FROM products p
    LEFT JOIN order_details od ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name, p.category, p.price
)
SELECT 
    category,
    product_name,
    total_quantity_sold,
    total_revenue,
    category_rank,
    CASE 
        WHEN category_rank <= 3 THEN 'Top Performer'
        WHEN category_rank <= 10 THEN 'Good Performer'
        WHEN total_quantity_sold > 0 THEN 'Average'
        ELSE 'No Sales'
    END as performance_category
FROM product_performance
WHERE total_quantity_sold > 0
ORDER BY category, category_rank;
```

#### Phase 3: Automated Reporting Functions (15 mins)
```sql
-- Create reusable reporting functions
CREATE OR REPLACE FUNCTION get_sales_report(
    start_date DATE,
    end_date DATE,
    granularity TEXT DEFAULT 'daily'
) RETURNS TABLE (
    period_start TIMESTAMP,
    order_count BIGINT,
    revenue NUMERIC,
    avg_order_value NUMERIC,
    unique_customers BIGINT
) AS $$
BEGIN
    RETURN QUERY
    EXECUTE format('
        SELECT 
            DATE_TRUNC(%L, order_date) as period_start,
            COUNT(*)::BIGINT as order_count,
            SUM(total_amount) as revenue,
            AVG(total_amount) as avg_order_value,
            COUNT(DISTINCT customer_id)::BIGINT as unique_customers
        FROM orders
        WHERE order_date BETWEEN %L AND %L
        GROUP BY DATE_TRUNC(%L, order_date)
        ORDER BY period_start',
        granularity, start_date, end_date, granularity
    );
END;
$$ LANGUAGE plpgsql;

-- Usage example
SELECT * FROM get_sales_report('2023-01-01', '2023-12-31', 'monthly');
```

#### Phase 4: Group Collaboration (10 mins)
**Groups work on different aspects:**
- **Group 1:** Customer lifetime value prediction
- **Group 2:** Inventory optimization queries  
- **Group 3:** Marketing campaign effectiveness analysis
- **Group 4:** Fraud detection patterns

---

## Hour 8: Modern Data Integration & Best Practices

**Objective:** Understand how SQL fits into modern data architectures and learn industry best practices for production systems.

### Teaching Activities & Content (60 mins):

#### [0-20 mins] SQL in Modern Data Stacks

**Integration Patterns:**
```python
# Production-grade Python integration
import pandas as pd
import psycopg2
from sqlalchemy import create_engine, text
import logging

# Connection pooling for production
from sqlalchemy.pool import QueuePool

class DatabaseManager:
    def __init__(self, connection_string):
        self.engine = create_engine(
            connection_string,
            poolclass=QueuePool,
            pool_size=20,
            max_overflow=0,
            pool_pre_ping=True,  # Verify connections
            echo=False  # Set to True for debugging
        )
    
    def execute_query(self, query, params=None):
        """Execute query with proper error handling"""
        try:
            with self.engine.connect() as conn:
                result = conn.execute(text(query), params or {})
                return result.fetchall()
        except Exception as e:
            logging.error(f"Query execution failed: {e}")
            raise
    
    def get_dataframe(self, query, params=None):
        """Return query results as pandas DataFrame"""
        return pd.read_sql(query, self.engine, params=params)

# Usage example
db = DatabaseManager("postgresql://user:pass@localhost/db")

# Complex analytical query
customer_analysis_query = """
WITH customer_metrics AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(total_amount) as total_spent,
        AVG(total_amount) as avg_order,
        MAX(order_date) as last_order
    FROM orders 
    WHERE order_date >= %(start_date)s
    GROUP BY customer_id
)
SELECT 
    cm.*,
    c.first_name,
    c.last_name,
    c.email
FROM customer_metrics cm
JOIN customers c ON cm.customer_id = c.customer_id
WHERE cm.total_spent > %(min_spend)s
ORDER BY cm.total_spent DESC
"""

df = db.get_dataframe(
    customer_analysis_query,
    {'start_date': '2023-01-01', 'min_spend': 1000}
)
```

**Cloud Data Warehouse Integration:**
```sql
-- BigQuery example (Google Cloud)
SELECT 
    customer_id,
    EXTRACT(YEAR FROM order_date) as year,
    SUM(total_amount) as annual_spend,
    LAG(SUM(total_amount)) OVER (
        PARTITION BY customer_id 
        ORDER BY EXTRACT(YEAR FROM order_date)
    ) as previous_year_spend,
    SAFE_DIVIDE(
        SUM(total_amount) - LAG(SUM(total_amount)) OVER (
            PARTITION BY customer_id 
            ORDER BY EXTRACT(YEAR FROM order_date)
        ),
        LAG(SUM(total_amount)) OVER (
            PARTITION BY customer_id 
            ORDER BY EXTRACT(YEAR FROM order_date)
        )
    ) * 100 as growth_rate
FROM orders
GROUP BY customer_id, EXTRACT(YEAR FROM order_date)
HAVING COUNT(*) > 3  -- Customers with significant activity
ORDER BY customer_id, year;
```

#### [20-35 mins] Production Best Practices

**Query Optimization Checklist:**
```sql
-- 1. Use EXPLAIN ANALYZE for all critical queries
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT c.customer_name, SUM(o.total_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2023-01-01'
GROUP BY c.customer_id, c.customer_name
ORDER BY SUM(o.total_amount) DESC
LIMIT 100;

-- 2. Proper indexing strategy
CREATE INDEX CONCURRENTLY idx_orders_date_customer 
ON orders (order_date, customer_id) 
WHERE order_date >= '2020-01-01';

-- 3. Efficient pagination
-- Instead of OFFSET (slow for large offsets)
SELECT * FROM products 
ORDER BY product_id 
LIMIT 20 OFFSET 10000;  -- Slow!

-- Use cursor-based pagination
SELECT * FROM products 
WHERE product_id > 10000  -- Use last seen ID
ORDER BY product_id 
LIMIT 20;  -- Fast!

-- 4. Avoid N+1 queries with proper JOINs
-- Instead of multiple queries in application code
SELECT 
    c.*,
    json_agg(
        json_build_object(
            'order_id', o.order_id,
            'order_date', o.order_date,
            'total_amount', o.total_amount
        ) ORDER BY o.order_date DESC
    ) as orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
```

**Monitoring & Maintenance:**
```sql
-- Query performance monitoring
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows,
    100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) as hit_percent
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;

-- Table bloat detection
SELECT 
    schemaname,
    tablename,
    n_dead_tup,
    n_live_tup,
    ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup + n_dead_tup, 0), 2) as dead_percent
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY dead_percent DESC;
```

#### [35-50 mins] Advanced SQL Patterns for Data Engineering

**Slowly Changing Dimensions (Type 2):**
```sql
-- Track historical changes in customer data
CREATE TABLE customer_history (
    customer_history_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    valid_from TIMESTAMP NOT NULL DEFAULT NOW(),
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);

-- Function to handle SCD Type 2 updates
CREATE OR REPLACE FUNCTION update_customer_scd(
    p_customer_id INTEGER,
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_email VARCHAR(100),
    p_city VARCHAR(50)
) RETURNS VOID AS $$
BEGIN
    -- Close current record
    UPDATE customer_history 
    SET valid_to = NOW(), is_current = FALSE
    WHERE customer_id = p_customer_id AND is_current = TRUE;
    
    -- Insert new record
    INSERT INTO customer_history (
        customer_id, first_name, last_name, email, city
    ) VALUES (
        p_customer_id, p_first_name, p_last_name, p_email, p_city
    );
END;
$$ LANGUAGE plpgsql;
```

**Data Quality Patterns:**
```sql
-- Data quality checks
WITH data_quality_checks AS (
    SELECT 
        'customers' as table_name,
        'duplicate_emails' as check_name,
        COUNT(*) as issue_count
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
    
    UNION ALL
    
    SELECT 
        'orders' as table_name,
        'negative_amounts' as check_name,
        COUNT(*) as issue_count
    FROM orders
    WHERE total_amount < 0
    
    UNION ALL
    
    SELECT 
        'products' as table_name,
        'missing_categories' as check_name,
        COUNT(*) as issue_count
    FROM products
    WHERE category IS NULL OR category = ''
)
SELECT 
    table_name,
    check_name,
    issue_count,
    CASE WHEN issue_count > 0 THEN 'FAIL' ELSE 'PASS' END as status
FROM data_quality_checks
ORDER BY table_name, check_name;
```

#### [50-60 mins] Final Review & Career Guidance

**SQL Skills Roadmap:**

**Beginner → Intermediate:**
- Master JOINs and subqueries
- Understand indexing basics
- Learn window functions
- Practice with real datasets

**Intermediate → Advanced:**
- Query optimization and performance tuning
- Advanced PostgreSQL features (JSON, arrays, custom functions)
- Data modeling and normalization
- Integration with programming languages

**Advanced → Expert:**
- Database architecture and design
- Cross-platform SQL (different databases)
- Data engineering pipelines
- Teaching and mentoring others

**Industry Certifications:**
- PostgreSQL Certification
- Microsoft SQL Server certifications
- Oracle Database certifications
- Google Cloud Professional Data Engineer
- AWS Certified Database - Specialty

**Next Steps:**
1. **Practice Platforms:** LeetCode SQL, HackerRank SQL, SQLBolt
2. **Real Projects:** Kaggle datasets, personal analytics projects
3. **Advanced Topics:** Data warehousing, OLAP, time-series databases
4. **Specializations:** Business Intelligence, Data Engineering, Database Administration

**Q&A Session:**
- Open floor for any remaining questions
- Discussion of real-world SQL challenges
- Career advice and learning paths
- Resources for continued learning

### Final Hands-on Challenge (If Time Permits):
**"Build a complete customer churn prediction dataset using SQL"**
- Combine all learned techniques
- Create features for machine learning
- Export results for further analysis

### Teaching Activities & Content (60 mins):

#### [0-20 mins] Mini-Project Review & Knowledge Consolidation
- Ask each group to present one of their queries and solutions.
- Discuss different approaches and correct any logical errors.
- **Code Review Best Practices:**
  - Analyze query efficiency and readability
  - Discuss alternative approaches
  - Identify potential performance issues

#### [20-40 mins] Production SQL Best Practices

**Code Quality & Maintainability:**
```sql
-- Good: Readable, well-formatted, commented
WITH monthly_sales AS (
    -- Calculate monthly aggregations for trending analysis
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        COUNT(*) as order_count,
        SUM(total_amount) as revenue
    FROM orders
    WHERE order_date >= '2023-01-01'  -- Focus on recent data
    GROUP BY DATE_TRUNC('month', order_date)
),
growth_calculations AS (
    -- Add period-over-period growth rates
    SELECT 
        month,
        order_count,
        revenue,
        LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
        ROUND(
            ((revenue - LAG(revenue) OVER (ORDER BY month)) / 
             LAG(revenue) OVER (ORDER BY month) * 100), 2
        ) as growth_rate
    FROM monthly_sales
)
SELECT * FROM growth_calculations ORDER BY month;

-- Bad: Hard to read, inefficient
select c.first_name,sum(o.total_amount) from customers c join orders o on c.customer_id=o.customer_id where extract(year from o.order_date)=2023 group by c.customer_id,c.first_name having sum(o.total_amount)>1000 order by sum(o.total_amount) desc;
```

**Performance Guidelines:**
- **SELECT Strategy:** Only select needed columns, avoid `SELECT *`
- **WHERE Optimization:** Filter early, use indexed columns
- **JOIN Efficiency:** Proper join order, indexed foreign keys
- **GROUP BY Performance:** Index columns used in grouping
- **LIMIT Usage:** Always use LIMIT for exploratory queries

**Security & Safety:**
- Always use parameterized queries
- Implement role-based access control
- Regular security audits and updates
- Backup strategies and disaster recovery

#### [40-55 mins] SQL in Modern Data Science Workflows

**Integration with Python Data Science Stack:**
```python
import pandas as pd
import numpy as np
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import seaborn as sns

# Database connection
engine = create_engine('postgresql://user:pass@localhost/company_db')

# Complex analytical query
customer_analysis_query = """
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name as customer_name,
        COUNT(o.order_id) as order_frequency,
        SUM(o.total_amount) as total_spent,
        AVG(o.total_amount) as avg_order_value,
        MAX(o.order_date) as last_order_date,
        MIN(o.order_date) as first_order_date,
        EXTRACT(DAYS FROM MAX(o.order_date) - MIN(o.order_date)) as customer_lifespan_days
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, customer_name
    HAVING COUNT(o.order_id) >= 3  -- Active customers only
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY last_order_date) as recency_score,
        NTILE(5) OVER (ORDER BY order_frequency) as frequency_score,
        NTILE(5) OVER (ORDER BY total_spent) as monetary_score
    FROM customer_metrics
)
SELECT 
    customer_name,
    order_frequency,
    total_spent,
    avg_order_value,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) as combined_score,
    CASE 
        WHEN (recency_score + frequency_score + monetary_score) >= 12 THEN 'High Value'
        WHEN (recency_score + frequency_score + monetary_score) >= 8 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment
FROM rfm_scores
ORDER BY combined_score DESC;
"""

# Execute query and load into DataFrame
df = pd.read_sql(customer_analysis_query, engine)

# Data science workflow continues with pandas/numpy
print(f"Dataset shape: {df.shape}")
print(f"Customer segments distribution:")
print(df['customer_segment'].value_counts())

# Visualization
plt.figure(figsize=(12, 8))
sns.scatterplot(data=df, x='order_frequency', y='total_spent', 
                hue='customer_segment', size='avg_order_value')
plt.title('Customer Segmentation Analysis')
plt.show()
```

**Modern Data Architecture Patterns:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Data Sources  │    │   Data Lake     │    │  Data Warehouse │
│   - APIs        │───▶│   - Raw Data    │───▶│   - Processed   │
│   - Databases   │    │   - JSON/Parquet│    │   - SQL Tables  │
│   - Files       │    │   - Unstructured│    │   - Aggregated  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ML Platforms  │    │   BI Tools      │    │   Analytics     │
│   - Python/R    │◀───│   - Tableau     │◀───│   - SQL Queries │
│   - Jupyter     │    │   - Power BI    │    │   - Dashboards  │
│   - TensorFlow  │    │   - Looker      │    │   - Reports     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

#### [55-60 mins] Career Paths & Learning Resources

**SQL Career Trajectories:**

**1. Data Analyst Track:**
- **Skills:** Advanced SQL, BI tools, statistical analysis
- **Tools:** SQL + Tableau/Power BI + Excel/Python
- **Growth:** Senior Analyst → Analytics Manager → Head of Analytics

**2. Data Engineer Track:**
- **Skills:** SQL + ETL/ELT, cloud platforms, programming
- **Tools:** SQL + Airflow/dbt + AWS/Azure/GCP + Python/Scala
- **Growth:** Junior Engineer → Senior Engineer → Data Architect

**3. Database Administrator Track:**
- **Skills:** Database optimization, security, infrastructure
- **Tools:** PostgreSQL/SQL Server/Oracle + monitoring tools
- **Growth:** DBA → Senior DBA → Database Architect

**4. Data Scientist Track:**
- **Skills:** SQL + ML/AI, statistics, programming
- **Tools:** SQL + Python/R + ML frameworks + cloud ML services
- **Growth:** Data Scientist → Senior Scientist → Principal Scientist

**Recommended Learning Path:**
```
Month 1-2: Master SQL Fundamentals
├── Practice on real datasets (Kaggle, public APIs)
├── Learn database design principles
└── Understand performance optimization basics

Month 3-4: Specialize & Integrate
├── Choose your track (Analyst/Engineer/Scientist)
├── Learn complementary tools (Python/R, BI tools)
└── Work on portfolio projects

Month 5-6: Advanced & Production
├── Study advanced SQL features
├── Learn cloud data platforms
└── Contribute to open source projects

Ongoing: Stay Current
├── Follow SQL and data community blogs
├── Attend conferences and meetups
└── Mentor others and build your network
```

**Essential Resources:**
- **Practice:** LeetCode SQL, HackerRank, SQLBolt, DB Fiddle
- **Documentation:** PostgreSQL docs, SQL standard references
- **Communities:** Stack Overflow, Reddit r/SQL, data professional forums
- **Blogs:** Use The Index Luke, Modern SQL, database vendor blogs
- **Books:** "Learning SQL" by Alan Beaulieu, "SQL Performance Explained"

**Final Advice:**
1. **Practice Regularly:** SQL is a skill that improves with consistent use
2. **Learn by Doing:** Work with real datasets and business problems
3. **Understand the Business:** Great SQL professionals understand the domain
4. **Stay Curious:** Database technology evolves rapidly
5. **Share Knowledge:** Teaching others reinforces your own learning