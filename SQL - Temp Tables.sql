USE [SalesDB];

WITH CTE_PRACTICE AS
(
SELECT SO.[OrderID],
	   SO.[ProductID],
	   SO.[SalesPersonID],
	   SO.[Sales],
	   ISNULL(NULLIF([BillAddress], ' '),SO.[ShipAddress]) AS BillAddress,
	   CONCAT(SC.[FirstName], ' ', SC.[LastName]) AS Customer_Name,
	   SC.[Country] AS Cust_Country,
	   FORMAT(SO.[OrderDate], 'dd/MM/yyyy') AS OrderDate,
	   SUM(SO.[Sales]) OVER (PARTITION BY SO.[ProductID]) AS TOTAL_SALES,
	   ROUND(CAST(SO.Sales * 100.0/ SUM(SO.[Sales]) OVER (PARTITION BY SO.[ProductID]) AS float),2) AS CONTRIBUTION
FROM [Sales].[Orders] AS SO
LEFT JOIN [Sales].[Customers] AS SC
ON SC.CustomerID = SO.CustomerID

UNION

SELECT SOA.[OrderID],
	   SOA.[ProductID],
	   SOA.[SalesPersonID],
	   SOA.[Sales],
	   ISNULL(NULLIF([BillAddress], ' '),SOA.[ShipAddress]) AS BillAddress,
	   CONCAT(SC.[FirstName], ' ', SC.[LastName]) AS Customer_Name,
	   SC.[Country] AS Cust_Country,
	   FORMAT(SOA.[OrderDate], 'dd/MM/yyyy') AS OrderDate,
	   SUM(SOA.[Sales]) OVER (PARTITION BY SOA.[ProductID]) AS TOTAL_SALES,
	   ROUND(CAST(SOA.Sales * 100.0/ SUM(SOA.[Sales]) OVER (PARTITION BY SOA.[ProductID]) AS float),2) AS CONTRIBUTION
FROM [Sales].[OrdersArchive] AS SOA
LEFT JOIN [Sales].[Customers] AS SC
ON SC.CustomerID = SOA.CustomerID
),
CTE_SEGMENTS AS
(
SELECT *,
NTILE(3) OVER (ORDER BY CTP.TOTAL_SALES DESC) AS Segments
FROM CTE_PRACTICE AS CTP
)
SELECT *,
CASE
WHEN CTS.Segments = 1 THEN 'HIGH'
WHEN CTS.Segments = 2 THEN 'MEDIUM'
WHEN CTS.Segments = 3 THEN 'LOW'
END AS GROUPINGS
INTO #TEMP_TABLE
FROM CTE_SEGMENTS AS CTS;

SELECT * 
FROM #TEMP_TABLE;

/*SELECT TT.ProductID,
SUM(TT.TOTAL_SALES) AS Summations
FROM #TEMP_TABLE AS TT
GROUP BY TT.ProductID
ORDER BY Summations DESC;*/