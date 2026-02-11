USE [SalesDB]

-- Checking date and time formats
SELECT 
   [OrderID],
   [CreationTime],
   '2020-01-01' AS SampleDate,
   GETDATE() AS CurrentDate
FROM [Sales].[Orders]

-- Extracting day, date and year parts
SELECT 
   [OrderID],
   [CreationTime],
   DAY([CreationTime]) AS DayPart,
   MONTH([CreationTime]) AS MonthPart,
   YEAR([CreationTime]) AS YearPart
FROM [Sales].[Orders]

-- Datepart functions
SELECT 
   [OrderID],
   [CreationTime],
   DATEPART(year, [CreationTime]) AS YearPart,
   DATEPART(month, [CreationTime]) AS MonthPart,
   DATEPART(day, [CreationTime]) AS DayPart,
   DATEPART(hour, [CreationTime]) AS HourPart,
   DATEPART(quarter, [CreationTime]) AS QuarterPart,
   DATEPART(week, [CreationTime]) AS WeekPart
FROM [Sales].[Orders]

-- Datename functions
SELECT
   [OrderID],
   [CreationTime],
   DATENAME(month, [CreationTime]) AS MonthName,
   DATENAME(weekday, [CreationTime]) AS DayName
FROM [Sales].[Orders]

-- Datetrunc functions
SELECT
   [OrderID],
   [CreationTime],
   DATETRUNC(month, [CreationTime]) AS MonthOnly
FROM [Sales].[Orders]

SELECT
   DATETRUNC(month, [CreationTime]) AS MonthOnly,
   COUNT(*) AS OrderCount
FROM [Sales].[Orders]
GROUP BY DATETRUNC(month, [CreationTime]);

-- End of month truncation example
SELECT
[OrderID],
[CreationTime],
  CAST( DATETRUNC(month, [CreationTime]) AS DATE) AS EndofMonth,
  CAST(DATETRUNC(month, [CreationTime]) AS DATE) AS StartofMonth
FROM [Sales].[Orders]

-- SHow all orders that were placed during February 2025
SELECT
[OrderID],
[OrderDate]
FROM [Sales].[Orders]
WHERE MONTH([OrderDate]) = 2 AND YEAR([OrderDate]) = 2025

--How many are placed each year ?
SELECT
YEAR([OrderDate]),
COUNT (*) AS NoOfOrders
FROM [Sales].[Orders]
GROUP BY YEAR([OrderDate])

-- Changing the format of date and time (timestamp)
SELECT
[OrderID],
[CreationTime],
FORMAT([CreationTime], 'yyyy-MM-dd') AS FormattedDate,
FORMAT([CreationTime], 'MM/dd/yyyy') AS FormattedDate2,
FORMAT([CreationTime], 'MMMM dd, yyyy') AS FormattedDate3,
FORMAT([CreationTime], 'hh:mm tt') AS FormattedTime
FROM [Sales].[Orders]

-- Show creation time in the format of 'Day Wed Jan Q1 2025 12:34:56 PM'
SELECT 
[OrderID],
[CreationTime],
    'Day ' + 
    FORMAT([CreationTime], 'ddd MMM ') + 
    'Q' + CAST(DATEPART(QUARTER, [CreationTime]) AS VARCHAR) + 
    FORMAT([CreationTime], ' yyyy hh:mm:ss tt') 
    AS formatted_date
FROM[Sales].[Orders] ;

-- Format function for Data Aggregation
SELECT 
    FORMAT([CreationTime], 'yyyy-MM') AS YearMonth, 
    COUNT(*) AS OrderCount
FROM [Sales].[Orders]
GROUP BY FORMAT([CreationTime], 'yyyy-MM')
ORDER BY YearMonth ASC;

-- Convert string to integer and then to date
SELECT 
[CreationTime],
CONVERT(DATE,[CreationTime] ) AS DatetimetoDate
FROM [Sales].[Orders]


-- CAST function to convert datetime to date
SELECT
[CreationTime],
CAST([CreationTime] AS DATE) AS DatetimetoDate
FROM [Sales].[Orders]

-- DATEADD function to add a specific number of days to a date
SELECT 
    [CreationTime],
    FORMAT(DATEADD(day, 7, [CreationTime]), 'yyyy-MM') AS CreationTimePlus7Days
FROM [Sales].[Orders];

--DATEDIFF function to calculate the difference in days between two dates
SELECT 
    [CreationTime],
    DATEDIFF(day, [CreationTime], GETDATE()) AS DaysSinceCreation
    FROM [Sales].[Orders]

--Calculate the age of employees based on their BirthDate
SELECT 
    [EmployeeID],
    [FirstName],
    [LastName],
    [BirthDate],
    DATEDIFF(year, [BirthDate], GETDATE()) AS Age
    FROM [Sales].[Employees]

-- Find the average shipping duration in days for all orders for each month
SELECT 
    OrderID,
    Month(OrderDate) AS Order_Month,
    ShipDate,
    FORMAT(OrderDate, 'yyyy-MM') AS YearMonth,
    -- Partition by Month to get the average specifically for that month
    AVG(DATEDIFF(day, OrderDate, ShipDate)) OVER(PARTITION BY Month(OrderDate)) AS AvgShippingDuration
FROM [Sales].[Orders]
ORDER BY AvgShippingDuration ASC;

-- Find the number of days between the order date and the ship date for each order
SELECT 
    OrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(day, OrderDate, ShipDate) AS ShippingDuration
    FROM [Sales].[Orders]
    Order By ShippingDuration ASC;

-- Find the number of days between the order date and the ship date for each order, and filter for orders that took more than 5 days to ship
SELECT 
    OrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(day, OrderDate, ShipDate) AS ShippingDuration
    FROM [Sales].[Orders]
    WHERE DATEDIFF(day, OrderDate, ShipDate) > 5
    Order By ShippingDuration ASC;


-- ISDATE function to check if a string can be converted to a date
SELECT 
    [CreationTime],
    CASE 
        WHEN TRY_CONVERT(DATETIME2, [CreationTime]) IS NOT NULL THEN 1 
        ELSE 0 
    END AS IsValidDate
FROM [Sales].[Orders];