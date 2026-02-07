USE [SalesDB]

-- Combine the data of employee and customer tables into a single table using the UNION operator
SELECT
FirstName,
LastName
FROM [Sales].[Customers]
UNION
SELECT
FirstName,
LastName
FROM [Sales].[Employees]

-- Combine the data of employee and customer tables into a single table with duplicates using the UNION ALL operator
SELECT
FirstName,
LastName
FROM [Sales].[Customers]
UNION ALL
SELECT
FirstName,
LastName
FROM [Sales].[Employees]

-- Find the employees who are not customers at the same time using the EXCEPT operator
SELECT
FirstName,
LastName
FROM [Sales].[Employees]
EXCEPT
SELECT
FirstName,
LastName
FROM [Sales].[Customers]

-- Find the employees who are also customers at the same time using the INTERSECT operator
SELECT
FirstName,
LastName
FROM [Sales].[Employees]
INTERSECT
SELECT
FirstName,
LastName
FROM [Sales].[Customers]

-- Use case -> Orders are stored in separate tables. Combine all orders into a single table without duplicates using the UNION operator 
SELECT 
       [ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM[Sales].[Orders]
UNION
SELECT
       [ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM[Sales].[OrdersArchive]