USE [SalesDB]

-- Scalar Query
SELECT SUM([Sales]) AS TOTAL_SALES
FROM [Sales].[Orders]

-- Row Query
SELECT [ProductID],
AVG([Sales]) AS AVERAGE_SALES
FROM [Sales].[Orders]
GROUP BY [ProductID]
ORDER BY AVG([Sales]) DESC;

-- Table Query
SELECT *
FROM [Sales].[Orders]

--- FROM Subquery
-- Find the products that have a price higher than the average of all products 
SELECT *
FROM 
(
	SELECT [ProductID],[Product], [Price],
	AVG([Price]) OVER () AS Average_Price
	FROM [Sales].[Products]
) t
WHERE [Price] > Average_Price;

-- Rank customers based in the total amount of sales
SELECT *,
DENSE_RANK() OVER (ORDER BY Total_Sales DESC) AS Ranked_Sales
FROM
(
	SELECT [CustomerID],
	SUM(COALESCE([Sales], 0)) AS Total_Sales
	FROM [Sales].[Orders]
	GROUP BY [CustomerID]
) t;

--- SELECT Subquery
-- Show the product IDs, product names, prices and total number of orders
SELECT [ProductID], [Product], [Price],
(
	SELECT COUNT([OrderID]) AS TOTAL_ORDERS
	FROM [Sales].[Orders]
)   AS TOTAL_NO_ORDERS
FROM [Sales].[Products];

--- JOIN Subquery
-- Show all customer details and find the total orders for each customers
SELECT SC.[CustomerID],
       SC.[FirstName],
       SC.[Country],
       COALESCE(SC.[Score],0) AS SCORE,
       COALESCE(SO.[Total_Orders],0) AS Total_Orders
FROM [Sales].[Customers] AS SC
LEFT JOIN
(
    SELECT SO.[CustomerID],
    COUNT(SO.[OrderID]) AS Total_Orders
    FROM [Sales].[Orders] AS SO
    GROUP BY [CustomerID]
) AS SO
ON SC.[CustomerID] = SO.[CustomerID];

--- WHERE Subqueries
-- Find the produts that have a price higher than the average price of all products (Can also be done with CTEs)
SELECT [ProductID], [Product], [Price],
(
	SELECT AVG([Price]) 
	FROM [Sales].[Products]
) AS averaged_price
FROM [Sales].[Products]
WHERE [Price] > 
(
	SELECT AVG([Price]) AS AVERAGE_PRICE 
	FROM [Sales].[Products]
) -- here we can't use group by as it only allows scalar subqueries


-- Show the details of orders made by customers in Germany (WHERE with IN operator)
SELECT * FROM [Sales].[Orders];
SELECT * FROM [Sales].[Customers];


SELECT [OrderID],[CustomerID],
(SELECT SUM([Price]) FROM [Sales].[Products]) AS Total_Price
FROM [Sales].[Orders]
WHERE [CustomerID] IN (SELECT [CustomerID] FROM [Sales].[Customers] WHERE [Country] = 'Germany')


-- Find female employees whose salaries are greater than the salaries of any male employees
SELECT [EmployeeID],[FirstName],[Gender],[Salary]
FROM [Sales].[Employees]
WHERE [Gender]='F' AND [Salary] > ANY (SELECT [Salary] FROM [Sales].[Employees] WHERE [Gender] = 'M');

-- CORRELATED SUBQUERIES
--- Show all customer details and find the total orders for each customer
SELECT *,
(
	SELECT COUNT(*) AS TOTAL_ORDERS 
	FROM [Sales].[Orders] AS SO 
	WHERE SO.[CustomerID] = SC.[CustomerID]
) AS TOATAL_ORDERS
FROM [Sales].[Customers] AS SC;


-- Show the details of orders made by customers in Germany (WHERE with EXISTS operator)
SELECT *
FROM [Sales].[Orders] AS SO
WHERE EXISTS
(
	SELECT 1
	FROM [Sales].[Customers] AS SC
	WHERE SO.CustomerID = SC.CustomerID AND SC.Country = 'Germany'
);