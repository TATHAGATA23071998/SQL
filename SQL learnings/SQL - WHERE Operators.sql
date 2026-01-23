/* Comparison Operators */
-- Select all cusotmers from USA
USE [MyDatabase]
Select *
From customers
WHERE country = 'USA'

-- Select all cusotmerswho are not from USA
USE [MyDatabase]
Select *
From customers
WHERE country != 'USA'

-- Select all cusotmers who scored geater than 500
USE [MyDatabase]
Select *
From customers
WHERE score > 500

-- Select all cusotmers who scored 500 or more
USE [MyDatabase]
Select *
From customers
WHERE score >= 500

-- Select all cusotmers who scored less than 500
USE [MyDatabase]
Select *
From customers
WHERE score < 500

-- Select all cusotmers who scored 500 or less
USE [MyDatabase]
Select *
From customers
WHERE score <= 500

/* Logical Operators */
-- Retrieve all cusotmers having a score of 500 or more and belonging to USA [In AND, both the conditions need to be true]
Select *
From customers
WHERE score > 500 AND country = 'USA'

-- Retrieve all cusotmers having a score of 500 or belonging to USA [In OR, only one of the conditions need to be true]
Select *
From customers
WHERE score > 500 OR country = 'USA'

-- Retrieve all cusotmers whose score is not less than 500
Select *
From customers
Where NOT score <500

/* Range operators*/
-- Retrieve all customers whose score falls between 100 and 500
Select *
from customers
Where score BETWEEN 100 and 500

/* Membership Operator */
-- Retrieve all customers from either Germany or USA
Select *
From customers
Where country IN ('USA', 'Germany')

-- Retrieve all customers not from either Germany or USA
Select *
From customers
Where country NOT IN ('USA', 'Germany')


/* Search Operator - LIKE operator */
--Find all customers whose name starts with 'm'
Select * 
From customers
Where first_name LIKE 'M%'

--Find all customers whose name ends with 'n'
Select *
From customers
Where first_name LIKE '%n'

--Find all customers whose name has'r'
Select *
From customers
Where first_name LIKE '%r%'

--Find all customers whose name has 'r' exactly in the thrid position
Select *
From customers
Where first_name LIKE '__r%'
