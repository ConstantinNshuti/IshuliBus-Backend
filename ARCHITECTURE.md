
# iShuliBus – Technical Architecture

## 1. Architecture Overview

iShuliBus follows a mobile-first,
API-driven architecture.

High-level architecture:

Flutter Mobile Application
|
| HTTPS / REST / JSON
|
v
Spring Boot Backend
|
| Spring Data JPA
|
v
PostgreSQL Database
Hosted through Supabase

Additional planned integrations:

- Push notification provider
- Device location services
- Mapping provider
- Email provider
- Future payment provider

## 2. Architecture Style

Recommended architecture:

Modular Monolith

Reasons:

- Simpler development
- Easier testing
- Lower infrastructure complexity
- Lower initial operating costs
- Easier deployment
- Appropriate for an early-stage MVP

Microservices are not currently required.

## 3. Backend Technology Stack

Language:
Java 21

Framework:
Spring Boot 4.1.1

Build Tool:
Maven Wrapper

Database:
PostgreSQL

Database Hosting:
Supabase

Persistence:
Spring Data JPA / Hibernate

Database Migrations:
Flyway

Security:
Spring Security

Authentication:
JWT

Validation:
Jakarta Bean Validation

Testing:
JUnit 5 and Spring Boot Test

Monitoring:
Spring Boot Actuator

API Documentation:
OpenAPI / Swagger, subject to dependency
compatibility verification.

These technologies describe the target stack.
Inspect the repository before assuming
all dependencies are already installed.

## 4. Mobile Technology Stack

Framework:
Flutter

Language:
Dart

Target Platforms:

- Android
- iOS

Mobile responsibilities:

- User authentication
- Parent dashboard
- Driver dashboard
- Trip information
- Live location display
- Notifications
- Localization

## 5. Backend Package Structure

Suggested package structure:

com.example.ishulibus

config/
common/
dto/
exception/
response/
security/
auth/
user/
school/
student/
parent/
driver/
vehicle/
route/
trip/
tracking/
notification/
subscription/

The final package name must be verified
against the actual existing repository.

Do not change the existing package structure
without owner approval.

## 6. Layered Design

Within each module:

Controller
|
v
Service
|
v
Repository
|
v
Database

### Controller

Responsibilities:

- Receive HTTP requests
- Validate request DTOs
- Delegate to services
- Return HTTP responses

Controllers should not contain
complex business logic.

### Service

Responsibilities:

- Implement business rules
- Coordinate operations
- Enforce domain-level constraints
- Manage transactions where appropriate

### Repository

Responsibilities:

- Database access
- Entity persistence
- Queries

### DTO

Responsibilities:

- Define API request and response contracts
- Separate external API models
  from persistence entities

### Entity

Responsibilities:

- Represent persisted domain data
- Define relationships and constraints

## 7. Proposed Domain Model

The following entities are proposed
and require implementation approval.

### User

Possible fields:

- id
- email
- passwordHash
- role
- status
- createdAt
- updatedAt

### School

Possible fields:

- id
- name
- address
- contactEmail
- phoneNumber
- status
- createdAt
- updatedAt

### Student

Possible fields:

- id
- schoolId
- firstName
- lastName
- status
- createdAt
- updatedAt

### ParentStudent

Relationship between authorized
parents or guardians and students.

Possible fields:

- id
- parentUserId
- studentId
- relationshipType
- authorizationStatus

### Driver

Possible fields:

- id
- schoolId
- userId
- status

### Vehicle

Possible fields:

- id
- schoolId
- registrationNumber
- capacity
- status

### Route

Possible fields:

- id
- schoolId
- name
- status

### RouteStop

Possible fields:

- id
- routeId
- name
- latitude
- longitude
- stopOrder

### Trip

Possible fields:

- id
- schoolId
- routeId
- vehicleId
- driverId
- status
- startedAt
- completedAt

### StudentTripEvent

Possible fields:

- id
- tripId
- studentId
- eventType
- eventTime
- recordedBy

Event types may include:

- BOARDED
- DROPPED_OFF

### VehicleLocation

Possible fields:

- id
- tripId
- latitude
- longitude
- recordedAt
- receivedAt

Retention policies must be defined
before collecting real location data.

## 8. Multi-Tenancy

Schools are separate organizational tenants.

Critical requirement:

A school must not access another school's data.

Recommended initial strategy:

Shared database with explicit school ownership
and application-level tenant isolation.

Every school-scoped operation must enforce
tenant authorization.

Do not rely only on frontend filtering.

Review whether additional database-level
controls are appropriate.

## 9. Authentication

Proposed authentication flow:

1. User submits credentials.
2. Backend validates credentials.
3. Backend issues a short-lived access token.
4. Mobile app stores credentials securely.
5. App sends Bearer token with API requests.
6. Backend validates token and authorization.

Refresh-token strategy requires
a separate security design decision.

Never store plaintext passwords.

Use a suitable password hashing algorithm.

## 10. Authorization

Proposed roles:

- PLATFORM_ADMIN
- SCHOOL_ADMIN
- DRIVER
- PARENT

Role alone is not sufficient.

Authorization must also verify:

- School ownership
- Student-parent relationship
- Assigned driver
- Assigned vehicle or trip
- Allowed access to location data

## 11. API Design

Base path proposal:

/api/v1

Example endpoints:

POST /api/v1/auth/login

GET /api/v1/schools/{id}

GET /api/v1/students

GET /api/v1/vehicles

GET /api/v1/routes

POST /api/v1/trips

POST /api/v1/trips/{id}/start

POST /api/v1/trips/{id}/complete

POST /api/v1/trips/{id}/locations

GET /api/v1/trips/{id}/location

POST /api/v1/trips/{id}/boarding-events

These endpoints are proposed contracts,
not confirmed implemented endpoints.

Use appropriate HTTP status codes.

Validate request bodies.

Return consistent error responses.

## 12. GPS Tracking

Initial MVP approach:

Driver application sends periodic
location updates to the backend.

Example flow:

Driver Device GPS
|
v
Flutter Driver App
|
v
HTTPS Location Update
|
v
Spring Boot API
|
v
Location Storage
|
v
Authorized Parent App

For the MVP, periodic polling may be
simpler than WebSocket infrastructure.

Update frequency must be tested
against battery, data cost, and reliability.

Requirements:

- Only active trips may publish locations.
- Only authorized drivers may update a trip.
- Only authorized parents and school staff
  may view relevant locations.
- Location timestamps must be preserved.
- Stale locations must be clearly identified.
- Unnecessary historical tracking must be avoided.

## 13. Notifications

Potential events:

- Trip started
- Bus delayed
- Student boarded
- Student dropped off
- Trip completed

Potential technologies:

- Firebase Cloud Messaging
- In-app notifications
- Future email notifications

Notification provider selection
requires implementation approval.

Notifications must not disclose
unnecessary student information.

## 14. Database Migrations

Use Flyway for versioned schema changes.

Example:

src/main/resources/db/migration/

V1__create_users.sql
V2__create_schools.sql
V3__create_students.sql

These filenames are examples only.

Never create migrations with duplicate
versions already present in the repository.

Never modify an applied production migration.

Always inspect existing migration history.

## 15. Error Handling

Use consistent error handling.

Recommended approach:

- Centralized exception handling
- Input validation
- Meaningful HTTP status codes
- Safe error messages
- No stack traces exposed to clients
- Structured server-side logging

## 16. Testing Strategy

### Unit Tests

Test business rules and services.

### Integration Tests

Test:

- Database persistence
- Security rules
- API behavior
- School data isolation

### Mobile Tests

Test:

- Widget behavior
- Authentication flow
- State transitions
- Localization
- GPS permission handling

### End-to-End Tests

Test complete workflows such as:

Driver starts trip
-> Location updates
-> Parent sees bus
-> Boarding event recorded
-> Parent receives notification

## 17. Security and Privacy

iShuliBus processes sensitive information
about children and transportation.

Required principles:

- Data minimization
- Secure authentication
- Tenant isolation
- Least privilege
- HTTPS
- Auditability
- Restricted location access
- Defined data retention
- Secure secret management
- Appropriate consent and legal basis

Applicable Rwandan data protection
requirements must be reviewed
before a real-world pilot.

## 18. Deployment

Deployment architecture is not finalized.

Potential components:

- Managed Spring Boot hosting
- Supabase PostgreSQL
- Secure environment variables
- HTTPS endpoint
- CI/CD pipeline
- Monitoring and logging

Production deployment requires
a separate approved plan.

## 19. Architectural Decision Process

Before introducing major changes:

1. Explain the current problem.
2. Present alternatives.
3. Compare tradeoffs.
4. Recommend one option.
5. Request approval.
6. Implement only after approval.
7. Document the decision.

Do not introduce new infrastructure
or frameworks without justification.
