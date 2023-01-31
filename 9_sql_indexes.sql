-- INDEXES
USE sql_store;

-- check out TYPE and ROWS from explain result. to see how many rows mysql has to check to get the result.
EXPLAIN SELECT customer_id FROM customers WHERE state = 'CA';

CREATE INDEX idx_state
ON customers(state);

-- find customers with more than 1000 points 
EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;

CREATE INDEX idx_points
ON customers(points);

ANALYZE TABLE customers;
SHOW INDEXES IN customers;

-- Indexing on strings
-- check optimal value to set for prefix string

SELECT 
	COUNT(DISTINCT LEFT(last_name,1)),
    COUNT(DISTINCT LEFT(last_name,5)),
    COUNT(DISTINCT LEFT(last_name,10))
FROM customers;

CREATE INDEX idx_last_name
ON customers(last_name(5));


-- Full Text Indexes
USE sql_blog;

CREATE FULLTEXT INDEX idx_title_body
ON posts(title,body);

-- MATCH(columns) must matched with index columns
SELECT *, MATCH(title,body) AGAINST('react redux') AS relavency_scores
FROM posts
WHERE MATCH(title,body) AGAINST('react redux');

-- boolean mode in minus redux and add form
SELECT *
FROM posts
WHERE MATCH(title,body) AGAINST('react -redux +form' IN BOOLEAN MODE);

-- exact string
SELECT *
FROM posts
WHERE MATCH(title,body) AGAINST('"handling a form"' IN BOOLEAN MODE);




-- Composite Indexes

USE sql_store;

DROP INDEX idx_state_points ON customers;

SHOW INDEXES IN customers;

CREATE INDEX idx_state_points ON customers(state,points);

EXPLAIN SELECT * FROM customers
WHERE state = 'CA' AND points > 1000;


