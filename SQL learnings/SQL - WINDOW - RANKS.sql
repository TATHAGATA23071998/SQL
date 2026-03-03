USE [SalesDB]

-- Rank the orders based on the sales from highest to lowest
WITH CTE_RANK AS
(
SELECT[OrderID], [ProductID], [OrderDate],[Sales],
FORMAT([OrderDate], 'dddd-MMMM-yyyy') AS Formatted_OrderDate,
ROW_NUMBER() OVER(PARTITION BY [ProductID] ORDER BY [Sales] DESC) AS SalesRank,
RANK () OVER(PARTITION BY [ProductID] ORDER BY [Sales] DESC) AS SalesRankWithTies,
DENSE_RANK() OVER(PARTITION BY [ProductID] ORDER BY [Sales] DESC) AS SalesDenseRank
FROM [Sales].[Orders]
)
SELECT * 
FROM CTE_RANK
--ORDER BY Sales DESC;
--WHERE SalesRank > 1;


-- Find the top highest sales for each product
WITH CTE_RANK AS	
(
SELECT [OrderID], [ProductID], [OrderDate], [Sales],
ROW_NUMBER() OVER(PARTITION BY [ProductID] ORDER BY [Sales] DESC) AS SalesRank
FROM [Sales].[Orders]
)
SELECT *
--DELETE
FROM CTE_RANK
WHERE SalesRank = 1

-- Find the lowest two customers based on the total sales
WITH CTE_LOWER_RANK AS
(
SELECT [CustomerID],
ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY SUM([Sales]) ASC) AS CustomerSalesRank
FROM [Sales].[Orders]
GROUP BY [CustomerID]
)
SELECT * 
FROM CTE_LOWER_RANK
WHERE CustomerSalesRank <= 2

-- Assign Unique IDs to the rows of 'Orders.Archieve' Table
WITH CTE_UNIQUE_ID AS
(
SELECT [OrderID], [ProductID],
ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY [OrderID]) AS UniqueIDS
FROM [Sales].[OrdersArchive]
)
SELECT *
FROM CTE_UNIQUE_ID;

-- Find out the duplicates in 'Orders.Archieve' Table
WITH CTE_DUPLICATES AS
(
SELECT [OrderID], [ProductID], [CustomerID],[CreationTime] ,
ROW_NUMBER() OVER(PARTITION BY [OrderID] ORDER BY [CreationTime]) AS DUPLICATED_RANK,
COUNT(*) OVER(PARTITION BY [OrderID] ORDER BY [CreationTime]) AS COUNT_DUPLICATED_RANK
FROM [Sales].[OrdersArchive]
)
SELECT *,
FORMAT(CAST([CreationTime] AS DATE), 'dd-MM-yyyy') AS Formatted_CreationTime
FROM CTE_DUPLICATES
-- DELETE FROM CTE_DUPLICATES
WHERE DUPLICATED_RANK > 1;

-- NTILE(n)
SELECT[ProductID], [CustomerID], [SalesPersonID],
NTILE(3) OVER(ORDER BY [CreationTime]) AS BUCKET
FROM [Sales].[Orders]

-- Segment all orders in to three categories based on their sales: 'High', 'Medium' and 'Low' using NTILE function
WITH CTE_NTILE AS
(
SELECT [OrderID], [ProductID],[SalesPersonID], [Sales],
NTILE (3) OVER (ORDER BY [Sales] DESC) AS SALES_SEGMENT
FROM [Sales].[Orders]
)
SELECT *,
CASE
	WHEN SALES_SEGMENT = 1 THEN 'HIGH'
	WHEN SALES_SEGMENT = 2 THEN 'MEDIUM'
    ELSE 'LOW'
END AS SALES_CATEGORY
FROM CTE_NTILE;


-- PERCENT BASED RANKINGS
-- Find the products taht fall within 40% of prices
WITH CTE_PERCENT_RANK AS
(
SELECT [ProductID],[Category],[Product],[Price],
CUME_DIST() OVER(ORDER BY [Price] DESC) AS Data_Distribution,
PERCENT_RANK() OVER (ORDER BY [Price] DESC) AS Data_Position
FROM [Sales].[Products]
)
SELECT *,
CONCAT(Data_Distribution * 100, ' ', '%') As NEW_DISTRIBUTION,
CONCAT(Data_Position * 100, ' ', '%') As NEW_POSITION
FROM CTE_PERCENT_RANK
WHERE Data_Distribution  <= 0.4 AND Data_Position < = 0.4;


