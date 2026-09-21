CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    Role NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Organiser', 'Participant')),
    DateRegistered DATETIME2 NOT NULL
        CONSTRAINT DF_Users_DateRegistered
        DEFAULT GETDATE(),
    IsActive BIT NOT NULL
        CONSTRAINT DF_Users_IsActive
        DEFAULT 1
);
GO

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(1000) NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    Location NVARCHAR(150) NOT NULL,
    Province NVARCHAR(100) NOT NULL,
    Status NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Events_Status
        CHECK (Status IN
        ('Upcoming', 'Open', 'Closed', 'Completed', 'Cancelled')),
    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Events_CreatedDate
        DEFAULT GETDATE(),

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID)
);
GO