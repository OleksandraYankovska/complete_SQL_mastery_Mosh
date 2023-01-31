-- Find product that are more expensive than Lettuce (id=3)

use sql_store;
SELECT *
FROM products 
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
);

-- Find employees whose earn more than average across each office

USE sql_hr;
SELECT *
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
    GROUP BY office_id
);

-- Find clients without invoices

USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
    FROM invoices
);

-- If result set of sub queries is too large, we better use EXISTS operator rather than IN 

USE sql_invoicing;
SELECT *
FROM clients c
WHERE NOT EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);


-- Find customers who have ordered lettuce (id-3)

use sql_store;
SELECT 
	DISTINCT c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
JOIN orders USING (customer_id)
JOIN order_items USING (order_id)
JOIN products USING(product_id)
WHERE product_id=3;

-- Find invoices that are larger than all invoices of client 3

USE sql_invoicing;
SELECT *
FROM invoices
WHERE invoice_total > 
	(SELECT MAX(invoice_total)
    FROM invoices
    WHERE client_id=3
);
    
 -- or
 
SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT invoice_total
    FROM invoices
    WHERE client_id=3
);


-- Subqueries in the SELECT Clause

USE sql_invoicing;
SELECT client_id,name,
	(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices WHERE client_id = c.client_id) AS average,
    (SELECT total_sales - average) AS difference
FROM clients c;

-- Subqueries in the FROM Clause

USE sql_invoicing;
SELECT*
FROM (
	SELECT client_id,name,
	(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices WHERE client_id = c.client_id) AS average,
    (SELECT total_sales - average) AS difference
	FROM clients c
) AS sales_summary 
WHERE total_sales IS NOT NULL;



-- Write a query to display insteal of null values - "NOT ASSIGNED", and if the shipper_id is null - return comments column 
-- and if it is null return - "PENDING"

USE sql_store;
SELECT order_id, customer_id, order_date, status,
	IFNULL(shipped_date,'NOT ASSIGNED') AS shipped_date,
    COALESCE(shipper_id, comments, 'PENDING') AS shipper
FROM orders;


-- Write a query to show if the order is placed in the current year return "active", otherwise return "archived"

USE sql_store;
SELECT order_id, order_date,
	IF(YEAR(order_date) >= YEAR(NOW()), 'Active', 'Archived') AS status
FROM orders;

-- CASE function

USE sql_store;
SELECT order_id, order_date,
	CASE
		WHEN YEAR(order_date) >= YEAR(NOW()) THEN 'Active'
        WHEN YEAR(order_date) = YEAR(DATE_ADD(NOW(), INTERVAL -1 YEAR)) THEN 'Last Year'
        ELSE 'Archived'
    END AS status
FROM orders;