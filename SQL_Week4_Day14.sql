------------------------------------------
--Hands-on - Scalar-valued functions

--Prepare function that for CustomerId on input will return the current balance of his MKD account
--	- Name: Dbo.MyMKDAccountBalance
--	- Input: @CustomerId int
--	- Output: decimal(18,2)

CREATE FUNCTION dbo.MyMKDAccountBalance (@CustomerID int)
RETURNS decimal(18,2)
AS
BEGIN
	DECLARE @Result decimal(18,2)

	SELECT
		@Result = SUM(ad.Amount)
	FROM
		dbo.Account as a
		INNER JOIN dbo.AccountDetails as ad ON a.ID = ad.AccountId
		INNER JOIN dbo.Currency as cu ON a.CurrencyId = cu.ID
	WHERE
		cu.ShortName = 'MKD'
	and a.CustomerId = @CustomerID

	RETURN @Result
END
--DROP FUNCTION dbo.MyMKDAccountBalance
	
--Prepare query that will show current balance for all customers from  Prilep

SELECT
	c.FirstName, c.LastName, ci.Name as City
,	dbo.MyMKDAccountBalance(c.ID) as CurrentBalance
FROM
	dbo.Customer as c
	INNER JOIN dbo.City as ci ON c.CityId = ci.ID
WHERE
	ci.Name = 'Prilep'
ORDER BY c.ID

--Extend the query to show only customers having current balance bigger then 5000 MKD

SELECT
	c.FirstName, c.LastName, ci.Name as City
,	dbo.MyMKDAccountBalance(c.ID) as CurrentBalance
FROM
	dbo.Customer as c
	INNER JOIN dbo.City as ci ON c.CityId = ci.ID
WHERE
	ci.Name = 'Prilep'
and dbo.MyMKDAccountBalance(c.ID) > 5000
ORDER BY c.ID

--With CTE
;WITH CTE AS
(
	SELECT
		c.FirstName, c.LastName, ci.Name as City
	,	dbo.MyMKDAccountBalance(c.ID) as CurrentBalance
	FROM
		dbo.Customer as c
		INNER JOIN dbo.City as ci ON c.CityId = ci.ID
	WHERE
		ci.Name = 'Prilep'
)
SELECT * FROM CTE WHERE CurrentBalance > 5000

------------------------------------------
--DEMO - Table-valued functions

--DROP FUNCTION dbo.fn_TotalTransactionsForCustomerAndCurrency
CREATE FUNCTION dbo.fn_TotalTransactionsForCustomerAndCurrency (@CustomerId int)
RETURNS @ResultSet table (CurrencyCode nvarchar(20), NumOfTransacions int)
AS 
BEGIN
	INSERT INTO @ResultSet (CurrencyCode, NumOfTransacions)
	SELECT c.ShortName as CurrencyCode, count(*) as NumOfTransacions
	FROM
		dbo.Account as a
		INNER JOIN dbo.AccountDetails as ad on a.ID = ad.AccountId
		INNER JOIN dbo.Currency as c on a.CurrencyId = c.ID
	WHERE
		a.CustomerId = @CustomerId
	GROUP BY c.ShortName

	RETURN 
END

--how to execute
--EUR, 8
--MKD, 9
SELECT * FROM dbo.fn_TotalTransactionsForCustomerAndCurrency (1)

------------------------------------------
--Hands on - Table-valued functions

--Create function that will return the total number of transactions per location type
--(total ATM transactions, total Clearing house transactions, etc.) for validity period defined on input of function
--Help:
--input: (@CustomerId, @validFrom date, @ValidTo date)
--Example output:
--ATM - 5
--Clearing house - 1
--Branch office - 2

CREATE FUNCTION dbo.fn_TotalTransactionsForCustomerLocationTypeInValidityPeriod
(
	@CustomerID int
,	@ValidFrom date
,	@ValidTo date
)
RETURNS @Result table (LocationType nvarchar(100), TotalNumberOfTransactions int)
AS
BEGIN

	INSERT INTO @Result (LocationType, TotalNumberOfTransactions)
	SELECT
		lt.Name as LocationType
	,	count(*) as TotalNumberOfTransactions
	FROM
		dbo.AccountDetails as ad
		INNER JOIN dbo.Location as l ON ad.LocationId = l.ID
		INNER JOIN dbo.LocationType as lt ON l.LocationTypeId = lt.Id
		INNER JOIN dbo.Account as a ON ad.AccountId = a.ID 
	WHERE
		a.CustomerId = @CustomerID
	and ad.TransactionDate between @ValidFrom and @ValidTo
	GROUP BY
		lt.Name
	ORDER BY lt.Name

	RETURN
END

SELECT * FROM dbo.fn_TotalTransactionsForCustomerLocationTypeInValidityPeriod(1, '2019-01-01', '2019-01-31')

------------------------------------------
--DEMO - View

CREATE VIEW dbo.FemaleEmployees
AS
SELECT FirstName, LastName
FROM dbo.Employee
WHERE Gender = 'F'

SELECT * FROM dbo.FemaleEmployees

ALTER VIEW dbo.FemaleEmployees
AS
SELECT ID, FirstName, LastName
FROM dbo.Employee
WHERE Gender = 'F'

SELECT
	*
FROM
	dbo.AccountDetails as ad
	INNER JOIN dbo.FemaleEmployees as fe ON ad.EmployeeID = fe.ID

DROP VIEW IF EXISTS dbo.FemaleEmployees

------------------------------------------
--Hands-on - View

--Create view MyRichestCustomer that will list all employees (First/Last name) together with their richest Customer at the moment.
--(richest customer – customer having biggest CurrentBalance for his MKD account open by the employee)

--With SUM(Amount) from dbo.AccountDetails
CREATE VIEW dbo.MyRichestCustomer
AS
WITH CTE AS
(
	select
		a.EmployeeId, a.CustomerId, SUM(ad.Amount) as CurrentBalance
	,	ROW_NUMBER() OVER (PARTITION BY a.EmployeeID ORDER BY SUM(ad.Amount) desc) as RN
	from
		dbo.Account as a
		INNER JOIN dbo.AccountDetails as ad ON a.ID = ad.AccountId
		INNER JOIN dbo.Currency as cu ON a.CurrencyId = cu.ID
	WHERE
		cu.ShortName = 'MKD'
	GROUP BY
		a.EmployeeId, a.CustomerId
)
SELECT
	cte.EmployeeID, e.FirstName as EmployeeFirstName, e.LastName as EmployeeLastName, c.FirstName as CustomerFirstName, c.LastName as CustomerLastName, cte.CurrentBalance
FROM
	CTE
	INNER JOIN dbo.Customer as c ON cte.CustomerId = c.ID
	INNER JOIN dbo.Employee as e ON cte.EmployeeId = e.ID
WHERE
	RN = 1

SELECT * FROM dbo.MyRichestCustomer ORDER BY EmployeeID

----------

--With CurrentBalance from dbo.Account
CREATE VIEW dbo.MyRichestCustomer2
AS
WITH CTE AS
(
	select
		a.ID as AccountID, e.ID as EmployeeID, e.FirstName as EmployeeFirstName, e.LastName as EmployeeLastName, c.FirstName as CustomerFirstName, c.LastName as CustomerLastName, a.CurrentBalance
	,	ROW_NUMBER() OVER (PARTITION BY a.EmployeeID ORDER BY a.CurrentBalance desc) as RN
	from
		dbo.Account as a
		INNER JOIN dbo.Currency as cu ON a.CurrencyId = cu.ID
		INNER JOIN dbo.Customer as c ON a.CustomerId = c.ID
		INNER JOIN dbo.Employee as e ON a.EmployeeId = e.ID
	WHERE
		cu.ShortName = 'MKD'
)
SELECT
	cte.EMployeeID, cte.EmployeeFirstName, cte.EmployeeLastName, cte.CustomerFirstName, cte.CustomerLastName, cte.CurrentBalance
FROM CTE WHERE RN = 1

SELECT * FROM dbo.MyRichestCustomer2 ORDER BY EmployeeID
