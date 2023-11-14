DROP TABLE IF EXISTS #City;
DROP TABLE IF EXISTS #nums;

CREATE TABLE #City (Name nvarchar(100))
INSERT INTO #City values ('Skopje'),('Bitola'),('Ohrid'),('Kumanovo'),('Prilep'),('Resen')
GO

Create table #nums (id int, idText nvarchar(100))
insert into #nums
select top 100 row_Number() OVER (Order by (select 0)) as id, cast(row_Number() OVER (Order by (select 0)) as nvarchar(100)) as idText
FROM sys.objects


delete from dbo.AccountDetails where 1=1;
delete from dbo.Account where 1=1;
delete from dbo.Location where 1=1;
delete from dbo.LocationType where 1=1;
DELETE from dbo.Customer where 1=1;
DELETE from dbo.Currency where 1=1;
delete from dbo.Employee where 1=1;
GO

------ add rest of tables
--DBCC CHECKIDENT ('Employee', RESEED, 0)
--DBCC CHECKIDENT ('LocationType', RESEED, 0)
--DBCC CHECKIDENT ('Location', RESEED, 0)
--DBCC CHECKIDENT ('Currency', RESEED, 0)
--DBCC CHECKIDENT ('AccountDetails', RESEED, 0)
--DBCC CHECKIDENT ('Account', RESEED, 0)
--DBCC CHECKIDENT ('Customer', RESEED, 0)
--GO

insert into dbo.LocationType (Name,Description)
values ('Region Branch','Regional office')
GO


insert into dbo.LocationType (Name,Description)
values ('City Branch','City branch office')
GO

insert into dbo.LocationType (Name,Description)
values ('Internet','Internet from e-bank')
GO

insert into dbo.LocationType (Name,Description)
values ('ATM','ATM cash')
GO

insert into dbo.LocationType (Name,Description)
values ('Clearing House','Clearing House')
GO

--select * from dbo.locationType

-- location
insert into dbo.Location (LocationTypeId,Name)
values (1,'Bitola branch office'), (1,'Ohrid branch office'), (1,'Stip branch office'), (1,'Strumica branch office'), (1,'Veles branch office'), (1,'Tetovo branch office')
GO

insert into dbo.Location (LocationTypeId,Name)
values (2,'Kavadarci city branch office'), (2,'Negotino city branch office'), (2,'Kocani city branch office'), (2,'Gostivar city branch office')
GO

insert into dbo.Location (LocationTypeId,Name)
values (3,'E-bank'), (3,'M-bank')
GO

insert into dbo.Location (LocationTypeId,Name)
select 4 as LocationTypeId , 'ATM ' + c.Name + ' ' + n.idText
from #City c 
cross apply #nums n 
where n.id <= 10
order by c.Name

insert into dbo.Location (LocationTypeId,Name)
values (5,'KIBS'), (5,'MIPS')
GO

--select * from dbo.locationtype
--select * from Location

-- Employee

-- Employee table
declare @FirstName table (FirstName nvarchar(50))
insert into @FirstName values ('Dime'),('Ivan'),('Borce'),('Goce'),('Dimitar'),('Vaska'),('Nikola'),('Marija'),('Marina'),('Vesna')

declare @LastName table (LastName nvarchar(50))
insert into @LastName values ('Popovski'),('Petrovski'),('Nikolov'),('Dimitrov'),('Lazarov'),('Ristovski'),('Naumovski'),('Todorov'),('Trajanov'),('Petrov')

insert into dbo.Employee (FirstName,LastName,DateOfBirth,Gender,HireDate,NationalIdNumber)
select f.FirstName, l.LastName,'1900.01.01' as date, case when FirstName in ('Vaska','Marija','Marina','Vesna') then 'F' else 'M' end as Gender,'2015.01.01' as HireDate,1 as IdNumber
from @FirstName f
CROSS JOIN @LastName l
GO


update e set DateOfBirth = dateadd(MM,Id,DateOfBirth),  
			 HireDate = dateadd(MM,2*Id,'1990.01.01'), 
			 NationalIdNumber =  id + cast(10000000 * rand(id*10) as int)
from dbo.Employee e
GO


-- Customer data
declare @FirstName table (FirstName nvarchar(50))
insert into @FirstName values ('Aleksandra'),('Ana'),('Biljana'),('Biba'),('Branka'),('Viktorija'),('Violeta'),('Gordana'),('Gabriela'),('Galaba'),('Dushanka'),('Danka'),('Daniela'),('Dragana'),('Divna')
insert into @FirstName values ('Goce'),('Goran'),('Gligor'),('Gorast'),('Zlatko'),('Zivko'),('Ivan'),('Ilija'),('Jordan'),('Kire'),('Koco'),('Kristijan'),('Krsto'),('Kalin'),('Petar')

declare @LastName table (LastName nvarchar(50))
insert into @LastName values ('Atanasov'),('Aleksovski'),('Andonov'),('Bojcevski'),('Boskovski'),('Bojadzive'),('Gogov'),('Gligorov'),('Todorov'),('Trajkovski')


insert into dbo.customer (FirstName,LastName,DateOfBirth,Gender,NationalIdNumber, isActive)
select f.FirstName, l.LastName,'1900.01.01' as date, case when FirstName in ('Aleksandra','Ana','Biljana','Biba','Branka','Viktorija','Violeta','Gordana','Gabriela','Galaba','Dushanka','Danka','Daniela','Dragana','Divna') then 'F' else 'M' end as Gender,
1 as IdNumber, 1 as isActive
from @FirstName f
CROSS JOIN @LastName l

update e set DateOfBirth = dateadd(MM,Id,DateOfBirth),  
			 NationalIdNumber =  id + cast(10000000 * rand(id*10) as int),
			 City = case when id % 6 = 0 then 'Skopje' 
						 when id % 6 = 1 then 'Bitola' 
						 when id % 6 = 2 then 'Ohrid' 
						 when id % 6 = 3 then 'Kumanovo' 
						 when id % 6 = 4 then 'Prilep' 
						 when id % 6 = 5 then 'Resen' end
from dbo.customer e
GO

-- Currency rates
insert into dbo.Currency (code, Name, ShortName, CountryName) values ('807','Denar','MKD','REPUBLIC OF MACEDONIA')
insert into dbo.Currency (code, Name, ShortName, CountryName) values ('975','Bulgarian Lev','BGN','BULGARIA')
insert into dbo.Currency (code, Name, ShortName, CountryName) values ('941','Serbian Dinar','RSD','SERBIA')
insert into dbo.Currency (code, Name, ShortName, CountryName) values ('191','Kuna','HRK','CROATIA')
insert into dbo.Currency (code, Name, ShortName, CountryName) values ('978','Euro','EUR','GERMANY')
insert into dbo.Currency (code, Name, ShortName, CountryName) values ('840','US Dollar','USD','UNITED STATES OF AMERICA')
GO

-- Account

-- mkd and eur accounts
insert into dbo.Account (AccountNumber,CustomerId,CurrencyId,AllowedOverdraft,CurrentBalance,EmployeeId)
select '210123456789012' as AcctNum, c.id, e.id as CurrencyId, 10000 as AllowedOverDraft, 0 as CurrentBalance, 1 AS EmployeeId
from dbo.Customer c
cross apply dbo.Currency e
where e.code in ('807','978')

update A set AccountNumber = CAST((cast(AccountNumber AS BIGINT) + id) AS nvarchar(20)) ,
AllowedOverdraft = a.AllowedOverdraft + 100*id ,
EmployeeId = (select top 1 id from dbo.Employee e where e.id%100 = a.id%100)
from dbo.Account A

--select * from dbo.Account

-- Account Details

-- priliv

-- odliv

--select * from dbo.Currency
--select * from dbo.AccountDetails
--select * from dbo.Location


-- plata na denarska smetka
insert into dbo.AccountDetails
select a.id as AcctId, l.id as LocationId, null as EmployeeId,'2019.01.01' as TransactionDate,40000 + 25*a.id as Amount, '101' as purposeCode,'plata' as PurposeDescription
from dbo.Account a
cross apply dbo.Location l 
where l.name = 'MIPS'
and a.CurrencyId = 1

-- uplata kes na devizna smetka (eur)
insert into dbo.AccountDetails
select a.id as AcctId, l.id as LocationId, null as EmployeeId,'2019.01.01' as TransactionDate,1000 + l.Id*25 as Amount, '930' as purposeCode,'uplata na devizi' as PurposeDescription
from dbo.Account a
cross apply dbo.Location l 
where l.id %10 = a.id %100
and a.CurrencyId = 5

-- isplata od denarska smetka
insert into dbo.AccountDetails
select a.id as AcctId, l.id as LocationId, 
case when l.name like '%branch%' then (select top 1 id from dbo.Employee e where e.id%100 =  a.id %100) else null end as EmployeeId,
dateadd(dd,(a.id % 20 + l.id % 100),'2019.01.15')  as TransactionDate,- (972 + 13*l.Id) as Amount, '930' as purposeCode,'isplata' as PurposeDescription
from dbo.Account a
cross apply dbo.Location l 
where l.id %10 = a.id %10
and a.CurrencyId = 1

-- isplata od dev smetka
-- to do



---- sostojba
--select AccountId, sum(amount) 
--from dbo.AccountDetails
-- where 1=1 -- AccountId = 1
-- group by AccountId
-- order by 1 asc


select * from dbo.Employee
select * from dbo.currency
select * from dbo.customer
select * from dbo.Location
select * from dbo.LocationType
select * from dbo.Account
select * from dbo.AccountDetails




