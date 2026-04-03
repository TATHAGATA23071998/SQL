
USE [SalesDB];

sp_helpindex '[Sales].[Customers]';

DROP PROCEDURE [dbo].[Practice];

-- 1. Find the total number of American cusotmers and their average scores
CREATE Procedure Summary_Report AS
BEGIN

SELECT 
		[CustomerID],
		COUNT(*) OVER () AS Total_Customers,
		CONCAT([FirstName], ' ', [LastName]) AS Customer_Names,
		[Country],
		CAST(COALESCE (AVG([Score]) OVER (PARTITION BY [CustomerID]),0) AS float) AS Score
FROM [Sales].[Customers]
WHERE Country = 'USA'

END

EXEC Summary_Report

-- 2. Find the total number of German cusotmers and their average scores using parameters

CREATE PROCEDURE [dbo].[Parameterized_Process] @Country NVARCHAR(30) = 'USA' AS

BEGIN

SELECT 
		[CustomerID],
		COUNT(*) OVER () AS Total_Customers,
		CONCAT([FirstName], ' ', [LastName]) AS Customer_Names,
		[Country],
		CAST(COALESCE (AVG([Score]) OVER (PARTITION BY [CustomerID]),0) AS float) AS Score
FROM [Sales].[Customers]
WHERE Country = @Country

END

EXEC [dbo].[Parameterized_Process] @Country = 'Germany' ;
EXEC [dbo].[Parameterized_Process];

-- Multiple queries -> Find the total number of orders and total sales
CREATE PROCEDURE New_set  @SalesPersonID INT = 1 AS

BEGIN

SELECT [CustomerID], [SalesPersonID], [OrderID], [Sales],[ProductID],
COUNT(*) OVER (PARTITION BY [ProductID]) AS Total_Orders,
SUM([Sales]) OVER (PARTITION BY [ProductID]) AS Total_Sales
FROM [Sales].[Orders]
WHERE [SalesPersonID] = @SalesPersonID;

SELECT 
		[CustomerID],
		COUNT(*) OVER () AS Total_Customers,
		CONCAT([FirstName], ' ', [LastName]) AS Customer_Names,
		[Country],
		CAST(COALESCE (AVG([Score]) OVER (PARTITION BY [CustomerID]),0) AS float) AS Score
FROM [Sales].[Customers]
WHERE Country = 'USA'

END

EXEC New_set @SalesPersonID= 3;
EXEC New_set;

-- Parameters with variables
-- We want to view the result in messages like number of customers
ALTER PROCEDURE Variaparameters @SalesPersonID INT = 1, @Country VARCHAR(50) = 'Germany'

AS

BEGIN 

DECLARE @Total_Orders INT, @Total_Sales Float -- declare the variables

SELECT
@Total_Orders = COUNT(*), -- once we use variables we cannot use aliases. Also we can only use scalar values for a single variable
@Total_Sales = SUM([Sales])
FROM [Sales].[Orders]
WHERE [SalesPersonID] = @SalesPersonID;

PRINT ('Total_Sales is' + ':' + CAST(@Total_Sales AS VARCHAR(50))); -- converting all to texts for viewing in messages
PRINT ('Total_Orders are' + ':' + CAST(@Total_Orders AS VARCHAR(50)));

SELECT 
		[CustomerID],
		COUNT(*) OVER () AS Total_Customers,
		CONCAT([FirstName], ' ', [LastName]) AS Customer_Names,
		[Country],
		CAST(COALESCE (AVG([Score]) OVER (PARTITION BY [CustomerID]),0) AS float) AS Score
FROM [Sales].[Customers]
WHERE Country = @Country

END

EXEC Variaparameters @SalesPersonID = 3, @Country = 'USA';
EXEC Variaparameters;

--If else logic
ALTER PROCEDURE Variaparameters @SalesPersonID INT = 1, @Country VARCHAR(50) = 'Germany'

AS

BEGIN 

DECLARE @Total_Orders INT, @Total_Sales Float -- declare the variables

--- if else logic
IF EXISTS ( SELECT 1 FROM [Sales].[Customers] WHERE [Score] IS NULL AND [Country] = @Country)
BEGIN
	 PRINT('UPDATING THE NULL SCORES TO 0')
	 UPDATE [Sales].[Customers]
	 SET [Score] = 0
	 WHERE Score IS NULL AND Country = @Country
END

ELSE
BEGIN
	PRINT ('NO NULL SCORES FOUND')
END

SELECT
@Total_Orders = COUNT(*), -- once we use variables we cannot use aliases. Also we can only use scalar values for a single variable
@Total_Sales = SUM([Sales])
FROM [Sales].[Orders]
WHERE [SalesPersonID] = @SalesPersonID;

PRINT ('Total_Sales is' + ':' + CAST(@Total_Sales AS VARCHAR(50))); -- converting all to texts for viewing in messages
PRINT ('Total_Orders are' + ':' + CAST(@Total_Orders AS VARCHAR(50)));

SELECT 
		[CustomerID],
		COUNT(*) OVER () AS Total_Customers,
		CONCAT([FirstName], ' ', [LastName]) AS Customer_Names,
		[Country],
		CAST(COALESCE (AVG([Score]) OVER (PARTITION BY [CustomerID]),0) AS float) AS Score
FROM [Sales].[Customers]
WHERE Country = @Country

END

EXEC Variaparameters @SalesPersonID = 3, @Country = 'USA';
EXEC Variaparameters;


-- ERROR HANDLING (TRY CATCH BLOCK)
ALTER PROCEDURE Variaparameters @SalesPersonID INT = 1, @Country VARCHAR(50) = 'Germany'

AS

BEGIN 
BEGIN TRY
DECLARE @Total_Orders INT, @Total_Sales Float -- declare the variables

--- if else logic
IF EXISTS ( SELECT 1 FROM [Sales].[Customers] WHERE [Score] IS NULL AND [Country] = @Country)
BEGIN
	 PRINT('UPDATING THE NULL SCORES TO 0')
	 UPDATE [Sales].[Customers]
	 SET [Score] = 0
	 WHERE Score IS NULL AND Country = @Country
END

ELSE
BEGIN
	PRINT ('NO NULL SCORES FOUND')
END

SELECT
@Total_Orders = COUNT(*), -- once we use variables we cannot use aliases. Also we can only use scalar values for a single variable
@Total_Sales = SUM([Sales])
FROM [Sales].[Orders]
WHERE [SalesPersonID] = @SalesPersonID;

PRINT ('Total_Sales is' + ':' + CAST(@Total_Sales AS VARCHAR(50))); -- converting all to texts for viewing in messages
PRINT ('Total_Orders are' + ':' + CAST(@Total_Orders AS VARCHAR(50)));

SELECT 
		[CustomerID],
		COUNT(*) OVER () AS Total_Customers,
		CONCAT([FirstName], ' ', [LastName]) AS Customer_Names,
		[Country],
		1/0,
		CAST(COALESCE (AVG([Score]) OVER (PARTITION BY [CustomerID]),0) AS float) AS Score
FROM [Sales].[Customers]
WHERE Country = @Country

END TRY
BEGIN CATCH
		PRINT ('An error occured');
		PRINT ('Error_Message' + ERROR_MESSAGE());
		PRINT ('Error_Number' + CAST(ERROR_NUMBER() AS NVARCHAR(50)));
	    PRINT ('Error_Line' + CAST(ERROR_LINE() AS NVARCHAR(50)));
		PRINT ('Error_Procedure' + ERROR_PROCEDURE());
END CATCH
END

EXEC Variaparameters @SalesPersonID = 3, @Country = 'USA';
EXEC Variaparameters;