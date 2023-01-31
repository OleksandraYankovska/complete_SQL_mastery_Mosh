-- Transactions
USE sql_store;

START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES(1,'2020-04-05',1);

INSERT INTO ordessr_items
VALUES(LAST_INSERT_ID(),1,1,1);

COMMIT;




-- Concurrency and Locking
SHOW VARIABLES LIKE 'transaction_isolation';

/*for session only*/
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

/*for global*/
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;