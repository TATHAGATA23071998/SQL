USE [SalesDB];

-- Total number of orders for each month
SELECT FORMAT(SO.[OrderDate], 'MMMM') AS OrderMonth,SO.[CustomerID],
CONCAT(SC.[FirstName], ' ', SC.[LastName]) AS Cutomer_Names, 
SC.[Country],
COUNT(SO.[OrderID]) OVER(PARTITION BY FORMAT(SO.[OrderDate], 'MMMM') ORDER BY SO.[CustomerID] DESC) AS Number_of_Orders
INTO [Sales].[CTAS_TABLE_1]
FROM [Sales].[Orders] AS SO
LEFT JOIN [Sales].[Customers] AS SC
ON SO.CustomerID = SC.CustomerID;

SELECT * FROM [Sales].[CTAS_TABLE_1];
