CREATE TABLE dbo.Employee
(
	ID int IDENTITY(1,1) NOT NULL
,	FirstName nvarchar(100) NOT NULL
,	LastName nvarchar(100) NOT NULL
,	NationalIDNumber nvarchar(15) NULL
,	JobTitle nvarchar(50) NULL
,	DateOfBirth date NULL
,	MaritalStatus nchar(1) NULL
,	Gender nchar(1) NULL
,	HireDate date NULL
,	CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED (ID ASC)
)
GO

CREATE TABLE dbo.Customer
(
	ID int IDENTITY(1,1) NOT NULL
,	FirstName nvarchar(100) NOT NULL
,	LastName nvarchar(100) NOT NULL
,	Gender nchar(1) NULL
,	NationalIDNumber nvarchar(15) NULL
,	DateOfBirth date NULL
,	City nvarchar(100) NULL
,	RegionName nvarchar(100) NULL
,	PhoneNumber nvarchar(20) NULL
,	IsActive bit NOT NULL
,	CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED (ID ASC)
)
GO

CREATE TABLE dbo.Currency
(
	ID int IDENTITY(1,1) NOT NULL
,	Code nvarchar(5) NULL
,	[Name] nvarchar(100) NULL
,	ShortName nvarchar(20) NULL
,	CountryName nvarchar(100) NULL
,	CONSTRAINT PK_Currency PRIMARY KEY CLUSTERED (ID ASC)
)
GO

CREATE TABLE dbo.LocationType
(
	ID int IDENTITY(1,1) NOT NULL
,	[Name] nvarchar(100) NOT NULL
,	[Description] nvarchar(1000) NULL
,	CONSTRAINT PK_LocationType PRIMARY KEY CLUSTERED (ID ASC)
)
GO

CREATE TABLE dbo.[Location]
(
	ID int IDENTITY(1,1) NOT NULL
,	LocationTypeID int NOT NULL
,	[Name] nvarchar(100) NOT NULL
,	[Description] nvarchar(1000) NULL
,	CONSTRAINT PK_Location PRIMARY KEY CLUSTERED (ID ASC)
)
GO

CREATE TABLE dbo.Account
(
	ID int IDENTITY(1,1) NOT NULL
,	AccountNumber nvarchar(20) NULL
,	CustomerID int NOT NULL
,	CurrencyID int NOT NULL
,	AllowedOverdraft decimal(18,2) NULL
,	CurrentBalance decimal(18,2) NULL
,	EmployeeID int NOT NULL
,	CONSTRAINT PK_Account PRIMARY KEY CLUSTERED (ID ASC)
)
GO

CREATE TABLE dbo.AccountDetails
(
	ID bigint IDENTITY(1,1) NOT NULL
,	AccountID int NOT NULL
,	LocationID int NOT NULL
,	EmployeeID int NULL
,	TransactionDate datetime NOT NULL
,	Amount decimal(18,2) NOT NULL
,	PurposeCode smallint NULL
,	PurposeDescription nvarchar(100) NULL
,	CONSTRAINT PK_AccountDetails PRIMARY KEY CLUSTERED (ID ASC)
)
GO

ALTER TABLE dbo.Account ADD CONSTRAINT FK_Account_Currency FOREIGN KEY (CurrencyID) REFERENCES dbo.Currency(ID)
GO



