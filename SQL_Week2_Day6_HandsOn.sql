

------------
SELECT
	c.FirstName, c.LastName, a.AccountNumber, a.CurrentBalance, curr.[Name]
FROM
	Customer as c
	LEFT OUTER JOIN Account as a on c.ID = a.CustomerId
	LEFT OUTER JOIN Currency as curr on curr.id = a.CurrencyID
ORDER BY a.ID

SELECT
	c.FirstName, c.LastName, a.AccountNumber, a.CurrentBalance, curr.[Name]
FROM
	Customer as c
	LEFT OUTER JOIN
	(
		Account as a
		INNER JOIN Currency as curr on a.CurrencyID = curr.id
	) ON c.ID = a.CustomerID
ORDER BY a.ID

-------------

insert into Customer (FirstName, LastName, IsActive)
values ('Bez smetka', 'Bez smetka', 1)

SELECT
	a.*, c.*
FROM
	dbo.Account as a
	INNER JOIN dbo.Customer as c ON a.CustomerID = c.ID
ORDER BY a.ID

SELECT
	a.*, c.*
FROM
	dbo.Customer as c
	INNER JOIN dbo.Account as a ON c.ID = a.CustomerID
ORDER BY a.ID
---
SELECT
	a.*, c.*
FROM
	dbo.Account as a
	LEFT OUTER JOIN dbo.Customer as c ON a.CustomerID = c.ID
ORDER BY a.ID

SELECT
	a.*, c.*
FROM
	dbo.Customer as c
	LEFT OUTER JOIN dbo.Account as a ON c.ID = a.CustomerID
ORDER BY a.ID

-----------------


----
select
	a.*, c.FirstName
from
	dbo.Account as a
	inner join dbo.Customer as c on a.CustomerID = c.ID

select
	a.*, (select FirstName from dbo.Customer as c where c.ID = a.CustomerID) as CutomerFirstName
from
	dbo.Account as a

-----
SELECT ID FROM Currency
INTERSECT
SELECT CurrencyID FROM Account

SELECT ID, (select count(*) from dbo.Account as ac where ac.CurrencyID = c.ID) as TotalAcountCurrency FROM Currency as c
INTERSECT
SELECT CurrencyID, (select count(*) from dbo.Account as ac where ac.CurrencyID = a.CurrencyID) as TotalAcountCurrency FROM Account as a




















