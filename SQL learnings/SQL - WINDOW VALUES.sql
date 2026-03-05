USE [SalesDB]

-- Analyze the Month on Month (MOM) performance by finding the percentage change in sales between the current and previous months
WITH CTE_LEAD_LAG AS
(
SELECT 
SUM([Sales]) AS TOTAL_SALES,
FORMAT([OrderDate], 'MMMM') AS MONTHS,
LEAD(SUM([Sales])) OVER(ORDER BY FORMAT([OrderDate], 'MMMM')) AS NEXT_MONTH_SALES,
LAG(SUM([Sales])) OVER(ORDER BY FORMAT([OrderDate], 'MMMM')) AS PREVIOUS_MONTH_SALES
FROM [Sales].[Orders]
GROUP BY FORMAT([OrderDate], 'MMMM')
)
SELECT *,
((TOTAL_SALES - PREVIOUS_MONTH_SALES)*100.0)/(PREVIOUS_MONTH_SALES) AS MoM_Change,
ROUND(CAST(((TOTAL_SALES - PREVIOUS_MONTH_SALES)*100.0)/(PREVIOUS_MONTH_SALES) AS float),2) AS MoM_Change_PERC
FROM CTE_LEAD_LAG;


-- Find the highest and lowest sales for each product
WITH CTE_HIGH_LOW AS
(
SELECT [ProductID], [OrderDate], FORMAT([OrderDate], 'dddd-MMMM') AS FORMATTED_DAY_MONTHS, [Sales],
FIRST_VALUE([Sales]) OVER(PARTITION BY [ProductID] ORDER BY [Sales]) AS FIRST_SALES,
LAST_VALUE([Sales]) OVER(PARTITION BY [ProductID] ORDER BY [Sales] ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LAST_SALES,
MAX([Sales]) OVER(PARTITION BY [ProductID]) - [Sales] AS Deviation_Maximum,
[Sales] - MIN([Sales]) OVER(PARTITION BY [ProductID]) AS Deviation_Minimum
FROM [Sales].[Orders]
)
SELECT *
FROM CTE_HIGH_LOW;

-- Rank customers on the basis of the average days between the orders (Customer Loyalty)
WITH CTE_LOYAL AS
(
SELECT [CustomerID],
LEAD([OrderDate],1,NULL) OVER (PARTITION BY [CustomerID] ORDER BY [OrderDate]) AS LEAD_DAY,
DATEDIFF(DAY, [OrderDate], LEAD([OrderDate],1,NULL) OVER (PARTITION BY [CustomerID] ORDER BY [OrderDate])) AS DAYS_UNTIL_NEXT_ORDER
FROM [Sales].[Orders]
)
SELECT [CustomerID],
AVG(DAYS_UNTIL_NEXT_ORDER) AS Average_Days,
DENSE_RANK() OVER (ORDER BY AVG(DAYS_UNTIL_NEXT_ORDER)) AS ranking
FROM CTE_LOYAL
GROUP BY [CustomerID]
HAVING AVG(DAYS_UNTIL_NEXT_ORDER) IS NOT NULL
