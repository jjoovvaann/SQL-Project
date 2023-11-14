------------------------------------------
--DEMO - Window functions

--Details
SELECT *
FROM dbo.AccountDetails as ad
ORDER BY AccountID, TransactionDate

--Simple grouping (GROUP BY)
SELECT ad.AccountID, SUM(ad.Amount) as OutflowPerAccount
FROM dbo.AccountDetails as ad
WHERE ad.Amount < 0
GROUP BY ad.AccountID
ORDER BY ad.AccountID

--Window functions
SELECT *,
		SUM(Amount) OVER (PARTITION BY AccountID) as OutflowPerAccount,
		MIN(Amount) OVER (PARTITION BY AccountID) as MinOutflowPerAccount,
		SUM(Amount) OVER (PARTITION BY LocationID) as OutflowPerLocation,
		SUM(Amount) OVER (PARTITION BY AccountID, LocationID) as OutflowPerAccountLocation,
		SUM(Amount) OVER() as GrandTotal
FROM dbo.AccountDetails as ad
WHERE ad.Amount < 0
ORDER BY AccountID, TransactionDate

------------------------------------------
--Hands on - windowing functions

--Find total amount of outflow per location in the month 03.2019
--List Location name next to each location ID

SELECT ad.*, l.Name
,	SUM(ad.Amount) OVER (PARTITION BY ad.LocationID) as TotalOutflowPerLocation
FROM
	dbo.AccountDetails as ad
	INNER JOIN dbo.Location as l ON ad.LocationID = l.ID
WHERE
	ad.Amount < 0
and Year(ad.TransactionDate) = 2019
and Month(ad.TransactionDate) = 3
ORDER BY ad.LocationId

------------------------------------------
--DEMO - Window ranking functions

SELECT ID, AccountID, TransactionDate, Amount,
		ROW_NUMBER() OVER (ORDER BY Amount) as RowNumb,
		RANK() OVER (ORDER BY Amount) as Rnk,
		DENSE_RANK() OVER (ORDER BY Amount) as DenseRnk,
		NTILE(100) OVER (ORDER BY Amount) as Ntile100
FROM dbo.AccountDetails

---------

declare @t table
(
	AccountID int
,	Amount decimal(18,2)
,	RN int
)
insert into @t (AccountID,Amount, RN)
select
	ad.AccountiD
,	ad.Amount
,	ROW_NUMBER() OVER (PARTITION BY ad.AccountID ORDER BY ad.Amount desc) as RN
from
	dbo.AccountDetails as ad
order by
	ad.AccountId
select * from @t where RN <= 3

--create #T
--insert into #T
--select

--select
--	ad.AccountiD
--,	ad.Amount
--,	ROW_NUMBER() OVER (PARTITION BY ad.AccountID ORDER BY ad.Amount desc) as RN
--INTO #TestTable
--from
--	dbo.AccountDetails as ad
--order by
--	ad.AccountId
--select * from #TestTable

SELECT ID, AccountID, TransactionDate, Amount,
		ROW_NUMBER() OVER (PARTITION BY AccountID ORDER BY Amount DESC) as RowNumbPerAccount,
		RANK() OVER (PARTITION BY AccountID ORDER BY Amount DESC) as RnkPerAccount,
		DENSE_RANK() OVER (PARTITION BY AccountID ORDER BY Amount DESC) as DenseRnkPerAccount,
		NTILE(3) OVER (PARTITION BY AccountID ORDER BY Amount DESC) as Ntile3PerAccount
FROM dbo.AccountDetails
WHERE Amount < 0
ORDER BY AccountID, Amount DESC

------------------------------------------
--Hands on - Window ranking functions

--Order all transactions from Clearing houses from highest to lowest transaction by using RowNumber function
--Show the following  data on output:
--LocationName
--AccountId
--Amount
--Rn (the ordering column)

SELECT l.Name, ad.AccountId, ad.Amount,  ROW_NUMBER() OVER (ORDER BY Amount DESC) as RN
FROM
	dbo.AccountDetails as ad
	INNER JOIN dbo.Location as l ON ad.LocationId = l.Id
	INNER JOIN dbo.LocationType as lt ON l.LocationTypeId = lt.Id
WHERE lt.Name = 'Clearing House' 
ORDER BY Amount DESC

------------------------------------------
--DEMO - CTE

;WITH MyCTE AS
(
	SELECT l.Name, ad.AccountId, ad.Amount,  ROW_NUMBER() OVER (ORDER BY Amount DESC) as RN
	FROM
		dbo.AccountDetails as ad
		INNER JOIN dbo.Location as l ON ad.LocationId = l.Id
		INNER JOIN dbo.LocationType as lt ON l.LocationTypeId = lt.Id
	WHERE lt.Name = 'Clearing House'
)
, MyCTE2 AS
(
	SELECT *, RANK () OVER (ORDER BY Amount DESC) as MyRank
	FROM MyCTE
	WHERE RN < = 5
)
SELECT * FROM MyCTE2 
WHERE myRank > 2
ORDER BY Amount DESC

---------

select 1;

;WITH CTE AS
(
	select
		ad.AccountiD
	,	ad.Amount
	,	ROW_NUMBER() OVER (PARTITION BY ad.AccountID ORDER BY ad.Amount desc) as RN
	from
		dbo.AccountDetails as ad
)
,CTE2 AS
(
	select * from dbo.Currency
)
,CTE3 AS
(
	select * from CTE2 where Code = '807'
)
--select * from CTE3
select * from CTE where RN <= 3

------------------------------------------
--Hands on - CTE

--Extend the query for top 5 transactions to show top 5 transactions for different clearing house (KIBS, MIPS)

;WITH MyCTE AS
(
	SELECT l.Name, ad.AccountId, ad.Amount,  ROW_NUMBER() OVER (PARTITION BY ad.LocationID ORDER BY ad.Amount DESC) as RN
	FROM
		dbo.AccountDetails as ad
		INNER JOIN dbo.Location as l ON ad.LocationId = l.Id
		INNER JOIN dbo.LocationType as lt ON l.LocationTypeId = lt.Id
	WHERE lt.Name = 'Clearing House'
)
SELECT * FROM MyCTE WHERE RN <= 5
ORDER BY Name, RN

--Prepare query that will show smallest 2 transactions from each location in February, 2019.
--Query should include the owner or the account as well.
--Columns on output: LocationName, Amount, Customer name

;WITH CTE AS
(
	SELECT
		l.Name as LocationName, ad.Amount, c.FirstName + ' ' + c.LastName as Customer
	,	ROW_NUMBER() OVER (PARTITION BY ad.LocationID ORDER BY ABS(Amount)) as RN
	FROM
		dbo.AccountDetails as ad
		INNER JOIN dbo.Location as l ON ad.LocationId = l.Id
		INNER JOIN dbo.Account as a ON ad.AccountId = a.ID
		INNER JOIN dbo.Customer as c ON a.CustomerId = c.Id
	WHERE
		Year(ad.TransactionDate) = 2019 and Month(ad.TransactionDate) = 2
)
SELECT * FROM CTE WHERE RN <= 2