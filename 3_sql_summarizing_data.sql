-- Create a report to see all the amount for two date ranges - 1)first half of 2019 and 2)second half of 2019 with records about
-- total sales, total payments, and a new calculated column "what we expect" - which is the difference between total sales and total payments
-- followed by the total amounts for whole year

USE sql_invoicing;
SELECT 
	'First half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 
	'Second half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 
	'TOTAL' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices;


-- Generate a report to show 3 columns - date, payment mathod and total payments against payments table, 
-- grouping records by date and payment method

USE sql_invoicing;
SELECT 
	p.date,
    pm.name AS payment_method, 
    SUM(p.amount) as total_payments
FROM payments p
JOIN payment_methods pm ON pm.payment_method_id=p.payment_method
GROUP BY p.date, pm.name
ORDER BY p.date;



-- Create a report to see total amount we have received for each payment method and the total amount across all payment methods

USE sql_invoicing;
SELECT 
	pm.name AS payment_method,
    SUM(p.amount) AS total
FROM payments p 
JOIN payment_methods pm ON pm.payment_method_id=p.payment_method
GROUP BY pm.name WITH ROLLUP;

-- Write a query to get the customers who are located in Virginia and have spent more than a 100$
USE sql_store;
SELECT 
	c.customer_id,
	CONCAT(c.first_name, " ", c.last_name) AS customer,
    SUM(oi.unit_price*oi.quantity) AS total
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE c.state = 'VA'
GROUP BY c.customer_id, customer
HAVING total > 100;