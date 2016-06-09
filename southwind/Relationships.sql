Use southwind;

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

SHOW CREATE TABLE product_details