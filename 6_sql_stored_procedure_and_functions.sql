-- Create procedure to get clients by state using input from user and if there is null as input - return whole list of cliens

USE sql_invoicing;

DROP PROCEDURE IF EXISTS get_client_by_state;
DELIMITER $$
CREATE PROCEDURE get_client_by_state(state CHAR(2))
BEGIN
		IF state IS NULL THEN
			SELECT * FROM clients;
		ELSE 
			SELECT * FROM clients c
			WHERE state = c.state;
		END IF;
END $$
DELIMITER ;

-- Testing
CALL get_client_by_state(NULL);



-- Create a procedure to return invoices for a given client 

DROP PROCEDURE IF EXISTS get_invoices_by_client;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client(name VARCHAR(50))
BEGIN
		SELECT * FROM invoices i
        JOIN clients c USING(client_id)
        WHERE c.name=name;
END$$
DELIMITER ;

-- Testing
CALL get_invoices_by_client('Vinte');



-- Create a stored procedure calles get_payments with 2 parameters: 
--     client_id - INT,
--     payment_method_id - TINYINT

DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments(
	client_id INT,
    payment_method_id TINYINT(1))
BEGIN
	SELECT * FROM payments p
    WHERE 
    p.client_id = IFNULL(client_id, p.client_id)
    AND 
    p.payment_method = IFNULL(payment_method_id, p.payment_method);
END$$

-- Testing
CALL get_payments(5,NULL);



-- Parameters Validation 

-- Create a stored procedure calles make_payments with 3 parameters: 
--   invoice_id - INT,
--   payment_amount - DECIMAL
--   payment_date - DATE

-- to update invoices table with a new records depending on user input


DROP PROCEDURE IF EXISTS make_payments;
DELIMITER $$

CREATE PROCEDURE make_payments(
	invoice_id INT,
    payment_amount DECIMAL(9,2),
    payment_date DATE)
    
BEGIN
		IF payment_amount < 0 
			THEN SIGNAL SQLSTATE '22003'
			SET MESSAGE_TEXT = 'Invalid payment amount';
        END IF;
        
	UPDATE invoices i
		SET i.payment_total = payment_amount,
		i.payment_date = payment_date
    WHERE i.invoice_id = invoice_id;
    
END$$
DELIMITER ;

-- Testing
CALL make_payments(1,10,'2019-01-01');




-- Create a stored procedure to get unpaid invoices for a client using Output Parameters: number of unpaid invoices and total unpaid amount 
-- per client letting the user to choose client by id

DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;

DELIMITER $$
CREATE PROCEDURE get_unpaid_invoices_for_client
	(client_id INT, 
    OUT number_of_unpaid_invoices INT, 
    OUT total_unpaid_amount INT)
    
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
		INTO number_of_unpaid_invoices, total_unpaid_amount
    FROM invoices i
    WHERE i.client_id = client_id
		  AND payment_total = 0;
END $$
DELIMITER ;

-- testing with User or Session Variables
set @number_of_unpaid_invoices = 0;
set @total_unpaid_amount = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @number_of_unpaid_invoices, @total_unpaid_amount);
select @number_of_unpaid_invoices, @total_unpaid_amount;




-- Create stored procedure with Local Variables to get risk factor per client letting user to choose client id when calling procedure
-- where risk factor is invoices_total / invoice_count * 5 

DROP PROCEDURE IF EXISTS get_risk_factor;

DELIMITER $$
CREATE PROCEDURE get_risk_factor(client_id INT)
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoice_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
		INTO invoice_count, invoices_total
    FROM invoices i
    WHERE i.client_id=client_id;
    
    SET risk_factor = invoices_total / invoice_count * 5;
    
    SELECT risk_factor;
END $$
DELIMITER ;


CALL get_risk_factor(1);





-- Create Function with Local Variables to get risk factor per client

DROP FUNCTION IF EXISTS func_get_risk_factor_for_client;

DELIMITER $$
CREATE FUNCTION func_get_risk_factor_for_client(
	client_id INT)
	RETURNS INTEGER
    READS SQL DATA
    
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoice_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
		INTO invoice_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;
    
    SET risk_factor = invoices_total / invoice_count * 5;
    
    RETURN IFNULL(risk_factor,0);
END $$
DELIMITER ;

-- Testing
SELECT client_id, name, func_get_risk_factor_for_client(client_id) AS risk_factor
FROM clients;

