/*
-- Create a trigger that gets fired when we insert new rows into the payments table to update the invoices table automatically
-- and to save this changes to your audit table
*/


USE sql_invoicing;

DROP TRIGGER IF EXISTS payments_after_insert;

DELIMITER $$
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments 
		FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total=payment_total+ NEW.amount
    WHERE invoice_id= NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES(NEW.client_id, NEW.date, NEW.amount, 'INSERT', NOW());
    
END$$

DELIMITER ;


-- Testing
INSERT INTO payments
VALUES(DEFAULT,5,3,'2019-01-01',10,1);



/*
-- Create a trigger that gets fired when we delete a row from the payments table to update the invoices table automatically
*/

USE sql_invoicing;

DROP TRIGGER IF EXISTS payments_after_delete;

DELIMITER $$
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments 
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total=payment_total - OLD.amount -- use old keyword to get the values that was deleted
    WHERE invoice_id= OLD.invoice_id;
    
    INSERT INTO payments_audit
    VALUES(OLD.client_id, OLD.date, OLD.amount, 'DELETE', NOW());
END$$

DELIMITER ;

-- Testing
DELETE
FROM payments
WHERE payment_id=10;

SHOW TRIGGERS LIKE '%payments%';


/*
-- EVENTS
-- Create an event that delete all the audit recrods which are 1 year old from today
*/

SHOW VARIABLES LIKE 'event%';

SET GLOBAL event_scheduler = ON; -- or OFF

DROP EVENT IF EXISTS yearly_delete_audit_records;
DELIMITER $$
CREATE EVENT yearly_delete_audit_records
	ON SCHEDULE EVERY 1 YEAR STARTS '2024-01-01' ENDS '2026-01-02'
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END$$

DELIMITER ;

SHOW EVENTS LIKE 'yearly%';



