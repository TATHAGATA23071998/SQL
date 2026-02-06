USE [SalesDB]

/* Using SalesDB, retrieve a list of all orders, along with the related customer, product and employee details. Also, for each order display: OrderID, Customer's Name, Product name, Sales, Price, Sales person's name*/
SELECT 
SO.CustomerID,
SO.OrderID,
SO.ProductID,
SO.SalesPersonID,
SO.Sales,
SC.FirstName AS CUSTOMERFIRSTNAMES,
SC.LastName AS CUSTOMERLASTNAMES,
SC.Country,
SP.Product,
SP.Price,
SE.Department,
SE.BirthDate,
SE. [FirstName] AS EMPLOYEEFIRSTNAME,
SE. [LastName] AS EMPLOYEELASTNAME,
SE.Gender AS EMPLOYEEGENDER,
SE.Salary,
SE.ManagerID
FROM [Sales].[Orders] AS SO --Important table
LEFT JOIN [Sales].[Customers] AS SC
ON SC.CustomerID = SO.CustomerID

LEFT JOIN [Sales].[Products] AS SP
ON SO.PRODUCTID = SP.PRODUCTID

LEFT JOIN [Sales].[Employees] AS SE
ON SO. [SalesPersonID] = SE. [EmployeeID]