
# iShuliBus – Product and Development Backlog

## 1. Backlog Purpose

This document tracks proposed and completed
development work for iShuliBus.

It must be reconciled with the actual
GitHub Issues and source code.

Do not assume a task is implemented
only because it appears in this document.

## 2. Status Definitions

BACKLOG:
Task has not been approved for implementation.

PROPOSED:
Claude Code has explained the task.

APPROVED:
The owner has explicitly approved implementation.

IN_PROGRESS:
Implementation is underway.

IMPLEMENTED:
Code has been written, but owner review
may still be pending.

EXPLAINED:
Claude Code has explained the implementation.

REVIEW:
Waiting for owner verification.

DONE:
Owner has accepted the task.

BLOCKED:
Task cannot proceed due to a dependency.

HISTORICAL_COMPLETE:
Previously reported complete, but current
repository status has not been verified.

HISTORICAL_IN_PROGRESS:
Previously reported in progress, but current
repository status has not been verified.

## 3. Sprint 1 – Backend Foundation

### B01-01 – Spring Boot + Maven + Git Setup

Historical GitHub Issue: #1

Status:
HISTORICAL_COMPLETE

Tasks:

- Initialize Spring Boot
- Configure Java 21
- Configure Maven Wrapper
- Initialize Git
- Create repository structure
- Verify application startup

Acceptance Criteria:

- Project builds successfully.
- Application starts.
- Maven Wrapper works.
- Repository is version-controlled.

Verification:
Required.

### B01-02 – Application Configuration

Historical GitHub Issue: #2

Status:
HISTORICAL_COMPLETE

Tasks:

- Configure application properties
- Configure application profiles
- Configure basic logging
- Configure Actuator settings
- Prepare environment configuration

Acceptance Criteria:

- Configuration loads successfully.
- Environment-specific settings are supported.
- No secrets are committed.

Verification:
Required.

### B01-03 – Health Endpoint

Historical GitHub Issue: #3

Status:
HISTORICAL_IN_PROGRESS

Tasks:

- Review existing Actuator configuration
- Verify health endpoint behavior
- Define health endpoint expectations
- Add or complete tests
- Document endpoint behavior

Acceptance Criteria:

- Health endpoint responds successfully.
- Health checks behave as configured.
- Tests pass.
- No sensitive health details are exposed.

Next Action:
Inspect existing implementation before proposing changes.

### B01-04 – Global Exception Handling

Status:
BACKLOG

Tasks:

- Define application exception strategy
- Implement centralized exception handling
- Map errors to HTTP status codes
- Add exception tests

Acceptance Criteria:

- Common errors return consistent responses.
- Internal stack traces are not exposed.
- Tests cover relevant failure scenarios.

### B01-05 – API Response Conventions

Status:
BACKLOG

Tasks:

- Define response conventions
- Define error response DTOs
- Consider pagination response design
- Add tests

Acceptance Criteria:

- Response contracts are documented.
- Error responses are consistent.
- Unnecessary response wrappers are avoided.

## 4. Sprint 2 – Database Foundation

### B02-01 – PostgreSQL Configuration

Status:
BACKLOG

Tasks:

- Configure PostgreSQL datasource
- Configure environment variables
- Verify connection
- Add integration tests

### B02-02 – Supabase Integration

Status:
BACKLOG

Tasks:

- Review Supabase connection options
- Configure secure connectivity
- Verify development connection
- Document required environment variables

### B02-03 – Flyway Setup

Status:
BACKLOG

Tasks:

- Add Flyway dependency
- Configure migration directory
- Verify migration execution
- Add migration verification tests

### B02-04 – JPA Configuration

Status:
BACKLOG

Tasks:

- Configure JPA
- Review entity naming conventions
- Define transaction conventions
- Verify persistence integration

## 5. Sprint 3 – Authentication

### B03-01 – User Domain

Status:
BACKLOG

Tasks:

- Define User entity
- Define UserRepository
- Define user status
- Define role representation
- Add migration and tests

### B03-02 – Password Security

Status:
BACKLOG

Tasks:

- Configure password hashing
- Implement secure password verification
- Add tests

### B03-03 – JWT Service

Status:
BACKLOG

Tasks:

- Define token claims
- Implement token generation
- Implement token validation
- Configure token expiry
- Add tests

### B03-04 – Spring Security

Status:
BACKLOG

Tasks:

- Configure security filter chain
- Configure authentication
- Protect endpoints
- Add security tests

### B03-05 – Login API

Status:
BACKLOG

Tasks:

- Define login request DTO
- Implement authentication service
- Implement login endpoint
- Handle invalid credentials
- Add tests

## 6. Sprint 4 – Schools and Authorization

### B04-01 – School Entity

Status:
BACKLOG

### B04-02 – School Repository and Service

Status:
BACKLOG

### B04-03 – School Management API

Status:
BACKLOG

### B04-04 – Role-Based Authorization

Status:
BACKLOG

### B04-05 – School Tenant Isolation

Status:
BACKLOG

Acceptance Criteria:

- Schools cannot access unrelated school data.
- Administrative operations are protected.
- Authorization tests cover cross-school access.

## 7. Sprint 5 – Students and Parents

### B05-01 – Student Entity

Status:
BACKLOG

### B05-02 – Student Management API

Status:
BACKLOG

### B05-03 – Parent-Student Relationship

Status:
BACKLOG

### B05-04 – Transportation Enrollment

Status:
BACKLOG

### B05-05 – Parent Authorization Tests

Status:
BACKLOG

Acceptance Criteria:

- Parent access requires an authorized relationship.
- Students belong to schools.
- Student information is protected.

## 8. Sprint 6 – Drivers and Vehicles

### B06-01 – Driver Domain

Status:
BACKLOG

### B06-02 – Vehicle Domain

Status:
BACKLOG

### B06-03 – Driver Assignment

Status:
BACKLOG

### B06-04 – Vehicle Assignment

Status:
BACKLOG

### B06-05 – Driver and Vehicle Tests

Status:
BACKLOG

## 9. Sprint 7 – Routes

### B07-01 – Route Entity

Status:
BACKLOG

### B07-02 – Route Stop Entity

Status:
BACKLOG

### B07-03 – Route Management API

Status:
BACKLOG

### B07-04 – Student Route Assignment

Status:
BACKLOG

### B07-05 – Route Validation Tests

Status:
BACKLOG

## 10. Sprint 8 – Trips

### B08-01 – Trip Entity

Status:
BACKLOG

### B08-02 – Trip Creation

Status:
BACKLOG

### B08-03 – Trip State Transitions

Status:
BACKLOG

### B08-04 – Driver Trip Assignment

Status:
BACKLOG

### B08-05 – Trip Authorization and Tests

Status:
BACKLOG

## 11. Sprint 9 – GPS Tracking

### B09-01 – Location Data Model

Status:
BACKLOG

### B09-02 – Driver Location Update API

Status:
BACKLOG

### B09-03 – Current Location API

Status:
BACKLOG

### B09-04 – Tracking Authorization

Status:
BACKLOG

### B09-05 – Stale Location Handling

Status:
BACKLOG

### B09-06 – Location Retention Policy

Status:
BACKLOG

## 12. Sprint 10 – Boarding and Notifications

### B10-01 – Boarding Event Model

Status:
BACKLOG

### B10-02 – Boarding API

Status:
BACKLOG

### B10-03 – Drop-Off API

Status:
BACKLOG

### B10-04 – Notification Model

Status:
BACKLOG

### B10-05 – Push Notification Integration

Status:
BACKLOG

### B10-06 – Notification Tests

Status:
BACKLOG

## 13. Sprint 11 – Flutter Foundation

### B11-01 – Flutter Project Setup

Status:
BACKLOG

### B11-02 – API Client

Status:
BACKLOG

### B11-03 – Authentication Integration

Status:
BACKLOG

### B11-04 – Navigation

Status:
BACKLOG

### B11-05 – Localization

Status:
BACKLOG

### B11-06 – Shared UI Components

Status:
BACKLOG

## 14. Sprint 12 – Parent Application

### B12-01 – Parent Login Screen

Status:
BACKLOG

### B12-02 – Parent Dashboard

Status:
BACKLOG

### B12-03 – Student Transport Information

Status:
BACKLOG

### B12-04 – Live Tracking Screen

Status:
BACKLOG

### B12-05 – Boarding Status Screen

Status:
BACKLOG

### B12-06 – Parent Notifications

Status:
BACKLOG

## 15. Sprint 13 – Driver Application

### B13-01 – Driver Login

Status:
BACKLOG

### B13-02 – Assigned Trips Screen

Status:
BACKLOG

### B13-03 – Trip Start and Completion

Status:
BACKLOG

### B13-04 – GPS Permission Handling

Status:
BACKLOG

### B13-05 – Location Transmission

Status:
BACKLOG

### B13-06 – Boarding and Drop-Off Interface

Status:
BACKLOG

## 16. Sprint 14 – Integration and Pilot

### B14-01 – End-to-End Testing

Status:
BACKLOG

### B14-02 – Security Review

Status:
BACKLOG

### B14-03 – Performance Testing

Status:
BACKLOG

### B14-04 – School Administration Workflow

Status:
BACKLOG

### B14-05 – Deployment Preparation

Status:
BACKLOG

### B14-06 – Monitoring and Logging

Status:
BACKLOG

### B14-07 – Pilot Documentation

Status:
BACKLOG

### B14-08 – Privacy and Compliance Review

Status:
BACKLOG

## 17. Definition of Done

A development task is DONE only when:

1. The owner approved the implementation.
2. The agreed code was implemented.
3. Relevant tests were executed.
4. Test results were reported accurately.
5. The code was explained in German.
6. The owner reviewed the explanation.
7. The owner accepted the result.
8. Documentation was updated where necessary.

Git commits, pushes, merges, and deployments
require separate authorization.

## 18. Backlog Reconciliation Rules

When Claude Code starts:

1. Inspect actual source code.
2. Inspect Git history.
3. Inspect GitHub Issues if available.
4. Compare documented tasks with implementation.
5. Identify missing or outdated tasks.
6. Present a reconciliation report.
7. Propose changes to this backlog.
8. Wait for owner approval before editing it.

Do not automatically recreate existing issues.

Do not overwrite completed work.

## 19. Next Recommended Action

Perform a read-only audit of Sprint 1.

Pay particular attention to:

B01-03 – Health Endpoint.

Confirm whether it is:

- Not started
- Partially implemented
- Implemented but untested
- Fully implemented and tested

Then recommend the next task.

Do not begin implementation without approval.
