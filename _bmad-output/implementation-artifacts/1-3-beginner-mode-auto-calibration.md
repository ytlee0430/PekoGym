# Story 1.3: Beginner Mode & Auto-Calibration

Status: done

## Story

As a new player unfamiliar with my lifting capacity,
I want to select beginner mode so the system starts with conservative
minimum weights and auto-calibrates my 5RM over my first 3–5 sessions,
so that I don't need to know my 5RM to start playing.

## Acceptance Criteria

1. **Given** the user is on the onboarding screen **When** the user
   has not yet created a profile **Then** a "Beginner Mode" toggle
   or button is visible alongside the manual 5RM entry form
2. **Given** the user selects "Beginner Mode" **When** the mode is
   activated **Then** all four 5RM fields are pre-filled with
   predefined beginner minimums: squat = 20.0 kg (empty barbell),
   bench press = 20.0 kg, deadlift = 20.0 kg, overhead press = 20.0 kg
3. **Given** the user selects "Beginner Mode" **When** the profile is
   saved **Then** `isBeginnerMode` is stored as `true` in the Drift
   `UserProfiles` table (FR2)
4. **And** a `calibrationSessionsCompleted` counter is stored as `0`
   in the profile, tracking progress toward calibration completion
5. **And** a `calibrationTargetSessions` value is stored as `5`,
   representing the target number of sessions before auto-calibration
   completes
6. **Given** the user is in beginner mode **When** they view their
   profile or home screen **Then** the UI clearly indicates
   "Calibrating (0/5 sessions)" so the player knows the system is
   learning their strength (FR2)
7. **Given** a beginner-mode player completes a battle session
   **When** the session concludes **Then** `calibrationSessionsCompleted`
   is incremented by 1 and persisted to the database
8. **And** the system computes a new estimated 5RM for each lift that
   was trained, using the Epley formula applied to the best set:
   `estimated1RM = weight × (1 + reps / 30)`, then converts to
   estimated 5RM via `fiveRm = estimated1RM / 1.0678`
9. **And** the new estimated 5RM replaces the stored value only if it
   is greater than the current value (never regresses the baseline)
10. **Given** `calibrationSessionsCompleted` reaches
    `calibrationTargetSessions` (5) **When** the session result is
    saved **Then** `isBeginnerMode` is set to `false`, completing the
    transition to normal mode (FR2)
11. **And** the user is notified on the result screen that calibration
    is complete with their finalized 5RM values displayed
12. **Given** the user is in any mode (beginner or normal) **When**
    they navigate to their profile settings **Then** they can manually
    override any 5RM value, immediately persisting the new value to
    the database
13. **And** manually overriding a 5RM in beginner mode does NOT exit
    beginner mode — calibration continues with the corrected baseline
14. **And** `flutter analyze` reports zero issues after all changes
15. **And** unit tests cover: `BeginnerCalibrationService` Epley
    estimation logic, `UserProfileMapper` round-trip with new fields,
    `DriftUserProfileRepository` calibration update, and
    `UserProfile.copyWith` for new fields

## Tasks / Subtasks

- [x] Task 1: Expand `UserProfile` domain model with calibration
  fields (AC: 4, 5, 8, 12)
  - [x] 1.1 Update
    `lib/domain/training/models/user_profile.dart`: add
    `calibrationSessionsCompleted` (`int`, default `0`) and
    `calibrationTargetSessions` (`int`, default `5`) fields to the
    `UserProfile` class, `copyWith`, `==` override, and `hashCode`
  - [x] 1.2 Confirm `isBeginnerMode` field already exists (added in
    Story 1.2) — do NOT add it again; only reference it

- [x] Task 2: Update Drift schema for new calibration columns (AC: 3,
  4, 5)
  - [x] 2.1 Update
    `lib/data/local/tables/user_profile_table.dart`: add
    `calibrationSessionsCompleted` integer column (default 0) and
    `calibrationTargetSessions` integer column (default 5)
  - [x] 2.2 Update `lib/data/local/app_database.dart`: bump
    `schemaVersion` 2 → 3; add migration case `if (from < 3)` that
    runs additive migration preserving existing data
  - [x] 2.3 Run
    `dart run build_runner build --delete-conflicting-outputs` —
    confirmed codegen succeeds with updated `UserProfileEntity`

- [x] Task 3: Update `UserProfileMapper` for new fields (AC: 4, 5)
  - [x] 3.1 Update
    `lib/data/mappers/user_profile_mapper.dart`: add
    `calibrationSessionsCompleted` and `calibrationTargetSessions`
    to `toDomain()`, `toInsertable()`, and `toUpdateCompanion()`

- [x] Task 4: Implement `BeginnerCalibrationService` (AC: 8, 9, 10)
  - [x] 4.1 Create
    `lib/domain/training/beginner_calibration_service.dart` — pure
    Dart service with zero Flutter/Drift dependency
  - [x] 4.2 Implement
    `estimateFiveRm(double weight, int reps) -> double`: uses Epley
    formula; returns 0 if `reps <= 0` or `weight <= 0`
  - [x] 4.3 Implement
    `applyCalibration(UserProfile profile, Map<String, double>
    newEstimates) -> UserProfile`: updates each 5RM only if
    `newEstimate > current`, increments
    `calibrationSessionsCompleted` by 1, and sets
    `isBeginnerMode = false` when target is reached
  - [x] 4.4 All methods are synchronous (pure computation — no
    async/Drift)

- [x] Task 5: Expose `BeginnerCalibrationService` via Riverpod
  provider (AC: 7, 8, 9, 10)
  - [x] 5.1 Created `lib/providers/training_providers.dart` with
    `beginnerCalibrationServiceProvider` as a `Provider<
    BeginnerCalibrationService>` (singleton, stateless service)

- [x] Task 6: Update `UserProfileRepository` with calibration update
  method (AC: 7, 10, 12, 13)
  - [x] 6.1 Add `updateCalibration(UserProfile profile) ->
    Future<Result<UserProfile, Exception>>` to the abstract
    `UserProfileRepository` interface
  - [x] 6.2 Implement `updateCalibration` in
    `DriftUserProfileRepository`: uses `db.transaction(() async {
    ... })` to atomically write all updated fields

- [x] Task 7: Update `OnboardingScreen` for Beginner Mode toggle
  (AC: 1, 2, 3, 6)
  - [x] 7.1 Update
    `lib/presentation/onboarding/onboarding_screen.dart`: added
    `SwitchListTile` labeled "Beginner Mode" above the 5RM input cards
  - [x] 7.2 When "Beginner Mode" is activated: pre-fills all four
    `TextEditingController` values to `'20'`, sets `_isBeginnerMode`
    to `true`
  - [x] 7.3 When the profile is saved, passes
    `isBeginnerMode: _isBeginnerMode` to `saveProfile`
  - [x] 7.4 5RM fields remain editable in beginner mode

- [x] Task 8: Create `ProfileEditScreen` for manual 5RM override
  (AC: 12, 13)
  - [x] 8.1 Created
    `lib/presentation/profile/profile_edit_screen.dart` — a
    `ConsumerStatefulWidget` with editable `TextFormField` widgets
  - [x] 8.2 "Save" button calls `saveProfile` preserving
    `isBeginnerMode` and `calibrationSessionsCompleted` unchanged
  - [x] 8.3 Added `/profile/edit` route to
    `lib/router/app_router.dart` with name `profileEditRoute`;
    `HomeScreen` has a settings icon navigating to the screen
  - [x] 8.4 Navigation uses `context.push('/profile/edit')`

- [x] Task 9: Tests (AC: 15)
  - [x] 9.1 Created
    `test/domain/training/beginner_calibration_service_test.dart`
    with all required test cases
  - [x] 9.2 Updated
    `test/data/mappers/user_profile_mapper_test.dart` with round-trip
    tests for calibration fields
  - [x] 9.3 Updated
    `test/data/repositories/user_profile_repository_test.dart` with
    `updateCalibration` tests
  - [x] 9.4 Updated
    `test/domain/training/user_profile_test.dart` with `copyWith`
    and equality tests for calibration fields
  - [x] 9.5 `flutter test` — all 63 tests pass

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Architecture doc references Isar throughout. The project uses Drift
2.31.0 (pivoted in Story 1.1 due to Dart 3.11.0 incompatibility).

| Architecture Doc Term | Actual Implementation |
|---|---|
| `@Collection()` | `class UserProfiles extends Table { ... }` |
| `Isar.autoIncrement` | `integer().autoIncrement()()` |
| `IsarLinks` | Drift relations (future stories) |
| `writeTxn()` | `db.transaction(() async { ... })` |
| `Isar.open([...])` | `AppDatabase(NativeDatabase.memory())` for tests |

### CRITICAL — No riverpod_generator

`riverpod_generator` is absent because `analyzer` version conflicts
with `drift_dev`. Do NOT use `@riverpod` or `@Riverpod` annotations.

All providers must be manually defined:

```dart
// Correct: manual definition
final beginnerCalibrationServiceProvider =
    Provider<BeginnerCalibrationService>((ref) {
  return const BeginnerCalibrationService();
});

// WRONG: codegen annotation
@riverpod
BeginnerCalibrationService beginnerCalibrationService(
  BeginnerCalibrationServiceRef ref,
) { ... }
```

### CRITICAL — Additive Schema Migration (schemaVersion 2 → 3)

Story 1.2 left the database at `schemaVersion = 2`. Story 1.3 adds
two new columns with `ALTER TABLE` (additive migration — existing
data is preserved, unlike the `recreateAllTables` used in 1.2).

```dart
// lib/data/local/app_database.dart
@DriftDatabase(tables: [UserProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3; // 1.3 adds calibration columns

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.drop(userProfiles);
        await m.createTable(userProfiles);
      }
      if (from < 3) {
        // Additive migration — preserves existing profile data
        await m.addColumn(
          userProfiles,
          userProfiles.calibrationSessionsCompleted,
        );
        await m.addColumn(
          userProfiles,
          userProfiles.calibrationTargetSessions,
        );
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ironmon_db');
  }
}
```

> Note: `m.addColumn()` is the Drift API for adding a single column
> in a migration. The column must have a `DEFAULT` value in the table
> definition so existing rows receive the default automatically.

### Updated Drift Table Schema

The full `UserProfiles` table after Story 1.3 additions:

```dart
// lib/data/local/tables/user_profile_table.dart
import 'package:drift/drift.dart';

/// UserProfile Drift table — singleton pattern (only one row,
/// id == 1). Stores player's character state, 5RM values,
/// preferences, and calibration progress.
@DataClassName('UserProfileEntity')
class UserProfiles extends Table {
  /// Auto-incremented primary key (always 1 for singleton profile).
  IntColumn get id => integer().autoIncrement()();

  // --- Character Stats ---
  /// Current player level (starts at 1).
  IntColumn get level => integer().withDefault(const Constant(1))();

  /// Accumulated experience points.
  IntColumn get experiencePoints =>
      integer().withDefault(const Constant(0))();

  // --- 5RM Values (kg) ---
  /// Squat 5-rep max in kilograms.
  RealColumn get squatFiveRm =>
      real().withDefault(const Constant(0))();

  /// Bench press 5-rep max in kilograms.
  RealColumn get benchPressFiveRm =>
      real().withDefault(const Constant(0))();

  /// Deadlift 5-rep max in kilograms.
  RealColumn get deadliftFiveRm =>
      real().withDefault(const Constant(0))();

  /// Overhead press 5-rep max in kilograms.
  RealColumn get overheadPressFiveRm =>
      real().withDefault(const Constant(0))();

  // --- Training Preferences ---
  /// Weekly training frequency in days (1–7).
  IntColumn get weeklyFrequency =>
      integer().withDefault(const Constant(3))();

  /// Whether the player is in beginner auto-calibration mode.
  BoolColumn get isBeginnerMode =>
      boolean().withDefault(const Constant(false))();

  // --- Calibration Progress (Story 1.3) ---
  /// Number of sessions completed during beginner calibration.
  IntColumn get calibrationSessionsCompleted =>
      integer().withDefault(const Constant(0))();

  /// Target number of calibration sessions (default 5).
  IntColumn get calibrationTargetSessions =>
      integer().withDefault(const Constant(5))();

  // --- Move Progression ---
  /// JSON-encoded list of unlocked move IDs.
  TextColumn get unlockedMoveIds =>
      text().withDefault(const Constant('[]'))();
}
```

> `@DataClassName('UserProfileEntity')` is required. Without it,
> Drift generates a class named `UserProfile` which conflicts with
> the domain model `UserProfile` in `lib/domain/`.

### Updated Domain Model

```dart
// lib/domain/training/models/user_profile.dart
// Add two new fields to the existing class:

/// Immutable domain model representing a player's profile.
/// Pure Dart — zero Flutter/Drift dependency.
class UserProfile {
  const UserProfile({
    this.id = 0,
    this.level = 1,
    this.experiencePoints = 0,
    this.squatFiveRm = 0.0,
    this.benchPressFiveRm = 0.0,
    this.deadliftFiveRm = 0.0,
    this.overheadPressFiveRm = 0.0,
    this.weeklyFrequency = 3,
    this.isBeginnerMode = false,
    this.calibrationSessionsCompleted = 0,  // NEW
    this.calibrationTargetSessions = 5,     // NEW
    this.unlockedMoveIds = const [],
  });

  // ... (existing fields unchanged)

  /// Sessions completed during auto-calibration (0 to
  /// calibrationTargetSessions).
  final int calibrationSessionsCompleted;

  /// Target sessions for auto-calibration to complete (default 5).
  final int calibrationTargetSessions;

  // ... copyWith must include both new fields
  // ... == override must include both new fields
  // ... hashCode must include both new fields
}
```

> The `==` override in Story 1.2 already omits `unlockedMoveIds`
> from equality (list equality requires `listEquals`). Follow the
> same pattern — include `calibrationSessionsCompleted` and
> `calibrationTargetSessions` in `==` and `hashCode` since they are
> primitive `int` fields.

### BeginnerCalibrationService Implementation

```dart
// lib/domain/training/beginner_calibration_service.dart
import 'package:ironmon/domain/training/models/user_profile.dart';

/// Pure Dart service for beginner mode 5RM auto-calibration.
/// Implements the Epley formula to estimate 5RM from actual
/// training sets.
///
/// Formula: estimated1RM = weight × (1 + reps / 30)
/// Convert to 5RM: fiveRm = estimated1RM / 1.0678
///
/// Reference: Epley B. (1985). Poundage Chart. Boyd Epley
/// Workout. Lincoln, NE: Body Enterprises.
class BeginnerCalibrationService {
  /// Creates a [BeginnerCalibrationService].
  const BeginnerCalibrationService();

  /// Estimates 5RM from a single set using the Epley formula.
  ///
  /// Returns 0.0 if [weight] or [reps] is not positive.
  double estimateFiveRm(double weight, int reps) {
    if (weight <= 0 || reps <= 0) return 0.0;
    final estimated1Rm = weight * (1 + reps / 30);
    return estimated1Rm / 1.0678;
  }

  /// Applies calibration estimates to [profile], updating 5RM
  /// values only when the new estimate exceeds the current value.
  ///
  /// [newEstimates] keys must be: 'squat', 'benchPress',
  /// 'deadlift', 'overheadPress'. Missing keys are ignored.
  ///
  /// Increments [UserProfile.calibrationSessionsCompleted] and
  /// transitions [UserProfile.isBeginnerMode] to false when the
  /// target is reached.
  UserProfile applyCalibration(
    UserProfile profile,
    Map<String, double> newEstimates,
  ) {
    final newSquat = newEstimates['squat'] ?? 0.0;
    final newBench = newEstimates['benchPress'] ?? 0.0;
    final newDeadlift = newEstimates['deadlift'] ?? 0.0;
    final newOhp = newEstimates['overheadPress'] ?? 0.0;

    final updatedSessions =
        profile.calibrationSessionsCompleted + 1;
    final calibrationComplete =
        updatedSessions >= profile.calibrationTargetSessions;

    return profile.copyWith(
      squatFiveRm: newSquat > profile.squatFiveRm
          ? newSquat
          : profile.squatFiveRm,
      benchPressFiveRm: newBench > profile.benchPressFiveRm
          ? newBench
          : profile.benchPressFiveRm,
      deadliftFiveRm: newDeadlift > profile.deadliftFiveRm
          ? newDeadlift
          : profile.deadliftFiveRm,
      overheadPressFiveRm: newOhp > profile.overheadPressFiveRm
          ? newOhp
          : profile.overheadPressFiveRm,
      calibrationSessionsCompleted: updatedSessions,
      isBeginnerMode: calibrationComplete ? false
          : profile.isBeginnerMode,
    );
  }
}
```

> This service is stateless. The Riverpod provider creates a single
> `const` instance. No `async` operations — all computation is
> synchronous (satisfies NFR1 <16ms budget awareness).

### Epley Formula Reference Values

To verify unit tests produce correct expected values:

| Input | Calc | Expected 5RM |
|---|---|---|
| 20 kg × 15 reps | 20 × (1 + 15/30) = 30 / 1.0678 | ≈ 28.1 kg |
| 60 kg × 8 reps | 60 × (1 + 8/30) = 76 / 1.0678 | ≈ 71.2 kg |
| 100 kg × 5 reps | 100 × (1 + 5/30) ≈ 116.67 / 1.0678 | ≈ 109.3 kg |

> The 1RM → 5RM divisor `1.0678` comes from applying the inverse
> Epley formula with 5 reps: `1RM = 5RM × (1 + 5/30)` → dividing
> both sides gives the constant. Use `closeTo(expected, 0.1)` in
> tests to allow for floating-point rounding.

### Updated Mapper

```dart
// lib/data/mappers/user_profile_mapper.dart (additions only)

static UserProfile toDomain(UserProfileEntity entity) {
  return UserProfile(
    // ... existing fields ...
    calibrationSessionsCompleted:     // NEW
        entity.calibrationSessionsCompleted,
    calibrationTargetSessions:        // NEW
        entity.calibrationTargetSessions,
  );
}

static UserProfilesCompanion toInsertable(UserProfile profile) {
  return UserProfilesCompanion.insert(
    // ... existing fields ...
    calibrationSessionsCompleted:     // NEW
        Value(profile.calibrationSessionsCompleted),
    calibrationTargetSessions:        // NEW
        Value(profile.calibrationTargetSessions),
  );
}
```

### updateCalibration Repository Method

```dart
// lib/data/repositories/user_profile_repository.dart (additions)

// In abstract interface:
/// Atomically persists calibration-updated profile.
/// Use this instead of [updateUserProfile] after calibration
/// to ensure no partial writes on interruption.
Future<Result<UserProfile, Exception>> updateCalibration(
  UserProfile profile,
);

// In DriftUserProfileRepository:
@override
Future<Result<UserProfile, Exception>> updateCalibration(
  UserProfile profile,
) async {
  try {
    await _db.transaction(() async {
      await (_db.update(_db.userProfiles)
            ..where((t) => t.id.equals(profile.id)))
          .write(UserProfileMapper.toInsertable(profile));
    });
    final updated =
        await _db.select(_db.userProfiles).getSingleOrNull();
    return Success(UserProfileMapper.toDomain(updated!));
  } on Exception catch (e) {
    return Failure(e);
  }
}
```

> `db.transaction()` wraps the write atomically — if the app
> crashes mid-write, the database rolls back. This satisfies the
> spirit of NFR10 (atomic updates) for calibration data.

### OnboardingScreen Beginner Mode Toggle Pattern

```dart
// lib/presentation/onboarding/onboarding_screen.dart (additions)

// State variables to add:
bool _isBeginnerMode = false;

// Widget to add above the 5RM cards:
SwitchListTile(
  title: const Text('Beginner Mode'),
  subtitle: const Text(
    'Start with minimum weights. System auto-calibrates '
    'your 5RM over your first 5 sessions.',
  ),
  value: _isBeginnerMode,
  onChanged: (value) {
    setState(() {
      _isBeginnerMode = value;
      if (value) {
        // Pre-fill all 5RM fields with empty barbell (20 kg)
        _squatController.text = '20';
        _benchController.text = '20';
        _deadliftController.text = '20';
        _ohpController.text = '20';
      }
    });
  },
),

// In the save call:
await ref.read(userProfileProvider.notifier).saveProfile(
  UserProfile(
    squatFiveRm: double.parse(_squatController.text),
    benchPressFiveRm: double.parse(_benchController.text),
    deadliftFiveRm: double.parse(_deadliftController.text),
    overheadPressFiveRm: double.parse(_ohpController.text),
    weeklyFrequency: _weeklyFrequency,
    isBeginnerMode: _isBeginnerMode,
    calibrationSessionsCompleted: 0,
    calibrationTargetSessions: 5,
  ),
);
```

### ProfileEditScreen Route Addition

```dart
// lib/router/app_router.dart — add nested under '/'

GoRoute(
  path: '/profile/edit',
  name: 'profileEditRoute',
  builder: (context, state) => const ProfileEditScreen(),
),
```

> This story scopes `ProfileEditScreen` as a functional screen for
> manual 5RM override (AC 12, 13). A placeholder navigation entry
> on `HomeScreen` is acceptable (e.g., an `IconButton` with a
> settings icon calling `context.push('/profile/edit')`).

### Test Pattern (NativeDatabase.memory() Injection)

```dart
// test/domain/training/beginner_calibration_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/beginner_calibration_service.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  const service = BeginnerCalibrationService();

  group('estimateFiveRm', () {
    test('returns correct estimate for 100 kg × 5 reps', () {
      final result = service.estimateFiveRm(100, 5);
      expect(result, closeTo(109.3, 0.1));
    });

    test('returns 0.0 for zero weight', () {
      expect(service.estimateFiveRm(0, 5), 0.0);
    });

    test('returns 0.0 for zero reps', () {
      expect(service.estimateFiveRm(100, 0), 0.0);
    });
  });

  group('applyCalibration', () {
    test('increments calibrationSessionsCompleted', () {
      const profile = UserProfile(isBeginnerMode: true);
      final result = service.applyCalibration(profile, {});
      expect(result.calibrationSessionsCompleted, 1);
    });

    test('does not decrease 5RM when estimate is lower', () {
      const profile = UserProfile(
        squatFiveRm: 50.0,
        isBeginnerMode: true,
      );
      final result = service.applyCalibration(
        profile,
        {'squat': 30.0},
      );
      expect(result.squatFiveRm, 50.0);
    });

    test('increases 5RM when estimate is higher', () {
      const profile = UserProfile(
        squatFiveRm: 20.0,
        isBeginnerMode: true,
      );
      final result = service.applyCalibration(
        profile,
        {'squat': 50.0},
      );
      expect(result.squatFiveRm, 50.0);
    });

    test('sets isBeginnerMode false when target reached', () {
      const profile = UserProfile(
        isBeginnerMode: true,
        calibrationSessionsCompleted: 4,
        calibrationTargetSessions: 5,
      );
      final result = service.applyCalibration(profile, {});
      expect(result.isBeginnerMode, isFalse);
      expect(result.calibrationSessionsCompleted, 5);
    });

    test('does not exit beginner mode before target reached', () {
      const profile = UserProfile(
        isBeginnerMode: true,
        calibrationSessionsCompleted: 3,
        calibrationTargetSessions: 5,
      );
      final result = service.applyCalibration(profile, {});
      expect(result.isBeginnerMode, isTrue);
    });
  });
}
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `lib/domain/` — zero `import 'package:drift/...'` or `import 'package:flutter/...'` |
| **BeginnerCalibrationService** | Must be pure Dart, stateless, synchronous |
| **Data Boundary** | Repository never returns `UserProfileEntity` — always maps through `UserProfileMapper` |
| **State Immutability** | All 5RM and calibration updates via `copyWith` |
| **Import Style** | `package:ironmon/...` only — no relative imports |
| **Provider Naming** | `beginnerCalibrationServiceProvider` |
| **Sealed Class Switch** | `Result` switch must exhaust `Success` and `Failure` — no `default` |
| **very_good_analysis** | All public members need `///` doc comments; lines ≤ 80 chars |
| **Drift Defaults** | Use `const Constant(0)` not `const Constant(0.0)` for integer columns |

### New Files Expected

```
ironmon/lib/domain/training/beginner_calibration_service.dart — CREATE
ironmon/lib/presentation/profile/profile_edit_screen.dart — CREATE
ironmon/test/domain/training/beginner_calibration_service_test.dart — CREATE
```

### Files to Update

```
ironmon/lib/domain/training/models/user_profile.dart — UPDATE
ironmon/lib/data/local/tables/user_profile_table.dart — UPDATE
ironmon/lib/data/local/app_database.dart — UPDATE (schemaVersion 3)
ironmon/lib/data/mappers/user_profile_mapper.dart — UPDATE
ironmon/lib/data/repositories/user_profile_repository.dart — UPDATE
ironmon/lib/providers/training_providers.dart — CREATE or UPDATE
ironmon/lib/router/app_router.dart — UPDATE (/profile/edit route)
ironmon/lib/presentation/onboarding/onboarding_screen.dart — UPDATE
ironmon/test/data/mappers/user_profile_mapper_test.dart — UPDATE
ironmon/test/data/repositories/user_profile_repository_test.dart — UPDATE
ironmon/test/domain/training/user_profile_test.dart — UPDATE
```

### Common Pitfalls to Avoid

1. **Do NOT re-add `isBeginnerMode`** — it already exists in the
   Drift table and domain model from Story 1.2. Adding it again will
   cause a compile error.
2. **Migration order matters** — the `from < 2` block runs `drop +
   recreate`; the `from < 3` block runs `addColumn`. If a device has
   `schemaVersion = 1` it will execute both blocks sequentially. Dart
   does NOT break after the first matching `if` — both will run,
   which is correct: recreate (version 1→2 drops the old column), then
   add new columns (1→3 path works because `createAll` in `onCreate`
   creates the table with all columns including the new ones — the
   `from < 3` `addColumn` is only reached in `onUpgrade` from v2).
3. **`m.addColumn()` requires the column object** — pass the getter
   reference from the table instance: `userProfiles
   .calibrationSessionsCompleted`, not a string name.
4. **`UserProfilesCompanion.insert` vs `.insertOnConflictUpdate`** —
   the repository uses `insertOnConflictUpdate`. The Companion fields
   for new columns must be wrapped in `Value(...)`. `Value.absent()`
   is NOT appropriate here — explicit values must be provided.
5. **Line length** — `very_good_analysis` enforces ≤ 80 chars per
   line. The `BeginnerCalibrationService` import paths and method
   signatures in the story examples above may need line-breaking in
   actual code.
6. **`closeTo` matcher** — use `package:test/test.dart`'s `closeTo(
   expected, delta)` for all floating-point assertions in the Epley
   formula tests. Never use `equals()` with doubles.

### Calibration UX Notes (Story Scope Only)

- The calibration progress display ("Calibrating 0/5") is scoped to
  Story 1.4 (Home Screen) where the player's profile summary is
  shown. In this story, only the onboarding toggle and database
  persistence are required.
- The actual session-end calibration trigger (calling
  `BeginnerCalibrationService.applyCalibration` after a battle
  concludes) is referenced here architecturally but will be wired
  in the battle stories (Epic 2). This story establishes the
  domain service and data layer; the battle engine will consume it.
- For now, expose `beginnerCalibrationServiceProvider` in
  `training_providers.dart` — it will be read by the battle
  providers in later stories.

### References

- [Source: epics.md#Story 1.3] — User story, acceptance criteria
  basis, FR2 coverage
- [Source: prd.md#Journey 2 — 小美的冒險] — Beginner mode UX
  context: minimum weights, auto-calibration over first few sessions,
  bodyweight starter moves
- [Source: prd.md#FR2] — "使用者可以選擇「初學者模式」，系統透過前
  3-5 次訓練自動校正 5RM 基準值"
- [Source: architecture.md#Data Architecture] — Drift singleton
  pattern, transaction writes for data integrity
- [Source: architecture.md#Domain Boundary] — Pure Dart domain
  services, zero Flutter/Drift imports in `lib/domain/`
- [Source: architecture.md#Error Handling Flow] — `Result<T, E>` in
  repository layer
- [Source: 1-2-player-profile-creation-persistence.md#Dev Notes] —
  Drift pivot confirmed, no riverpod_generator, schemaVersion 2,
  `@DataClassName('UserProfileEntity')` pattern, `meta: ^1.15.0`
  in pubspec.yaml
- [Source: 1-2-player-profile-creation-persistence.md#Dev Agent
  Record#Completion Notes] — `prefer_int_literals` lint: use
  `Constant(0)` not `Constant(0.0)` for RealColumn defaults

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

- Fixed pre-existing Drift schema bug: `customConstraint('NOT NULL PRIMARY KEY CHECK (id = 1)')` caused double PRIMARY KEY declaration in generated SQL. Fixed by changing to `customConstraint('NOT NULL CHECK (id = 1)')` with explicit `@override Set<Column> get primaryKey => {id}`. This unblocked all repository tests.

### Completion Notes List

- Expanded `UserProfile` domain model with `calibrationSessionsCompleted` (default 0) and `calibrationTargetSessions` (default 5) fields including `copyWith`, `==`, `hashCode`
- Updated Drift schema: two new integer columns with defaults; bumped `schemaVersion` 2 → 3 with additive `m.addColumn()` migration preserving existing data
- Updated `UserProfileMapper`: `toDomain()`, `toInsertable()`, `toUpdateCompanion()` all include new calibration fields
- Created `BeginnerCalibrationService`: pure Dart, stateless, synchronous; implements Epley formula for 5RM estimation and `applyCalibration` for session-based updates
- Created `training_providers.dart` with `beginnerCalibrationServiceProvider`
- Added `updateCalibration` method to repository interface and `DriftUserProfileRepository` using `db.transaction()` for atomic writes
- Updated `OnboardingScreen` with `SwitchListTile` for Beginner Mode; auto-fills 5RM fields with 20 kg when enabled
- Created `ProfileEditScreen` for manual 5RM override; preserves calibration state on save
- Added `/profile/edit` route to router; `HomeScreen` has settings icon entry point
- All 63 tests pass; `flutter analyze` reports zero issues
- Fixed double-PRIMARY-KEY Drift bug as part of this work

### File List

ironmon/lib/domain/training/models/user_profile.dart
ironmon/lib/domain/training/beginner_calibration_service.dart
ironmon/lib/data/local/tables/user_profile_table.dart
ironmon/lib/data/local/app_database.dart
ironmon/lib/data/local/app_database.g.dart
ironmon/lib/data/mappers/user_profile_mapper.dart
ironmon/lib/data/repositories/user_profile_repository.dart
ironmon/lib/providers/training_providers.dart
ironmon/lib/providers/repository_providers.dart
ironmon/lib/providers/user_profile_providers.dart
ironmon/lib/presentation/onboarding/onboarding_screen.dart
ironmon/lib/presentation/profile/profile_edit_screen.dart
ironmon/lib/presentation/home/home_screen.dart
ironmon/lib/router/app_router.dart
ironmon/test/domain/training/user_profile_test.dart
ironmon/test/domain/training/beginner_calibration_service_test.dart
ironmon/test/data/mappers/user_profile_mapper_test.dart
ironmon/test/data/repositories/user_profile_repository_test.dart

### Change Log

- Story 1.3 implementation: Beginner Mode & Auto-Calibration (Date: 2026-02-26)
