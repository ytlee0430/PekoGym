# Per-Exercise 5RM Estimation & Onboarding Redesign

Status: done

## Feature Summary

Replaced the generic muscle-group 5RM inputs with 4 specific standard compound lifts during
onboarding. The system auto-estimates 5RM values for all 15 exercises using fixed strength
ratios, then lets the user fine-tune them on an adjustment page. Per-exercise values are stored
in `UserProfile.exerciseFiveRms` and used in battle damage calculation.

## Changes Made

### New Files

- `ironmon/lib/domain/training/exercise_weight_estimator.dart` — CREATED

### Modified Files

- `ironmon/lib/domain/training/models/user_profile.dart` — added `exerciseFiveRms` field
- `ironmon/lib/data/local/tables/user_profile_table.dart` — added `exerciseFiveRms TEXT` column
- `ironmon/lib/data/local/app_database.dart` — bumped schema 8 → 9, added migration
- `ironmon/lib/data/mappers/user_profile_mapper.dart` — JSON encode/decode for `exerciseFiveRms`
- `ironmon/lib/data/local/app_database.g.dart` — regenerated via build_runner
- `ironmon/lib/presentation/onboarding/widgets/five_rm_input_card.dart` — added optional `exerciseName`/`exerciseSubtitle`
- `ironmon/lib/presentation/onboarding/onboarding_screen.dart` — 9-page experienced flow + adjustment page
- `ironmon/lib/domain/training/pr_detector.dart` — added `getFiveRmForExercise()` with fallback
- `ironmon/lib/presentation/battle/battle_screen.dart` — uses per-exercise 5RM lookup
- `ironmon/lib/presentation/home/widgets/five_rm_summary_card.dart` — "Deadlift" label → "Barbell Row"
- `ironmon/lib/presentation/profile/profile_edit_screen.dart` — "Deadlift" label → "Barbell Row"
- `ironmon/test/data/mappers/user_profile_mapper_test.dart` — added `exerciseFiveRms: '{}'` to UserProfileEntity constructors

---

## Architecture Details

### ExerciseWeightEstimator (`lib/domain/training/exercise_weight_estimator.dart`)

Pure static Dart service. Estimates all 15 exercise 5RMs from 4 compound inputs. Rounds to
nearest 2.5 kg.

```dart
class ExerciseWeightEstimator {
  static Map<String, double> estimateAll({
    required double benchPress,
    required double barbellRow,
    required double squat,
    required double shoulderPress,
  }) {
    final raw = <String, double>{
      'chest-1': benchPress * 0.50,      // Push-up
      'chest-2': benchPress,              // Barbell Bench Press (direct)
      'chest-3': benchPress * 0.75,      // Incline Dumbbell Press
      'back-1':  barbellRow * 0.55,      // Inverted Row
      'back-2':  barbellRow,             // Barbell Row (direct)
      'back-3':  barbellRow * 0.70,      // Lat Pulldown
      'legs-1':  squat * 0.40,           // Bodyweight Squat
      'legs-2':  squat,                  // Barbell Squat (direct)
      'legs-3':  squat * 0.80,           // Front Squat
      'shoulders-1': shoulderPress * 0.55, // Pike Push-up
      'shoulders-2': shoulderPress,        // Overhead Press (direct)
      'shoulders-3': shoulderPress * 0.70, // Arnold Press
      'arms-1': benchPress * 0.35,        // Diamond Push-up
      'arms-2': benchPress * 0.30,        // Barbell Curl
      'arms-3': benchPress * 0.35,        // Skull Crusher
    };
    return raw.map((k, v) => MapEntry(k, _roundToNearest2p5(v)));
  }

  static double _roundToNearest2p5(double value) =>
      (value / 2.5).round() * 2.5;
}
```

### UserProfile — New Field

```dart
final Map<String, double> exerciseFiveRms;  // default: const {}
```

`==` uses `MapEquality<String, double>()` from `package:collection`.
`hashCode` includes `MapEquality<String, double>().hash(exerciseFiveRms)`.
`copyWith` accepts nullable `Map<String, double>? exerciseFiveRms`.

### Database Schema (version 9)

New column in `UserProfiles` table:

```dart
TextColumn get exerciseFiveRms =>
    text().withDefault(const Constant('{}'))();
```

Migration:

```dart
if (from < 9) {
  await m.addColumn(userProfiles, userProfiles.exerciseFiveRms);
}
```

### Mapper

```dart
// toDomain:
exerciseFiveRms: _decodeExerciseFiveRms(entity.exerciseFiveRms),

// toInsertable / toUpdateCompanion:
exerciseFiveRms: Value(_encodeExerciseFiveRms(profile.exerciseFiveRms)),

// Helpers:
static Map<String, double> _decodeExerciseFiveRms(String json) {
  final decoded = jsonDecode(json) as Map<String, dynamic>;
  return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
}
static String _encodeExerciseFiveRms(Map<String, double> map) =>
    jsonEncode(map);
```

### FiveRmInputCard — Optional Override Params

```dart
const FiveRmInputCard({
  required this.muscleType,
  required this.value,
  required this.onChanged,
  this.validator,
  this.exerciseName,       // overrides muscleType.displayName
  this.exerciseSubtitle,   // overrides muscleType.elementName
  super.key,
});
```

When `exerciseName` is non-null, the card title shows the exercise name instead of the
muscle group name (e.g. "Barbell Bench Press" instead of "Chest").

### Onboarding Flow (Experienced Mode)

**Before:** 8 pages — Welcome, Mode, Chest, Back, Legs, Shoulders, Frequency, Confirm
**After:** 9 pages — Welcome, Mode, BenchPress, BarbellRow, Squat, OHP, AdjustAll, Frequency, Confirm

Pages 2-5 use `_buildStandardLiftPage()` with exercise-specific names:
- Page 2: `exerciseName: 'Barbell Bench Press'`, `exerciseSubtitle: 'Standard barbell compound'`
- Page 3: `exerciseName: 'Barbell Row'`, `exerciseSubtitle: 'Standard back compound'`
- Page 4: `exerciseName: 'Barbell Squat'`, `exerciseSubtitle: 'Standard leg compound'`
- Page 5: `exerciseName: 'Overhead Press'`, `exerciseSubtitle: 'Standard shoulder compound'`

Page 6: `_buildExerciseAdjustmentPage()` — scrollable list of all 15 exercises grouped by
muscle type. The 4 standard lifts show lock icon + read-only value. The other 11 show inline
editable TextFormField. `ExerciseWeightEstimator.estimateAll()` is called when entering page 6.

On submit: `exerciseFiveRms: _isBeginnerMode ? const {} : Map.unmodifiable(_exerciseFiveRms)`

### PRDetector — Per-Exercise Lookup

```dart
double getFiveRmForExercise(
  UserProfile profile,
  String moveId,
  MuscleType muscleType,
) {
  final override = profile.exerciseFiveRms[moveId];
  if (override != null && override > 0) return override;
  return getFiveRmForType(profile, muscleType); // fallback
}
```

`getFiveRmForType()` is unchanged — still used by `BeginnerCalibrationService`.

### BattleScreen — Updated Calls

**Damage calculation** (in `onSubmit` callback):
```dart
final fiveRm = profile != null
    ? detector.getFiveRmForExercise(profile, move.id, state.playerMuscleType)
    : 80.0;
```

**SetInputPanel prefill** (in `build`, before rendering):
```dart
// Last set for currently selected move only
final setsForMove = selectedMoveId == null
    ? <ExerciseSet>[]
    : state.completedSets.where((s) => s.moveId == selectedMoveId).toList();
final prevSetForMove = setsForMove.isEmpty ? null : setsForMove.last;

// Recommended weight: per-exercise 5RM if no history for this move
final recommendedWeight = prevSetForMove?.weight ??
    (profile != null && selectedMoveId != null
        ? prDetector.getFiveRmForExercise(profile, selectedMoveId, state.playerMuscleType)
        : null);

// Suggested reps: phase-appropriate if no history for this move
final suggestedReps = prevSetForMove?.reps ??
    switch (state.phase) {
      Warmup() => 12,
      MidBossPhase() => 8,
      GymLeaderPhase() => 5,
      _ => 10,
    };
```

This ensures each move shows its own recommended weight when selected, not a generic value.

### Label Changes: "Deadlift" → "Barbell Row"

The DB column remains `deadliftFiveRm` (no migration cost). All UI labels now say "Barbell Row":
- `FiveRmSummaryCard`: label `'Barbell Row'`
- `ProfileEditScreen`: `_buildField('Barbell Row', _deadliftController)`

---

## Exercise ID → Name Mapping

| ID | Exercise | Type | Standard |
|----|----------|------|---------|
| chest-1 | Push-up | Chest | No |
| chest-2 | Barbell Bench Press | Chest | Yes |
| chest-3 | Incline Dumbbell Press | Chest | No |
| back-1 | Inverted Row | Back | No |
| back-2 | Barbell Row | Back | Yes |
| back-3 | Lat Pulldown | Back | No |
| legs-1 | Bodyweight Squat | Legs | No |
| legs-2 | Barbell Squat | Legs | Yes |
| legs-3 | Front Squat | Legs | No |
| shoulders-1 | Pike Push-up | Shoulders | No |
| shoulders-2 | Overhead Press | Shoulders | Yes |
| shoulders-3 | Arnold Press | Shoulders | No |
| arms-1 | Diamond Push-up | Arms | No |
| arms-2 | Barbell Curl | Arms | No |
| arms-3 | Skull Crusher | Arms | No |

---

## Notes

- `exerciseFiveRms` defaults to `{}` so existing profiles and beginner-mode profiles are
  unaffected — battle damage falls back to muscle-type 5RM via `getFiveRmForType()`.
- DB column `deadliftFiveRm` name kept as-is to avoid migration churn; all UI says "Barbell Row".
- `ExerciseWeightEstimator` maps `barbellRow` parameter to the `deadliftFiveRm` field's
  corresponding move ID (`back-2`), not the DB column name.

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Completion Notes

1. `build_runner build --delete-conflicting-outputs` required after adding `exerciseFiveRms` column.
2. `package:collection` already a dependency — `MapEquality` available without pubspec change.
3. Test file `user_profile_mapper_test.dart` updated: added `exerciseFiveRms: '{}'` to both
   `UserProfileEntity` constructor calls (generated class now requires the field).
4. Pre-existing test failures in `five_rm_input_card_test.dart` (checks for Chinese `'胸部'` but
   widget returns English `'Chest'`) and `widget_test.dart` (button label mismatch) were NOT
   introduced by this change.

### File List

- `ironmon/lib/domain/training/exercise_weight_estimator.dart` — CREATED
- `ironmon/lib/domain/training/models/user_profile.dart` — UPDATED (exerciseFiveRms field)
- `ironmon/lib/data/local/tables/user_profile_table.dart` — UPDATED (exerciseFiveRms column)
- `ironmon/lib/data/local/app_database.dart` — UPDATED (schemaVersion 9, migration)
- `ironmon/lib/data/local/app_database.g.dart` — REGENERATED
- `ironmon/lib/data/mappers/user_profile_mapper.dart` — UPDATED (exerciseFiveRms encode/decode)
- `ironmon/lib/presentation/onboarding/widgets/five_rm_input_card.dart` — UPDATED (exerciseName, exerciseSubtitle params)
- `ironmon/lib/presentation/onboarding/onboarding_screen.dart` — REWRITTEN (9-page experienced flow)
- `ironmon/lib/domain/training/pr_detector.dart` — UPDATED (getFiveRmForExercise method)
- `ironmon/lib/presentation/battle/battle_screen.dart` — UPDATED (per-exercise 5RM lookup)
- `ironmon/lib/presentation/home/widgets/five_rm_summary_card.dart` — UPDATED (Deadlift → Barbell Row label)
- `ironmon/lib/presentation/profile/profile_edit_screen.dart` — UPDATED (Deadlift → Barbell Row label)
- `ironmon/test/data/mappers/user_profile_mapper_test.dart` — UPDATED (exerciseFiveRms: '{}' in entity constructors)
