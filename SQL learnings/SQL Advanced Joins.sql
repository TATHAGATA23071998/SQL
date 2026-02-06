USE [MyDatabase]

--LEFT ANTI JOIN - Get all customers who haven't placed any orders
SELECT *
FROM customers AS C
LEFT JOIN orders AS o
    ON C.id = O.customer_id
WHERE o.customer_id IS NULL; -- This keeps only the non-matches

-- RIGHT ANTI JOIN - Get all the orders without the customers
SELECT *
FROM customers as C
RIGHT JOIN orders AS o
     ON C.id = o.customer_id
WHERE o.customer_id IS NULL

--LEFT ANTI JOIN - Get all the orders without the customers
SELECT *
FROM orders AS o
LEFT JOIN customers AS C
     ON C.id = o.customer_id
WHERE o.customer_id IS NULL

-- FULL ANTI JOIN - Find all customers without orders and orders withut customers
SELECT *
FROM orders AS o
FULL JOIN customers AS C
ON C.id = o.customer_id
WHERE o.customer_id IS NULL OR C.id IS NULL

-- Get all customers along with their orders, but only for customers who have placed an order
SELECT *
FROM orders AS o
LEFT JOIN customers AS C
     ON C.id = o.customer_id
WHERE o.customer_id IS NOT NULL 

-- Generate all possible combinations of customers and orders
SELECT *
FROM customers AS C
CROSS JOIN orders AS o