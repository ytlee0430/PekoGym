# Story 9.1: HealthKit & Health Connect Setup

Status: ready-for-dev

## Story

As a player,
I want to connect my wearable device to the app,
So that my real-time heart rate data can enhance the battle experience.

## Acceptance Criteria

1. **Given** the player has a compatible wearable device
   **When** the player grants HealthKit (iOS) or Health Connect (Android) permission
   **Then** the app can read real-time heart rate data during workouts
2. **And** the onboarding flow includes an optional wearable sync step
3. **And** if no wearable is connected, the system falls back to RPE manual input (existing behavior)
4. **And** the health data integration uses the `health` package
5. **And** permission handling follows platform-specific best practices

## Tasks / Subtasks

- [ ] Task 1: Add health package dependency (AC: 4)
  - [ ] 1.1 Add `health: ^11.0.0` to `pubspec.yaml`
  - [ ] 1.2 Run `flutter pub get`

- [ ] Task 2: iOS HealthKit configuration (AC: 1, 5)
  - [ ] 2.1 Add HealthKit capability to `ios/Runner.xcodeproj`
  - [ ] 2.2 Add `NSHealthShareUsageDescription` to `Info.plist`
  - [ ] 2.3 Request read permission for `HEART_RATE` data type

- [ ] Task 3: Android Health Connect configuration (AC: 1, 5)
  - [ ] 3.1 Add Health Connect permissions to `AndroidManifest.xml`
  - [ ] 3.2 Add intent filter for Health Connect
  - [ ] 3.3 Request read permission for `HEART_RATE` data type

- [ ] Task 4: Create HealthService (AC: 1, 3)
  - [ ] 4.1 Create `lib/presentation/shared/health_service.dart`
  - [ ] 4.2 Method `requestPermissions() → Future<bool>` — requests HR read access
  - [ ] 4.3 Method `isAvailable() → Future<bool>` — checks if HealthKit/Health Connect available
  - [ ] 4.4 Method `getLatestHeartRate() → Future<int?>` — reads most recent HR sample
  - [ ] 4.5 Method `streamHeartRate() → Stream<int>` — streams HR updates during workout
  - [ ] 4.6 Graceful fallback: if unavailable or denied, return null (caller uses RPE)

- [ ] Task 5: Add wearable sync to onboarding (AC: 2)
  - [ ] 5.1 Add optional "Connect Wearable" step after 5RM input in onboarding
  - [ ] 5.2 Show explanation: "Connect Apple Watch or fitness tracker for heart rate bonuses"
  - [ ] 5.3 "Connect" button triggers permission request
  - [ ] 5.4 "Skip" button proceeds without wearable
  - [ ] 5.5 Store `hasWearable` flag in UserProfile

- [ ] Task 6: Add wearable flag to UserProfile (AC: 3)
  - [ ] 6.1 Add `hasWearable` bool to `UserProfile` domain model
  - [ ] 6.2 Add `hasWearable` column to `UserProfiles` Drift table (default false)
  - [ ] 6.3 Update mapper, schema migration
  - [ ] 6.4 Add `age` int field to UserProfile (needed for max HR calculation: 220 - age)

- [ ] Task 7: Provider wiring (AC: 1)
  - [ ] 7.1 Create `lib/providers/health_providers.dart`
  - [ ] 7.2 `healthServiceProvider` — singleton HealthService
  - [ ] 7.3 `hasWearableProvider` — reads from UserProfile
  - [ ] 7.4 `heartRateStreamProvider` — StreamProvider wrapping HealthService stream

- [ ] Task 8: Tests (AC: 1-5)
  - [ ] 8.1 Unit test: HealthService returns null when unavailable
  - [ ] 8.2 Unit test: fallback to RPE when no wearable
  - [ ] 8.3 Widget test: onboarding wearable step renders correctly
  - [ ] 8.4 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0. New columns: `hasWearable`, `age`.

### CRITICAL — No riverpod_generator

Manual providers only.

### health Package

Use `health: ^11.0.0`. Key APIs:

```dart
import 'package:health/health.dart';

final health = Health();
final types = [HealthDataType.HEART_RATE];
final permissions = [HealthDataAccess.READ];

final granted = await health.requestAuthorization(types, permissions: permissions);

final now = DateTime.now();
final data = await health.getHealthDataFromTypes(
  types: types,
  startTime: now.subtract(const Duration(minutes: 1)),
  endTime: now,
);
```

### HealthService Is Presentation Layer

Uses platform APIs, belongs in `lib/presentation/shared/` — same as `HapticService` and `AudioService`.

### Fallback Strategy

The existing `DamageCalculator` uses RPE multiplier. When wearable is connected, Story 9.2 will replace RPE with heart rate zone multiplier. This story only sets up the data pipeline.

### Dependencies on Previous Stories

- **Story 1.2** — `UserProfile` for `hasWearable`, `age` fields
- **Story 1.3** — Onboarding flow for wearable step insertion

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation Layer** | `HealthService` in `presentation/shared/` |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition in `providers/health_providers.dart` |
| **Graceful Fallback** | Always return null/empty when unavailable |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/shared/health_service.dart
ironmon/lib/providers/health_providers.dart
ironmon/test/presentation/shared/health_service_test.dart
```

Files to update:

```
ironmon/pubspec.yaml (add health dependency)
ironmon/ios/Runner/Info.plist (HealthKit description)
ironmon/lib/domain/training/models/user_profile.dart (hasWearable, age)
ironmon/lib/data/local/tables/user_profile_table.dart (new columns)
ironmon/lib/data/local/app_database.dart (migration)
ironmon/lib/data/mappers/user_profile_mapper.dart
ironmon/lib/presentation/onboarding/onboarding_screen.dart (wearable step)
```

### References

- [Source: epics.md#Story 9.1] — User story, acceptance criteria
- [Source: spec.md#Section 2] — HealthKit / Health Connect
- [Source: spec.md#Section 5.6] — Heart rate sync system
- [Source: architecture.md#Technical Constraints] — iOS HealthKit permission reserved

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
