 USE [SalesDB];

 -- 1. CREATE THE LOG TABLE
 CREATE TABLE Sales.Employee_Logs
 (
	LOGID INT IDENTITY (1,1) PRIMARY KEY,
	EmployeeID INT,
	LOG_MESSAGE VARCHAR(250),
	LOG_DATE DATE
)

--2. CREATE TRIGGER
CREATE TRIGGER trg_After_Insert_Employee ON [Sales].[Employees]
AFTER INSERT AS
BEGIN
	INSERT INTO [Sales].[Employee_Logs] ([EmployeeID], [LOG_MESSAGE], [LOG_DATE])
	SELECT [EmployeeID],
	'New Employee Added is:' + CAST([EmployeeID] AS VARCHAR(30)),
	GETDATE ()
	FROM INSERTED
END


SELECT * FROM [Sales].[Employee_Logs]
SELECT * FROM [Sales].[Employees]

INSERT INTO [Sales].[Employees]
VALUES
(7, 'Vladimir', 'Lenin', 'IT', '1998-08-23', 'M', 100000, 3)
	