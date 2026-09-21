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

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    ActivityType NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Categories_ActivityType
        CHECK (ActivityType IN ('Running', 'Walking', 'Cycling')),
    DistanceKM DECIMAL(6,2) NOT NULL
        CONSTRAINT CK_Categories_Distance
        CHECK (DistanceKM > 0),
    EntryFee DECIMAL(10,2) NOT NULL
        CONSTRAINT CK_Categories_EntryFee
        CHECK (EntryFee >= 0),
    MaximumParticipants INT NOT NULL
        CONSTRAINT CK_Categories_MaxParticipants
        CHECK (MaximumParticipants > 0),
    IsActive BIT NOT NULL
        CONSTRAINT DF_Categories_IsActive
        DEFAULT 1,

    CONSTRAINT FK_Categories_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT UQ_Categories_Event_Category
        UNIQUE (EventID, CategoryName)
);
GO

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL
        CONSTRAINT DF_Enrolments_Date
        DEFAULT GETDATE(),
    EmergencyContactName NVARCHAR(100) NOT NULL,
    EmergencyContactPhone NVARCHAR(20) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Enrolments_Payment
        CHECK (PaymentStatus IN ('Pending', 'Paid', 'Refunded')),
    EnrolmentStatus NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Enrolments_Status
        CHECK (EnrolmentStatus IN ('Active', 'Cancelled')),

    CONSTRAINT FK_Enrolments_User
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT UQ_Enrolments_User_Category
        UNIQUE (UserID, CategoryID)
);
GO

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    Position INT NULL,
    ResultStatus NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Results_Status
        CHECK (ResultStatus IN
        ('Finished', 'DNF', 'DNS', 'Disqualified')),
    RecordedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Results_RecordedDate
        DEFAULT GETDATE(),

    CONSTRAINT CK_Results_Position
        CHECK (Position IS NULL OR Position > 0),

    CONSTRAINT FK_Results_Enrolment
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID)
);
GO

CREATE TABLE Routes
(
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL UNIQUE,
    StartPoint NVARCHAR(200) NOT NULL,
    FinishPoint NVARCHAR(200) NOT NULL,
    DistanceKM DECIMAL(6,2) NOT NULL
        CONSTRAINT CK_Routes_Distance
        CHECK (DistanceKM > 0),
    ElevationGainM INT NULL
        CONSTRAINT CK_Routes_Elevation
        CHECK (ElevationGainM IS NULL OR ElevationGainM >= 0),
    RouteDescription NVARCHAR(1000) NULL,
    MapURL NVARCHAR(500) NULL,

    CONSTRAINT FK_Routes_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
);
GO