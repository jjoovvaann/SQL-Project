------------------------------------------
--DEMO - GROUPING SETS

--GROUP BY single grouping set
SELECT
	ad.AccountID,
	Month(ad.TransactionDate) as TransactionMonth,
	SUM(ad.Amount) as TotalTransactions
FROM dbo.AccountDetails as ad
WHERE ad.Amount < 0
GROUP BY
	ad.AccountID, Month(ad.TransactionDate)

--Mutiple grouping sets
SELECT
	ad.AccountID,
	Month(ad.TransactionDate) as TransactionMonth,
	SUM(ad.Amount) as TotalTransactions
FROM dbo.AccountDetails as ad
WHERE ad.Amount < 0
GROUP BY GROUPING SETS
(
	( ad.AccountID, Month(ad.TransactionDate) ),
	( ad.AccountID ),
	()
)
--ORDER BY AccountID, CASE WHEN Month(ad.TransactionDate) IS NULL THEN 1 ELSE 0 END

--CASE Example
select
	*
,	CASE
		WHEN ad.Amount < 0 THEN 'N'
		WHEN ad.Amount > 0 THEN 'P'
		ELSE '_'
	END as PositiveNegative
from
	dbo.AccountDetails as ad

------------------------------------------
--DEMO - CUBE

SELECT
	ad.AccountID,
	Month(ad.TransactionDate) as TransactionMonth,
	SUM(ad.Amount) as TotalTransactions
FROM dbo.AccountDetails as ad
WHERE ad.Amount < 0
GROUP BY CUBE ( ad.AccountID, Month(ad.TransactionDate) )
ORDER BY AccountID , TransactionMonth

--Filter CUBE results with CTE
;WITH CTE AS
(
	SELECT
		ad.AccountID,
		Month(ad.TransactionDate) as TransactionMonth,
		SUM(ad.Amount) as TotalTransactions
	FROM dbo.AccountDetails as ad
	WHERE ad.Amount < 0
	GROUP BY CUBE ( ad.AccountID, Month(ad.TransactionDate) )
)
SELECT *
FROM CTE
WHERE AccountID IS NULL
ORDER BY AccountID , TransactionMonth

------------------------------------------
--DEMO - ROLLUP

--lt.Name, l.Name, ad.AccountId
--lt.Name, l.Name
--lt.Name
--()

SELECT
	lt.Name as LocationTypeName
,	l.Name as LocationName
,	ad.AccountID
, 	SUM(ad.Amount) as TotalTransactions
FROM
	dbo.AccountDetails as ad
	INNER JOIN dbo.Location as l ON ad.LocationID = l.ID
	INNER JOIN dbo.LocationType as lt ON l.LocationTypeID = lt.ID
WHERE ad.Amount < 0
GROUP BY ROLLUP ( lt.Name, l.Name, ad.AccountID )
ORDER BY LocationTypeName, LocationName, AccountID

------------------------------------------
--Hands-on - Multiple Grouping sets
--Test this functions at home and analyse the output

------------------------------------------
--DEMO - Coalesce, ISNULL, NULLIF

SELECT
	ad.*,
	ISNULL(EmployeeID, 0) as EmployeeID_0, COALESCE(EmployeeID, 999) as EmployeeID_999,
	NULLIF(ad.PurposeCode, 101) as PurposeCode_NullIF_101
FROM
	dbo.AccountDetails as ad
	
declare
	@x int = NULL
,	@y tinyint = NULL
,	@z decimal (16,8) = 5

select COALESCE(@x, @y, @z)	--5.000000
select ISNULL(@x, @z)		--5

declare
	@a nvarchar(5)
,	@b nvarchar(10) = 'Marjan'

select COALESCE(@a, @b)	--'Marjan'
select ISNULL(@a, @b)	--'Marja'

------------------------------------------
--DEMO - Date functions

DECLARE @dt datetime
SET @dt = GETDATE()

SELECT @dt as DateNow, DATEADD(day, -7, @dt) as DateLastWeek, DATEADD(day, 7, @dt) as DateNextWeek
SELECT @dt as DateNow, DATEADD(minute, -15, @dt) as DateBefore15Minutes, DATEADD(minute, 15, @dt) as DateAfter15Minutes

------------------------------------------
--DEMO - CAST, CONVERT

DECLARE @dt datetime
SET @dt = Getdate()

SELECT
	'broj 20' as Str_Varchar
,	N'број 20' as Str_NVarchar
,	cast('20' as int) as Varchar_Cast_Int
,	cast(N'20' as int) as NVarchar_Cast_Int
,	convert(int, '20') as Varchar_Convert_Int
,	convert(int, N'20') as NVarchar_Convert_Int
,	@dt as Datetime_Default
,	convert(varchar(50), @dt, 104) as Datetime_Convert_Varchar	--dd.mm.yyyy

------------------------------------------
--Hands on - Date functions, ISNULL/COALESCE, CAST/CONVERT

--Show all transactions from the past 20 months.
--Show Columns CustomerName, AccountNumber, TransactionDate and Amount
SELECT
	c.FirstName + ' ' + c.LastName as CustomerName, a.AccountNumber, ad.TransactionDate, ad.Amount
FROM
	dbo.AccountDetails as ad
	INNER JOIN dbo.Account as a ON ad.AccountId = a.ID
	INNER JOIN dbo.Customer as c ON a.CustomerId = c.ID
WHERE TransactionDate > DATEADD(month, -20, GETDATE())

--Show all Cities in the system
--Show columns Name, Region, Population and EastWest
--If the value in column Region IS NULL return 'N/A'
--If the value in column Population IS NULL return 0
--If the value in column EastWest IS NULL return 'N/A'
SELECT
	ID
,	Name
,	ISNULL(Region, 'N/A') as Region
,	ISNULL(Population, 0) as Population
,	CASE
		WHEN [EastWest] IS NULL THEN 'N/A'
		ELSE [EastWest]
	END as EastWestCASE
,	COALESCE(EastWest, 'N/A') as EastWestCoalesce
FROM dbo.City

--Change the previous query
--If the value in column Population IS NULL return 'N/A'
--Hint: use cast or convert
SELECT
	ID
,	Name
,	ISNULL(Region, N'N/A') as Region
,	ISNULL(cast(Population as nvarchar(50)), N'N/A') as Population
,	CASE
		WHEN [EastWest] IS NULL THEN 'N/A'
		ELSE [EastWest]
	END as EastWest
,	COALESCE(EastWest, 'N/A') as EastWestCoalesce
FROM dbo.City