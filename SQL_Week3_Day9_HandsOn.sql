--Grouping
select * from dbo.AccountDetails as ad order by ad.AccountID, ad.TransactionDate

--Grouping with 1 columns
SELECT
	ad.AccountID
,	COUNT(*) as TotalTransactions, COUNT(ad.AccountID) as CntAccountID, COUNT(ad.EmployeeID) as CntEmployeeID
,	SUM(ad.Amount) as S, MIN(ad.Amount) as MinAmount
,	MIN(ABS(ad.Amount)) as MinAbsAmount,MAX(ad.Amount) as MaxAmount
,	AVG(ad.Amount) as AvgAmount
,	STRING_AGG(ad.PurposeCode, ',') as PurposeCodes
FROM
	dbo.AccountDetails as ad
GROUP BY
	ad.AccountID
ORDER BY
	ad.AccountID

--Grouping with multiple columns
SELECT
	ad.AccountID, YEAR(ad.TransactionDate) as Y, MONTH(ad.TransactionDate) as M
,	SUM(ad.Amount) as S, COUNT(*) as TotalTransactions, MIN(ad.Amount) as MinAmount
,	MIN(ABS(ad.Amount)) as MinAbsAmount,MAX(ad.Amount) as MaxAmount
FROM
	dbo.AccountDetails as ad
GROUP BY
	ad.AccountID, YEAR(ad.TransactionDate), MONTH(ad.TransactionDate)
ORDER BY
	ad.AccountID


SELECT
	ad.AccountID, SUM(ad.Amount) as S
,	COUNT(*) as CntTransactions
FROM
	dbo.AccountDetails as ad
WHERE
	ad.Amount < 0
GROUP BY
	ad.AccountID
HAVING
	COUNT(*) > 7
ORDER BY
	ad.AccountID

--------------------
create #T ()
insert into #T (AccountID, Amount)
--insert into @T (AccountID, Amount)
select
	ad.AccountID, ad.Amount
from
	dbo.AccountDetails as ad
where
	ad.AccountID = 1

select * from #T where Amount > 
--select * from @T where Amount > 


drop table #Test
select
	ad.AccountID, ad.Amount
into #Test
from
	dbo.AccountDetails as ad
where
	ad.AccountID = 1

select * from #test

-----------------

select * from dbo.AccountDetails as ad order by ad.AccountID

select
	ad.AccountID, sum(ad.Amount)
from
	dbo.AccountDetails as ad
group by
	ad.AccountID
order by
	ad.AccountID


select
	ad.AccountID, ad.LocationID, sum(ad.Amount)
from
	dbo.AccountDetails as ad
group by
	ad.AccountID, ad.LocationID
order by
	ad.AccountID



select
	ad.AccountID, sum(ad.Amount) as S, STRING_AGG(ad.LocationID, ',') as L
from
	dbo.AccountDetails as ad
group by
	ad.AccountID
order by
	ad.AccountID

select
	ad.*
,	SUM(ad.Amount) OVER (PARTITION BY ad.AccountID) as S
--,	COUNT(*) OVER (PARTITION BY ad.AccountID) as C
--,	COUNT(*) OVER () as C2
from
	dbo.AccountDetails as ad
order by
	ad.AccountID

select count(*) from dbo.AccountDetails
