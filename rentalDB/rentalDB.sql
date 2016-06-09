-- *** RENTAL SYSTEM EXERCISE ***
DROP DATABASE IF EXISTS rentalDB;
CREATE DATABASE rentalDB; USE rentalDB;

-- Create 'vehicles' table
DROP TABLE IF EXISTS vehicles;
CREATE TABLE vehicles (
veh_reg_no VARCHAR(8) 		NOT NULL,
category 	ENUM('car', 'truck') NOT NULL DEFAULT 'car',
brand 		VARCHAR(30) 	NOT NULL DEFAULT '',
des 			VARCHAR(256) 	NOT NULL DEFAULT '',
photo 		BLOB 				NULL, -- binary large object up to 64KB
daily_rate 	DECIMAL(6,2) 	NOT NULL DEFAULT 9999.99, -- set default to max value
PRIMARY KEY (veh_reg_no),
INDEX(category) -- Build index on this column for fast search
)
ENGINE = InnoDB;
	-- MySQL provides a few ENGINEs, InnoDB supports foreign keys and transactions

DESC vehicles; SHOW
CREATE TABLE vehicles; SHOW INDEX
FROM vehicles;

-- INSERTing 'vehicles' test records
INSERT INTO vehicles VALUES
('SBA1111A', 'car', 'NISSAN SUNNY 1.6L', '4 Door Saloon, Automatic', NULL, 99.99),
('SBB2222B', 'car', 'TOYOTA ALTIS 1.6L', '4 Door Saloon, Automatic', NULL, 99.99),
('SBC3333C', 'car', 'HONDA CIVIC 1.8L', '4 Door Saloon, Automatic', NULL, 119.99),
('GA5555E', 'truck', 'NISSAN CABSTAR 3.0L', 'Lorry, Manual', NULL, 89.99),
('GA6666F', 'truck', 'OPEL COMBO 1.6L', 'Van, Manual', NULL, 69.99);
-- No photo yet, set to NULL
SELECT *
FROM vehicles;

-- Create 'customers' table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
name VARCHAR(30) NOT NULL DEFAULT '',
address VARCHAR(80) NOT NULL DEFAULT '',
phone VARCHAR(15) NOT NULL DEFAULT '',
discount DOUBLE NOT NULL DEFAULT 0.0, PRIMARY KEY (customer_id), UNIQUE INDEX (phone), INDEX (name)
) ENGINE=InnoDB; DESC customers; SHOW
CREATE TABLE customers; SHOW INDEX
FROM customers;
INSERT INTO customers VALUES
(1001, 'Tan Ah Teck', '8 Happy Ave', '88888888', 0.1),
(NULL, 'Mohammed Ali', '1 Kg Java', '99999999', 0.15),
(NULL, 'Kumar', '5 Serangoon Road', '55555555', 0),
(NULL, 'Kevin Jones', '2 Sunset boulevard', '22222222', 0.2);
SELECT *
FROM customers;


-- Create 'rentalRecords' table
DROP TABLE IF EXISTS	rentalRecords;
CREATE TABLE rentalRecords (
rental_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
veh_reg_no VARCHAR(8) NOT NULL,
customer_id INT UNSIGNED NOT NULL,
start_date DATE NOT NULL DEFAULT '0000-00-00',
end_date DATE NOT NULL DEFAULT '0000-00-00',
lastUpdated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON
UPDATE CURRENT_TIMESTAMP,
	-- Keep the created and last updated timestamp for auditing and security
PRIMARY KEY (rental_id), FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON
DELETE RESTRICT ON
UPDATE CASCADE,
	-- Disallow deletion of parent record if there are matching records here
	-- If parent record (customer_id) changes, update the matching records here
FOREIGN KEY (veh_reg_no) REFERENCES vehicles (veh_reg_no) ON
DELETE RESTRICT ON
UPDATE CASCADE
) ENGINE=InnoDB; DESC rentalRecords; SHOW
CREATE TABLE rentalRecords; SHOW INDEX
FROM rentalRecords;

-- Inserting 'rentalRecords' test records
INSERT INTO rentalRecords VALUES
(NULL, 'SBA1111A', 1001, '2012-01-01', '2012-01-21', NULL),
(NULL, 'SBA1111A', 1001, '2012-02-01', '2012-02-05', NULL),
(NULL, 'GA5555E', 1003, '2012-01-05', '2012-01-31', NULL),
(NULL, 'GA6666F', 1004, '2012-01-20', '2012-02-20', NULL);
SELECT *
FROM rentalRecords;


-- Exercise 1
-- Create new 'rentalRecords' entry
INSERT INTO rentalRecords VALUES
(NULL,
'SBA1111A', 
(
SELECT customer_id
FROM customers
WHERE name = 'Tan Ah Teck'), CURDATE(), DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL);


-- Exercise 2
-- Create new 'rentalRecords' entry
INSERT INTO rentalRecords VALUES
(NULL,
'GA5555E',
(
SELECT customer_id
FROM customers
WHERE name='Kumar'), DATE_ADD(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 91 DAY), NULL);


-- Exercise 3
-- List all rental records (start date, end date) 
-- with vehicle's registration number, brand,
-- and customer name, sorted by vehicle's
-- cateogories followed by start date.
SELECT
	r.start_date AS	'Start Date',
	r.end_date AS 'End Date',
	r.veh_reg_no AS	'Vehicle No',
	v.brand AS 'Vehicle Brand',
	c.name AS 'Customer Name'
FROM rentalRecords AS r
INNER JOIN vehicles AS v USING (veh_reg_no)
INNER JOIN customers AS c USING (customer_id)
ORDER BY	v.category, start_date;


-- Exercise 4
-- List all expired rental records
SELECT
	r.end_date AS 'End Date',
	r.customer_id AS 'Customer ID'
FROM rentalRecords AS r
WHERE end_date < CURDATE();


-- Exercise 5
-- List all vehicles rented out on '2012-01-10'
SELECT
	r.veh_reg_no AS 'Vehicle No',
	c.name AS 'Customer Name',
	r.start_date AS 'Start Date',
	r.end_date AS 'End Date'
FROM rentalRecords AS r
INNER JOIN customers AS c USING (customer_id)
WHERE start_date < '2012-01-10';


-- Exercise 6
-- List all vehicles rented out today
SELECT
	r.veh_reg_no AS 'Vehicle No',
	c.name AS 'Customer Name',
	r.start_date AS 'Start Date',
	r.end_date AS 'End Date'
FROM rentalRecords AS r
INNER JOIN customers AS c USING (customer_id)
WHERE start_date <= CURDATE() AND CURDATE() < end_date;


-- Exercise 7
-- List all vehicles rented out on between '2012-01-03' to '2012-01-18'
SELECT
	r.veh_reg_no AS 'Vehicle No',
	c.name AS 'Customer Name',
	r.start_date AS 'Start Date',
	r.end_date AS 'End Date'
FROM rentalRecords AS r
INNER JOIN customers AS c USING (customer_id)
WHERE start_date <= '2012-01-03' AND end_date > '2012-01-18';


-- Exercise 8
-- List all vehicles available for rent on '2012-01-10'
SELECT
	r.veh_reg_no AS 'Vehicle No',
	v.brand AS 'Brand',
	v.des AS 'Description',
	r.start_date AS 'Start Date',
	r.end_date AS 'End Date'
FROM rentalRecords AS r
INNER JOIN vehicles AS v USING (veh_reg_no)
WHERE NOT start_date < '2012-01-10' AND end_date > '2012-01-10';


-- Exercise 9
-- List all vehicles available for rent bewtween '2012-01-03' to '2012-01-18'
SELECT
	r.veh_reg_no AS 'Vehicle No',
	v.brand AS 'Brand',
	v.des AS 'Description',
	r.start_date AS 'Start Date',
	r.end_date AS 'End Date'
FROM rentalRecords AS r
INNER JOIN vehicles AS v USING (veh_reg_no)
WHERE NOT start_date < '2012-01-18' AND end_date > '2012-01-18';


-- Exercise 10
-- List all rentals avaulable from today for 10 days
SELECT
	r.veh_reg_no AS 'Vehicle No',
	v.brand AS 'Brand',
	v.des AS 'Description',
	r.start_date AS 'Start Date',
	r.end_date AS 'End Date'
FROM rentalRecords AS r
INNER JOIN vehicles AS v USING (veh_reg_no)
WHERE end_date < DATE_ADD(CURDATE(), INTERVAL 10 DAY);


-- Exercise 11
-- a) Try deleting a parent row with matching row(s) in chold table(s)
-- * Can't be done this way!
-- DELETE FROM vehicles WHERE veh_reg_no='GA6666F';
-- SELECT * FROM vehicles;

-- b) Try updating a parent row with matching row(s) in child tables.
-- Check the effects on the chold table rentalRecords (ON UPDATE CASCADE)
UPDATE vehicles 
SET veh_reg_no='GA9999F'
WHERE veh_reg_no='GA6666F';
SELECT * FROM rentalRecords;

-- c) Remove 'GA6666F' from the database
-- * remove it from child table then parent table
DELETE FROM rentalRecords 
WHERE veh_reg_no='GA9999F';
DELETE FROM vehicles
WHERE veh_reg_no='GA9999F';
SELECT * FROM vehicles;
SELECT * FROM rentalRecords;


-- Create 'Payments' table
DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
	payment_id		INT UNSIGNED	NOT NULL	AUTO_INCREMENT,
	rental_id		INT UNSIGNED	NOT NULL,
	amount			DECIMAL(8,2)	NOT NULL	DEFAULT 0,
	pay_mode			ENUM('cash', 'credit card', 'check'),
	pay_type			ENUM('deposit', 'partial', 'full')	NOT NULL	DEFAULT 'full',
	remark			VARCHAR(255),
	created_date	DATETIME			NOT NULL,
	created_by		INT UNSIGNED	NOT NULL,
	last_updated_date	TIMESTAMP	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	last_updated_by	INT UNSIGNED	NOT NULL,
	PRIMARY KEY	(payment_id),
	INDEX 		(rental_id),
	FOREIGN KEY	(rental_id) REFERENCES rentalRecords (rental_id)
)
ENGINE=InnoDB;

DESC payments;
SHOW CREATE TABLE payments;
SHOW INDEX FROM payments;


-- Create 'staff' table
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	staff_id		INT UNSIGNED	NOT NULL	AUTO_INCREMENT,
	name			VARCHAR(30)		NOT NULL DEFAULT '',
	title			VARCHAR(30)		NOT NULL	DEFAULT '',
	address		VARCHAR(80)		NOT NULL DEFAULT '',
	phone			VARCHAR(15)		NOT NULL	DEFAULT '',
	report_to	INT UNSIGNED	NOT NULL,
	PRIMARY KEY		(staff_id),
	UNIQUE INDEX	(phone),
	INDEX				(name),
	FOREIGN KEY		(report_to) REFERENCES staff (staff_id)
)
ENGINE=InnoDB;

DESC staff;
SHOW INDEX FROM staff;

INSERT INTO staff VALUE
	(8001, 'Peter Johns', 'Managing Director', '1 Happy Ave', '12345678', 8001);
SELECT * FROM staff;

ALTER TABLE rentalRecords
	ADD COLUMN staff_id	INT UNSIGNED	NOT NULL;

UPDATE rentalRecords SET staff_id = 8001;
ALTER TABLE rentalRecords ADD FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
	ON DELETE RESTRICT ON UPDATE CASCADE;

SHOW CREATE TABLE rentalRecords;
SHOW INDEX FROM rentalRecords;

ALTER TABLE payments
	ADD COLUMN staff_id	INT UNSIGNED	NOT NULL;
	
UPDATE payments SET staff_id = 8001;
ALTER TABLE payments
	ADD FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
	ON DELETE RESTRICT ON UPDATE CASCADE;

SHOW CREATE TABLE payments;
SHOW INDEX FROM payments;


-- Create 'rentalPrices' VIEW
DROP VIEW IF EXISTS rentalPrices;
CREATE VIEW rentalPrices
AS
SELECT
	v.veh_reg_no			AS	'Vehicle No',
	v.daily_rate			AS	'Daily Rate',
	c.name					AS	'Customer Name',
	c.discount*100			AS	'Customer Discount (%)',
	r.start_date			AS	'Start Date',
	r.end_date				AS	'End Date',
	DATEDIFF(r.end_date, r.start_date) AS 'Duration'
FROM rentalRecords AS r
	INNER JOIN vehicles	AS v USING (veh_reg_no)
	INNER JOIN customers AS c USING (customer_id);
	
DESC rentalPrices;
SHOW CREATE VIEW rentalPrices;

SELECT * FROM rentalPrices;
