USE [SalesDB]

--Find the total number of distinct or unique orders
SELECT COUNT (DISTINCT [ProductID])AS TotalOrders
FROM [Sales].[Orders];

--Find the total number of orders
SELECT COUNT (*)AS TotalOrders
FROM [Sales].[Orders];

-- Find the total number of orders and provide details like order Id, order date with CTE for WHERE clause
WITH CTE_ORDERS AS
(
    SELECT [CustomerID], [ProductID], [OrderID], [OrderDate],
    COUNT (*) OVER (PARTITION BY [CustomerID]) AS TotalOrders
    FROM [Sales].[Orders]
)
SELECT * FROM CTE_ORDERS
WHERE TotalOrders > 0;

-- Find the total number of orders and provide details like order Id, order date without CTE
SELECT [OrderID], [ProductID], [OrderDate], [CustomerID],
COUNT (*) OVER (PARTITION BY [CustomerID]) AS TotalOrders
FROM [Sales].[Orders]

-- Find the total number of scores for customers
SELECT *,
COUNT(*) OVER () AS TotalScores1,
COUNT (Score) OVER () AS TotalScores2 -- ignores the NULLs
FROM [Sales].[Customers]

-- Check whether the table 'orders' has any duplicates
SELECT OrderID,
    COUNT(*) OVER (PARTITION BY OrderID) AS TotalOrders
    FROM [Sales].[Orders];

WITH CTE_Orders_Archieve AS
(
    SELECT
    [OrderID],[CustomerID],
    COUNT(*) OVER(PARTITION BY OrderID) AS TotalOrdersArchieve
    FROM [Sales].[OrdersArchive]
)
SELECT * FROM CTE_Orders_Archieve
WHERE TotalOrdersArchieve > 1; -- Here, we use CTE as where clause cannot be used with window functions

-- Delete duplicates from a table with CTE
WITH CTE_Orders_Archive AS
(
    SELECT
        [CustomerID],
        [OrderID],
        ROW_NUMBER() OVER(PARTITION BY [OrderID] ORDER BY ([ProductID])) AS RowNum
    FROM [Sales].[OrdersArchive]
)
SELECT* FROM CTE_Orders_Archive
--DELETE FROM CTE_Orders_Archive
WHERE RowNum > 1;

-- SUM
-- Find the total sales across all product and the total sales for each product. Porvide details like OrderId and OrderDate
WITH CTE_SALES AS
(
SELECT [OrderID], [ProductID], [OrderDate],
    SUM(Sales) OVER() AS TotalSales,
    SUM(Sales) OVER (PARTITION BY [ProductID]) AS TotalSalesByProduct
FROM [Sales].[Orders]
)
SELECT * FROM CTE_SALES
WHERE TotalSales > 50;

-- Find the percentage contribution of each product's sales to the total sales
WITH CTE_TOTAL_SALES AS
(
SELECT [OrderID], [ProductID], [OrderDate], [Sales],
    SUM([Sales]) OVER() AS OverallSales,
    Cast(Sales *100.0/ SUM(Sales) OVER () AS DECIMAL(6,2)) AS PercentageContribution
FROM [Sales].[Orders] 
)
SELECT * FROM CTE_TOTAL_SALES
WHERE PercentageContribution > 5 -- Here, we use CTE as where clause cannot be used with window functions
ORDER BY PercentageContribution DESC;

-- AVERAGE
-- Find the average sales across all product and the average sales for each product. Porvide details like OrderId and OrderDate
WITH CTE_AVG_SALES AS
(
SELECT [OrderID], [ProductID], [OrderDate],[Sales],
FORMAT([OrderDate], 'dd-MM-yyyy') AS formatted_date,
AVG(Sales) OVER() AS OverallAVG,
AVG(Sales) OVER (PARTITION BY [ProductID]) AS AVGByProduct
FROM [Sales].[Orders]
)
SELECT * FROM CTE_AVG_SALES
WHERE AVGByProduct > 0
ORDER BY [OrderID];

-- Find all orders where sales are higher than the average sales for that product across all orders
WITH CTE_AVG_SALES AS
(
SELECT [OrderID], [ProductID], [OrderDate],[Sales],
AVG(Sales) OVER() AS OverallAVG,
AVG(Sales) OVER (PARTITION BY [ProductID]) AS AVGByProduct
FROM [Sales].[Orders]
)
SELECT * FROM CTE_AVG_SALES
WHERE [Sales] > AVGByProduct
ORDER BY [OrderID];

-- Find the highest and lowest sales for all orders and across each product. Porvide details like OrderId and OrderDate.
WITH CTE_SALES AS
(
SELECT [OrderID], [ProductID], [OrderDate],[Sales],
MAX([Sales]) OVER() AS MaxSales,
MIN([Sales]) OVER() AS MinSales,
MAX([Sales]) OVER (PARTITION BY [ProductID]) AS MaxSalesByProduct,
MIN([Sales]) OVER (PARTITION BY [ProductID]) AS MinSalesByProduct
FROM [Sales].[Orders]
)
SELECT * FROM CTE_SALES

-- Find the employess who have the highest salaries
WITH CTE_SALARY AS
(
SELECT [EmployeeID],[FirstName],[Department],[Gender],[ManagerID],[Salary],
MAX([Salary]) OVER() AS MAXSalary,
FORMAT([BirthDate], 'dd-MM-yyyy') AS formatted_BIRTH_date
FROM[Sales].[Employees]
)
SELECT *,
COALESCE([ManagerID],0) AS ManagerID_Coalesced
FROM CTE_SALARY
WHERE Salary = MAXSalary

-- Calculate the deviation of each sales from maximum and minimum sales amounts.
WITH CTE_DEV AS
(
SELECT [EmployeeID], [FirstName], [Department], [BirthDate], [Salary],
    MAX([Salary]) OVER() AS SALARY_MAX,
    MIN([Salary]) OVER() AS SALARY_MIN,
    MAX([Salary]) OVER() - [Salary] AS DeviationFromMax,
    [Salary] - MIN([Salary])OVER()  AS DeviationFromMin
FROM [Sales].[Employees]
)
SELECT * FROM CTE_DEV
--WHERE DeviationFromMax > 0 AND DeviationFromMin > 0
ORDER BY [EmployeeID] ASC;


-- Calculate the moving average of sales for each product over time.
WITH CTE_MOVING_AVG AS
(
SELECT [OrderID],[ProductID],[OrderDate],[Sales],
FORMAT([OrderDate], 'MMMM') AS formatted_date,
AVG([Sales]) OVER(PARTITION BY [ProductID] ORDER BY [OrderDate]) AS TotalAvgSales,
AVG([Sales]) OVER(PARTITION BY [ProductID] ORDER BY [OrderDate] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvgSales
FROM [Sales].[Orders]
)
SELECT * FROM CTE_MOVING_AVG
WHERE MovingAvgSales > 0
ORDER BY MovingAvgSales DESC;

