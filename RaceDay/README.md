# RaceDay


RaceDay is a computer-based event management system for road running, walking and cycling events.

System to organise events, categories, routes, enrolments and results. Participants can see events available and sign up for event categories and view results.

 Part 1

Part 1 is a discussion of initial planning and design of the database for the RaceDay system.

 A. Entity Relationship diagrams (ERD)

The ERD provides an overview of the database structure of the RaceDay system, including the main entities, attributes, primary keys, foreign keys, and relationships.

This is the final ERD which will be available here:

`docs/RaceDay-ERD.png`

 B. API Endpoint Plan

The plan for the REST API endpoint specifies what endpoints are needed for authentication, user profiles, events, categories, enrolments, and results.

The API endpoint documentation can be found here:

[API Endpoint Plan](docs/API-Endpoint-Plan.md)

 C. SQL Database Script

The SQL file will create the RaceDay database and tables, such as:

- Users
- Events
- Categories
- Enrolments
- Results
- Routes

Sample data and tests are also provided.

This SQL script can be found here:

[RaceDay SQL Script](docs/RaceDay.sql)

 Database Relationships

The main relationships in the RaceDay database are:

Many events can be managed by one organiser.
There may be multiple categories for one event.
- One participant can have many enrolments.
Many enrolments are possible for one category.
There may be 0 or 1 result in an enrolment.
- There are only one route per event.

 Technologies

- C
- .NET
- SQL Server
- REST API
- GitHub Actions
- GitHub

 Project Structure

```text
RaceDay
├── .github
│   └── workflows
│       └── part1-validation.yml
├── docs
│   ├── API-Endpoint-Plan.md
│   ├── RaceDay.sql
│   └── RaceDay-ERD.png
└── README.md

