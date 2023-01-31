
USE sql_invoicing;

CREATE VIEW sales_by_client AS

SELECT c.client_id, c.name, SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id, name;


CREATE OR REPLACE VIEW clients_balance AS

SELECT c.client_id, c.name, SUM(i.invoice_total - i.payment_total) AS balance
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id, name;

SELECT * FROM clients_balance WHERE client_id != 2 ;

-- DROP VIEW clients_balance;


CREATE OR REPLACE VIEW invoices_with_balance AS 
SELECT 
	invoice_id, number, client_id, invoice_total, payment_total,
    invoice_total - payment_total AS balance,
	invoice_date, due_date, payment_date
FROM invoices 
WHERE invoice_total - payment_total > 0;

SELECT * FROM v_invoices_with_remaining_balance;

DELETE FROM invoices_with_balance
WHERE invoice_id = 1;


UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 4; 

