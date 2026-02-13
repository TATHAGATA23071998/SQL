USE [SalesDB]

-- Find the average score of customers and handle the NULLS by treating them as zero
SELECT
[CustomerID],
[Score],
COALESCE(Score, 0) Score2, -- if Score is NULL, it will be treated as 0 with the COALESCE function
AVG(Score) OVER() AvgScores,
AVG(COALESCE(Score,0)) OVER() AvgScores2
FROM Sales.Customers

-- Display the full name of the customers in a single field by merging their first and last names. Handle the NULLS by treating them as empty strings.
-- Also, add 10 bonus points for each customer's score
SELECT
[CustomerID],
[FirstName],
[LastName],
[Score],
COALESCE(FirstName, '') + ' ' + COALESCE(LastName, '') AS FullName,
COALESCE(Score, 0) + 10 AS ScoreWithBonus
FROM Sales.Customers

-- Select the customers from lowest to highest scores with nulls at the end
SELECT
[CustomerID],
[Score]
FROM Sales.Customers
ORDER BY
CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score ASC

-- Find the sales price for eachorder by dividing sales by quantity. Handle the NULLS by treating them as zero.
SELECT
[OrderID],
[Sales],
[Quantity],
CASE WHEN Quantity = 0 THEN 0 ELSE Sales / Quantity END AS SalesPrice
FROM Sales.Orders

--Find the customers who have no scores
SELECT
[CustomerID],
[FirstName],
[LastName],
[Score]
FROM Sales.Customers
WHERE Score IS NULL

--Find the customers who have scores
SELECT
[CustomerID],
[FirstName],
[LastName],
[Score]
FROM Sales.Customers
WHERE Score IS NOT NULL

-- List all customers who have not placed any orders (Left Anti Join)
SELECT 
    C.*,
    C.[CustomerID], 
    C.[FirstName], 
    C.[LastName]
FROM Sales.Customers AS C
LEFT JOIN Sales.Orders AS O 
    ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;

