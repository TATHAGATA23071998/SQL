USE [MyDatabase]

/* NO JOIN - Retrieve all the data of customers and orders in two separate tables */
SELECT *
From customers;

Select *
From orders;

/* INNER JOIN - Get all customers along with their orders, but only for customers who have placed an order */
Select 
O.customer_id,
O.order_id,
O.order_date,
C.first_name,
C.country,
O.sales
FROM customers AS C
INNER JOIN ORDERS AS O
ON C.id = O.customer_id;

/* LEFT JOIN - Get all customers along with orders including those without orders*/
SELECT
O.customer_id,
O.order_id,
O.order_date,
C.first_name,
C.country,
O.sales
FROM customers AS C --main table
LEFT JOIN orders AS O
ON C.id = O.customer_id;

/* RIGHT JOIN - Get all customers with orders including customers without matching orders */
SELECT
O.customer_id,
O.order_id,
O.order_date,
C.first_name,
C.country,
O.sales
FROM customers AS C 
RIGHT JOIN orders AS O --main table
ON C.id = O.customer_id;

SELECT
    O.customer_id,
    C.first_name,
    O.order_id,
    O.order_date,
    C.country,
    O.sales
FROM  orders O
LEFT JOIN customers C
    ON C.id = O.customer_id;

/* Get all customers and orders even if there's no match */
SELECT
  C.id,
  C.first_name,
  O.order_id,
  O.sales
FROM  customers as C
FULL JOIN orders as O
    ON C.id = O.customer_id;