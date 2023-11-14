--Extend the view to show total number of transactions for the customer

ALTER VIEW dbo.MyRichestCustomer
AS
WITH CTE AS
(
	select
		a.EmployeeId, a.CustomerId, SUM(ad.Amount) as CurrentBalance
	,	ROW_NUMBER() OVER (PARTITION BY a.EmployeeID ORDER BY SUM(ad.Amount) desc) as RN
	,	COUNT(*) as TotalNumberOfTransactions
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
	cte.EmployeeID, e.FirstName as EmployeeFirstName, e.LastName as EmployeeLastName, c.FirstName as CustomerFirstName, c.LastName as CustomerLastName, cte.CurrentBalance, cte.TotalNumberOfTransactions
FROM
	CTE
	INNER JOIN dbo.Customer as c ON cte.CustomerId = c.ID
	INNER JOIN dbo.Employee as e ON cte.EmployeeId = e.ID
WHERE
	RN = 1

SELECT * FROM dbo.MyRichestCustomer ORDER BY EmployeeID

----------

ALTER VIEW dbo.MyRichestCustomer2
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
,	(SELECT COUNT(*) FROM dbo.AccountDetails as ad WHERE ad.AccountId = cte.AccountID) as TotalNumberOfTransactions
FROM CTE WHERE RN = 1

SELECT * FROM dbo.MyRichestCustomer2 ORDER BY EmployeeID

--Select the top 3 employees by their customer current balance

;WITH CTE AS
(
	SELECT
		*
	,	ROW_NUMBER() OVER (ORDER BY CurrentBalance desc) as RN
	FROM
		dbo.MyRichestCustomer
)
SELECT * FROM CTE WHERE RN <= 3

SELECT TOP(3) * FROM dbo.MyRichestCustomer ORDER BY CurrentBalance desc

------------------------------------------
--DEMO - Stored procedure

CREATE PROCEDURE dbo.p_SubtractNumbers
( 
	@First int = 1
,	@Second int = 0
)
AS
BEGIN
	SELECT @First as [First], @Second as [Second], @First - @Second as Result
END
GO

-- Different ways of executing the procedure
EXEC dbo.p_SubtractNumbers
EXEC dbo.p_SubtractNumbers @First=1
EXEC dbo.p_SubtractNumbers @Second =10
EXEC dbo.p_SubtractNumbers 10,20
EXEC dbo.p_SubtractNumbers @second=50, @First=100

DECLARE	@ReturnValue int
EXEC @ReturnValue = dbo.p_SubtractNumbers
SELECT @ReturnValue as ReturnValue
GO

ALTER PROCEDURE dbo.p_SubtractNumbers
( 
	@First int = 1
,	@Second int = 0
,	@Result int out
)
AS
BEGIN
	SELECT @Result = @First - @Second
	SELECT @First as [First], @Second as [Second], @Result as Result
END

DECLARE
	@ReturnValue int
,	@ResultOut int

EXEC @ReturnValue = dbo.p_SubtractNumbers
	 @First = 10, @Second = 7, @Result = @ResultOut OUT
SELECT @ReturnValue as ReturnValue, @ResultOut as ResultOut

DROP PROCEDURE dbo.p_SubtractNumbers

------------------------------------------
--DEMO - Stored procedure

CREATE OR ALTER PROCEDURE dbo.AddNewEmployee
(
	@FirstName nvarchar(100)
,	@LastName nvarchar(100)
,	@NationalIDNumber nvarchar(15)
,	@JobTitle nvarchar(50)
,	@DateOfBirth date
,	@MaritalStatus nchar(1)
,	@Gender nchar(1)
,	@HireDate date
,	@CityId int
)
AS
BEGIN
	DECLARE
		@BornInSameMonth int = 0
	,	@SameFirstLetterInLastName int = 0
	,	@HiredSameYear int = 0

	SELECT @BornInSameMonth = COUNT(*)
	FROM dbo.Employee
	WHERE MONTH(DateOfBirth) = MONTH(@DateOfBirth)

	SELECT @SameFirstLetterInLastName = COUNT(*)
	FROM dbo.Employee
	WHERE LEFT(LastName, 1) = LEFT(@LastName, 1)

	SELECT @HiredSameYear = COUNT(*)
	FROM dbo.Employee
	WHERE YEAR(HireDate) = YEAR(@HireDate)

	INSERT INTO dbo.Employee (FirstName, LastName, NationalIDNumber, JobTitle, DateOfBirth, MaritalStatus, Gender, HireDate, CityId)
	VALUES (@FirstName, @LastName, @NationalIDNumber, @JobTitle, @DateOfBirth, @MaritalStatus, @Gender, @HireDate, @CityId)

	SELECT
		@BornInSameMonth as BornInSameMonth
	,	@SameFirstLetterInLastName as SameFirstLetterInLastName
	,	@HiredSameYear as HiredSameYear
END
GO

EXEC dbo.AddNewEmployee
	@FirstName = 'Naum'
,	@LastName ='Naumov'
,	@NationalIDNumber = '123456789'
,	@JobTitle = 'Officer'
,	@DateOfBirth = '1990-01-01'
,	@MaritalStatus = 'M'
,	@Gender = 'M'
,	@HireDate = '2010-01-01'
,	@CityId = 1

------------------------------------------
--Hands-on - 1 (slide)

--Create procedure that will add new transactions in the system. Procedure should be used by M-bank application
--	Procedure name: NewMbankTransaction
--	Input parameters: CustomerId , Currency code, TransactionDate, Amount, PurposeCode
--	Output: New balance on the customer account 
--	Note: insert data only in AccountDetails table (do not correct the CurrentBalance)

CREATE PROCEDURE dbo.AddNewTransactionMbank
(
	@CustomeriD int
,	@CurrencyCode nvarchar(5)
,	@TransactionDate datetime
,	@Amount decimal(18,2)
,	@PurposeCode smallint
)
AS
BEGIN
	DECLARE
		@LocationID int
	,	@AccountID int

	SELECT @LocationID = ID FROM dbo.Location WHERE Name = 'M-bank'
	SELECT @AccountID  = a.ID
	FROM
		dbo.Account as a
		inner join dbo.Currency as c ON a.CurrencyId = c.ID
	WHERE a.CustomerId = @CustomeriD and c.Code = @CurrencyCode

	INSERT INTO dbo.AccountDetails (AccountId, LocationId, TransactionDate, Amount, PurposeCode)
	VALUES (@AccountID, @LocationID, @TransactionDate, @Amount, @PurposeCode)

	SELECT SUM(ad.Amount) as CurrentBalance
	FROM AccountDetails as ad
	WHERE ad.AccountId = @AccountID
END

EXEC dbo.AddNewTransactionMbank @CustomerId = 1, @CurrencyCode = '807', @TransactionDate = '2020-09-25', 
@Amount = -100, @PurposeCode = 930
GO

SELECT *
FROM dbo.AccountDetails as ad
ORDER BY ad.ID desc

SELECT SUM(ad.Amount)
FROM dbo.AccountDetails as ad
WHERE ad.AccountID = 1
