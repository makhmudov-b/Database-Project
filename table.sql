CREATE TABLE dbo.SubscriptionTypes
(
    ID INT NOT NULL,
    [NAME] NVARCHAR(32) NOT NULL,
    Description NVARCHAR(128) NOT NULL,
    PRIMARY Key (ID)
)
CREATE TABLE dbo.Countries
(
    ID INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(64) NOT NULL
)
CREATE TABLE dbo.Users
(
  UserID INT PRIMARY KEY NOT NULL,
  Preferences BIT,
  FirstName NVARCHAR(64) NOT NULL,
  SecondName NVARCHAR(64) NOT NULL,
  Email NVARCHAR(320) NOT NULL,
  Gender BIT NOT NULL,
  BirthdayDate DATE NOT NULL,
  CountryID INT NOT NULL,
  FOREIGN KEY (CountryID) REFERENCES dbo.Countries(ID),
  RegistrationDate DATE,
  ProneNumber NCHAR(12) NOT NULL,
  Address NVARCHAR(72) NOT NULL,
  UserInterfaceLanguage INT NOT NULL
)
CREATE TABLE dbo.UserSubscription
(
    ID INT PRIMARY Key NOT NULL,
    Email NVARCHAR(320) NOT NULL,
    LastPurchaseDate DATE NOT NULL,
    SubscriptionTypesID INT NOT NULL,
    FOREIGN KEY (SubscriptionTypesID) REFERENCES dbo.SubscriptionTypes(ID),
    PaymentsID INT NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)
