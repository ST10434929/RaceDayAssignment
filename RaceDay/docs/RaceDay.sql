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

INSERT INTO Users
(
    FirstName,
    LastName,
    Email,
    PasswordHash,
    PhoneNumber,
    Role
)
VALUES
('Thabo', 'Mokoena', 'thabo@raceday.co.za',
 'HASHED_PASSWORD_1', '0821111111', 'Organiser'),

('Lerato', 'Naidoo', 'lerato@raceday.co.za',
 'HASHED_PASSWORD_2', '0832222222', 'Organiser'),

('Aisha', 'Mthembu', 'aisha@example.com',
 'HASHED_PASSWORD_3', '0843333333', 'Participant'),

('Daniel', 'Jacobs', 'daniel@example.com',
 'HASHED_PASSWORD_4', '0854444444', 'Participant');
GO

INSERT INTO Events
(
    OrganiserID,
    EventName,
    Description,
    EventDate,
    StartTime,
    Location,
    Province,
    Status
)
VALUES
(
    1,
    'Pretoria City Run',
    'Annual road running event in Pretoria.',
    '2027-03-15',
    '07:00',
    'Pretoria',
    'Gauteng',
    'Open'
),
(
    1,
    'Johannesburg Charity Walk',
    'Community charity walking event.',
    '2027-04-10',
    '08:00',
    'Johannesburg',
    'Gauteng',
    'Upcoming'
),
(
    2,
    'Cape Cycle Challenge',
    'Road cycling event around Cape Town.',
    '2027-05-20',
    '06:30',
    'Cape Town',
    'Western Cape',
    'Upcoming'
);
GO

INSERT INTO Categories
(
    EventID,
    CategoryName,
    ActivityType,
    DistanceKM,
    EntryFee,
    MaximumParticipants
)
VALUES
(1, '10km Run', 'Running', 10.00, 150.00, 500),
(1, '5km Fun Run', 'Running', 5.00, 100.00, 700),
(2, '10km Walk', 'Walking', 10.00, 80.00, 400),
(2, '5km Family Walk', 'Walking', 5.00, 50.00, 500),
(3, '50km Cycle', 'Cycling', 50.00, 300.00, 300),
(3, '100km Cycle', 'Cycling', 100.00, 450.00, 250);
GO

INSERT INTO Routes
(
    EventID,
    StartPoint,
    FinishPoint,
    DistanceKM,
    ElevationGainM,
    RouteDescription,
    MapURL
)
VALUES
(
    1,
    'Union Buildings',
    'Church Square',
    10.00,
    120,
    'Urban Pretoria running route.',
    'https://example.com/pretoria-route'
),
(
    2,
    'Zoo Lake',
    'Zoo Lake',
    10.00,
    80,
    'Community walking route.',
    'https://example.com/johannesburg-route'
),
(
    3,
    'Cape Town Stadium',
    'Cape Town Stadium',
    100.00,
    850,
    'Road cycling route around Cape Town.',
    'https://example.com/cape-cycle-route'
);
GO

INSERT INTO Enrolments
(
    UserID,
    CategoryID,
    EmergencyContactName,
    EmergencyContactPhone,
    PaymentStatus,
    EnrolmentStatus
)
VALUES
(
    3,
    1,
    'Nomsa Mthembu',
    '0865555555',
    'Paid',
    'Active'
),
(
    3,
    3,
    'Nomsa Mthembu',
    '0865555555',
    'Paid',
    'Active'
),
(
    4,
    2,
    'Michael Jacobs',
    '0876666666',
    'Pending',
    'Active'
),
(
    4,
    5,
    'Michael Jacobs',
    '0876666666',
    'Paid',
    'Active'
);
GO
