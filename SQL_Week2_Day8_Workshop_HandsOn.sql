SELECT
	l.[Name],l.ID
FROM
	[DBO].[Location] as l
	INNER JOIN dbo.LocationType as lt ON l.LocationTypeID=lt.ID
WHERE
	lt.Name='ATM'
and l.ID in
	(
		SELECT a.LocationID
		FROM dbo.AccountDetails as a
		WHERE
			a.Amount < -1500
		and Month(a.TransactionDate) = 3 and Year(a.TransactionDate) = 2019
)

-----------
select * from Customer
select * from Employee
select * from Location

--DROP TABLE dbo.City

CREATE TABLE dbo.City
(
	ID int IDENTITY(1,1) NOT NULL
,	[Name] nvarchar(100) NOT NULL
,	Region nvarchar(50) NOT NULL
,	[Population] int NULL
,	EastWest char(1) NOT NULL
,	CONSTRAINT PK_City PRIMARY KEY CLUSTERED (ID ASC)
)
GO

INSERT INTO dbo.City ([Name], Region, EastWest)
SELECT DISTINCT
	City as [Name]
,	'' as Region
,	'' as EastWest
FROM Customer WHERE City IS NOT NULL

select * from City

UPDATE dbo.City
SET
	Region = 'Pelagoniski'
,	[Population] = 85000
,	EastWest = 'W'
WHERE
	[Name] = 'Bitola'

--...

ALTER TABLE dbo.Customer ADD CityID int
ALTER TABLE dbo.Employee ADD CityID int
ALTER TABLE dbo.[Location] ADD CityID int

select * from dbo.Customer

ALTER TABLE dbo.Customer
ADD CONSTRAINT FK_Customer_City FOREIGN KEY (CityID)
REFERENCES dbo.City(ID)

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_City FOREIGN KEY (CityID)
REFERENCES dbo.City(ID)

ALTER TABLE dbo.[Location]
ADD CONSTRAINT FK_Location_City FOREIGN KEY (CityID)
REFERENCES dbo.City(ID)

select * from dbo.Customer
select * from dbo.City

SELECT
	c.*, ci.ID
FROM
	dbo.Customer as c
	INNER JOIN dbo.City as ci ON c.City = ci.[Name]

UPDATE
	c
SET
	c.CityID = ci.ID
FROM
	dbo.Customer as c
	INNER JOIN dbo.City as ci ON c.City = ci.[Name]

select * from Customer

--ALTER TABLE dbo.Customer DROP COLUMN City

-------------------
select * from [Location] where LocationTypeID in (1,2)
select * from [Location] where LocationTypeID = 4
select * from City

--Mar
select LEFT('Marjan', 3)
--jan
select RIGHT('Marjan', 3)
--arj
select SUBSTRING('Marjan', 2, 3)
--3
select CHARINDEX('r', 'Marjan')
--6
select len('Marjan')
--Maan
select REPLACE('Marjan', 'rj', '')

--INSERT INTO dbo.City ([Name], Region, EastWest)
select
	LEFT([Name], CHARINDEX(' ', [Name]) - 1) as [Name]
,	'' as Region
,	'' as EastWest
from [Location]
where
	LocationTypeID in (1,2)
and	LEFT([Name], CHARINDEX(' ', [Name]) - 1) NOT IN (select [Name] from City)

select DISTINCT
	LEFT(REPLACE([Name], 'ATM ', ''), CHARINDEX(' ', REPLACE([Name], 'ATM ', '')) - 1) as [Name]
,	'' as Region
,	'' as EastWest
from [Location]
where
	LocationTypeID = 4
and LEFT(REPLACE([Name], 'ATM ', ''), CHARINDEX(' ', REPLACE([Name], 'ATM ', '')) - 1) NOT IN (select [Name] from City)

--select
--	l.*
--,	LEFT(l.[Name], CHARINDEX(' ', l.[Name]) - 1)
--,	c.ID
update
	l
set
	l.CityID = c.ID
from
	dbo.[Location] as l
	INNER JOIN dbo.City as c ON LEFT(l.[Name], CHARINDEX(' ', l.[Name]) - 1) = c.[Name]
where
	LocationTypeID in (1,2)
select * from dbo.City

select * from Location

--select
--	l.*
--,	LEFT(REPLACE(l.[Name], 'ATM ', ''), CHARINDEX(' ', REPLACE(l.[Name], 'ATM ', '')) - 1)
--,	c.ID
update
	l
set
	l.CityID = c.ID
from
	[Location] as l
	INNER JOIN dbo.City as c ON LEFT(REPLACE(l.[Name], 'ATM ', ''), CHARINDEX(' ', REPLACE(l.[Name], 'ATM ', '')) - 1) = c.[Name]
where
	l.LocationTypeID = 4
select * from dbo.City

----------------
select * from dbo.Employee
select * from City

select 100/14, 7*14, 7*12 + 8*2

update
	dbo.Employee
set
	CityID = 1
where
	ID between 1 and 7

update
	dbo.Employee
set
	CityID = 2
where
	ID between 8 and 14

update
	dbo.Employee
set
	CityID = 3
where
	ID between 15 and 21

update
	dbo.Employee
set
	CityID = 4
where
	ID between 22 and 28

update
	dbo.Employee
set
	CityID = 5
where
	ID between 29 and 35

update
	dbo.Employee
set
	CityID = 6
where
	ID between 36 and 42

update
	dbo.Employee
set
	CityID = 7
where
	ID between 43 and 49

update
	dbo.Employee
set
	CityID = 8
where
	ID between 50 and 56

update
	dbo.Employee
set
	CityID = 9
where
	ID between 57 and 63

update
	dbo.Employee
set
	CityID = 10
where
	ID between 64 and 70

update
	dbo.Employee
set
	CityID = 11
where
	ID between 71 and 77

update
	dbo.Employee
set
	CityID = 12
where
	ID between 78 and 84

update
	dbo.Employee
set
	CityID = 13
where
	ID between 85 and 92

update
	dbo.Employee
set
	CityID = 14
where
	ID between 93 and 100


select * from Employee

select * from dbo.Employee
where
	--ID >= 3 and ID <=5
	ID between 3 and 5




------------------
select top 5 * from dbo.Account order by ID
select * from dbo.AccountDetails where AccountID = 1 order by ID


update
	a
set
	CurrentBalance = (select sum(amount) from AccountDetails as ad where )
from
	dbo.Account as a

--select
--	a.*
--,	(select sum(Amount) from AccountDetails as ad where ad.AccountID = a.ID) as CurrentBalance2
update
	a
set
	a.CurrentBalance = (select sum(Amount) from AccountDetails as ad where ad.AccountID = a.ID)
from
	dbo.Account as a

---------------
select * from Account

--1. Update 10*CurrentBalance
--2. Update 60000 where CB=0 and Currency = MKD
--3. Update 1000 where CB=0 and Currency <> MKD

select distinct CurrencyID from Account where CurrentBalance is null

select * from Currency

------------

SELECT
	c.FirstName
,	c.LastName
,	(
		SELECT SUM(Amount)
		FROM
			AccountDetails as ad
			INNER JOIN dbo.[Location] as l ON ad.LocationID = l.ID
			INNER JOIN dbo.LocationType as lt ON l.LocationTypeID = lt.ID
		WHERE
			ad.AccountId = a.id
		and lt.Name = 'ATM'
	) as CurrentBalance2
,	cc.Name
FROM
	Customer as c
	INNER JOIN Account as a ON c.ID = a.CustomerId
	INNER JOIN Currency as cc ON cc.id = a.CurrencyId



	select * from Location where Name like 'ATM%'
	select * from LocationType 

