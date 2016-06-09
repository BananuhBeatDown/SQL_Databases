DROP TABLE IF EXISTS t1, t2;

CREATE TABLE t1 (
id			INT			PRIMARY KEY,
des		VARCHAR(30)
);
-- 'desc' is a reserved word - must be back-quoted

CREATE TABLE t2 (
id			INT			PRIMARY KEY,
des		VARCHAR(30)
);

INSERT INTO t1 VALUES
(1, 'ID 1 in t1'),
(2, 'ID 2 in t1'),
(3, 'ID 3 in t1');

INSERT INTO t2 VALUES
(2, 'ID 2 in t2'),
(3, 'ID 3 in t2'),
(4, 'ID 4 in t2');

SELECT * FROM t1;

SELECT * FROM t2;

SELECT * FROM t1 INNER JOIN t2;
-- SELECT all columns in t1 and t2 (*)
-- INNER JOIN produces ALL combinations of rows in t1 and t2

-- Impose constraints by using the ON clause
SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id;
-- defaul JOIN in INNER JOIN
SELECT * FROM t1 CROSS JOIN t2 ON t1.id = t2.id;
-- Also called CROSS JOIN

-- You can use USING clause if the join-columns have the same name
SELECT * FROM t1 INNER JOIN t2 USING (id);
	-- Only 3 columns in the result set, instead of 4 columns with ON clause

SELECT * FROM t1 INNER JOIN t2 WHERE t1.id = t2.id;
	-- Use WHERE instead of ON

SELECT * FROM t1, t2 WHERE t1.id = t2.id;
	-- Use "commas" operator to join

SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id;
-- Rows on the left without an equivalent on the right are give a NULL value

SELECT * FROM t1 LEFT JOIN t2 USING (id);
-- Same result as previous example 

SELECT * FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;
-- Right side equivalent example

SELECT * FROM t1 RIGHT JOIN t2 USING (id);
-- Same result as previous example

SELECT t1.id, t1.des
FROM t1 LEFT JOIN t2 USING (id)
WHERE t2.id IS NULL;
-- SELECT LEFT row result with a NULL RIGHT equivalent
