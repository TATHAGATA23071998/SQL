USE [SalesDB]

-- Find the total sales accross all orders
SELECT 
SUM(Sales) AS TotalSales
FROM Sales.Orders
Group by ProductID

-- Find the total sales accross all orders and provide details like OrderID, OrderDate
SELECT
    OrderID,ProductID,OrderDate,
    SUM(Sales) OVER (PARTITION BY PRODUCTID) AS Total_Sales
FROM Sales.Orders;

-- Find the total sales accross all orders and provide details like OrderID, OrderDate
SELECT
    OrderID,ProductID,OrderDate,
    SUM(Sales) OVER (PARTITION BY [OrderStatus]) AS Total_Sales
FROM Sales.Orders
ORDER BY OrderID;

-- Find the total sales accross each product and provide details like OrderID, OrderDate
SELECT
    OrderID,ProductID,OrderDate,[OrderStatus],
    SUM(Sales) OVER () AS Actual_Total_Sales,
    SUM(Sales) OVER (PARTITION BY ProductID) AS Granularized_Total_Sales,
    SUM(sales) OVER (PARTITION BY ProductID,OrderStatus) AS Total_Sales_By_OrderStatus
    FROM Sales.Orders

-- Rank each order on their sales from highest to lowest and provide details like OrderID, OrderDate
SELECT
    OrderID,OrderDate,Sales,
    RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank
    FROM Sales.Orders

-- Window frames 
SELECT
    OrderID,OrderDate,[OrderStatus],Sales,
    SUM(Sales) OVER (PARTITION BY [OrderStatus] ORDER BY [OrderDate] ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS Running_Total_Sales
    FROM Sales.Orders

    -- Rank customers based on their total sales and provide details like CustomerID, OrderID, OrderDate
    SELECT
    CustomerID,OrderID,OrderDate,Sales,
    RANK() OVER (PARTITION BY CustomerID ORDER BY Sales DESC) AS Sales_Rank
    FROM Sales.Orders
    GROUP BY   CustomerID,OrderID,OrderDate,Sales