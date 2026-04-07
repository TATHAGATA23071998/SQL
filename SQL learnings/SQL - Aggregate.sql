USE [SalesDB]

-- Find the total sales of all orders
SELECT 
count(*) AS TotalOrders
From [Sales].[Orders]

-- Find the total and average sales of all orders
SELECT
COUNT(*) AS TotalOrders,
SUM(sales) AS TotalSales,
AVG(sales) AS AverageSales
FROM [Sales].[Orders]

-- Find the highest and lowest sales of all orders
SELECT
[CustomerID],
COUNT(*) AS TotalOrders,
MAX(sales) AS HighestSales,
MIN(sales) AS LowestSales
FROM [Sales].[Orders]
GROUP BY [CustomerID]

-- Analyze the scores in customer table
SELECT
COUNT(*) AS TotalCustomers,
AVG(Score) AS AverageScore,
MAX(Score) AS HighestScore,
MIN(Score) AS LowestScore
FROM [Sales].[Customers]
