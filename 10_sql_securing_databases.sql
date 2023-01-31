-- Creating a user    

/* with IP address */
CREATE USER john@127.0.0.1;

/* with Host name */
CREATE USER john@localhost;

CREATE USER john@sample.com;

/* from any subdomain of sample.com */
CREATE USER john@'%.sample.com';

/* can access from anywhere with this name */
CREATE USER john IDENTIFIED BY '1234';


SELECT * FROM mysql.user;
DROP USER john;


-- set password for a specific user
SET PASSWORD FOR john = '5678';

-- set password ourselves who ever is currently logged in
SET PASSWORD = 'abcdefg';




-- Granting Priviliges

-- Scenerio 1) web/desktop application
CREATE USER awesome_app IDENTIFIED BY '1234';

-- execute means able to use stored procedures

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON sql_store.*
TO awesome_app;

-- Scenerio 2) Admin User

GRANT ALL -- all means every priviliges
ON *.* -- every database and every tables
TO john;





SHOW GRANTS FOR john;

-- for current user
SHOW GRANTS;



/*   Revoking  Priviliges    */

GRANT CREATE VIEW
ON sql_store.*
TO awesome_app;

-- now made mistake and want to revoke
REVOKE CREATE VIEW
ON sql_store.*
FROM awesome_app;