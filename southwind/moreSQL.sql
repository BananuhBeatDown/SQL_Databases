-- *** SUB-QUERY ***

-- SELECT with Subquery
SELECT suppliers.name from suppliers
WHERE suppliers.supplierID
NOT IN (SELECT DISTINCT supplierID from products_suppliers);
-- Use EXIST or NOT EXIST to test for empty set

-- Supplier 'QQ Corp' now supplies 'Pencil 6B'
-- You need to put the SELECT subqueries in parentheses
INSERT INTO products_suppliers VALUES (
(SELECT productID FROM products WHERE name = 'Pencil 6B'),
(SELECT supplierID FROM suppliers WHERE name = 'QQ Corp')
);

-- Supplier 'QQ Corp' no longer supplies any item
DELETE FROM products_suppliers
WHERE supplierID = (SELECT supplierID FROM suppliers WHERE name = 'QQ Corp');


-- *** WORKING WITH DATE AND TIME ***

-- Create a table 'patients' of a clinic
CREATE TABLE patients (
patientID		INT UNSIGNED	NOT NULL	AUTO_INCREMENT,
name				VARCHAR(30)		NOT NULL	DEFAULT '',
dateOfBirth		DATE				NOT NULL,
lastVisitDate	DATE				NOT NULL, 
nextVisitDate	DATE				NULL, -- The 'Date' type contains a date value in 'yyyy-mm-dd'
PRIMARY KEY (patientID)
);

INSERT INTO patients VALUES
(1001, 'Ah Teck', '1991-12-31', '2012-01-20', NULL),
(NULL, 'Kumar', '2011-10-29', '2012-09-20', NULL),
(NULL, 'Ali', '2011-01-30', CURDATE(), NULL);
-- Date must be written as 'yyyy-mm-dd'
-- Function CURDATE() returns today's date

SELECT * FROM patients;

-- Selct patients who last visited on a particular range of date
SELECT * FROM patients
WHERE lastVisitDate BETWEEN '2012-09-15' AND CURDATE()
ORDER BY lastVisitDate;

-- Select patients who were born in a particular year and sort by birth-month
-- Function YEAR(date), MONTH(date), DAY(date) returns
-- the year, month, day part of the given date
SELECT * FROM patients
WHERE YEAR(dateOfBirth) = 2011
ORDER BY MONTH(dateOfBirth), DAY(dateOfBirth);

-- Select patients whose birthday is today
SELECT * FROM patients
WHERE MONTH(dateOfBirth) = MONTH(CURDATE())
AND DAY(dateOfBirth) = DAY(CURDATE());

-- List the age of patients
-- Function TIMESTAMPDIFF(unit, start, end) returns the difference in the unit specified
SELECT name, dateOfBirth, TIMESTAMPDIFF(YEAR, dateOfBirth, CURDATE()) AS age
FROM patients
ORDER BY age, dateOfBirth;

-- List patients whose last visited more than 60 days ago
SELECT name, lastVisitDate FROM patients
WHERE TIMESTAMPDIFF(DAY, lastVisitDate, CURDATE()) > 60;
-- Functions TO_DAYS(date) converts the date to days
SELECT name, lastVisitDate FROM patients
WHERE TO_DAYS(CURDATE()) - TO_DAYS(lastVisitDate) > 60;

-- Select patients 18 years old or younger
-- Function DATE_SUB(date, INTERVAL X unit) returns the date
-- by subtracting the given date by x unit
SELECT * FROM patients
WHERE dateOfBirth > DATE_SUB(CURDATE(), INTERVAL 18 YEAR);

-- Schedule Ali's next visit to be 6 months from now
-- Function DATE_ADD(date, INTERVAL x unit) returns the date
-- by adding the given date by x unit
UPDATE patients
SET nextVisitDate = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
WHERE name = 'Ali';

-- CREATE VIEW supplier_view
-- AS
-- SELECT suppliers.name AS 'Supplier Name', products.name AS 'Product Name'
-- FROM products
-- JOIN suppliers ON products.productID = products_suppliers.productID;
-- JOIN products_suppliers ON suppliers.supplierID = products_suppliers.supplierID;
-- 
-- SELECT * FROM supplier_view;
-- 
-- SELECT * FROM supplier_view WHERE 'Supplier Name' LIKE 'ABC%';

DROP VIEW IF EXISTS patient_view;
CREATE VIEW patient_view
AS
SELECT
	patientID AS ID,
	name AS Name,
	dateOfBirth AS DOB,
	TIMESTAMPDIFF(YEAR, dateOfBirth, NOW()) AS Age
FROM patients
ORDER BY Age, DOB;

SELECT * FROM patient_view WHERE Name LIKE 'A%';


-- *** TRANSACTIONS ***
CREATE TABLE accounts (
name		VARCHAR(30),
balance	DECIMAL(10, 2)
);

INSERT INTO accounts VALUES ('Paul', 1000), ('Peter', 2000);
SELECT * FROM accounts;

START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
COMMIT; -- Commit the transaction and end transaction
SELECT * FROM accounts;

START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
ROLLBACK; -- Discard all changes of this transaction and end Transaction
SELECT * FROM accounts;


-- *** USER VARIABLES ***
SELECT @ali_dob := dateOfBirth FROM patients WHERE name = 'Ali';
SELECT name FROM patients WHERE dateOfBirth < @ali_dob;

SET @today := CURDATE();
SELECT name FROM patients WHERE nextVisitDate = @today;