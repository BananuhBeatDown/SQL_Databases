-- Delete the database 'southwind' to get a fresh start
DROP DATABASE IF EXISTS southwind;

-- Create the 'southwind' database
CREATE DATABASE IF NOT EXISTS southwind;

-- Select the 'southwind' database as the default database
USE southwind;

-- Create 'products' TABLE
CREATE TABLE IF NOT EXISTS products (
         productID    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
         productCode  CHAR(3)       NOT NULL DEFAULT '',
         name         VARCHAR(30)   NOT NULL DEFAULT '',
         quantity     INT UNSIGNED  NOT NULL DEFAULT 0,
         price        DECIMAL(7,2)  NOT NULL DEFAULT 99999.99,
         PRIMARY KEY  (productID)
       );

-- Show the names of the different tables in the database       
SHOW tables;

-- Describe the fields of the 'products' table
DESC products;
-- Show the complete CREATE TABLE statement used by MySQL to create this table
SHOW CREATE TABLE products;

-- Insert a row with all the column values
INSERT INTO products VALUES (1001, 'PEN', 'Pen Red', 5000, 1.23);

-- Insert into multiple rows in one command
-- Inserting NULL into the auto_increment column result in the max_value + 1
INSERT INTO products VALUES
         (NULL, 'PEN', 'Pen Blue',  8000, 1.25),
         (NULL, 'PEN', 'Pen Black', 2000, 1.25);
 
-- Insert value to selected columns
-- Missing value for the auto_increment column also results in max_value + 1 
INSERT INTO products (productCode, name, quantity, price) VALUES
         ('PEC', 'Pencil 2B', 10000, 0.48),
         ('PEC', 'Pencil 2H', 8000, 0.49);
         
-- Missing columns get their default values
INSERT INTO products (productCode, name) VALUES ('PEC', 'Pencil HB');

SELECT * FROM products;

-- Remove the last row
DELETE FROM products WHERE productID = 1006;

SELECT * FROM products;

-- List all rows for the specified columns
SELECT name, price
FROM products;

-- List all rows of ALL the columns. The wildcard * deontes all columns
SELECT *
FROM products;

-- Multiple Columns
SELECT 1+1, NOW();
SELECT name, price
FROM products
WHERE price < 1.0;
SELECT name, quantity
FROM products
WHERE quantity <= 2000;
SELECT name, price
FROM products
WHERE productCode = 'PEN';
-- String values are quoted

-- "name" begins with 'PENCIL'
SELECT name, price
FROM products
WHERE name LIKE 'PENCIL%';

-- "name" begins with 'P', followed by any two characters,
-- followed by space, followed by zero or more characters
SELECT name, price
FROM products
WHERE name LIKE 'P__ %';

-- Logical Operators - AND, OR, NOT, XOR
SELECT *
FROM products
WHERE quantity >= 5000 AND name LIKE 'Pen %';
SELECT *
FROM products
WHERE quantity >= 5000 AND price < 1.24 AND name LIKE 'Pen %';
SELECT *
FROM products
WHERE NOT (quantity >= 5000 AND name LIKE 'Pen %');

-- IN, NOT IN
SELECT *
FROM products
WHERE name IN ('Pen Red', 'Pen Black');

-- BETWEEN, NOT BETWEEN
SELECT *
FROM products
WHERE (price BETWEEN 1.0 AND 2.0) AND (quantity BETWEEN 1000 AND 2000);

-- IS NULL, IS NOT NULL
SELECT *
FROM products
WHERE productCode IS NULL;
-- NULL cannot be compared, so no productCode = NULL, NULL cannot be equaled

-- ORDER by Clasue
-- Order the result in descending order
SELECT *
FROM products
WHERE name LIKE 'Pen %'
ORDER BY price DESC;
	-- Order by price in descending order, followed by quantity in ascending (default) order
SELECT *
FROM products
WHERE name LIKE 'Pen %'
ORDER BY price DESC, quantity;

-- Randomize the returned records
SELECT *
FROM products
ORDER BY RAND();

-- LIMIT Clause
-- Display the first two rows
SELECT *
FROM products
ORDER BY price
LIMIT 2;
-- Skip the first two rows and display the next one row;
SELECT *
FROM products
ORDER BY price
LIMIT 2, 1;

-- AS - Alias
-- Define aliases to be used as column display names, and use alias ID as reference
SELECT productID AS ID, productCode AS Code, name AS Description, price AS 'Unit Price'
FROM products
ORDER BY ID;
	-- Unit price contains a blank and must be back-quoted

-- Function CONCAT()
SELECT CONCAT(productCODE, ' - ', name) AS 'Product Description', price
FROM products;

-- *** PRODUCING SUMMARY REPORTS ***
-- DISTINCT
-- Without DISTINCT
SELECT price
FROM products;
-- With DISTINCT on price
SELECT DISTINCT price AS `Distinct Price`
FROM products;
-- DISTINCT combination of price and name
SELECT DISTINCT price, name
FROM products;

-- GROUP BY Clause
SELECT *
FROM products
ORDER BY productCode, productID;
SELECT *
FROM products
GROUP BY productCode;
 -- Only first record in each group is shown
 
-- GROUP BY Aggregate Functions: COUNT, MAX, MIN, AVG, SUM, STD, GROUP_CONCAT
-- Function COUNT(*) returns the number of rows selected
SELECT COUNT(*) AS `Count`
FROM products;
 -- All rows without GROUP BY clause
SELECT productCode, COUNT(*)
FROM products
GROUP BY productCode;
 
-- Order by COUNT - need to define an alias to be used as reference
SELECT productCode, COUNT(*) AS COUNT
FROM products
GROUP BY productCode
ORDER BY COUNT DESC;
-- Besides COUNT(), there are many other GROUP BY aggregate functions such as AVG(), MAX(), MIN() and SUM(). For example,
SELECT MAX(price), MIN(price), AVG(price), STD(price), SUM(quantity)
FROM products;
 -- Without GROUP BY - All rows
SELECT productCode, MAX(price) AS `Highest Price`, MIN(price) AS `Lowest Price`
FROM products
GROUP BY productCode;
SELECT productCode, MAX(price), MIN(price), CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`, CAST(STD(price) AS DECIMAL(7,2)) AS `Std Dev`, SUM(quantity)
FROM products
GROUP BY productCode;
 -- Use CAST(... AS ...) function to format floating-point numbers

-- HAVING clause
-- HAVING is similar to WHERE, but it can operate on the GROUP BY aggregate functions; whereas WHERE operates only on columns.
SELECT productCode AS `Product Code`, COUNT(*) AS `Count`, CAST(AVG(price) AS DECIMAL(7,2)) AS 'Average' 
FROM products 
GROUP BY productCode 
HAVING Count >=3;
	-- CANNOT use WHERE count >= 3

-- WITH ROLLUP
-- The WITH ROLLUP clause shows the summary of group summary, e.g.,
SELECT 
productCode, 
MAX(price), 
MIN(price), 
CAST(AVG(price) AS DECIMAL(7,2)) AS 'Average',
SUM(quantity)
FROM products
GROUP BY productCode
WITH ROLLUP;        -- Apply aggregate functions to all groups

-- *** MODIFYING DATA - UPDATE ***
-- Increase the price by 10% for all products
UPDATE products SET price = price * 1.1;
SELECT * FROM products;
-- Modify selected rows
UPDATE products SET quantity = quantity - 100 WHERE name = 'Pen Red';   
SELECT * FROM products WHERE name = 'Pen Red';
   
-- You can modify more than one values
UPDATE products SET quantity = quantity + 50, price = 1.23 WHERE name = 'Pen Red';   
SELECT * FROM products WHERE name = 'Pen Red';
-- * CAUTION: If the WHERE clause is omitted in the UPDATE command, ALL ROWS will be updated!
-- Hence, it is a good practice to issue a SELECT query, using the same criteria,
-- to check the result set before issuing the UPDATE.
-- This also applies to the DELETE statement in the following section.

-- *** DELETING ROWS - DELETE FROM ***
-- Delete all rows from the table. Use with extreme care! Records are NOT recoverable!!!
DELETE FROM products WHERE name LIKE 'Pencil%';
SELECT * FROM products;
	-- Use this with extreme care, as the deleted records are irrecoverable!
DELETE FROM products;   
SELECT * FROM products;

-- *** LOADING/EXTRACTING DATA TO/FROM A TEXT FILE ***
-- LOAD DATA LOCAL INFILE ... INTO TABLE ...
-- \N,PEC,Pencil 3B,500,0.52
-- \N,PEC,Pencil 4B,200,0.62
-- \N,PEC,Pencil 5B,100,0.73
-- \N,PEC,Pencil 6B,500,0.47
-- Need to use forward-slash (instead of back-slash) as directory separator
LOAD DATA LOCAL INFILE 'C://Users//Matt//Desktop//products_in.csv' INTO TABLE products 
COLUMNS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'; 
SELECT * FROM products;

-- SELECT ... INTO OUTFILE ...
-- SELECT * FROM products INTO OUTFILE 'C:/Users/Matt/Desktop/MatSQL/products_out.csv'
-- COLUMNS TERMINATED BY ','
-- LINES TERMINATED BY '\r\n';
 

-- *** RUNNING AN SQL SCRIPT ***
-- DELETE FROM products;
-- INSERT INTO products VALUES (2001, 'PEC', 'Pencil 3B', 500, 0.52),
-- (NULL, 'PEC', 'Pencil 4B', 200, 0.62), 
-- (NULL, 'PEC', 'Pencil 5B', 100, 0.73),
-- (NULL, 'PEC', 'Pencil 6B', 500, 0.47);
-- SELECT * FROM products;
-- source C:/Users/Matt/Desktop/MatSQL/load_products.sql
-- Use Unix-style forward slash (/) as directory separator


DELETE FROM products;
INSERT INTO products VALUES (2001, 'PEC', 'Pencil 3B', 500, 0.52), 
(NULL, 'PEC', 'Pencil 4B', 200, 0.62), 
(NULL, 'PEC', 'Pencil 5B', 100, 0.73), 
(NULL, 'PEC', 'Pencil 6B', 500, 0.47); 
SELECT * FROM products;

-- Create 'supplier' table
DROP TABLE IF EXISTS suppliers;


CREATE TABLE suppliers (
supplierID	INT UNSIGNED	NOT	NULL	AUTO_INCREMENT,
name			VARCHAR(30)		NOT	NULL	DEFAULT '',
phone			CHAR(8)			NOT	NULL	DEFAULT '',
PRIMARY KEY	(supplierID)
);

DESCRIBE suppliers;

INSERT INTO suppliers VALUE
(501, 'ABC Traders', '88881111'),
(502, 'XYZ Company', '88882222'),
(503, 'QQ Corp', '88883333');

SELECT * FROM suppliers;


-- ALTER TABLE
ALTER TABLE products
ADD COLUMN supplierID INT UNSIGNED NOT NULL;
DESCRIBE products;

-- Set the supplierID of the existing records in "products" table to a VALID
-- supplierID
UPDATE products SET supplierID = 501;

-- Add a foreign key constrain
ALTER TABLE products
ADD FOREIGN KEY (supplierID) REFERENCES suppliers (supplierID);
DESCRIBE products;
UPDATE products SET supplierID = 502 WHERE productID = 2004;
	-- Choose a valid productID
SELECT * FROM products;


-- SELECT WITH JOIN
-- ANSI style: JOIN ... ON ...
SELECT products.name, price, suppliers.name
FROM products
JOIN suppliers ON products.supplierID = suppliers.supplierID
WHERE price < 0.6;
	-- Need to use products.name and suppliers.name to differentiate the two "names"

-- Use aliases for column names for display
SELECT products.name AS 'Product Name', price, suppliers.name AS 'Supplier Name'
FROM products
JOIN suppliers ON products.supplierID = suppliers.supplierID
WHERE price < 0.6;

-- Use aliases for table names too
SELECT p.name AS 'Product Name', p.price, s.name AS 'Supplier Name'
FROM products AS p
JOIN suppliers AS s ON p.supplierID = s.supplierID
WHERE p.price < 0.6;


-- Many-To-Many Relationship
CREATE TABLE products_suppliers (
productID	INT	UNSIGNED	NOT	NULL,
supplierID	INT	UNSIGNED	NOT	NULL,
	--  Same data types as parent tables
PRIMARY KEY (productID, supplierID),
	-- uniqueness
FOREIGN KEY (productID) REFERENCES products (productID),
FOREIGN KEY (supplierID) REFERENCES suppliers (supplierID)
);

DESCRIBE products_suppliers;

INSERT INTO products_suppliers VALUES (2001, 501), (2002, 501), (2003, 501), (2004, 502), (2001, 503);
-- Values in the foreign-key columns (of the child table) must match
-- valid values in the columns they reference (of the parent table)

SELECT * FROM products_suppliers;

-- Remove a foreign key that builds on a column
SHOW CREATE TABLE products;

ALTER TABLE products DROP FOREIGN KEY products_ibfk_1;

SHOW CREATE TABLE products;

-- Now the redundant supplierID column can be removed
ALTER TABLE products DROP supplierID;
DESC products;

-- Querying
SELECT products.name AS 'Product Name', price, suppliers.name AS 'Supplier Name'
FROM products_suppliers
JOIN products ON products_suppliers.productID = products.productID
JOIN suppliers ON products_suppliers.supplierID = suppliers.supplierID
WHERE price < 0.6;

-- Define aliases for tablenames too
SELECT p.name AS 'Product Name', s.name AS 'Supplier Name'
FROM products_suppliers AS ps
JOIN products AS p on ps.productID = p.productID
JOIN suppliers AS s on ps.supplierID = s.supplierID
WHERE p.name = 'Pencil 3B';

-- Using WHERE clause to join (legacy and not reccomended)
SELECT p.name AS 'Product Name', s.name AS 'Supplier Name'
FROM products AS p, products_suppliers AS ps, suppliers AS s
WHERE p.productID = ps.productID
AND ps.supplierID = s.supplierID
AND s.name = 'ABC Traders';


-- ONE-TO-ONE RELATIONSHIP
CREATE TABLE product_details ( 
productID	INT UNSIGNED	NOT NULL,
	-- same data type as the parent table
comment		TEXT				NULL,
	-- up to 64KB
PRIMARY KEY (productID),
FOREIGN KEY (productID) REFERENCES products (productID)
);

DESCRIBE product_details;

SHOW CREATE TABLE product_details;


-- SELECT * FROM products_suppliers;

-- DELETE FROM suppliers WHERE supplierID = 501;

-- Indexes (or Keys) can be created on selected column(s) to facilitate fast search. Without index, a "SELECT * FROM products WHERE productID=x" needs to match with the productID column of all the records in the products table. If productID column is indexed (e.g., using a binary tree), the matching can be greatly improved (via the binary tree search).
-- You should index columns which are frequently used in the WHERE clause; and as JOIN columns.
-- The drawback about indexing is cost and space. Building and maintaining indexes require computations and memory spaces. Indexes facilitate fast search but deplete the performance on modifying the table (INSERT/UPDATE/DELETE), and need to be justified. Nevertheless, relational databases are typically optimized for queries and retrievals, but NOT for updates.
-- In MySQL, the keyword KEY is synonym to INDEX.
-- In MySQL, indexes can be built on:
-- a single column (column-index)
-- a set of columns (concatenated-index)
-- on unique-value column (UNIQUE INDEX or UNIQUE KEY)
-- on a prefix of a column for strings (VARCHAR or CHAR), e.g., first 5 characters.
-- There can be more than one indexes in a table. Index are automatically built on the primary-key column(s).
-- You can build index via CREATE TABLE, CREATE INDEX or ALTER TABLE.

CREATE TABLE employees (
emp_no		INT UNSIGNED	NOT NULL	AUTO_INCREMENT,
name			VARCHAR(50)		NOT NULL,
gender		ENUM ('M','F')	NOT NULL,
birth_date	DATE				NOT NULL,
hire_date	DATE				NOT NULL,
PRIMARY KEY (emp_no) -- Index built automatically on primary-key column
);

DESCRIBE employees;

SHOW INDEX FROM employees;

CREATE TABLE departments (
dept_no		CHAR(4)		NOT NULL,
dept_name	VARCHAR(40)	NOT NULL,
PRIMARY KEY (dept_no), -- Index built automatically on primary-key column
UNIQUE INDEX (dept_name) -- Build INDEX on this unique-value column
);

DESCRIBE departments;

SHOW INDEX FROM departments;

-- Many-to-many juntion table between employees and departments
CREATE TABLE dept_emp (
emp_no		INT UNSIGNED	NOT NULL,
dept_no		CHAR(4)			NOT NULL,
from_date	DATE				NOT NULL,
to_date		DATE				NOT NULL,
INDEX (emp_no), -- Build INDEX on this non-unique-value column
INDEX (dept_no), -- Build INDEX on this non-unique-value column
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (emp_no, dept_no) -- Index built automatically
);

DESCRIBE dept_emp;

SHOW INDEX FROM dept_emp;
