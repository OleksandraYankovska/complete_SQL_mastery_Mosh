
-- arithmetic expressions, regular expressions, where clause

use sql_store;
SELECT 
	first_name, 
    last_name,
    birth_date,
    (points + 10)*100 AS 'new points',
    points,
    state
FROM customers
WHERE 
	(last_name REGEXP 'field$|^mac|[gim]e' OR birth_date > '1993-01-01')
	OR 
    (points > 2000 AND STATE IN ('IL','CA'))
ORDER BY state, last_name;
    

-- sort orders #2 by their total price in descending order

use sql_store;
SELECT *, unit_price*quantity as total_price
FROM order_items
WHERE order_id=2
ORDER BY total_price DESC;

-- join across databases

SELECT *
FROM sql_store.order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;


-- Self Join. Write a query to get all the employyes and their managers. The result must include the manager as employee.

use sql_hr;
SELECT 
	e1.employee_id, 
    e1.first_name, 
    e1.last_name, 
	COALESCE(CONCAT(e2.first_name," ",e2.last_name), 'Top Manager') AS manager
FROM employees e1
LEFT JOIN employees e2 
	ON e1.reports_to = e2.employee_id
ORDER BY e1.employee_id;
    
-- Write a query to join orders table with customers and order_statuses tables to see order status for each order per customer 

use sql_store;
SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    s.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses s
	ON o.status = s.order_status_id
ORDER BY o.order_id;
    
    

-- Write a query to join payments table with two tables clients and payment_methods to see payment method for each payment per client 

USE sql_invoicing;
SELECT 
	p.client_id,
    p.date,
    p.invoice_id,
    p.amount,
    c.name as client_name,
    pm.name as payment_method
FROM payments p
JOIN clients c
	ON c.client_id=p.client_id
JOIN payment_methods pm
	ON pm.payment_method_id=p.payment_method
ORDER BY client_id;


-- Write a query to join products table with order_items table to see how many times each product was ordered

use sql_store;
SELECT
	p.product_id,
    p.name,
    sum(case when o.quantity is not null then o.quantity else 0 end) as sum_quantity
FROM
	products p
LEFT JOIN order_items o
	ON o.product_id=p.product_id
GROUP BY p.product_id
ORDER BY p.product_id;

-- Write a query to join products table with order_items table to see product which has never been ordered

use sql_store;
SELECT 
	p.product_id, 
    p.name, 
    oi.quantity
FROM products p
LEFT JOIN order_items oi 
	ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL;

-- Write a query to see the order id, the order date , the customer name, the shipper and the status 

use sql_store;
SELECT 
	o.order_id, 
    o.order_date, 
    c.first_name AS customer,
    s.name AS shipper,
    os.name AS status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN shippers s ON s.shipper_id = o.shipper_id
LEFT JOIN order_statuses os ON os.order_status_id = o.status
ORDER BY o.order_id;

-- The Using Clause. Write a query to select the payments from the payments table having a date, client name, amount and payment method

use sql_invoicing;
SELECT 
	p.date,
    c.name as client,
    p.amount,
    pm.name as payment_method
FROM payments p
JOIN clients c USING (client_id)
LEFT JOIN payment_methods pm 
	ON pm.payment_method_id=p.payment_method;
    
-- Cross join between shippers and products using 1) implicit syntax and 2) explict syntax
use sql_store;
SELECT s.name, p.name
FROM shippers s , products p;

SELECT s.name, p.name
FROM shippers s
CROSS JOIN products p;

-- Using UNION add a new column "status" for orders that have place at 2019 and to those that have place until 2019
use sql_store;
SELECT 
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date>='2019-01-01'
UNION
SELECT 
	order_id,
    order_date,
    'Archive' AS status
FROM orders
WHERE order_date<'2019-01-01';

-- Write a query to produce the report including 4 columns:customer_id,first_name,points and new calculated column - type, based on the 
-- points each customer has. If they have less than 2000 - their type is Bronze; 2000-3000 - Silver, more than 3000 - Gold.
use sql_store;
SELECT
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers
WHERE points<2000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Gold' AS type
FROM customers
WHERE points>3000
ORDER BY customer_id;

