USE [SalesDB]

-- Concatenate the first name and last names of customers into a single column named name Full_Name using the CONCAT function
SELECT
    FirstName,
    LastName,
    CONCAT (FirstName, '',  LastName) AS Full_Name
FROM [Sales].[Customers]

-- Convert the full name of customers to lowercase using the LOWER function
SELECT
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) AS Full_Name,
    LOWER(CONCAT(FirstName, ' ', LastName)) AS Full_Name_Lower
FROM [Sales].[Customers];

-- Convert the full name of customers to upper case using the UPPER function
SELECT
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) AS Full_Name,
    UPPER(CONCAT(FirstName, ' ', LastName)) AS Full_Name_Lower
FROM [Sales].[Customers];

-- Detect spaces in the first name using the TRIM function to remove leading and trailing spaces
SELECT
    FirstName,
    LastName,
    LEN(FirstName)
FROM [Sales].[Customers]
WHERE FirstName != TRIM(FirstName) -- Detect spaces in the first name

-- Replace the first name of customers with the word 'Customer' using the REPLACE function
SELECT
    FirstName,
    LastName,
    REPLACE(FirstName, FirstName, 'Customer') AS New_FirstName
FROM [Sales].[Customers]

-- Calculate the length of the first name of customers using the LEN function
SELECT
    FirstName,
    LastName,
    LEN(FirstName) AS FirstName_Length
FROM [Sales].[Customers]

-- Retrieve the first two characters of the first name of customers using the LEFT function
SELECT
    FirstName,
    LastName,
    LEFT(FirstName, 2) AS FirstName_First2Chars
FROM [Sales].[Customers]

-- Retrieve the last two characters of the first name of customers using the RIGHT function
SELECT
    FirstName,
    LastName,
    RIGHT(FirstName, 2) AS FirstName_Last2Chars
FROM [Sales].[Customers]

-- Retrieve the first name of customers starting from the second character using the SUBSTRING function
SELECT
    FirstName,
    SUBSTRING (TRIM(FirstName), 2, LEN(FirstName)) AS Sub_Name
    FROM [Sales].[Customers]
