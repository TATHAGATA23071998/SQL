USE [SalesDB];

-- 1. Find the total sales per customers
WITH CTE_PRAC AS
(
SELECT SO.[CustomerID],
SUM(SO.[Sales]) AS Total_Sales
FROM [Sales].[Orders] AS SO
GROUP BY SO.[CustomerID]
)
SELECT SC.[FirstName],
       ISNULL(SC.[LastName],'NA') AS LastName,
       SC.[Country],
       COALESCE(CP.Total_Sales,0) AS Total_Sales
FROM [Sales].[Customers] AS SC 
LEFT JOIN CTE_PRAC AS CP
ON CP.[CustomerID] = SC.[CustomerID]
ORDER BY Total_Sales DESC;

-- Multiple CTEs
-- 1. Find the total sales per customers
-- 2. Find the last order date for each customer
WITH CTE_STAND_1 AS
(
    SELECT SO.[CustomerID],
    SUM(SO.[Sales]) AS TOTAL_SALES
    FROM [Sales].[Orders] AS SO
    GROUP BY SO.[CustomerID]
),
CTE_STAND_2 AS 
(
    SELECT SO.[CustomerID],
    MAX(FORMAT(SO.[OrderDate], 'dd-MM-yyyy')) AS Latest_Order_Date
    FROM [Sales].[Orders] AS SO
    GROUP BY SO.[CustomerID]
)
SELECT * 
FROM CTE_STAND_1 AS CTS1
LEFT JOIN CTE_STAND_2 AS CTS2
ON CTS1.[CustomerID] = CTS2.[CustomerID]
ORDER BY CTS1.TOTAL_SALES DESC;

-- Nested CTEs
-- 1. Find the total sales per customers
-- 2. Find the last order date for each customer
-- 3. Rank customers based on Total Sales per Customer
-- 4. Segment customers based on their total sales
WITH CTE_STAND_1 AS
(
 SELECT SO.CustomerID,
        ISNULL(SUM(SO.Sales),0) AS Total_Sales,
        SC.FirstName,
        COALESCE(SC.LastName,'NA') AS LastName,
        SC.Country
    FROM Sales.Orders AS SO
    LEFT JOIN Sales.Customers AS SC
    ON SC.CustomerID = SO.CustomerID
    GROUP BY SO.CustomerID, SC.FirstName, SC.LastName, SC.Country
),
CTE_STAND_2 AS 
(
    SELECT SO.[CustomerID],
    MAX(FORMAT(SO.[OrderDate], 'dd-MM-yyyy')) AS Latest_Order_Date
    FROM [Sales].[Orders] AS SO
    GROUP BY SO.[CustomerID]
),
CTE_NEST_3 AS
(
    SELECT [CustomerID],TOTAL_SALES,
    DENSE_RANK() OVER (ORDER BY TOTAL_SALES DESC) AS Ranked_Total_Sales
    FROM CTE_STAND_1
),
CTE_NEST_4 AS
(
    SELECT [CustomerID], TOTAL_SALES, FirstName, LastName, Country,
    CASE 
    WHEN TOTAL_SALES > 100 THEN 'HIGH'
    WHEN TOTAL_SALES <= 100 AND TOTAL_SALES > 55 THEN 'MEDIUM'
    WHEN TOTAL_SALES <= 55 THEN 'LOW'
    END AS CUSTOMER_SEGMENTATION
    FROM CTE_STAND_1
)
SELECT * 
FROM CTE_NEST_4 AS CTN4
LEFT JOIN CTE_STAND_2 AS CTS2
ON CTN4.[CustomerID] = CTS2.[CustomerID]
ORDER BY TOTAL_SALES DESC;

-- RECURSIVE CTEs
--- Generate sequence of numbers from 1 to 20
WITH CTE_SEQ AS
(
    SELECT 1 AS My_Number

    UNION ALL

    SELECT My_Number +1
    FROM CTE_SEQ
    WHERE My_Number < 20
)
SELECT *
FROM CTE_SEQ
OPTION (MAXRECURSION 20)



