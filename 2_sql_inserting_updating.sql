-- Write a query to copy invoices table and replace the column "client_id" with the column "client_name" from clients table, except 
-- the records which dont have a payment date

use sql_invoicing;

CREATE TABLE invoices_archive AS
	SELECT 
		i.invoice_id, 
		i.number,
		c.name AS client,
		i.invoice_total,
		i.payment_total,
		i.invoice_date,
		i.due_date,
		i.payment_date
	FROM invoices i
	JOIN clients c USING (client_id)
	WHERE payment_date IS NOT NULL;
    
TRUNCATE invoices_archive;

-- Write a query to update the records about client with name MyWorks in invoices table where payment total will be 50% of invoice total
-- and payment date will be a due date

use sql_invoicing;
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN (
	SELECT client_id FROM clients WHERE name LIKE 'MyWorks'
);


-- Write a query to give any customers born before 1990 50 extra points

use sql_store;
UPDATE customers
SET points = points + 50
WHERE YEAR(birth_date) < 1990;


-- Write a query to update comments from orders for customers who have more that 3000 points - set "gold" customer

use sql_store;
UPDATE orders 
SET comments = 'Gold' 
WHERE customer_id IN
	(SELECT customer_id
	FROM customers
	WHERE points > 3000);


