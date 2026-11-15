
# iShuliBus – Development Roadmap

## 1. Development Strategy

Development follows an incremental approach.

Primary principles:

- One task at a time
- Explain before implementation
- Obtain owner approval
- Implement the approved scope
- Write and run tests
- Explain the completed code
- Wait for owner review
- Update documentation and backlog

The owner aims to spend approximately
one hour per day on development.

Sprint duration is flexible.

The 14-sprint plan is a planning baseline,
not a commitment to fixed delivery dates.

## 2. Project Phases

Phase 1:
Backend foundation

Phase 2:
Authentication and core domain

Phase 3:
Transportation operations

Phase 4:
GPS and notifications

Phase 5:
Flutter mobile application

Phase 6:
Testing, deployment, and pilot

## 3. Sprint 1 – Backend Foundation

Objectives:

- Initialize Spring Boot
- Configure Maven
- Configure Git
- Configure application properties
- Configure development profiles
- Implement health checks
- Establish common error handling
- Establish API response conventions
- Prepare automated tests

Historical progress:

Issue #1:
Spring Boot + Maven + Git Setup
Reported complete.

Issue #2:
Application Configuration
Reported complete.

Issue #3:
Health Endpoint
Previously in progress.

Actual status must be verified.

Deliverable:
Stable backend foundation.

## 4. Sprint 2 – Database Foundation

Objectives:

- Configure PostgreSQL connection
- Configure Supabase connectivity
- Introduce Flyway
- Establish migration conventions
- Configure JPA
- Verify database connectivity
- Add database integration tests

Deliverable:
Version-controlled database foundation.

## 5. Sprint 3 – Authentication

Objectives:

- User entity
- User repository
- Password hashing
- Authentication service
- JWT service
- Spring Security configuration
- Login endpoint
- Authentication tests

Deliverable:
Secure backend authentication.

## 6. Sprint 4 – Authorization and Schools

Objectives:

- Role model
- Role-based authorization
- School entity
- School management API
- School administrator assignment
- Tenant isolation rules
- Authorization tests

Deliverable:
Secure multi-school foundation.

## 7. Sprint 5 – Students and Parents

Objectives:

- Student entity
- Student management API
- Parent-student relationship
- Authorized guardian access
- Transportation enrollment
- Student access control tests

Deliverable:
Student and guardian management.

## 8. Sprint 6 – Drivers and Vehicles

Objectives:

- Driver profiles
- Vehicle entity
- Driver assignment
- Vehicle assignment
- Capacity validation
- Driver authorization

Deliverable:
Driver and vehicle administration.

## 9. Sprint 7 – Routes and Stops

Objectives:

- Route entity
- Route stops
- Stop ordering
- Student route assignment
- Route APIs
- Route validation tests

Deliverable:
School transportation route management.

## 10. Sprint 8 – Trip Management

Objectives:

- Trip entity
- Trip creation
- Trip assignment
- Trip state machine
- Start trip
- Complete trip
- Trip authorization
- Trip tests

Deliverable:
Operational trip lifecycle.

## 11. Sprint 9 – GPS Tracking

Objectives:

- Driver location submission
- Active trip validation
- Current vehicle location
- Parent location access
- Stale location detection
- Tracking authorization tests
- Data retention design

Deliverable:
Backend-supported bus tracking.

## 12. Sprint 10 – Boarding and Notifications

Objectives:

- Boarding events
- Drop-off events
- Event validation
- Notification model
- Push notification integration
- Notification delivery handling
- Notification tests

Deliverable:
Student transport event visibility.

## 13. Sprint 11 – Flutter Foundation

Objectives:

- Flutter project configuration
- Environment configuration
- Navigation
- API client
- Authentication integration
- Secure token handling
- Localization foundation
- Shared UI components

Deliverable:
Functional mobile application foundation.

## 14. Sprint 12 – Parent Experience

Objectives:

- Parent login
- Parent dashboard
- Student information
- Assigned route
- Active trip tracking
- Boarding status
- Notification display
- Error and loading states

Deliverable:
Usable parent mobile experience.

## 15. Sprint 13 – Driver Experience

Objectives:

- Driver login
- Assigned trips
- Start trip
- End trip
- GPS permission handling
- Location updates
- Boarding and drop-off actions
- Network failure handling

Deliverable:
Usable driver mobile experience.

## 16. Sprint 14 – Integration and Pilot Readiness

Objectives:

- End-to-end tests
- Security review
- Tenant isolation verification
- Performance evaluation
- Mobile device testing
- School administration workflow
- Deployment preparation
- Monitoring
- Pilot documentation
- Privacy and regulatory review

Deliverable:
Controlled pilot candidate.

## 17. Cross-Sprint Requirements

The following apply to every sprint:

- Code review
- Security considerations
- Automated testing
- Documentation updates
- API contract consistency
- Owner approval
- Code explanation

## 18. Development Milestones

Milestone 1:
Backend foundation complete.

Milestone 2:
Secure user and school management.

Milestone 3:
Transportation domain complete.

Milestone 4:
Live tracking and notifications.

Milestone 5:
Mobile workflows integrated.

Milestone 6:
Pilot-ready release candidate.

## 19. GitHub Workflow

Each task should have:

- Issue title
- Description
- Acceptance criteria
- Implementation plan
- Tests
- Definition of done

Suggested workflow:

Backlog
-> Proposed
-> Approved
-> In Progress
-> Implemented
-> Explained
-> Owner Review
-> Done

Do not move an issue to Done
without owner confirmation.

## 20. Progress Reporting

At the end of each approved task,
Claude Code should report:

1. Task name
2. Implementation summary
3. Changed files
4. Tests executed
5. Test results
6. Known limitations
7. Code explanation
8. Remaining questions

Do not automatically start the next task.

## 21. Roadmap Change Management

If a new requirement appears:

1. Explain its purpose.
2. Determine MVP relevance.
3. Evaluate dependencies.
4. Estimate complexity.
5. Identify affected sprints.
6. Recommend prioritization.
7. Request owner approval.

The roadmap must evolve based on
actual development progress.
