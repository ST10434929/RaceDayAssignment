# RaceDay API Endpoint Plan

## 1. Overview

The RaceDay API will provide RESTful endpoints for managing road running, walking and cycling events.

The system supports two user roles:
- Organiser
- Participant

Organisers can create and manage events, categories, participant enrolments and results.
Participants can create accounts, browse upcoming events, enter event categories, view their enrolments and track their personal results.

All API routes use the `/api/` prefix.

## 2. Authentication

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/auth/register` | Creates a new user account. | Public | `firstName`, `lastName`, `email`, `password`, `phoneNumber`, `role` | 201 Created, 400 Bad Request, 409 Conflict |
| POST | `/api/auth/login` | Authenticates a registered user. | Public | `email`, `password` | 200 OK, 400 Bad Request, 401 Unauthorized |

## 3. User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/users/profile` | Returns the profile of the currently authenticated user. | Organiser / Participant | None | 200 OK, 401 Unauthorized |
| PUT | `/api/users/profile` | Updates the authenticated user's profile details. | Organiser / Participant | `firstName`, `lastName`, `phoneNumber` | 200 OK, 400 Bad Request, 401 Unauthorized |

## 4. Events

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/events` | Returns a list of available events. | Public | None | 200 OK |
| GET | `/api/events/{id}` | Returns details for a specific event. | Public | None | 200 OK, 404 Not Found |
| POST | `/api/events` | Creates a new event. | Organiser | `eventName`, `description`, `eventDate`, `startTime`, `location`, `province`, `status` | 201 Created, 400 Bad Request, 401 Unauthorized, 403 Forbidden |
| PUT | `/api/events/{id}` | Updates an existing event. | Organiser | `eventName`, `description`, `eventDate`, `startTime`, `location`, `province`, `status` | 200 OK, 400 Bad Request, 403 Forbidden, 404 Not Found |
| DELETE | `/api/events/{id}` | Deletes an event. | Organiser | None | 204 No Content, 403 Forbidden, 404 Not Found |

## 5. Event Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/events/{eventId}/categories` | Returns all categories belonging to an event. | Public | None | 200 OK, 404 Not Found |
| GET | `/api/categories/{id}` | Returns details for a specific category. | Public | None | 200 OK, 404 Not Found |
| POST | `/api/events/{eventId}/categories` | Creates a category for an event. | Organiser | `categoryName`, `activityType`, `distanceKM`, `entryFee`, `maximumParticipants` | 201 Created, 400 Bad Request, 403 Forbidden, 404 Not Found |
| PUT | `/api/categories/{id}` | Updates an existing category. | Organiser | `categoryName`, `activityType`, `distanceKM`, `entryFee`, `maximumParticipants`, `isActive` | 200 OK, 400 Bad Request, 403 Forbidden, 404 Not Found |
| DELETE | `/api/categories/{id}` | Deletes a category. | Organiser | None | 204 No Content, 403 Forbidden, 404 Not Found |

## 6. Event Enrolments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/enrolments` | Enrols the authenticated participant in an event category. | Participant | `categoryId`, `emergencyContactName`, `emergencyContactPhone` | 201 Created, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict |
| GET | `/api/enrolments/mine` | Returns all enrolments belonging to the authenticated participant. | Participant | None | 200 OK, 401 Unauthorized |
| GET | `/api/events/{eventId}/enrolments` | Returns all enrolments for an event. | Organiser | None | 200 OK, 403 Forbidden, 404 Not Found |
| GET | `/api/enrolments/{id}` | Returns a specific enrolment belonging to the authenticated participant. | Participant | None | 200 OK, 401 Unauthorized, 404 Not Found |
| DELETE | `/api/enrolments/{id}` | Cancels a participant's enrolment. | Participant | None | 204 No Content, 401 Unauthorized, 404 Not Found |

## 7. Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/enrolments/{enrolmentId}/result` | Records a result for an enrolment. | Organiser | `finishTime`, `position`, `resultStatus` | 201 Created, 400 Bad Request, 403 Forbidden, 404 Not Found, 409 Conflict |
| PUT | `/api/results/{id}` | Updates an existing participant result. | Organiser | `finishTime`, `position`, `resultStatus` | 200 OK, 400 Bad Request, 403 Forbidden, 404 Not Found |
| GET | `/api/results/mine` | Returns the authenticated participant's results. | Participant | None | 200 OK, 401 Unauthorized |
| GET | `/api/events/{eventId}/results` | Returns all results for an event. | Organiser | None | 200 OK, 403 Forbidden, 404 Not Found |
| GET | `/api/results/{id}` | Returns a specific result. | Organiser / Participant | None | 200 OK, 403 Forbidden, 404 Not Found |

## 8. HTTP Response Codes

- 200 OK - Request completed successfully.
- 201 Created - A new resource was successfully created.
- 204 No Content - Resource was successfully deleted.
- 400 Bad Request - Invalid or incomplete request data.
- 401 Unauthorized - User is not authenticated.
- 403 Forbidden - Authenticated user does not have the required role or permission.
- 404 Not Found - Requested resource does not exist.
- 409 Conflict - Request conflicts with an existing resource or database constraint.

## 9. Organiser Permissions

- Create events.
- Edit events.
- Delete events.
- Create event categories.
- Edit event categories.
- Delete event categories.
- View enrolments for their events.
- Capture participant results.
- Update participant results.
- View event results.

## 10. Participant Permissions

- Create an account.
- Log in.
- Update their profile.
- Browse events.
- View event details.
- View event categories.
- Enrol in event categories.
- View their own enrolments.
- Cancel their enrolments.
- View their own results.

## 11. RESTful Design

GET retrieves information.

POST creates new resources.

PUT updates existing resources.

DELETE removes resources.

All routes begin with `/api/`.