#!/usr/bin/env bash
set -euo pipefail

# IshuliBus Frontend - complete learning-oriented GitHub issue setup.
# Existing issues with the exact same title are skipped.

command -v gh >/dev/null 2>&1 || { echo "FEHLER: gh CLI fehlt."; exit 1; }
gh auth status

OWNER="$(gh api user --jq '.login')"
REPO="$OWNER/IshuliBus-Frontend"

if ! gh repo view "$REPO" >/dev/null 2>&1; then
  gh repo create "$REPO" --private --description "IshuliBus frontend"
fi

label() {
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null
}
label "frontend" "1D76DB" "Frontend"
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
  gh issue create --repo "$REPO" --title "$title" --label "frontend,$phase" --milestone "$milestone_title" --body "$(cat <<EOF
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
flutter analyze
flutter test
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


milestone "Sprint F01 - Flutter Foundation"
issue '[F01] Tag 1 - Flutter Projekt erstellen' 'Sprint F01 - Flutter Foundation' 'mvp' 'Projektbasis' 'pubspec.yaml
lib/main.dart' 'void main() {
  runApp(const IshuliBusApp());
}' 'feature/f01-01-flutter-projekt-erstellen'
issue '[F01] Tag 2 - Projektstruktur und Packages' 'Sprint F01 - Flutter Foundation' 'mvp' 'Architektur' 'lib/core/
lib/features/
lib/shared/' 'lib/
├── core/
├── features/
│   ├── auth/
│   ├── driver/
│   └── tracking/
└── shared/' 'feature/f01-02-projektstruktur-und-packages'
issue '[F01] Tag 3 - Environment Configuration' 'Sprint F01 - Flutter Foundation' 'mvp' 'Config' 'lib/core/config/app_config.dart' 'class AppConfig {
  static const apiBaseUrl =
      String.fromEnvironment('"'"'API_BASE_URL'"'"');
}' 'feature/f01-03-environment-configuration'
issue '[F01] Tag 4 - Theme und Design System' 'Sprint F01 - Flutter Foundation' 'mvp' 'UI' 'lib/core/theme/app_theme.dart' 'final ThemeData appTheme = ThemeData(
  useMaterial3: true,
);' 'feature/f01-04-theme-und-design-system'
issue '[F01] Tag 5 - Routing Setup' 'Sprint F01 - Flutter Foundation' 'mvp' 'Navigation' 'lib/core/router/app_router.dart' 'final router = GoRouter(routes: [
  GoRoute(path: '"'"'/login'"'"', builder: (_, __) => const LoginScreen()),
]);' 'feature/f01-05-routing-setup'
issue '[F01] Tag 6 - API Client Basis' 'Sprint F01 - Flutter Foundation' 'mvp' 'Networking' 'lib/core/network/api_client.dart' 'final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));' 'feature/f01-06-api-client-basis'
issue '[F01] Tag 7 - Foundation Tests' 'Sprint F01 - Flutter Foundation' 'mvp' 'Test' 'test/' 'testWidgets('"'"'app starts'"'"', (tester) async {
  await tester.pumpWidget(const IshuliBusApp());
});' 'feature/f01-07-foundation-tests'

milestone "Sprint F02 - Flutter Authentication"
issue '[F02] Tag 1 - Login Screen' 'Sprint F02 - Flutter Authentication' 'mvp' 'UI' 'lib/features/auth/presentation/login_screen.dart' 'class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: LoginForm());
}' 'feature/f02-01-login-screen'
issue '[F02] Tag 2 - Auth Models und DTOs' 'Sprint F02 - Flutter Authentication' 'mvp' 'Model' 'lib/features/auth/data/models/' 'class LoginRequest {
  final String email;
  final String password;
  LoginRequest(this.email, this.password);
}' 'feature/f02-02-auth-models-und-dtos'
issue '[F02] Tag 3 - Auth Repository' 'Sprint F02 - Flutter Authentication' 'mvp' 'Repository' 'lib/features/auth/data/auth_repository.dart' 'Future<AuthResponse> login(LoginRequest request) async {
  final response = await dio.post('"'"'/api/v1/auth/login'"'"', data: request.toJson());
  return AuthResponse.fromJson(response.data);
}' 'feature/f02-03-auth-repository'
issue '[F02] Tag 4 - Token Storage' 'Sprint F02 - Flutter Authentication' 'mvp' 'Security' 'lib/core/security/token_storage.dart' 'await secureStorage.write(key: '"'"'access_token'"'"', value: token);' 'feature/f02-04-token-storage'
issue '[F02] Tag 5 - Auth State Management' 'Sprint F02 - Flutter Authentication' 'mvp' 'State' 'lib/features/auth/presentation/auth_controller.dart' '// loading -> authenticated / error
state = const AsyncLoading();' 'feature/f02-05-auth-state-management'
issue '[F02] Tag 6 - Role-based Navigation' 'Sprint F02 - Flutter Authentication' 'mvp' 'Navigation' 'lib/core/router/app_router.dart' 'switch (user.role) {
 case '"'"'DRIVER'"'"': return '"'"'/driver'"'"';
 case '"'"'PARENT'"'"': return '"'"'/parent'"'"';
 default: return '"'"'/admin'"'"';
}' 'feature/f02-06-role-based-navigation'
issue '[F02] Tag 7 - Authentication Tests' 'Sprint F02 - Flutter Authentication' 'mvp' 'Test' 'test/features/auth/' 'test('"'"'invalid login exposes error state'"'"', () async { });' 'feature/f02-07-authentication-tests'

milestone "Sprint F03 - School Admin App"
issue '[F03] Tag 1 - School Admin Dashboard' 'Sprint F03 - School Admin App' 'mvp' 'UI' 'lib/features/admin/presentation/admin_dashboard.dart' 'return GridView(children: const [
  DashboardCard(title: '"'"'Buses'"'"'),
  DashboardCard(title: '"'"'Drivers'"'"'),
]);' 'feature/f03-01-school-admin-dashboard'
issue '[F03] Tag 2 - Driver Liste und Detail' 'Sprint F03 - School Admin App' 'mvp' 'UI/API' 'lib/features/admin/drivers/' 'final drivers = await dio.get('"'"'/api/v1/drivers'"'"');' 'feature/f03-02-driver-liste-und-detail'
issue '[F03] Tag 3 - Bus Liste und Detail' 'Sprint F03 - School Admin App' 'mvp' 'UI/API' 'lib/features/admin/buses/' 'final buses = await dio.get('"'"'/api/v1/buses'"'"');' 'feature/f03-03-bus-liste-und-detail'
issue '[F03] Tag 4 - Student und Parent Verwaltung' 'Sprint F03 - School Admin App' 'mvp' 'UI/API' 'lib/features/admin/students/' '// list students, open detail, show linked parents' 'feature/f03-04-student-und-parent-verwaltung'
issue '[F03] Tag 5 - Route Verwaltung' 'Sprint F03 - School Admin App' 'mvp' 'UI/API' 'lib/features/admin/routes/' '// route form + ordered stops' 'feature/f03-05-route-verwaltung'
issue '[F03] Tag 6 - Trip Übersicht' 'Sprint F03 - School Admin App' 'mvp' 'UI/API' 'lib/features/admin/trips/' '// scheduled / active / completed trips' 'feature/f03-06-trip-bersicht'
issue '[F03] Tag 7 - School Admin Tests' 'Sprint F03 - School Admin App' 'mvp' 'Test' 'test/features/admin/' 'testWidgets('"'"'admin dashboard shows management sections'"'"', (tester) async { });' 'feature/f03-07-school-admin-tests'

milestone "Sprint F04 - Driver App"
issue '[F04] Tag 1 - Driver Dashboard' 'Sprint F04 - Driver App' 'mvp' 'UI' 'lib/features/driver/presentation/driver_dashboard.dart' '// show today'"'"'s assigned trips' 'feature/f04-01-driver-dashboard'
issue '[F04] Tag 2 - Assigned Trips Screen' 'Sprint F04 - Driver App' 'mvp' 'UI/API' 'lib/features/driver/trips/' 'final response = await dio.get('"'"'/api/v1/driver/trips'"'"');' 'feature/f04-02-assigned-trips-screen'
issue '[F04] Tag 3 - Trip Detail Screen' 'Sprint F04 - Driver App' 'mvp' 'UI' 'lib/features/driver/trips/trip_detail_screen.dart' '// route, bus, stops, status, start button' 'feature/f04-03-trip-detail-screen'
issue '[F04] Tag 4 - Trip starten' 'Sprint F04 - Driver App' 'mvp' 'API' 'lib/features/driver/data/trip_repository.dart' 'await dio.post('"'"'/api/v1/trips/$tripId/start'"'"');' 'feature/f04-04-trip-starten'
issue '[F04] Tag 5 - GPS Permission und Location Service' 'Sprint F04 - Driver App' 'mvp' 'Location' 'lib/core/location/location_service.dart' 'final permission = await Geolocator.requestPermission();' 'feature/f04-05-gps-permission-und-location-service'
issue '[F04] Tag 6 - Trip beenden' 'Sprint F04 - Driver App' 'mvp' 'API' 'lib/features/driver/data/trip_repository.dart' 'await dio.post('"'"'/api/v1/trips/$tripId/end'"'"');' 'feature/f04-06-trip-beenden'
issue '[F04] Tag 7 - Driver Flow Tests' 'Sprint F04 - Driver App' 'mvp' 'Test' 'test/features/driver/' 'testWidgets('"'"'driver can open assigned trip'"'"', (tester) async { });' 'feature/f04-07-driver-flow-tests'

milestone "Sprint F05 - Parent App"
issue '[F05] Tag 1 - Parent Dashboard' 'Sprint F05 - Parent App' 'mvp' 'UI' 'lib/features/parent/presentation/parent_dashboard.dart' '// child cards + active trip state' 'feature/f05-01-parent-dashboard'
issue '[F05] Tag 2 - Children Overview' 'Sprint F05 - Parent App' 'mvp' 'UI/API' 'lib/features/parent/children/' 'final children = await repository.getChildren();' 'feature/f05-02-children-overview'
issue '[F05] Tag 3 - Child Detail' 'Sprint F05 - Parent App' 'mvp' 'UI' 'lib/features/parent/children/child_detail_screen.dart' '// child + assigned route + active trip' 'feature/f05-03-child-detail'
issue '[F05] Tag 4 - Active Trip Anzeige' 'Sprint F05 - Parent App' 'mvp' 'UI/API' 'lib/features/parent/tracking/' 'if (trip.status == TripStatus.inProgress) return const TrackBusButton();' 'feature/f05-04-active-trip-anzeige'
issue '[F05] Tag 5 - Trip Status Anzeige' 'Sprint F05 - Parent App' 'mvp' 'UI' 'lib/features/parent/tracking/' 'Text('"'"'Status: ${trip.status.label}'"'"')' 'feature/f05-05-trip-status-anzeige'
issue '[F05] Tag 6 - Parent History Basis' 'Sprint F05 - Parent App' 'mvp' 'UI/API' 'lib/features/parent/history/' '// completed trips for linked children' 'feature/f05-06-parent-history-basis'
issue '[F05] Tag 7 - Parent Flow Tests' 'Sprint F05 - Parent App' 'mvp' 'Test' 'test/features/parent/' 'testWidgets('"'"'parent sees only linked children'"'"', (tester) async { });' 'feature/f05-07-parent-flow-tests'

milestone "Sprint F06 - Maps & Live Tracking"
issue '[F06] Tag 1 - Map Package integrieren' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'Map' 'pubspec.yaml
lib/features/tracking/' '// Add chosen map package and API/platform configuration' 'feature/f06-01-map-package-integrieren'
issue '[F06] Tag 2 - Bus Marker anzeigen' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'Map UI' 'lib/features/tracking/widgets/bus_marker.dart' 'Marker(point: LatLng(location.latitude, location.longitude), child: const Icon(Icons.directions_bus))' 'feature/f06-02-bus-marker-anzeigen'
issue '[F06] Tag 3 - Latest Location API anbinden' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'API' 'lib/features/tracking/data/tracking_repository.dart' 'await dio.get('"'"'/api/v1/trips/$tripId/location/latest'"'"');' 'feature/f06-03-latest-location-api-anbinden'
issue '[F06] Tag 4 - Polling implementieren' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'State' 'lib/features/tracking/presentation/tracking_controller.dart' 'Timer.periodic(const Duration(seconds: 5), (_) => loadLatestLocation());' 'feature/f06-04-polling-implementieren'
issue '[F06] Tag 5 - Route/Stop Darstellung' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'Map UI' 'lib/features/tracking/presentation/' '// draw route polyline and stop markers' 'feature/f06-05-route-stop-darstellung'
issue '[F06] Tag 6 - Tracking Error States' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'UX' 'lib/features/tracking/presentation/' 'if (location == null) return const Text('"'"'Location not available yet'"'"');' 'feature/f06-06-tracking-error-states'
issue '[F06] Tag 7 - Live Tracking Tests' 'Sprint F06 - Maps & Live Tracking' 'mvp' 'Test' 'test/features/tracking/' 'test('"'"'polling updates latest bus location'"'"', () async { });' 'feature/f06-07-live-tracking-tests'

milestone "Sprint F07 - Push Notifications"
issue '[F07] Tag 1 - Firebase Flutter Setup' 'Sprint F07 - Push Notifications' 'mvp' 'Config' 'firebase_options.dart
main.dart' 'await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);' 'feature/f07-01-firebase-flutter-setup'
issue '[F07] Tag 2 - FCM Token registrieren' 'Sprint F07 - Push Notifications' 'mvp' 'API' 'lib/core/notifications/' 'final token = await FirebaseMessaging.instance.getToken();' 'feature/f07-02-fcm-token-registrieren'
issue '[F07] Tag 3 - Foreground Notifications' 'Sprint F07 - Push Notifications' 'mvp' 'Notification' 'lib/core/notifications/notification_service.dart' 'FirebaseMessaging.onMessage.listen((message) { /* show in-app/local */ });' 'feature/f07-03-foreground-notifications'
issue '[F07] Tag 4 - Background Notifications' 'Sprint F07 - Push Notifications' 'mvp' 'Notification' 'lib/main.dart' 'FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);' 'feature/f07-04-background-notifications'
issue '[F07] Tag 5 - Trip Delay Notification UI' 'Sprint F07 - Push Notifications' 'mvp' 'UI' 'lib/features/notifications/' '// display delay title, route/trip and timestamp' 'feature/f07-05-trip-delay-notification-ui'
issue '[F07] Tag 6 - Notification Navigation' 'Sprint F07 - Push Notifications' 'mvp' 'Navigation' 'lib/core/router/' '// payload tripId -> parent tracking screen' 'feature/f07-06-notification-navigation'
issue '[F07] Tag 7 - Notification Tests' 'Sprint F07 - Push Notifications' 'mvp' 'Test' 'test/features/notifications/' 'test('"'"'trip payload resolves tracking route'"'"', () { });' 'feature/f07-07-notification-tests'

milestone "Sprint F08 - Offline Driver Tracking"
issue '[F08] Tag 1 - Connectivity Detection' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'Offline' 'lib/core/connectivity/' 'final result = await Connectivity().checkConnectivity();' 'feature/f08-01-connectivity-detection'
issue '[F08] Tag 2 - GPS Queue Modell' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'Model' 'lib/features/driver/tracking/pending_location.dart' 'class PendingLocation {
 final double latitude, longitude;
 final DateTime recordedAt;
}' 'feature/f08-02-gps-queue-modell'
issue '[F08] Tag 3 - Locations offline puffern' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'Storage' 'lib/features/driver/tracking/location_queue.dart' 'await queue.add(PendingLocation(latitude: lat, longitude: lng, recordedAt: DateTime.now()));' 'feature/f08-03-locations-offline-puffern'
issue '[F08] Tag 4 - Retry und Sync Service' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'Sync' 'lib/features/driver/tracking/sync_service.dart' 'for (final point in await queue.all()) {
  await repository.send(point);
}' 'feature/f08-04-retry-und-sync-service'
issue '[F08] Tag 5 - Duplicate Protection' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'Sync' 'lib/features/driver/tracking/' '// clientGeneratedId per GPS point for idempotent server sync' 'feature/f08-05-duplicate-protection'
issue '[F08] Tag 6 - Offline Status UI' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'UX' 'lib/features/driver/presentation/' 'const Chip(label: Text('"'"'Offline – locations will sync later'"'"'))' 'feature/f08-06-offline-status-ui'
issue '[F08] Tag 7 - Offline Tracking Tests' 'Sprint F08 - Offline Driver Tracking' 'mvp' 'Test' 'test/features/driver/tracking/' 'test('"'"'queued locations remain until successful sync'"'"', () async { });' 'feature/f08-07-offline-tracking-tests'

milestone "Sprint F09 - Flutter CI/CD & MVP Release"
issue '[F09] Tag 1 - Flutter Analyze Workflow' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'CI' '.github/workflows/flutter-ci.yml' '- run: flutter analyze' 'feature/f09-01-flutter-analyze-workflow'
issue '[F09] Tag 2 - Flutter Test Workflow' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'CI' '.github/workflows/flutter-ci.yml' '- run: flutter test' 'feature/f09-02-flutter-test-workflow'
issue '[F09] Tag 3 - Android Release Konfiguration' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'Release' 'android/' '// signing config via protected environment/secrets; never commit keystore passwords' 'feature/f09-03-android-release-konfiguration'
issue '[F09] Tag 4 - iOS Release Konfiguration' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'Release' 'ios/' '// bundle identifier, signing and release configuration' 'feature/f09-04-ios-release-konfiguration'
issue '[F09] Tag 5 - Environment Build Flavors' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'Config' 'lib/main_dev.dart
lib/main_prod.dart' 'flutter run --dart-define=API_BASE_URL=https://api.example.com' 'feature/f09-05-environment-build-flavors'
issue '[F09] Tag 6 - MVP End-to-End App Test' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'Test' 'integration_test/' '// login -> role dashboard -> trip -> tracking' 'feature/f09-06-mvp-end-to-end-app-test'
issue '[F09] Tag 7 - MVP Release Checklist' 'Sprint F09 - Flutter CI/CD & MVP Release' 'mvp' 'Release' 'docs/release-checklist.md' '- [ ] analyze
- [ ] tests
- [ ] permissions
- [ ] production API
- [ ] privacy review' 'feature/f09-07-mvp-release-checklist'

milestone "Sprint F10 - QR Boarding Post-MVP"
issue '[F10] Tag 1 - QR Scanner integrieren' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'QR' 'pubspec.yaml
lib/features/boarding/' '// integrate QR scanner package behind BoardingScannerScreen' 'feature/f10-01-qr-scanner-integrieren'
issue '[F10] Tag 2 - Camera Permission Flow' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'Permission' 'lib/features/boarding/' '// request camera permission and show denied state' 'feature/f10-02-camera-permission-flow'
issue '[F10] Tag 3 - Student QR Scan' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'QR' 'lib/features/boarding/presentation/' 'void onDetect(String qrIdentifier) { controller.submit(qrIdentifier); }' 'feature/f10-03-student-qr-scan'
issue '[F10] Tag 4 - Boarding API anbinden' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'API' 'lib/features/boarding/data/boarding_repository.dart' 'await dio.post('"'"'/api/v1/trips/$tripId/boarding'"'"', data: {'"'"'qrIdentifier'"'"': qr});' 'feature/f10-04-boarding-api-anbinden'
issue '[F10] Tag 5 - Boarding Result UI' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'UI' 'lib/features/boarding/presentation/' 'const SnackBar(content: Text('"'"'Student boarding recorded'"'"'));' 'feature/f10-05-boarding-result-ui'
issue '[F10] Tag 6 - Duplicate Scan Handling' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'UX' 'lib/features/boarding/presentation/' 'if (state.isSubmitting) return; // debounce/lock repeated scan' 'feature/f10-06-duplicate-scan-handling'
issue '[F10] Tag 7 - QR Boarding Tests' 'Sprint F10 - QR Boarding Post-MVP' 'post-mvp' 'Test' 'test/features/boarding/' 'test('"'"'duplicate scan is not submitted twice'"'"', () async { });' 'feature/f10-07-qr-boarding-tests'

echo "FERTIG: IshuliBus-Frontend - alle Sprints/Issues geprüft."
