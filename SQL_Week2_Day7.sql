--Hands-on Combining sets 3/3
--Find all Currencies for which there are open accounts in the system
SELECT c.id FROM dbo.Currency as c
INTERSECT
SELECT a.CurrencyId FROM dbo.Account as a

--Extend the previous query to show total number of Accounts per currency
SELECT c.id, (SELECT count(*) FROM dbo.Account as ac WHERE ac.CurrencyId = c.id) as TotalAccountsInCurrency
FROM dbo.Currency as c
INTERSECT
SELECT a.CurrencyId, (SELECT count(*) FROM dbo.Account as ac WHERE ac.CurrencyId = a.CurrencyID) as TotalAccountsInCurrency
FROM dbo.Account as a

--Try at Home
--List all accounts in the system. Show AccountNumber, CustomerName and CurrentBalance
SELECT
	a.AccountNumber, c.FirstName, a.CurrentBalance
FROM
	dbo.Account as a
	INNER JOIN dbo.Customer as c ON a.CustomerID = c.ID

--Extend the previous query to show only data for accounts opened by EmployeeLastName = 'Popovski'
SELECT
	a.AccountNumber, c.FirstName, a.CurrentBalance
FROM
	dbo.Account as a
	INNER JOIN dbo.Customer as c ON a.CustomerID = c.ID
	INNER JOIN dbo.Employee as e ON a.EmployeeID = e.ID
WHERE
	e.LastName = 'Popovski'

--Extend the previous query to show only accounts in MKD currency
SELECT
	a.AccountNumber, c.FirstName, a.CurrentBalance
FROM
	dbo.Account as a
	INNER JOIN dbo.Customer as c ON a.CustomerID = c.ID
	INNER JOIN dbo.Employee as e ON a.EmployeeID = e.ID
	INNER JOIN dbo.Currency as cy ON a.CurrencyID = cy.ID
WHERE
	e.LastName = 'Popovski'
and cy.ShortName = 'MKD'

------------------------------------------
--DEMO - Scalar Variables
--Scalar variables
DECLARE @MyName nvarchar(10) = 'Marjan'
DECLARE @CurrentYear int --= 2019

SELECT @MyName as MyName, @CurrentYear as CurrentYear

SET @MyName = 'Marjan2'
SET @CurrentYear = 2020

SELECT @MyName as MyName, @CurrentYear as CurrentYear

SELECT @MyName = 'Ana', @CurrentYear = 2021

--Visible only in the BATCH where is declared
SELECT @MyName as MyName, @CurrentYear as CurrentYear

SELECT * from dbo.Customer WHERE FirstName = @MyName
GO
--Not visible
--select @MyName as MyName, @CurrentYear as CurrentYear

------------------------------------------
--Try after each topic (slide)
-- Scalar variable:
	-- Find all customers that has Boskovski as LastName and are born in February any year
DECLARE
	@LastName nvarchar(100) = 'Boskovski'
,	@Month tinyint = 2
SELECT * FROM dbo.Customer WHERE LastName = @LastName and Month(DateOfBirth) = @Month

------------------------------------------
--DEMO - Table Variables

--Table variables
DECLARE @MyCustomer TABLE (FirstName nvarchar(100), LastName nvarchar(100), City nvarchar(50))

INSERT INTO @MyCustomer (FirstName, LastName, City) VALUES ('Aleks', 'Aleksov', 'Skopje') 
INSERT INTO @MyCustomer (FirstName, LastName, City) VALUES ('Martin', 'Martinov', 'Skopje')

INSERT INTO @MyCustomer (FirstName, LastName, City)
VALUES
	('Ande', 'Andev', 'Veles')
,	('Mende', 'Mendov', 'Veles')

UPDATE @MyCustomer SET City = 'Bitola' WHERE FirstName = 'Mende'

INSERT INTO @MyCustomer (FirstName, LastName, City)
SELECT FirstName, LastName, City from dbo.Customer WHERE ID <= 2

--Visible only in the BATCH where is declared
SELECT * FROM @MyCustomer
GO
--Not visible
--select * from @FemaleEmployeeList

------------------------------------------
--Try after each topic (slide)

--Table variable
	-- DECALRE table variable @MyEmployees (NationalIdNumber)
	-- DECLARE @MyGender scalar variable = 'M/F'
	-- Insert few EMBG from the exisitng EMBGS in dbo.Employee
	-- List all employees that has NationalIdNumber as @MyEmployees table and has Gender as @MyGender scalar variable
	
DECLARE @MyEmployee TABLE (NationalIdNumber nvarchar(15))	
DECLARE @MyGender nchar(1) = 'M'

INSERT INTO @MyEmployee (NationalIdNumber)
SELECT TOP(3) NationalIdNumber from dbo.Employee where Gender = 'M'
UNION ALL
SELECT TOP(3) NationalIdNumber from dbo.Employee where Gender = 'F'

SELECT
	e.*
FROM
	dbo.Employee as e
	INNER JOIN @MyEmployee as me ON e.NationalIdNumber = me.NationalIdNumber
WHERE
	e.Gender = @MyGender

SELECT
	e.*
FROM
	dbo.Employee as e
WHERE
	e.NationalIdNumber IN (SELECT NationalIdNumber FROM @MyEmployee) and e.Gender = @MyGender
------------------------------------------
--DEMO - Temporary tables

--Temporary tables
CREATE TABLE #MyCustomer (FirstName nvarchar(100), LastName nvarchar(100), City nvarchar(50))

INSERT INTO #MyCustomer (FirstName, LastName, City) VALUES ('Aleks', 'Aleksov', 'Skopje') 
INSERT INTO #MyCustomer (FirstName, LastName, City) VALUES ('Martin', 'Martinov', 'Skopje')

INSERT INTO #MyCustomer (FirstName, LastName, City)
VALUES
	('Ande', 'Andev', 'Veles')
,	('Mende', 'Mendov', 'Veles')

UPDATE #MyCustomer SET City = 'Bitola' WHERE FirstName = 'Mende'

INSERT INTO #MyCustomer (FirstName, LastName, City)
SELECT FirstName, LastName, City from dbo.Customer WHERE ID <= 2

--Visible in the Sesion where is declared
SELECT * FROM #MyCustomer
GO
--Visible (same session)
select * from #MyCustomer

--Not Visible (another session)
select * from #MyCustomer

--drop table #MyCustomer
--GO

------------------------------------------
--Try after each topic (slide)

-- Temp table
	-- Same exercise but with temp table
	-- Add additional parameter for month of birth and do testing with it

CREATE TABLE #MyEmployee (NationalIdNumber nvarchar(15))	
DECLARE
	@MyGender nchar(1) = 'M'
,	@MonthOfBirth tinyint = 2

INSERT INTO #MyEmployee (NationalIdNumber)
SELECT TOP(3) NationalIdNumber from dbo.Employee where Gender = 'M'
UNION ALL
SELECT TOP(3) NationalIdNumber from dbo.Employee where Gender = 'F'

SELECT
	e.*
FROM
	dbo.Employee as e
	INNER JOIN #MyEmployee as me ON e.NationalIdNumber = me.NationalIdNumber
WHERE
	e.Gender = @MyGender and Month(e.DateOfBirth) = @MonthOfBirth
