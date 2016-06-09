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
