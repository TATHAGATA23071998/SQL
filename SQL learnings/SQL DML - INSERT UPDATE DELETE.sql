/* SQL DML - INSERT, UODATE & DELETE */
/* INSERT values into cusotmer table using 'INSERT INTO' clause of DML */

Use [MyDatabase]
INSERT INTO customers ( id, first_name, country, score)
VALUES 
(6, 'Anna', 'USA', NULL),
(7, 'Sam', NULL, 100);

SELECT *
FROM customers

--INSERT values from one source table (customers) to another target table (persons) using INSERT-SELECT DML clause
INSERT INTO persons (id, person_name, birth_date,email)
SELECT
id, first_name, NULL, 'Unknown'
FROM customers

SELECT *
FROM persons

/*Change the score of customers id 6 to 0 in the customers table using UPDATE clause of DML*/
UPDATE customers
SET score = 0
WHERE id = 6


/* Change the score of cusotmer with id 7 from 100 to 10 and change the country from NULL to Russia */
UPDATE customers
SET score = 10,
    country = 'Russia'
WHERE id = 7;


SELECT *
FROM [dbo].[customers]

/* We can use TRUNCATE instead of DELETE for large datasets */