USE [SalesDB];

-- Find the running total of sales for each month
WITH CTE_RUNNING AS
(
	SELECT 
	FORMAT([OrderDate], 'MMMM') AS OrderDate,
	SUM([Sales]) AS TOTAL_SALES,
	COUNT([OrderID]) AS No_of_Orders,
	COUNT([CustomerID]) AS No_of_Customers,
	COUNT([ProductID]) AS No_of_Products,
	SUM([Quantity]) AS Total_Quantities
	FROM [Sales].[Orders]
	GROUP BY FORMAT([OrderDate], 'MMMM')
)
SELECT OrderDate,TOTAL_SALES,
SUM(TOTAL_SALES) OVER (PARTITION BY NULL ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS NEW_RUNNING
FROM CTE_RUNNING;

CREATE VIEW Sales.RUNNING_VIEW AS
(
	SELECT 
	FORMAT([OrderDate], 'MMMM') AS OrderDate,
	SUM([Sales]) AS TOTAL_SALES,
	COUNT([OrderID]) AS No_of_Orders,
	COUNT([CustomerID]) AS No_of_Customers,
	COUNT([ProductID]) AS No_of_Products,
	SUM([Quantity]) AS Total_Quantities
	FROM [Sales].[Orders]
	GROUP BY FORMAT([OrderDate], 'MMMM')
);

SELECT OrderDate,TOTAL_SALES,
SUM(TOTAL_SALES) OVER (PARTITION BY NULL ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS NEW_RUNNING
FROM [Sales].[RUNNING_VIEW];


-- Provide a view that combines details from orders, products, customers and employees
CREATE VIEW Sales.SUMMARY AS
(
	SELECT 
	SO.[OrderID],
	SO.[ProductID],
	SO.[CustomerID],
	CONCAT(NULLIF(SC.FirstName, ' ') , ' '  , NULLIF(SC.[LastName], ' ')) AS Customer_Name,
	CONCAT(NULLIF(SE.FirstName, ' ') , ' '  , NULLIF(SE.[LastName], ' ')) AS Employee_Name,
	SE.[Department] AS Employee_Department,
	SE.[Salary],
	SE.[Department] AS EMP_DEPT,
	SE.[Gender],
	SO.[SalesPersonID],
	SP.[Product],
	SP.[Category],
	FORMAT(SO.[OrderDate], 'dd-MM-yyyy') AS OrderDate,
	SO.[Sales]
	FROM [Sales].[Orders] AS SO
	LEFT JOIN [Sales].[Products] AS SP
	ON SP.[ProductID] = SO.[ProductID]
	LEFT JOIN [Sales].[Customers] AS SC
	ON SC.CustomerID = SO.CustomerID
	LEFT JOIN [Sales].[Employees] AS SE
	ON SE.EmployeeID = SO.SalesPersonID
)
SELECT * FROM [Sales].[SUMMARY] -- Final view

-- Create a view for the EU sales team that combines details from all tables and exclude USA
CREATE VIEW DATA_SECURITY AS
(
	SELECT 
		SO.[OrderID],
		SO.[ProductID],
		SO.[CustomerID],
		CONCAT(NULLIF(SC.FirstName, ' ') , ' '  , NULLIF(SC.[LastName], ' ')) AS Customer_Name,
		SC.[Country] AS Customer_Country,
		CONCAT(NULLIF(SE.FirstName, ' ') , ' '  , NULLIF(SE.[LastName], ' ')) AS Employee_Name,
		SE.[Department] AS Employee_Department,
		SE.[Salary],
		SE.[Department] AS EMP_DEPT,
		SE.[Gender],
		SO.[SalesPersonID],
		SP.[Product],
		SP.[Category],
		FORMAT(SO.[OrderDate], 'dd-MM-yyyy') AS OrderDate,
		SO.[Sales]
		FROM [Sales].[Orders] AS SO
		LEFT JOIN [Sales].[Products] AS SP
		ON SP.[ProductID] = SO.[ProductID]
		LEFT JOIN [Sales].[Customers] AS SC
		ON SC.CustomerID = SO.CustomerID
		LEFT JOIN [Sales].[Employees] AS SE
		ON SE.EmployeeID = SO.SalesPersonID
		WHERE SC.Country <> 'USA'
	)
	SELECT * FROM [dbo].[DATA_SECURITY]