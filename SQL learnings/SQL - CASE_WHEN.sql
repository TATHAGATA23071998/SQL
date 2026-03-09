USE [SalesDB]
-- Create a report for each of the following categories:
--High (sales over 50), Medium (sales 21 - 50) , Low (sales 20 or less)
-- Sort the category from highest to lowest
SELECT 
Category, 
SUM(Sales) AS TotalSales
FROM(
    SELECT
    OrderID,
    Sales,
CASE
    WHEN Sales > 50 THEN 'HIGH'
    WHEN Sales > 20 THEN 'MEDIUM'
    ELSE 'LOW'
END Category
From Sales.Orders
) AS SalesCategory
GROUP BY Category
Order BY TotalSales DESC;

-- Retrieve customers with abbreviated country codes.
SELECT
CustomerID,
FirstName,
LastName,
Country,
CASE
    WHEN Country = 'United States' THEN 'US'
    WHEN Country = 'Germany' THEN 'DE'
    ELSE 'OTHERS'
END CountryCode
FROM [Sales].[Customers]

-- Find the average scores of customers and treat NULLS as 0.
-- Additionally provide details such as CusotmerID and LastName.
SELECT
CustomerID,
LastName,
Score,
CASE
    WHEN Score IS NULL THEN 0
    ELSE Score
END AS CleanedScore,
AVG(CASE
    WHEN Score IS NULL THEN 0
    ELSE Score
END) OVER() AverageCleanedScore,
AVG(Score) OVER() AverageCustomer
FROM [Sales].[Customers]

--Count how many customers have placed an order with sales greater than 30.
SELECT
    CustomerID,
    SUM(CASE 
            WHEN Sales > 30 THEN 1
            ELSE 0
        END) AS OrdersAbove30,
    COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY CustomerID;
