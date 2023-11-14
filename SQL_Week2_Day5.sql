
--------------------------
--List all informations for the account + FirstName and Gender of the customer

SELECT
	a.*, c.FirstName, c.Gender
FROM
	dbo.Account as a
	INNER JOIN dbo.Customer as c ON a.CustomerId = c.Id
ORDER BY
	a.id

------------------------------
--Get AccountNumber, CustomerFirstName, CustomerLastName, CustomerCity and CustomerDateOfBirth
--for all Customers born in March

SELECT
	a.AccountNumber, c.FirstName, c.LastName, c.City, c.DateOfBirth
FROM
	dbo.Account as a
	inner join dbo.Customer as c ON a.CustomerID = c.ID
WHERE
	Month(c.DateOfBirth) = 3

--------------------------


------------------------------
--List all Curreencies with an open account

SELECT DISTINCT
	c.*
FROM
	dbo.Currency as c
	INNER JOIN dbo.Account as a ON a.CurrencyId = c.ID

--List all Curreencies without an open account
SELECT
	c.*
FROM
	dbo.Currency as c
	LEFT OUTER JOIN dbo.Account as a ON c.id = a.CurrencyId
WHERE
	a.CurrencyId IS NULL

------------------------------
--List all MKD accounts. Show AccountNumber and CurrencyShortName

SELECT
	a.*, c.ShortName
FROM
	dbo.Account as a
	inner join dbo.Currency as c ON a.CurrencyId = c.id
WHERE
	c.ShortName = 'MKD'

--List all customers for which we don't have open accounts

SELECT
	*
FROM
	dbo.Customer as c
	left outer join dbo.Account as a ON c.ID = a.CustomerId
WHERE
	a.CustomerId IS NULL

