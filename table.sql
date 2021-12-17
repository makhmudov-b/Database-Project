------------------------- Head of the queries----------------------------------

-- Table with all unique types of subcriptions --
CREATE TABLE dbo.SubscriptionTypes
(
    ID INT PRIMARY KEY NOT NULL,
    [NAME] NVARCHAR(32) NOT NULL,
    Description NVARCHAR(128) NOT NULL, -- description of the subsription
)
-- Tabel for all countries (used for metrics and stuff) --
CREATE TABLE dbo.Countries
(
    ID INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(64) NOT NULL
)
-- Table of all available languages for the shows --
CREATE TABLE dbo.Languages
(
    ID INT PRIMARY KEY NOT NULL,
    NAME NVARCHAR(128) NOT NULL
)

-- Table of every user with his info --
CREATE TABLE dbo.Users
(
  UserID INT PRIMARY KEY NOT NULL,
  Preferences BIT, 
  FirstName NVARCHAR(64) NOT NULL,
  SecondName NVARCHAR(64) NOT NULL,
  Email NVARCHAR(320) NOT NULL,
  Gender BIT NOT NULL, --male or female, we are conservative
  BirthdayDate DATE NOT NULL,
  CountryID INT NOT NULL,
  FOREIGN KEY (CountryID) REFERENCES dbo.Countries(ID),
  RegistrationDate DATE NOT NULL,
  PhoneNumber NCHAR(12) NOT NULL,
  Address NVARCHAR(72) NOT NULL,
  UserInterfaceLanguage INT NOT NULL
  FOREIGN KEY (UserInterfaceLanguage) REFERENCES dbo.Languages(ID)
)

-- The table of subsriptions assgined to users --
CREATE TABLE dbo.UserSubscription
(
    ID INT PRIMARY Key NOT NULL,
    Email NVARCHAR(320) NOT NULL,
    LastPurchaseDate DATE NOT NULL, --inserted while the new subscription is bought or renewed
    SubscriptionTypeID INT NOT NULL,
    FOREIGN KEY (SubscriptionTypeID) REFERENCES dbo.SubscriptionTypes(ID),
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)

-- The table for all purchases in the system --
CREATE TABLE dbo.Purchases
(
    ID INT PRIMARY KEY NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    SubscriptionTypeID INT NULL, -- could be show either subsription
    FOREIGN KEY (SubscriptionTypeID) REFERENCES dbo.SubscriptionTypes(ID),
    PurchaseDateTime DATETIME NOT NULL,
    ShowPriceID INT NULL, -- could be show either subsription (used XOR down here)
    FOREIGN KEY (ShowPriceID) REFERENCES dbo.ShowsPrices(ID),
    PurchaseSum DECIMAL(4, 2) NOT NULL,
    DebetCard BIT,
    CHECK (
        (SubscriptionTypeID IS NULL AND ShowPriceID IS NOT NULL)
        OR (SubscriptionTypeID IS NOT NULL AND ShowPriceID IS NULL)
    ) --show or sub checker
)

-- The table for the shows --
CREATE TABLE dbo.ShowsPrices
(
    ID INT PRIMARY KEY NOT NULL,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Price DECIMAL(4, 2) NOT NULL
)

-- The table of all reviews --
CREATE TABLE dbo.UserReview
(
    ID INT NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    RatingID INT NOT NULL PRIMARY KEY, 
    FOREIGN KEY (RatingID) REFERENCES dbo.Rating(ID), --connection to the rating stats to calculate
    ReviewText NVARCHAR(256) NOT NULL,
    Grade INT NOT NULL,
    CreationDateTime DATETIME NOT NULL,
    ModificationDateTime DATETIME NOT NULL
)

--The table for all shows --
CREATE TABLE dbo.Shows
(
    ID INT NOT NULL PRIMARY KEY,
    RatingID INT NOT NULL,
    FOREIGN KEY (RatingID) REFERENCES dbo.UserReview(RatingID), -- connect for metrics
    Description NVARCHAR(256),
    TypeOfShow INT NOT NULL -- series, film, and could be upgraded to podcasts or talk show
    FOREIGN KEY (TypeOfShow) REFERENCES dbo.ShowTypes(ID)
)

-- The table for all unique session (for metrics, of course) --
CREATE TABLE dbo.PlaySession
(
    ID INT PRIMARY KEY NOT NULL,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    StartDateTime DATETIME NOT NULL,
    SessionLength REAL NOT NULL, -- measured in minutes
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)

-- The table for liked or disliked shows of the user (for metrics, of course) --
CREATE TABLE dbo.ChosenShows
(
    ID INT NOT NULL PRIMARY KEY,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    IsFavorite BIT -- 1 is liked, 0 is disliked
)


--The table for the available languages for each show --
CREATE TABLE dbo.ShowLanguage
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    LanguageID INT NOT NULL
    FOREIGN KEY (LanguageID) REFERENCES dbo.Languages(ID)
)

-- The table for trailers for each show --
CREATE TABLE dbo.Trailers
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID)
)

-- The table for all possible types of a show (series, short or full movies etc.)
CREATE TABLE dbo.ShowTypes
(
    ID INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(64) NOT NULL,
    [Description] NVARCHAR(128) NOT NULL
)

-- Table of countries where show was made --
CREATE TABLE dbo.CountryOfProduction
(
    CountryOfProductionID INT NOT NULL PRIMARY KEY,
    CountryID INT NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES dbo.Countries(ID),
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID)
)

-- The table of all possible genres --
CREATE TABLE dbo.Genres
(
    ID INT NOT NULL PRIMARY KEY,
    Name NVARCHAR(126) NOT NULL,
    Description NVARCHAR(256) NOT NULL
)

-- The table of seasons of series --
CREATE TABLE dbo.Season
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Name NVARCHAR(128) NOT NULL
)

-- The table of episodes of show's seasons
CREATE TABLE dbo.Episode
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Name NVARCHAR(128) NOT NULL,
    SeasonID INT NOT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID)
)

-- The collection of assigned genre for specific media piece --
CREATE TABLE dbo.[Show/season/episodes genre]
(
    ID INT NOT NULL PRIMARY KEY,
    GenreID INT NOT NULL,
    FOREIGN KEY (GenreID) REFERENCES dbo.Genres(ID),
    ShowID INT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    SeasonID INT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID),
    EpisodeID INT NULL,
    FOREIGN KEY (EpisodeID) REFERENCES dbo.Episodes(ID),
    CHECK (
        2 = (CASE WHEN ShowID IS NULL THEN 1 ELSE 0 END ) +
        (CASE WHEN SeasonID IS NULL THEN 1 ELSE 0 END ) +
        (CASE WHEN EpisodeID IS NULL THEN 1 ELSE 0 END )
    ) --checking so the row would be for specific piece of media so it wont mess up
)

-- The total rating of each piece of media --
CREATE TABLE dbo.Rating
(
    ID INT NOT NULL PRIMARY KEY,
    EpisodeID INT NULL,
    FOREIGN KEY (EpisodeID) REFERENCES dbo.Episode(ID),
    SeasonID INT NULL,
    FOREIGN KEY (SeasonID) REFERENCES dbo.Season(ID),
    ShowID INT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Grade DECIMAL(4,2),
    CHECK (
        2 = (CASE WHEN ShowID IS NULL THEN 1 ELSE 0 END ) +
        (CASE WHEN SeasonID IS NULL THEN 1 ELSE 0 END ) +
        (CASE WHEN EpisodeID IS NULL THEN 1 ELSE 0 END )
    )--checking so the row would be for specific piece of media so it wont mess up
)

-- Table for possible position of a person (like writer, producer or actor)--
CREATE TABLE dbo.Positions
(
    ID INT NOT NULL PRIMARY KEY,
    ShowID INT NOT NULL,
    FOREIGN KEY (ShowID) REFERENCES dbo.Shows(ID),
    Description NVARCHAR(128) NOT NULL 
)

-- The table of cinema celebreties --
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

-- The table of person in season position ---
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

-- The table of person in episode position ---
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

-- The table of person in show position ---
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

-- Nationalities of each celebrety --
CREATE TABLE dbo.PersonaNationality
(
    ID INT NOT NULL PRIMARY KEY,
    PersonaID INT NOT NULL,
    FOREIGN KEY (PersonaID) REFERENCES dbo.Persona(ID),
    NationalityID INT NOT NULL,
    FOREIGN KEY (NationalityID) REFERENCES dbo.Countries(ID)
)