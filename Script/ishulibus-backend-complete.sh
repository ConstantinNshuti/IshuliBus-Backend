#!/usr/bin/env bash
set -euo pipefail

# IshuliBus Backend - complete learning-oriented GitHub issue setup.
# Existing issues with the exact same title are skipped.

command -v gh >/dev/null 2>&1 || { echo "FEHLER: gh CLI fehlt."; exit 1; }
gh auth status

OWNER="$(gh api user --jq '.login')"
REPO="$OWNER/IshuliBus-Backend"

if ! gh repo view "$REPO" >/dev/null 2>&1; then
  gh repo create "$REPO" --private --description "IshuliBus backend"
fi

label() {
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null
}
label "backend" "1D76DB" "Backend"
label "mvp" "0E8A16" "MVP"
label "post-mvp" "5319E7" "Post MVP"
label "feature" "A2EEEF" "Feature"
label "test" "FBCA04" "Tests"

milestone() {
  local title="$1"
  local found
  found="$(gh api "repos/$REPO/milestones?state=all&per_page=100" --jq ".[] | select(.title == \"$title\") | .number" | head -1)"
  if [ -z "$found" ]; then
    echo "CREATE Milestone: $title"
    gh api --method POST "repos/$REPO/milestones" -f title="$title" -f state="open" >/dev/null
  else
    echo "SKIP Milestone: $title"
  fi
}

issue() {
  local title="$1" milestone_title="$2" phase="$3" overview="$4" files="$5" code="$6" branch="$7"
  local found
  found="$(gh issue list --repo "$REPO" --state all --limit 500 --json title --jq ".[] | select(.title == \"$title\") | .title" | head -1)"
  if [ -n "$found" ]; then
    echo "SKIP Issue: $title"
    return
  fi
  echo "CREATE Issue: $title"
  gh issue create --repo "$REPO" --title "$title" --label "backend,$phase" --milestone "$milestone_title" --body "$(cat <<EOF
## 🎯 Ziel

**$title** konkret umsetzen.

## 🧠 Überblick – Was bauen wir?

**$overview**

Das Issue ist bewusst klein gehalten. Ziel ist, diesen Baustein zu verstehen, umzusetzen und zu testen, bevor die nächste Funktion begonnen wird.

## 🔗 Zusammenhang mit IshuliBus

IshuliBus ist eine Multi-Tenant-Schultransport-Plattform. Der Baustein muss deshalb – wo fachlich relevant – Schule (`school_id`), Benutzerrolle und bestehende Beziehungen wie Route → Trip → Tracking berücksichtigen.

## 📁 Dateien / Packages

\`\`\`text
$files
\`\`\`

## 💻 Beispielcode / Startpunkt

> Der Code ist ein Startpunkt zum Lernen und Anpassen, nicht blindes Copy/Paste.

\`\`\`
$code
\`\`\`

## 🛠 Aufgaben

- [ ] Überblick und Abhängigkeiten verstehen
- [ ] Dateien/Packages anlegen
- [ ] Beispielcode an das aktuelle Projekt anpassen
- [ ] Fachlogik implementieren
- [ ] Eingaben validieren
- [ ] Rollen-/Tenant-Isolation prüfen, wenn relevant
- [ ] Fehlerfälle behandeln
- [ ] Unit- oder Integrationstest ergänzen
- [ ] Lokalen Build/Test erfolgreich ausführen

## 🧪 Test / Befehl

\`\`\`bash
./mvnw clean verify
\`\`\`

## ✅ Acceptance Criteria

- [ ] Das Ziel dieses Issues funktioniert
- [ ] Code liegt im vorgesehenen Package
- [ ] Validierung ist vorhanden, wenn Eingaben verarbeitet werden
- [ ] Autorisierung und `school_id` sind berücksichtigt, wenn relevant
- [ ] Fehlerfälle liefern kontrolliertes Verhalten
- [ ] Tests sind erfolgreich
- [ ] Keine Secrets sind committed
- [ ] Code ist committed und gepusht

## 🚫 Nicht Teil dieses Issues

Keine Funktionen aus späteren Issues/Sprints vorziehen.

## 🌿 Branch

\`\`\`text
$branch
\`\`\`

## 📦 Commit-Beispiel

\`\`\`bash
git commit -m "feat: $title"
\`\`\`

## ⏱️ Estimate

Ca. 1 fokussierte Entwicklungsstunde.
EOF
)"
}


milestone "Sprint B01 - Backend Foundation"
issue '[B01] Tag 1 - Spring Boot + Maven + Git Setup' 'Sprint B01 - Backend Foundation' 'mvp' 'Projektbasis' 'pom.xml
src/main/java/com/ishulibus/IshuliBusApplication.java' '@SpringBootApplication
public class IshuliBusApplication {
    public static void main(String[] args) {
        SpringApplication.run(IshuliBusApplication.class, args);
    }
}' 'feature/b01-01-spring-boot-maven-git-setup'
issue '[B01] Tag 2 - Application Configuration' 'Sprint B01 - Backend Foundation' 'mvp' 'Konfiguration' 'src/main/resources/application.yml
src/main/resources/application-dev.yml
.env.example' 'spring:
  application:
    name: ishulibus-backend
  profiles:
    active: ${SPRING_PROFILES_ACTIVE:dev}' 'feature/b01-02-application-configuration'
issue '[B01] Tag 3 - Health Endpoint' 'Sprint B01 - Backend Foundation' 'mvp' 'REST' 'src/main/java/com/ishulibus/common/controller/HealthController.java' '@RestController
@RequestMapping("/api")
public class HealthController {
    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP", "service", "ishulibus-backend");
    }
}' 'feature/b01-03-health-endpoint'
issue '[B01] Tag 4 - Global Exception Handling' 'Sprint B01 - Backend Foundation' 'mvp' 'Exception' 'src/main/java/com/ishulibus/exception/GlobalExceptionHandler.java' '@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<?> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
    }
}' 'feature/b01-04-global-exception-handling'
issue '[B01] Tag 5 - ApiResponse und PageResponse' 'Sprint B01 - Backend Foundation' 'mvp' 'DTO' 'src/main/java/com/ishulibus/common/dto/ApiResponse.java
src/main/java/com/ishulibus/common/dto/PageResponse.java' 'public record ApiResponse<T>(
    boolean success,
    String message,
    T data
) {}' 'feature/b01-05-apiresponse-und-pageresponse'
issue '[B01] Tag 6 - PostgreSQL / Supabase Anbindung' 'Sprint B01 - Backend Foundation' 'mvp' 'Datenbank' 'src/main/resources/application-dev.yml
.env.example' 'spring:
  datasource:
    url: ${DB_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}' 'feature/b01-06-postgresql-supabase-anbindung'
issue '[B01] Tag 7 - Flyway Setup' 'Sprint B01 - Backend Foundation' 'mvp' 'Migration' 'src/main/resources/db/migration/' '-- V1__baseline.sql
CREATE TABLE app_health_check (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);' 'feature/b01-07-flyway-setup'

milestone "Sprint B02 - School & Multi-Tenant Foundation"
issue '[B02] Tag 1 - School Entity und Migration' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'Entity' 'school/entity/School.java
db/migration/V2__create_schools.sql' '@Entity
@Table(name = "schools")
public class School {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(nullable = false)
    private String name;
}' 'feature/b02-01-school-entity-und-migration'
issue '[B02] Tag 2 - School Repository' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'Repository' 'school/repository/SchoolRepository.java' 'public interface SchoolRepository extends JpaRepository<School, UUID> {
    boolean existsByNameIgnoreCase(String name);
}' 'feature/b02-02-school-repository'
issue '[B02] Tag 3 - School DTOs und Mapper' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'DTO/Mapper' 'school/dto/SchoolRequest.java
school/dto/SchoolResponse.java
school/mapper/SchoolMapper.java' 'public record SchoolResponse(UUID id, String name) {}' 'feature/b02-03-school-dtos-und-mapper'
issue '[B02] Tag 4 - School Service' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'Service' 'school/service/SchoolService.java' '@Service
@RequiredArgsConstructor
public class SchoolService {
    private final SchoolRepository repository;
    public School find(UUID id) {
        return repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("School not found"));
    }
}' 'feature/b02-04-school-service'
issue '[B02] Tag 5 - School REST Controller' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'REST' 'school/controller/SchoolController.java' '@RestController
@RequestMapping("/api/v1/schools")
@RequiredArgsConstructor
public class SchoolController {
    private final SchoolService service;
    @GetMapping("/{id}")
    public School get(@PathVariable UUID id) { return service.find(id); }
}' 'feature/b02-05-school-rest-controller'
issue '[B02] Tag 6 - Multi-Tenant school_id Regeln' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'Security/Tenant' 'school/*
security/*' '// Niemals nur nach ID laden:
repository.findByIdAndSchoolId(resourceId, currentSchoolId);' 'feature/b02-06-multi-tenant-school-id-regeln'
issue '[B02] Tag 7 - School Integration Tests' 'Sprint B02 - School & Multi-Tenant Foundation' 'mvp' 'Test' 'src/test/java/com/ishulibus/school/' '@Test
void schoolA_mustNotAccessSchoolBData() {
    // Arrange two schools, authenticate A, request B resource -> 403/404
}' 'feature/b02-07-school-integration-tests'

milestone "Sprint B03 - Authentication & Security"
issue '[B03] Tag 1 - User Entity und Rollen' 'Sprint B03 - Authentication & Security' 'mvp' 'Entity/Security' 'user/entity/User.java
user/entity/Role.java' 'public enum Role {
    SUPER_ADMIN, SCHOOL_ADMIN, DRIVER, PARENT
}' 'feature/b03-01-user-entity-und-rollen'
issue '[B03] Tag 2 - User Repository und DTOs' 'Sprint B03 - Authentication & Security' 'mvp' 'Repository/DTO' 'user/repository/UserRepository.java
user/dto/' 'Optional<User> findByEmailIgnoreCase(String email);' 'feature/b03-02-user-repository-und-dtos'
issue '[B03] Tag 3 - Password Encoder und SecurityConfig' 'Sprint B03 - Authentication & Security' 'mvp' 'Security' 'config/SecurityConfig.java' '@Bean
PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}' 'feature/b03-03-password-encoder-und-securityconfig'
issue '[B03] Tag 4 - JWT Service' 'Sprint B03 - Authentication & Security' 'mvp' 'JWT' 'security/JwtService.java
config/JwtProperties.java' '@Service
public class JwtService {
    public String generateToken(UserDetails user) {
        // claims + subject + expiration + signature
        return "implement-with-jjwt";
    }
}' 'feature/b03-04-jwt-service'
issue '[B03] Tag 5 - Login und Authentication Endpoint' 'Sprint B03 - Authentication & Security' 'mvp' 'REST/Auth' 'auth/controller/AuthController.java
auth/dto/LoginRequest.java' '@PostMapping("/login")
public AuthResponse login(@Valid @RequestBody LoginRequest request) {
    return authService.login(request);
}' 'feature/b03-05-login-und-authentication-endpoint'
issue '[B03] Tag 6 - JWT Authentication Filter' 'Sprint B03 - Authentication & Security' 'mvp' 'Security' 'security/JwtAuthenticationFilter.java' 'public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest req,
        HttpServletResponse res, FilterChain chain) throws IOException, ServletException {
        chain.doFilter(req, res);
    }
}' 'feature/b03-06-jwt-authentication-filter'
issue '[B03] Tag 7 - Authorization und Security Tests' 'Sprint B03 - Authentication & Security' 'mvp' 'Test/Security' 'src/test/java/com/ishulibus/security/' '@Test
void unauthenticatedRequest_returns401() {
    // call protected endpoint without Bearer token
}' 'feature/b03-07-authorization-und-security-tests'

milestone "Sprint B04 - Driver Management"
issue '[B04] Tag 1 - Driver Entity und Migration' 'Sprint B04 - Driver Management' 'mvp' 'Entity' 'driver/entity/Driver.java
db/migration/V__create_drivers.sql' '@Entity
public class Driver {
    @Id private UUID id;
    @Column(nullable=false) private UUID schoolId;
    private String firstName;
    private String lastName;
}' 'feature/b04-01-driver-entity-und-migration'
issue '[B04] Tag 2 - Driver Repository' 'Sprint B04 - Driver Management' 'mvp' 'Repository' 'driver/repository/DriverRepository.java' 'Page<Driver> findAllBySchoolId(UUID schoolId, Pageable pageable);' 'feature/b04-02-driver-repository'
issue '[B04] Tag 3 - Driver DTOs und Mapper' 'Sprint B04 - Driver Management' 'mvp' 'DTO/Mapper' 'driver/dto/
driver/mapper/DriverMapper.java' 'public record DriverResponse(UUID id, String firstName, String lastName) {}' 'feature/b04-03-driver-dtos-und-mapper'
issue '[B04] Tag 4 - Driver Service' 'Sprint B04 - Driver Management' 'mvp' 'Service' 'driver/service/DriverService.java' 'public Driver get(UUID schoolId, UUID id) {
    return repository.findByIdAndSchoolId(id, schoolId)
        .orElseThrow(() -> new ResourceNotFoundException("Driver not found"));
}' 'feature/b04-04-driver-service'
issue '[B04] Tag 5 - Driver REST Controller' 'Sprint B04 - Driver Management' 'mvp' 'REST' 'driver/controller/DriverController.java' '@GetMapping
public PageResponse<DriverResponse> list(Pageable pageable) {
    return service.list(pageable);
}' 'feature/b04-05-driver-rest-controller'
issue '[B04] Tag 6 - Driver Validation und Tenant Security' 'Sprint B04 - Driver Management' 'mvp' 'Validation/Security' 'driver/dto/DriverRequest.java' 'public record DriverRequest(
    @NotBlank String firstName,
    @NotBlank String lastName,
    @Pattern(regexp="^\\+?[0-9]{7,15}$") String phone
) {}' 'feature/b04-06-driver-validation-und-tenant-security'
issue '[B04] Tag 7 - Driver Tests' 'Sprint B04 - Driver Management' 'mvp' 'Test' 'src/test/java/com/ishulibus/driver/' '@Test
void driverFromAnotherSchool_isNotVisible() { /* tenant isolation */ }' 'feature/b04-07-driver-tests'

milestone "Sprint B05 - Bus Management"
issue '[B05] Tag 1 - Bus Entity und Migration' 'Sprint B05 - Bus Management' 'mvp' 'Entity' 'bus/entity/Bus.java
db/migration/V__create_buses.sql' '@Entity
public class Bus {
    @Id private UUID id;
    private UUID schoolId;
    @Column(nullable=false) private String plateNumber;
    private Integer capacity;
}' 'feature/b05-01-bus-entity-und-migration'
issue '[B05] Tag 2 - Bus Repository' 'Sprint B05 - Bus Management' 'mvp' 'Repository' 'bus/repository/BusRepository.java' 'Optional<Bus> findByIdAndSchoolId(UUID id, UUID schoolId);' 'feature/b05-02-bus-repository'
issue '[B05] Tag 3 - Bus DTOs und Mapper' 'Sprint B05 - Bus Management' 'mvp' 'DTO/Mapper' 'bus/dto/
bus/mapper/BusMapper.java' 'public record BusResponse(UUID id, String plateNumber, Integer capacity) {}' 'feature/b05-03-bus-dtos-und-mapper'
issue '[B05] Tag 4 - Bus Service' 'Sprint B05 - Bus Management' 'mvp' 'Service' 'bus/service/BusService.java' 'public BusResponse create(UUID schoolId, BusRequest request) {
    // map -> set school -> save -> response
    return null;
}' 'feature/b05-04-bus-service'
issue '[B05] Tag 5 - Bus REST Controller' 'Sprint B05 - Bus Management' 'mvp' 'REST' 'bus/controller/BusController.java' '@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public BusResponse create(@Valid @RequestBody BusRequest request) {
    return service.create(currentSchoolId(), request);
}' 'feature/b05-05-bus-rest-controller'
issue '[B05] Tag 6 - Bus-Driver Assignment' 'Sprint B05 - Bus Management' 'mvp' 'Domain' 'bus/service/BusAssignmentService.java' 'public void assignDriver(UUID schoolId, UUID busId, UUID driverId) {
    // verify both belong to same school, then assign
}' 'feature/b05-06-bus-driver-assignment'
issue '[B05] Tag 7 - Bus Tests' 'Sprint B05 - Bus Management' 'mvp' 'Test' 'src/test/java/com/ishulibus/bus/' '@Test
void cannotAssignDriverFromDifferentSchool() { /* expect rejection */ }' 'feature/b05-07-bus-tests'

milestone "Sprint B06 - Parent & Student Management"
issue '[B06] Tag 1 - Parent und Student Entities' 'Sprint B06 - Parent & Student Management' 'mvp' 'Entity' 'parent/entity/Parent.java
student/entity/Student.java' '@Entity
public class Student {
    @Id private UUID id;
    private UUID schoolId;
    private String firstName;
    private String lastName;
    private boolean active;
}' 'feature/b06-01-parent-und-student-entities'
issue '[B06] Tag 2 - ParentStudent Junction Table' 'Sprint B06 - Parent & Student Management' 'mvp' 'Entity/DB' 'student/entity/ParentStudent.java
db/migration/V__create_parent_students.sql' 'CREATE TABLE parent_students (
 parent_id UUID NOT NULL,
 student_id UUID NOT NULL,
 PRIMARY KEY (parent_id, student_id)
);' 'feature/b06-02-parentstudent-junction-table'
issue '[B06] Tag 3 - Parent und Student Repositories' 'Sprint B06 - Parent & Student Management' 'mvp' 'Repository' 'parent/repository/
student/repository/' 'List<Student> findAllBySchoolIdAndActiveTrue(UUID schoolId);' 'feature/b06-03-parent-und-student-repositories'
issue '[B06] Tag 4 - Parent und Student DTOs' 'Sprint B06 - Parent & Student Management' 'mvp' 'DTO' 'parent/dto/
student/dto/' 'public record StudentResponse(UUID id, String firstName, String lastName, boolean active) {}' 'feature/b06-04-parent-und-student-dtos'
issue '[B06] Tag 5 - Parent und Student Services' 'Sprint B06 - Parent & Student Management' 'mvp' 'Service' 'parent/service/
student/service/' 'public void linkParentToStudent(UUID schoolId, UUID parentId, UUID studentId) {
    // validate same school before relation
}' 'feature/b06-05-parent-und-student-services'
issue '[B06] Tag 6 - Parent/Student REST Controller' 'Sprint B06 - Parent & Student Management' 'mvp' 'REST' 'parent/controller/
student/controller/' '@GetMapping("/{studentId}/parents")
public List<ParentResponse> parents(@PathVariable UUID studentId) {
    return service.parentsOf(studentId);
}' 'feature/b06-06-parent-student-rest-controller'
issue '[B06] Tag 7 - Relationship und Tenant Tests' 'Sprint B06 - Parent & Student Management' 'mvp' 'Test' 'src/test/java/com/ishulibus/student/' '@Test
void parentStudentRelation_isManyToManyAndTenantSafe() { }' 'feature/b06-07-relationship-und-tenant-tests'

milestone "Sprint B07 - Routes & Stops"
issue '[B07] Tag 1 - Route und Stop Entities' 'Sprint B07 - Routes & Stops' 'mvp' 'Entity' 'route/entity/Route.java
stop/entity/Stop.java' '@Entity
public class Route {
    @Id private UUID id;
    private UUID schoolId;
    private String name;
}' 'feature/b07-01-route-und-stop-entities'
issue '[B07] Tag 2 - RouteStop Entity und Reihenfolge' 'Sprint B07 - Routes & Stops' 'mvp' 'Entity/DB' 'route/entity/RouteStop.java' '@Entity
public class RouteStop {
    @Id private UUID id;
    private UUID routeId;
    private UUID stopId;
    private Integer stopOrder;
}' 'feature/b07-02-routestop-entity-und-reihenfolge'
issue '[B07] Tag 3 - Route/Stop Repositories' 'Sprint B07 - Routes & Stops' 'mvp' 'Repository' 'route/repository/
stop/repository/' 'List<RouteStop> findByRouteIdOrderByStopOrderAsc(UUID routeId);' 'feature/b07-03-route-stop-repositories'
issue '[B07] Tag 4 - Route/Stop DTOs und Mapper' 'Sprint B07 - Routes & Stops' 'mvp' 'DTO/Mapper' 'route/dto/
stop/dto/' 'public record StopResponse(UUID id, String name, double latitude, double longitude) {}' 'feature/b07-04-route-stop-dtos-und-mapper'
issue '[B07] Tag 5 - Route Service' 'Sprint B07 - Routes & Stops' 'mvp' 'Service' 'route/service/RouteService.java' 'public RouteDetailsResponse details(UUID schoolId, UUID routeId) {
    // route + ordered stops
    return null;
}' 'feature/b07-05-route-service'
issue '[B07] Tag 6 - Route und Stop REST API' 'Sprint B07 - Routes & Stops' 'mvp' 'REST' 'route/controller/RouteController.java' '@GetMapping("/{id}")
public RouteDetailsResponse get(@PathVariable UUID id) {
    return service.details(currentSchoolId(), id);
}' 'feature/b07-06-route-und-stop-rest-api'
issue '[B07] Tag 7 - Route Tests' 'Sprint B07 - Routes & Stops' 'mvp' 'Test' 'src/test/java/com/ishulibus/route/' '@Test
void stops_areReturnedInConfiguredOrder() { }' 'feature/b07-07-route-tests'

milestone "Sprint B08 - Trip Management"
issue '[B08] Tag 1 - Trip Entity und Migration' 'Sprint B08 - Trip Management' 'mvp' 'Entity' 'trip/entity/Trip.java' '@Entity
public class Trip {
    @Id private UUID id;
    private UUID schoolId;
    private UUID routeId;
    private UUID busId;
    @Enumerated(EnumType.STRING) private TripStatus status;
}' 'feature/b08-01-trip-entity-und-migration'
issue '[B08] Tag 2 - Trip Status Enum und State Machine' 'Sprint B08 - Trip Management' 'mvp' 'Domain' 'trip/entity/TripStatus.java
trip/service/TripStateMachine.java' 'public enum TripStatus {
    SCHEDULED, READY, IN_PROGRESS, COMPLETED, CANCELLED
}' 'feature/b08-02-trip-status-enum-und-state-machine'
issue '[B08] Tag 3 - Trip Repository' 'Sprint B08 - Trip Management' 'mvp' 'Repository' 'trip/repository/TripRepository.java' 'Optional<Trip> findByIdAndSchoolId(UUID id, UUID schoolId);' 'feature/b08-03-trip-repository'
issue '[B08] Tag 4 - Trip DTOs und Mapper' 'Sprint B08 - Trip Management' 'mvp' 'DTO/Mapper' 'trip/dto/
trip/mapper/TripMapper.java' 'public record TripResponse(UUID id, UUID routeId, UUID busId, TripStatus status) {}' 'feature/b08-04-trip-dtos-und-mapper'
issue '[B08] Tag 5 - Trip Service' 'Sprint B08 - Trip Management' 'mvp' 'Service' 'trip/service/TripService.java' '@Transactional
public void start(UUID schoolId, UUID tripId) {
    Trip trip = getTrip(schoolId, tripId);
    // validate transition READY -> IN_PROGRESS
}' 'feature/b08-05-trip-service'
issue '[B08] Tag 6 - Start/End/Cancel Trip API' 'Sprint B08 - Trip Management' 'mvp' 'REST' 'trip/controller/TripController.java' '@PostMapping("/{id}/start")
public void start(@PathVariable UUID id) {
    service.start(currentSchoolId(), id);
}' 'feature/b08-06-start-end-cancel-trip-api'
issue '[B08] Tag 7 - Trip State und Tenant Tests' 'Sprint B08 - Trip Management' 'mvp' 'Test' 'src/test/java/com/ishulibus/trip/' '@Test
void completedTrip_cannotBeStartedAgain() { }' 'feature/b08-07-trip-state-und-tenant-tests'

milestone "Sprint B09 - GPS & Parent Live Tracking"
issue '[B09] Tag 1 - BusLocation Entity und Migration' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'Entity' 'tracking/entity/BusLocation.java' '@Entity
public class BusLocation {
    @Id private UUID id;
    private UUID tripId;
    private UUID busId;
    private double latitude;
    private double longitude;
    private Instant recordedAt;
}' 'feature/b09-01-buslocation-entity-und-migration'
issue '[B09] Tag 2 - Location Repository' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'Repository' 'tracking/repository/BusLocationRepository.java' 'Optional<BusLocation> findTopByTripIdOrderByRecordedAtDesc(UUID tripId);' 'feature/b09-02-location-repository'
issue '[B09] Tag 3 - Driver GPS Update Endpoint' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'REST' 'tracking/controller/TrackingController.java' '@PostMapping("/trips/{tripId}/locations")
@ResponseStatus(HttpStatus.CREATED)
public void update(@PathVariable UUID tripId, @Valid @RequestBody LocationRequest body) {
    service.record(tripId, body);
}' 'feature/b09-03-driver-gps-update-endpoint'
issue '[B09] Tag 4 - Latest Location Endpoint' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'REST' 'tracking/controller/TrackingController.java' '@GetMapping("/trips/{tripId}/location/latest")
public LocationResponse latest(@PathVariable UUID tripId) {
    return service.latest(tripId);
}' 'feature/b09-04-latest-location-endpoint'
issue '[B09] Tag 5 - Trip-basierte Tracking Security' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'Security' 'tracking/service/TrackingAuthorizationService.java' '// Parent may track only trips connected to their linked child.
authorization.assertParentCanTrack(parentUserId, tripId);' 'feature/b09-05-trip-basierte-tracking-security'
issue '[B09] Tag 6 - Location Validation' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'Validation' 'tracking/dto/LocationRequest.java' 'public record LocationRequest(
 @DecimalMin("-90.0") @DecimalMax("90.0") double latitude,
 @DecimalMin("-180.0") @DecimalMax("180.0") double longitude,
 Double speed, Double accuracy
) {}' 'feature/b09-06-location-validation'
issue '[B09] Tag 7 - Tracking Integration Tests' 'Sprint B09 - GPS & Parent Live Tracking' 'mvp' 'Test' 'src/test/java/com/ishulibus/tracking/' '@Test
void latestLocation_returnsNewestPointForTrip() { }' 'feature/b09-07-tracking-integration-tests'

milestone "Sprint B10 - Notifications & Backend Hardening"
issue '[B10] Tag 1 - Notification Entity und Migration' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'Entity' 'notification/entity/Notification.java' '@Entity
public class Notification {
 @Id private UUID id;
 private UUID schoolId;
 private UUID userId;
 private String type;
 private Instant createdAt;
}' 'feature/b10-01-notification-entity-und-migration'
issue '[B10] Tag 2 - Firebase Cloud Messaging Konfiguration' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'Config' 'notification/config/FirebaseConfig.java' '@Configuration
public class FirebaseConfig {
    // initialize Firebase Admin SDK from environment credentials
}' 'feature/b10-02-firebase-cloud-messaging-konfiguration'
issue '[B10] Tag 3 - Notification Service' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'Service' 'notification/service/NotificationService.java' 'public void sendToUser(UUID userId, String title, String body) {
    // persist + send FCM
}' 'feature/b10-03-notification-service'
issue '[B10] Tag 4 - Trip Notification Events' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'Domain/Event' 'trip/event/
notification/listener/' 'public record TripStartedEvent(UUID tripId, UUID schoolId) {}' 'feature/b10-04-trip-notification-events'
issue '[B10] Tag 5 - Validation Hardening' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'Validation' 'dto packages' '@NotBlank
@Size(max = 120)
private String name;' 'feature/b10-05-validation-hardening'
issue '[B10] Tag 6 - OpenAPI / Swagger Dokumentation' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'API Docs' 'config/OpenApiConfig.java' '@OpenAPIDefinition(info = @Info(title="IshuliBus API", version="v1"))
@Configuration
public class OpenApiConfig {}' 'feature/b10-06-openapi-swagger-dokumentation'
issue '[B10] Tag 7 - Backend Security und Regression Tests' 'Sprint B10 - Notifications & Backend Hardening' 'mvp' 'Test' 'src/test/java/com/ishulibus/' '@Test
void crossTenantAccess_isRejectedAcrossProtectedResources() { }' 'feature/b10-07-backend-security-und-regression-tests'

milestone "Sprint B11 - Backend CI/CD & MVP Release"
issue '[B11] Tag 1 - GitHub Actions Maven Build' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'CI' '.github/workflows/backend-ci.yml' 'name: Backend CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: '"'"'21'"'"' }
      - run: ./mvnw clean verify' 'feature/b11-01-github-actions-maven-build'
issue '[B11] Tag 2 - Testcontainers PostgreSQL Integration' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'Test' 'src/test/java/.../PostgresContainerTest.java' '@Testcontainers
class PostgresContainerTest {
 @Container
 static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");
}' 'feature/b11-02-testcontainers-postgresql-integration'
issue '[B11] Tag 3 - Production Profile prüfen' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'Config' 'src/main/resources/application-prod.yml' 'spring:
  jpa:
    hibernate:
      ddl-auto: validate' 'feature/b11-03-production-profile-pr-fen'
issue '[B11] Tag 4 - Dockerfile erstellen' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'Docker' 'Dockerfile' 'FROM eclipse-temurin:21-jre
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]' 'feature/b11-04-dockerfile-erstellen'
issue '[B11] Tag 5 - Environment und Secret Dokumentation' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'Docs' '.env.example
README.md' 'DB_URL=
DB_USERNAME=
DB_PASSWORD=
JWT_SECRET=
FIREBASE_CREDENTIALS_JSON=' 'feature/b11-05-environment-und-secret-dokumentation'
issue '[B11] Tag 6 - MVP End-to-End Backend Test' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'Test' 'src/test/java/.../MvpFlowIT.java' '// school -> user -> driver -> bus -> route -> trip -> location -> parent tracking' 'feature/b11-06-mvp-end-to-end-backend-test'
issue '[B11] Tag 7 - Backend MVP Release vorbereiten' 'Sprint B11 - Backend CI/CD & MVP Release' 'mvp' 'Release' 'README.md
CHANGELOG.md' '## MVP release checklist
- migrations
- tests
- security
- environment
- API docs' 'feature/b11-07-backend-mvp-release-vorbereiten'

milestone "Sprint B12 - QR Boarding Post-MVP"
issue '[B12] Tag 1 - BoardingEvent Entity' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'Entity' 'boarding/entity/BoardingEvent.java' 'public enum BoardingType { BOARDING, ALIGHTING }' 'feature/b12-01-boardingevent-entity'
issue '[B12] Tag 2 - Student QR Identifier' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'Domain' 'student/entity/Student.java' '@Column(unique=true, nullable=false)
private UUID qrIdentifier;' 'feature/b12-02-student-qr-identifier'
issue '[B12] Tag 3 - QR Boarding Service' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'Service' 'boarding/service/BoardingService.java' 'public BoardingResponse scan(UUID tripId, UUID qrIdentifier) {
    // resolve student + validate trip + create event
    return null;
}' 'feature/b12-03-qr-boarding-service'
issue '[B12] Tag 4 - Boarding Endpoint' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'REST' 'boarding/controller/BoardingController.java' '@PostMapping("/trips/{tripId}/boarding")
public BoardingResponse scan(@PathVariable UUID tripId, @RequestBody ScanRequest request) {
 return service.scan(tripId, request.qrIdentifier());
}' 'feature/b12-04-boarding-endpoint'
issue '[B12] Tag 5 - Parent Boarding Notification' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'Notification' 'boarding/event/
notification/' 'public record StudentBoardedEvent(UUID studentId, UUID tripId) {}' 'feature/b12-05-parent-boarding-notification'
issue '[B12] Tag 6 - Boarding Security Regeln' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'Security' 'boarding/service/' '// only assigned driver may create boarding events for active trip' 'feature/b12-06-boarding-security-regeln'
issue '[B12] Tag 7 - QR Boarding Tests' 'Sprint B12 - QR Boarding Post-MVP' 'post-mvp' 'Test' 'src/test/java/com/ishulibus/boarding/' '@Test
void duplicateBoardingScan_isRejectedOrHandledIdempotently() { }' 'feature/b12-07-qr-boarding-tests'

milestone "Sprint B13 - SaaS Billing Post-MVP"
issue '[B13] Tag 1 - Subscription Entity' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'Entity' 'billing/entity/Subscription.java' '@Entity
public class Subscription {
 @Id private UUID id;
 private UUID schoolId;
 private String status;
}' 'feature/b13-01-subscription-entity'
issue '[B13] Tag 2 - Billing Plan Modell' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'Domain' 'billing/entity/BillingPlan.java' 'public record BillingPlan(String name, BigDecimal pricePerActiveStudent) {}' 'feature/b13-02-billing-plan-modell'
issue '[B13] Tag 3 - Active Student Billing Metric' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'Service' 'billing/service/BillingMetricService.java' 'long activeStudents = studentRepository.countBySchoolIdAndActiveTrue(schoolId);' 'feature/b13-03-active-student-billing-metric'
issue '[B13] Tag 4 - Invoice Entity' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'Entity' 'billing/entity/Invoice.java' '@Entity
public class Invoice {
 @Id private UUID id;
 private UUID schoolId;
 private BigDecimal amount;
 private LocalDate billingMonth;
}' 'feature/b13-04-invoice-entity'
issue '[B13] Tag 5 - Monthly Billing Service' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'Service' 'billing/service/BillingService.java' 'amount = pricePerStudent.multiply(BigDecimal.valueOf(activeStudentCount));' 'feature/b13-05-monthly-billing-service'
issue '[B13] Tag 6 - Super Admin Billing API' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'REST' 'billing/controller/BillingAdminController.java' '@PreAuthorize("hasRole('"'"'SUPER_ADMIN'"'"')")
@GetMapping("/api/v1/admin/billing/schools/{schoolId}")
public BillingResponse billing(@PathVariable UUID schoolId) { return null; }' 'feature/b13-06-super-admin-billing-api'
issue '[B13] Tag 7 - Billing Tests' 'Sprint B13 - SaaS Billing Post-MVP' 'post-mvp' 'Test' 'src/test/java/com/ishulibus/billing/' '@Test
void invoiceAmount_usesActiveStudentsOnly() { }' 'feature/b13-07-billing-tests'

echo "FERTIG: IshuliBus-Backend - alle Sprints/Issues geprüft."
