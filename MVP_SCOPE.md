
# iShuliBus – Minimum Viable Product Scope

## 1. MVP Objective

Build a usable pilot version of iShuliBus
for selected schools in Rwanda.

The MVP should demonstrate that:

1. Schools can manage transportation data.
2. Drivers can manage assigned trips.
3. Parents can monitor authorized trips.
4. Student boarding events can be recorded.
5. Parents can receive important notifications.
6. School data remains securely separated.

The MVP must be validated with real users
before commercial expansion.

## 2. MVP User Roles

The proposed MVP roles are:

- PLATFORM_ADMIN
- SCHOOL_ADMIN
- DRIVER
- PARENT

Students do not require personal accounts
during the initial MVP.

## 3. Authentication and Accounts

### Included

- Secure login
- Password hashing
- JWT authentication
- Role-based access control
- School-level authorization
- Logout behavior appropriate to token strategy
- Basic account activation and deactivation

### Acceptance Criteria

- Users can authenticate securely.
- Invalid credentials are rejected.
- Unauthorized endpoints are protected.
- Parents cannot access unrelated students.
- Schools cannot access other schools' data.

## 4. School Management

### Included

- Create school records
- View school details
- Update school information
- Activate or deactivate school accounts
- Assign school administrators

### Acceptance Criteria

- School records are persisted.
- Required fields are validated.
- Only authorized administrators can manage schools.

## 5. Student Management

### Included

- Register students
- Update student information
- Assign students to schools
- Link authorized parents to students
- Assign transportation routes
- Activate or deactivate transportation enrollment

### Acceptance Criteria

- Students belong to a school.
- Parents only access authorized children.
- Duplicate and invalid assignments are rejected.

## 6. Driver Management

### Included

- Register driver profiles
- Assign drivers to schools
- Assign drivers to vehicles or trips
- Activate or deactivate drivers

### Acceptance Criteria

- Drivers can view assigned trips.
- Drivers cannot modify unrelated trips.
- Inactive drivers cannot start new trips.

## 7. Vehicle Management

### Included

- Register vehicles
- Update vehicle information
- Store passenger capacity
- Assign vehicles to schools
- Manage vehicle status

### Acceptance Criteria

- Vehicles belong to the correct school.
- Invalid capacity values are rejected.
- Inactive vehicles cannot be assigned
  to new trips.

## 8. Route Management

### Included

- Create transportation routes
- Add route stops
- Define stop order
- Assign students to appropriate routes
- Associate routes with schools

### Acceptance Criteria

- Routes belong to schools.
- Stops have a defined order.
- Unauthorized route changes are rejected.

## 9. Trip Management

### Included

- Create trips
- Assign driver
- Assign vehicle
- Assign route
- Start trip
- Complete trip
- View trip status

Proposed trip statuses:

- SCHEDULED
- IN_PROGRESS
- COMPLETED
- CANCELLED

### Acceptance Criteria

- Only authorized drivers can start trips.
- Completed trips cannot be restarted
  without an approved business rule.
- Trip transitions are validated.
- Trip timestamps are recorded.

## 10. Live Bus Tracking

### Included

- Driver device location collection
- Periodic location updates
- Backend location endpoint
- Parent location viewing
- Timestamp of last location update
- Stale-location indication

### Acceptance Criteria

- Location updates are accepted only
  for authorized active trips.
- Parents see only relevant trips.
- Location data is transmitted securely.
- Old locations are not presented
  as current locations.
- GPS failure does not crash the app.

## 11. Boarding and Drop-Off

### Included

- Record student boarding
- Record student drop-off
- Store event timestamp
- Associate event with trip and student
- Display current boarding status

### Acceptance Criteria

- Only authorized users record events.
- Events belong to the correct trip.
- Duplicate events are handled consistently.
- Parents can see events for their own children.

## 12. Notifications

### Included

- Trip started
- Student boarded
- Student dropped off
- Important trip delay
- Trip completed, where relevant

### Acceptance Criteria

- Notifications target authorized recipients.
- Notification failures are logged safely.
- Duplicate notifications are controlled.
- Sensitive information is minimized.

## 13. Parent Mobile Experience

### Included

- Login
- Parent dashboard
- Child transportation information
- Assigned bus and route
- Active trip status
- Live bus location
- Boarding and drop-off status
- Notifications

### Acceptance Criteria

- Parents can navigate essential workflows.
- Unauthorized data is not visible.
- Missing network connectivity is handled gracefully.

## 14. Driver Mobile Experience

### Included

- Login
- Assigned trip list
- Trip details
- Start and end trip
- GPS permission handling
- Location sharing during active trips
- Boarding and drop-off recording

### Acceptance Criteria

- Driver can complete a basic trip workflow.
- GPS permissions are clearly explained.
- Location sharing stops when appropriate.
- Failed network requests are handled safely.

## 15. School Administration Interface

The administration interface is required
for a usable school pilot.

Its delivery approach is not finalized.

Possible approaches:

- Dedicated web dashboard
- Flutter-based administration interface
- Limited pilot administration tooling

A final choice requires owner approval.

Essential workflows must be available
before a real school pilot.

## 16. Localization

Initial languages:

- English
- Kinyarwanda

Requirements:

- Externalized user-facing strings
- Language selection
- Consistent translation keys
- Support for future languages

## 17. Subscription Management

The business model is based on active students.

For the MVP:

- Track transportation enrollment status
- Define active student counting rules
- Provide basic school-level counts
- Support manual billing operations

Automated payment collection is not
required for the initial technical pilot.

## 18. Explicitly Out of Scope

The following are deferred:

- AI route optimization
- Predictive arrival times using machine learning
- QR-code boarding
- Facial recognition
- Advanced fleet maintenance
- Complex accounting integrations
- Automated multi-country tax processing
- Fully automated subscription payments
- Advanced analytics dashboards
- Microservices architecture

Any addition requires a scope review.

## 19. Non-Functional Requirements

### Security

Protect student and location information.

### Reliability

Handle temporary network interruptions.

### Performance

Essential workflows should remain responsive
under realistic pilot conditions.

### Maintainability

Use clean architecture and automated tests.

### Privacy

Collect only necessary personal information.

### Localization

Support English and Kinyarwanda.

### Observability

Provide useful operational logs and health checks.

## 20. MVP Definition of Done

The MVP is ready for a controlled pilot when:

- Essential user workflows work end to end.
- Critical authorization tests pass.
- Student and school data isolation is verified.
- GPS tracking is sufficiently reliable.
- Notifications work for essential events.
- School administrators can manage pilot data.
- No known critical security defects remain.
- Deployment and recovery procedures exist.
- Pilot users receive basic onboarding.
- Applicable legal and privacy requirements
  have been reviewed.

The owner must approve pilot readiness.
