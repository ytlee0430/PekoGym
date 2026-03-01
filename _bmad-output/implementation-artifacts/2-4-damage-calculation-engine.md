# Story 2.4: Damage Calculation Engine

Status: done

## Story

As a player,
I want my actual training performance to translate into meaningful battle damage,
So that heavier weights and higher effort deal more damage.

## Acceptance Criteria

1. **Given** a player completes a set with weight, reps, and RPE
   **When** damage is calculated
   **Then** the formula applies: Intensity (weight/5RM) × Type Multiplier × RPE Multiplier (FR9)
2. **And** type effectiveness multiplier is applied (1.5x / 1.0x / 0.5x) (FR10)
3. **And** RPE multiplier is applied (RPE 6-7: 1.0x, RPE 8: 1.2x, RPE 9-10: 1.5x) (FR13)
4. **And** in Strength Gym, single-hit damage below boss defense threshold shows "Not Very Effective" (FR11)
5. **And** calculation completes in <16ms synchronously (NFR1)
6. **And** `DamageCalculator` is Pure Dart with unit tests covering all multiplier combinations

## Tasks / Subtasks

- [x] Task 1: Create `DamageResult` domain model (AC: 1, 4)
  - [x] 1.1 Create `lib/domain/battle/models/damage_result.dart` — immutable Pure Dart class
  - [x] 1.2 Fields: `rawDamage` (double), `finalDamage` (int), `typeMultiplier` (double), `rpeMultiplier` (double), `intensity` (double), `isEffective` (bool), `effectiveness` (enum: superEffective, neutral, notVeryEffective)

- [x] Task 2: Create `ExerciseSet` domain model (AC: 1)
  - [x] 2.1 Create `lib/domain/training/models/exercise_set.dart` — immutable Pure Dart class
  - [x] 2.2 Fields: `moveId` (String), `weight` (double), `reps` (int), `rpe` (int), `setNumber` (int)
  - [x] 2.3 Include `copyWith`, `==`, `hashCode`

- [x] Task 3: Implement `DamageCalculator` (AC: 1, 2, 3, 4, 5)
  - [x] 3.1 Create `lib/domain/battle/damage_calculator.dart` — Pure Dart, synchronous
  - [x] 3.2 Constructor takes `TypeEffectiveness` dependency
  - [x] 3.3 Implement `DamageResult calculate({required ExerciseSet set, required MoveDefinition move, required MuscleType bossType, required double playerFiveRm, required int bossDefense, required GymType gymType})`
  - [x] 3.4 Intensity = `set.weight / playerFiveRm` (clamped to 0.0–2.0)
  - [x] 3.5 Base damage = `intensity * move.power * set.reps`
  - [x] 3.6 Apply type multiplier from `TypeEffectiveness`
  - [x] 3.7 Apply RPE multiplier: RPE ≤ 5: 0.8x, RPE 6-7: 1.0x, RPE 8: 1.2x, RPE 9-10: 1.5x
  - [x] 3.8 Final damage = `(baseDamage * typeMultiplier * rpeMultiplier).round()`
  - [x] 3.9 In Strength Gym: if `finalDamage < bossDefense`, set `isEffective = false`
  - [x] 3.10 All operations synchronous — zero async/await

- [x] Task 4: Create Riverpod provider (AC: 1)
  - [x] 4.1 Add `damageCalculatorProvider` to `lib/providers/battle_providers.dart`
  - [x] 4.2 Inject `TypeEffectiveness` via provider dependency

- [x] Task 5: Tests (AC: 1, 2, 3, 4, 5, 6)
  - [x] 5.1 Create `test/domain/battle/damage_calculator_test.dart`
  - [x] 5.2 Test base damage formula with known inputs
  - [x] 5.3 Test all RPE multiplier tiers (≤5, 6-7, 8, 9-10)
  - [x] 5.4 Test all type effectiveness multipliers (0.5x, 1.0x, 1.5x)
  - [x] 5.5 Test Strength Gym defense threshold ("Not Very Effective")
  - [x] 5.6 Test Physique Gym has no defense threshold
  - [x] 5.7 Test intensity clamping (weight > 2× 5RM)
  - [x] 5.8 Test edge cases: zero weight, zero reps, zero 5RM
  - [x] 5.9 Performance test: verify calculation completes in <16ms
  - [x] 5.10 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Architecture doc references Isar. Project uses Drift 2.31.0.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is Pure Dart domain logic. No Drift tables, no migrations.

### CRITICAL — Synchronous Only (NFR1: <16ms)

`DamageCalculator` must be completely synchronous. No `Future`, no
`async`, no `await`. The architecture doc explicitly states:
"DamageCalculator: Intensity × TypeMultiplier × RPEMultiplier（同步 <16ms）"

### Dependencies on Previous Stories

- **Story 2.1** — `TypeEffectiveness`, `MuscleType`
- **Story 2.2** — `MoveDefinition` (for `move.power` and `move.type`)
- **Story 2.3** — `GymType`, `Boss` (for `bossDefense` and `bossType`)

### Damage Formula Breakdown

```
Intensity = weight / playerFiveRm  (clamped 0.0–2.0)
BaseDamage = Intensity × MovePower × Reps
TypeMul = TypeEffectiveness.getMultiplier(moveType, bossType)
RPEMul = RPE ≤ 5 → 0.8 | RPE 6-7 → 1.0 | RPE 8 → 1.2 | RPE 9-10 → 1.5
FinalDamage = round(BaseDamage × TypeMul × RPEMul)

// Strength Gym only:
if (FinalDamage < BossDefense) → "Not Very Effective" (damage still applies but flagged)
```

### RPE Multiplier Rationale

| RPE | Effort Level | Multiplier | Description |
|-----|---|---|---|
| 1-5 | Light | 0.8x | Warmup / easy sets |
| 6-7 | Moderate | 1.0x | Standard working sets |
| 8 | Hard | 1.2x | Challenging sets |
| 9-10 | Maximum | 1.5x | Near-failure / PR attempts |

### Implementation Pattern

```dart
/// Synchronous damage calculator for battle system.
/// Pure Dart — zero Flutter dependency.
/// Completes in <16ms (NFR1).
class DamageCalculator {
  /// Creates a [DamageCalculator] with type effectiveness.
  const DamageCalculator({
    required TypeEffectiveness typeEffectiveness,
  }) : _typeEffectiveness = typeEffectiveness;

  final TypeEffectiveness _typeEffectiveness;

  /// Calculates damage for a single training set.
  DamageResult calculate({
    required ExerciseSet set,
    required MoveDefinition move,
    required MuscleType bossType,
    required double playerFiveRm,
    required int bossDefense,
    required GymType gymType,
  }) {
    if (playerFiveRm <= 0) {
      return DamageResult.zero();
    }

    final intensity =
        (set.weight / playerFiveRm).clamp(0.0, 2.0);
    final baseDamage = intensity * move.power * set.reps;

    final typeMultiplier = _typeEffectiveness
        .getMultiplier(move.type, bossType);
    final rpeMultiplier = _getRpeMultiplier(set.rpe);

    final rawDamage =
        baseDamage * typeMultiplier * rpeMultiplier;
    final finalDamage = rawDamage.round();

    final isEffective = gymType != GymType.strength ||
        finalDamage >= bossDefense;

    return DamageResult(
      rawDamage: rawDamage,
      finalDamage: finalDamage,
      typeMultiplier: typeMultiplier,
      rpeMultiplier: rpeMultiplier,
      intensity: intensity,
      isEffective: isEffective,
    );
  }

  double _getRpeMultiplier(int rpe) {
    if (rpe >= 9) return 1.5;
    if (rpe == 8) return 1.2;
    if (rpe >= 6) return 1.0;
    return 0.8;
  }
}
```

### 5RM Mapping for Damage Calculation

The player's `UserProfile` has 4 separate 5RM values. The damage
calculator needs to know which 5RM to use based on the move's type:

| Move Type | 5RM Field |
|---|---|
| Chest (Fire) | `benchPressFiveRm` |
| Back (Water) | `deadliftFiveRm` (or barbell row — choose one) |
| Legs (Rock) | `squatFiveRm` |
| Shoulders (Electric) | `overheadPressFiveRm` |
| Arms (Fighting) | `benchPressFiveRm` (shared — no separate arm 5RM) |

The caller (Battle Engine in Story 2.5) is responsible for selecting
the correct 5RM value based on the move type.

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `DamageCalculator` — zero Flutter/Drift imports |
| **Synchronous** | No `Future`, `async`, `await` — NFR1 <16ms |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition — no `@riverpod` |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **Immutability** | `DamageResult` and `ExerciseSet` immutable with `copyWith` |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/battle/damage_calculator.dart
ironmon/lib/domain/battle/models/damage_result.dart
ironmon/lib/domain/training/models/exercise_set.dart
ironmon/test/domain/battle/damage_calculator_test.dart
```

Files to update:

```
ironmon/lib/providers/battle_providers.dart
```

### References

- [Source: epics.md#Story 2.4] — User story, acceptance criteria
- [Source: architecture.md#Domain Layer] — DamageCalculator: Intensity × TypeMul × RPEMul（同步 <16ms）
- [Source: architecture.md#Data Flow] — 戰鬥核心數據流
- [Source: architecture.md#Domain Boundary] — Pure Dart
- [Source: prd.md#FR9] — 傷害計算公式
- [Source: prd.md#FR13] — RPE 傷害加成倍率

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created DamageResult immutable model with Effectiveness enum
- Created ExerciseSet immutable model with copyWith
- Implemented synchronous DamageCalculator with full formula
- RPE multiplier tiers: ≤5→0.8, 6-7→1.0, 8→1.2, 9-10→1.5
- Strength Gym defense threshold check
- Intensity clamped 0.0–2.0
- Added damageCalculatorProvider to battle_providers.dart
- Comprehensive tests covering all multiplier combos, edge cases, perf

### File List
- ironmon/lib/domain/battle/models/damage_result.dart (new)
- ironmon/lib/domain/training/models/exercise_set.dart (new)
- ironmon/lib/domain/battle/damage_calculator.dart (new)
- ironmon/lib/providers/battle_providers.dart (modified)
- ironmon/test/domain/battle/damage_calculator_test.dart (new)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- DamageCalculator is Pure Dart, synchronous, meets NFR1 (<16ms)
- Correct formula: intensity × movePower × reps × typeMultiplier × rpeMultiplier
- RPE multiplier tiers (≥9→1.5, 8→1.2, ≥6→1.0, <6→0.8) match spec
- Strength gym defense threshold check properly implemented
- All ACs verified
