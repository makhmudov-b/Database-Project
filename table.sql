CREATE TABLE dbo.SubscriptionTypes
(
    ID INT,
    [NAME] NVARCHAR(32),
    Description NVARCHAR(128),
    PRIMARY Key (ID)
)
CREATE TABLE dbo.Countries
(
    ID INT PRIMARY KEY,
    Name NVARCHAR(64)
)
CREATE TABLE dbo.Users
(
  UserID INT PRIMARY KEY,
  Preferences BIT,
  FirstName NVARCHAR(64),
  SecondName NVARCHAR(64),
  Email NVARCHAR(320),
  Gender BIT,
  BirthdayDate DATE,
  CountryID INT,
  FOREIGN KEY (CountryID) REFERENCES dbo.Countries(ID),
  RegistrationDate DATE,
  ProneNumber NCHAR(12),
  Address NVARCHAR(72),
  UserInterfaceLanguage INT
)
CREATE TABLE dbo.UserSubscription
(
    ID INT PRIMARY Key,
    Email NVARCHAR(320),
    LastPurchaseDate DATE,
    SubscriptionTypesID INT,
    FOREIGN KEY (SubscriptionTypesID) REFERENCES dbo.SubscriptionTypes(ID),
    PaymentsID INT,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)
