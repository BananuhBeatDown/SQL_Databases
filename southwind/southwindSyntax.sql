USE southwind;

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

-- 2.6  Producing Summary Reports
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

-- 2.7  Modifying Data - UPDATE
-- Increase the price by 10% for all products
UPDATE products SET price = price * 1.1;
SELECT * FROM products;
-- Modify selected rows
UPDATE products SET quantity = quantity - 100 WHERE name = 'Pen Red';   
SELECT * FROM products WHERE name = 'Pen Red';
   
-- You can modify more than one values
UPDATE products SET quantity = quantity + 50, price = 1.23 WHERE name = 'Pen Red';   
SELECT * FROM products WHERE name = 'Pen Red';
-- ***CAUTION: If the WHERE clause is omitted in the UPDATE command, ALL ROWS will be updated!
-- Hence, it is a good practice to issue a SELECT query, using the same criteria,
-- to check the result set before issuing the UPDATE.
-- This also applies to the DELETE statement in the following section.

-- 2.8  Deleting Rows - DELETE FROM
-- Delete all rows from the table. Use with extreme care! Records are NOT recoverable!!!
DELETE FROM products WHERE name LIKE 'Pencil%';
SELECT * FROM products;
-- Use this with extreme care, as the deleted records are irrecoverable!
DELETE FROM products;   
SELECT * FROM products;

-- 2.9  Loading/Exporting Data from/to a Text File
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
 

-- 2.10  Running a SQL Script
-- DELETE FROM products;
-- INSERT INTO products VALUES (2001, 'PEC', 'Pencil 3B', 500, 0.52),
-- (NULL, 'PEC', 'Pencil 4B', 200, 0.62), 
-- (NULL, 'PEC', 'Pencil 5B', 100, 0.73),
-- (NULL, 'PEC', 'Pencil 6B', 500, 0.47);
-- SELECT * FROM products;
-- source C:/Users/Matt/Desktop/MatSQL/load_products.sql
-- Use Unix-style forward slash (/) as directory separator

