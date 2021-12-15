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
CREATE TABLE dbo.Languages
(
    ID INT PRIMARY KEY NOT NULL,
    NAME NVARCHAR(128) NOT NULL
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
  RegistrationDate DATE NOT NULL,
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
CREATE TABLE dbo.Purchases
(
    ID INT PRIMARY KEY NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    SubscriptionTypesID INT NOT NULL,
    FOREIGN KEY (SubscriptionTypesID) REFERENCES dbo.SubscriptionTypes(ID),
    PurchaseDateTime DATETIME NOT NULL,
    ShowPriceID INT NOT NULL,
    PurchaseSum DECIMAL(3, 2) NOT NULL,
    DebetCard BIT 
)
CREATE TABLE dbo.ShowsPrices
(
    ID INT PRIMARY KEY NOT NULL,
    ShowID INT NOT NULL,
    Price DECIMAL(3, 2) NOT NULL
)
CREATE TABLE dbo.UserReview
(
    ID INT NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    RatingID INT NOT NULL PRIMARY KEY, 
    ReviewText NVARCHAR(256) NOT NULL,
    Grade INT NOT NULL,
    CreationDateTime DATETIME NOT NULL,
    ModificationDateTime DATETIME NOT NULL
)
CREATE TABLE dbo.Shows
(
    ID INT NOT NULL PRIMARY KEY,
    RatingID INT NOT NULL,
    FOREIGN KEY (RatingID) REFERENCES dbo.UserReview(RatingID),
    Description NVARCHAR(256),
    TypeOfShow INT NOT NULL
)
CREATE TABLE dbo.PlaySession
(
    ID INT PRIMARY KEY NOT NULL,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    StartDateTime DATETIME NOT NULL,
    SessionLength REAL NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)
CREATE TABLE dbo.ChosenShows
(
    ID INT NOT NULL PRIMARY KEY,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    IsFavorite BIT 
)
CREATE TABLE dbo.ShowLanguage
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    LanguageID INT NOT NULL
    FOREIGN KEY (LanguageID) REFERENCES dbo.Languages(ID)
)
CREATE TABLE dbo.Trailers
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID)
)
CREATE TABLE dbo.ShowTypes
(
    ID INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(64) NOT NULL,
    [Description] NVARCHAR(64) NOT NULL
)
CREATE TABLE dbo.CountryOfProduction
(
    CountryOfProductionID INT NOT NULL PRIMARY KEY,
    CountryID INT NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES dbo.Countries(ID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID)
)
CREATE TABLE dbo.Genres
(
    ID INT NOT NULL PRIMARY KEY,
    Name NVARCHAR(126) NOT NULL,
    Description NVARCHAR(256) NOT NULL
)
CREATE TABLE dbo.Season
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Name NVARCHAR(128) NOT NULL
)
CREATE TABLE dbo.Episode
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Name NVARCHAR(128) NOT NULL,
    SeasonID INT NOT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID)
)
CREATE TABLE dbo.[Show/season/episodes/genre]
(
    ID INT NOT NULL PRIMARY KEY,
    GenreID INT NOT NULL,
    FOREIGN KEY (GenreID) REFERENCES dbo.Genres(ID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    SeasonID INT NOT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID)
)
CREATE TABLE dbo.Rating
(
    ID INT NOT NULL PRIMARY KEY,
    GradesID INT NOT NULL,
    FOREIGN KEY (GradesID) REFERENCES dbo.UserReview(RatingID),
    EpisodeID INT NOT NULL,
    FOREIGN KEY (EpisodeID) REFERENCES dbo.Episode(ID),
    SeasonID INT NOT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID) 
)
CREATE TABLE dbo.Positions
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Description NVARCHAR NOT NULL
)
CREATE TABLE dbo.Persona
(
    ID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(64) NOT NULL,
    SecondName VARCHAR(64) NOT NULL,
    BirthDate Date NOT NULL,
    DeathDate Date NOT NULL,
    Gender BIT,
    Description VARCHAR(256) NOT NULL
)
CREATE TABLE InSeasonPosition
(
    ID INT NOT NULL PRIMARY KEY,
    PersonaID INT NOT NULL,
    FOREIGN KEY (PersonaID) REFERENCES dbo.Persona(ID),
    SeasonID INT NOT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID),
    PositionID INT NOT NULL,
    FOREIGN KEY (PositionID) REFERENCES dbo.Positions(ID)
)
CREATE TABLE dbo.InEpisodePosition
(
    ID INT NOT NULL PRIMARY KEY,
    PersonaID INT NOT NULL,
    FOREIGN KEY (PersonaID) REFERENCES dbo.Persona(ID),
    EpisodeID INT NOT NULL,
    FOREIGN KEY (EpisodeID) REFERENCES dbo.Episode(ID),
    PositionID INT NOT NULL,
    FOREIGN KEY (PositionID) REFERENCES dbo.Positions(ID),
)
CREATE TABLE dbo.InShowPosition
(
    ID INT NOT NULL PRIMARY KEY,
    PersonaID INT NOT NULL,
    FOREIGN KEY (PersonaID) REFERENCES dbo.Persona(ID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    PositionID INT NOT NULL,
    FOREIGN KEY (PositionID) REFERENCES dbo.Positions(ID)
)

CREATE TABLE dbo.PersonaNationality
(
    ID INT NOT NULL PRIMARY KEY,
    PersonaID INT NOT NULL,
    FOREIGN KEY (PersonaID) REFERENCES dbo.Persona(ID),
    NationalityID INT NOT NULL,
    FOREIGN KEY (NationalityID) REFERENCES dbo.Countries(ID)
)