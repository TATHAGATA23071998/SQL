USE [SalesDB];

SELECT * 
INTO [Sales].[New_Customers]
FROM [Sales].[Customers];

--Create a clustered index on the New_Customers table
CREATE CLUSTERED INDEX CLIX_New_Customers_CustomerID ON [Sales].[New_Customers] ([CustomerID]);

--Create multiple non - clustered indexes on the New_Customers table
CREATE NONCLUSTERED INDEX NCLIX_New_Customers_FirstName ON [Sales].[New_Customers] ([FirstName]);
CREATE NONCLUSTERED INDEX NCLIX_New_Customers_LasttName ON [Sales].[New_Customers] ([LastName]);

-- Composite Index
CREATE NONCLUSTERED INDEX CNCLIX_New_Customers_Country_Score ON [Sales].[New_Customers] ([Country], [Score] DESC);

SELECT * FROM [Sales].[New_Customers]
WHERE Country = 'USA' AND Score > 80

-- Clustered Columnstore Index
CREATE CLUSTERED COLUMNSTORE INDEX CCIX_New_Customers ON [Sales].[New_Customers];

USE [AdventureWorks2025]
--- We create 3 copies of the same table to understadn the performance of heap, columnstore and rowstore indexes in terms of storage space
-- Heap table
SELECT * 
INTO [Production].[TransactionHistoryHP]
FROM [Production].[TransactionHistory]

-- rowstore index
SELECT * 
INTO [Production].[TransactionHistory_Rowstore]
FROM [Production].[TransactionHistory]

CREATE CLUSTERED INDEX CLRIX_TransactionHistory_Rowstore ON [Production].[TransactionHistory_Rowstore] ([TransactionID],[ProductID]);

-- columnstore index
SELECT * 
INTO [Production].[TransactionHistory_Colstore]
FROM [Production].[TransactionHistory]

CREATE CLUSTERED COLUMNSTORE INDEX CLCIX_TransactionHistory_Colstore ON [Production].[TransactionHistory_Colstore];

--- Unique Index
CREATE UNIQUE NONCLUSTERED INDEX UNCLIX_Sales_Customer_ID ON [Sales].[Customer] ([CustomerID]);

SELECT * FROM [Sales].[Customer]

-- Filtered Index
SELECT * FROM [Person].[CountryRegion]
ORDER BY [CountryRegionCode] DESC;

CREATE UNIQUE NONCLUSTERED  INDEX NCLUIX_Person_CountryRegion ON [Person].[CountryRegion] ([CountryRegionCode])
WHERE [CountryRegionCode] = 'Russia';