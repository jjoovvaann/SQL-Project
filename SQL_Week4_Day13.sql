------------------------------------------
--DEMO - Scalar-valued functions

--DROP FUNCTION IF EXISTS dbo.fn_TotalTransactionsForCustomer

CREATE FUNCTION dbo.fn_TotalTransactionsForCustomer (@CustomerID int)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	
	SELECT @Result = COUNT(*)
	FROM
		dbo.Account as a
		INNER JOIN dbo.AccountDetails as ad ON a.ID = ad.AccountID
	WHERE a.CustomerID = @CustomerID
	
	RETURN @Result
END

--17
SELECT dbo.fn_TotalTransactionsForCustomer (1)

SELECT c.*, dbo.fn_TotalTransactionsForCustomer (c.ID) as TotalTransactions
FROM dbo.Customer as c

-------

CREATE FUNCTION dbo.fn_EmployeeFullName(@EmployeeID int)
RETURNS nvarchar(201)
AS
BEGIN
	DECLARE @Result nvarchar(201)

	SELECT @Result = e.FirstName + ' ' + e.LastName
	FROM dbo.Employee as e
	WHERE e.ID = @EmployeeID
	
	RETURN @Result
END

SELECT dbo.fn_EmployeeFullName (1)

SELECT e.*, dbo.fn_EmployeeFullName (e.ID) as FullName, LEN(e.LastName) as LastNameLen
FROM dbo.Employee as e

------------------------------------------
--Hands-on - Scalar-valued functions

--Create scalar function MakeLastNameFemale, that will:
--Fix Female employee Last Names in the following way:
--	- Lazarov -> Lazarova
--	- Ristovski -> Ristovska
--The function has 2 input parameters
--	- @LastName nvarchar(20)
--	- @Gender nchar(1)
--If the value of the parameter @Gender is 'M', the function will return the original LastName,
--if the value of the parameter is 'F', the function will return fixed LastName

CREATE FUNCTION dbo.MakeLastNameFemale (@LastName nvarchar(100), @Gender nchar(1))
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @Result nvarchar(100)
	
	SELECT @Result =
	CASE
		WHEN @Gender = 'F' and RIGHT(@LastName, 3) = 'ski' THEN REPLACE(@LastName+'#', 'ski#', 'ska')
		WHEN @Gender = 'F' and RIGHT(@LastName, 1) = 'v' THEN REPLACE(@LastName+'#', 'v#', 'va')
		ELSE @LastName
	END

	RETURN @Result
END

SELECT dbo.MakeLastNameFemale('Trajkovski', 'M')
SELECT dbo.MakeLastNameFemale('Skiatovski', 'F')
SELECT dbo.MakeLastNameFemale('Vasov', 'M')
SELECT dbo.MakeLastNameFemale('Jovanov', 'F')

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
