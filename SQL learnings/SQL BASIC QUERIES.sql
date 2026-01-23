USE mydatabase
	SELECT *
	FROM [dbo].[customers]

--retrieve all order data
	SELECT *
	FROM [dbo].[orders]
--retrieve each customers name, country and score only
SELECT
	first_name,
	country,
	score
FROM customers

--where clause [condition based]
SELECT
	first_name,
    country,
    score
FROM customers
WHERE score != 0

--where clause [retrieve customers from Germany]
SELECT
	first_name,
    country,
    score
FROM customers
WHERE country = 'Germany'

--order by [sorts the data in ascending or descending order. In SQL ascending order is the default]
SELECT
	first_name,
    country,
    score
FROM customers
ORDER BY score asc

SELECT
	first_name,
    country,
    score
FROM customers
WHERE score != 0
ORDER BY score desc, country asc

-- using Group By total score (aggregation) by each country
SELECT
    country AS customer_country,
    first_name,
    SUM(score) AS total_score
FROM customers
GROUP BY country, first_name
ORDER BY total_score DESC, customer_country ASC;

-- using Group By to find total score and total customer for each country
SELECT
    country AS customer_country,
    SUM(score) AS total_score,
    COUNT(id) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_score DESC, customer_country ASC;

-- grouping of aggregated column using HAVING BY
SELECT 
    country AS customer_country,
    SUM(score) AS total_score,
    COUNT(id) AS total_customers
FROM customers
GROUP BY country
HAVING SUM(score) > 800
ORDER BY total_score DESC, customer_country DESC;

--using both WHERE and HAVING clauses
SELECT
	country as customer_country,
    SUM(score) as total_score,
    COUNT(id) as total_cusotmers
FROM customers
WHERE score >400
GROUP BY country
HAVING sum(score) >800
ORDER BY total_score desc

-- new example with WHERE AND HAVING combined
SELECT 
    country AS customer_country,
    AVG(score) AS average_score,
    COUNT(id) AS total_customers
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430
ORDER BY average_score DESC

--DISTINCT clause - remove duplicates
SELECT	
	DISTINCT country
FROM customers

-- TOP or Limit (limits the number of rows returned)
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;

--TOP clause from orders database for 2 most recent orders
SELECT TOP 3 *
FROM orders
ORDER BY order_date DESC;