# Story 2.1: Type Effectiveness System

Status: done

## Story

As a player,
I want the game to apply type advantages and disadvantages based on muscle groups,
So that my training choices have strategic meaning.

## Acceptance Criteria

1. **Given** 5 muscle types exist (Chest=Fire, Back=Water, Legs=Rock, Shoulders=Electric, Arms=Fighting)
   **When** the type effectiveness matrix is queried
   **Then** the 5×5 matrix returns correct multipliers (Super Effective 1.5x, Not Effective 0.5x, Neutral 1.0x) (FR26)
2. **And** the matrix is implemented as Pure Dart in `domain/type_system/` with zero Flutter dependency
3. **And** unit tests verify all 25 type matchup combinations
4. **And** the multiplier is applied to damage calculation output (FR27)

## Tasks / Subtasks

- [x] Task 1: Create `MuscleType` enum (AC: 1, 2)
  - [x] 1.1 Create `lib/domain/type_system/muscle_type.dart` — enum with 5 values: `chest`, `back`, `legs`, `shoulders`, `arms`
  - [x] 1.2 Add `displayName` and `elementName` getters (e.g., `chest` → "Fire", `back` → "Water", `legs` → "Rock", `shoulders` → "Electric", `arms` → "Fighting")
  - [x] 1.3 Ensure Pure Dart — zero `import 'package:flutter/...'`

- [x] Task 2: Implement `TypeEffectiveness` matrix (AC: 1, 2, 4)
  - [x] 2.1 Create `lib/domain/type_system/type_effectiveness.dart` — a Pure Dart class with a static/const 5×5 matrix
  - [x] 2.2 Implement `double getMultiplier(MuscleType attacker, MuscleType defender)` returning 1.5x (super effective), 0.5x (not effective), or 1.0x (neutral)
  - [x] 2.3 Define the type matchup matrix (design decision — see Dev Notes for suggested matrix)
  - [x] 2.4 Class must be `const` constructible and stateless

- [x] Task 3: Create Riverpod provider (AC: 4)
  - [x] 3.1 Add `typeEffectivenessProvider` to `lib/providers/type_system_providers.dart` as `Provider<TypeEffectiveness>`

- [x] Task 4: Tests (AC: 3)
  - [x] 4.1 Create `test/domain/type_system/type_effectiveness_test.dart`
  - [x] 4.2 Test all 25 matchup combinations (5 attackers × 5 defenders)
  - [x] 4.3 Test that super effective returns 1.5, not effective returns 0.5, neutral returns 1.0
  - [x] 4.4 Test `MuscleType` enum values and display names
  - [x] 4.5 `flutter analyze` reports zero issues
  - [x] 4.6 All existing tests continue to pass

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
final typeEffectivenessProvider =
    Provider<TypeEffectiveness>((ref) {
  return const TypeEffectiveness();
});
```

### This Story Is Pure Domain — No Data Layer Changes

This story touches only `lib/domain/type_system/` and
`lib/providers/type_system_providers.dart`. No Drift tables,
no schema changes, no migrations.

### Suggested Type Matchup Matrix

The architecture doc specifies 5 types but does NOT define the
exact matchup relationships. Here is a suggested Pokémon-inspired
matrix balancing gameplay:

| Attacker ↓ \ Defender → | Chest (Fire) | Back (Water) | Legs (Rock) | Shoulders (Electric) | Arms (Fighting) |
|---|---|---|---|---|---|
| **Chest (Fire)** | 1.0 | 0.5 | 1.5 | 1.0 | 1.0 |
| **Back (Water)** | 1.5 | 1.0 | 1.0 | 0.5 | 1.0 |
| **Legs (Rock)** | 1.0 | 1.0 | 1.0 | 1.5 | 0.5 |
| **Shoulders (Electric)** | 1.0 | 1.5 | 0.5 | 1.0 | 1.0 |
| **Arms (Fighting)** | 1.0 | 1.0 | 1.5 | 1.0 | 1.0 |

Each type has exactly 1 super-effective and 1 not-effective matchup
(except Arms which has 1 super-effective and 0 not-effective for
balance as the "generalist" type). Adjust if needed.

### Implementation Pattern

```dart
/// 5×5 type effectiveness matrix for muscle-type battle system.
/// Pure Dart — zero Flutter dependency.
class TypeEffectiveness {
  /// Creates a [TypeEffectiveness] instance.
  const TypeEffectiveness();

  static const _matrix = <MuscleType, Map<MuscleType, double>>{
    MuscleType.chest: {
      MuscleType.chest: 1.0,
      MuscleType.back: 0.5,
      MuscleType.legs: 1.5,
      // ...
    },
    // ...
  };

  /// Returns the damage multiplier for [attacker] vs [defender].
  ///
  /// - 1.5 = Super Effective
  /// - 0.5 = Not Very Effective
  /// - 1.0 = Neutral
  double getMultiplier(MuscleType attacker, MuscleType defender) {
    return _matrix[attacker]![defender]!;
  }
}
```

### MuscleType Enum Pattern

```dart
/// Represents the 5 muscle group types in the battle system.
/// Each maps to a Pokémon-style elemental type.
enum MuscleType {
  /// Chest — mapped to Fire element.
  chest,

  /// Back — mapped to Water element.
  back,

  /// Legs — mapped to Rock element.
  legs,

  /// Shoulders — mapped to Electric element.
  shoulders,

  /// Arms — mapped to Fighting element.
  arms;

  /// Human-readable display name.
  String get displayName {
    switch (this) {
      case MuscleType.chest:
        return 'Chest';
      // ...
    }
  }

  /// Elemental type name.
  String get elementName {
    switch (this) {
      case MuscleType.chest:
        return 'Fire';
      // ...
    }
  }
}
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `lib/domain/` — zero `import 'package:flutter/...'` or `import 'package:drift/...'` |
| **Import Style** | `package:ironmon/...` only — no relative imports |
| **Provider Pattern** | Manual `Provider<T>((ref) { ... })` — no `@riverpod` annotations |
| **Sealed Class Switch** | Enum switch must exhaust all values — no `default` |
| **very_good_analysis** | All public members need `///` doc comments; lines ≤ 80 chars |
| **Pure Dart** | `TypeEffectiveness` and `MuscleType` must have zero Flutter imports |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/type_system/muscle_type.dart
ironmon/lib/domain/type_system/type_effectiveness.dart
ironmon/lib/providers/type_system_providers.dart
ironmon/test/domain/type_system/type_effectiveness_test.dart
```

All paths follow the architecture spec's domain-first structure
under `domain/type_system/`.

### References

- [Source: epics.md#Story 2.1] — User story, acceptance criteria
- [Source: architecture.md#Type System] — `domain/type_system/type_effectiveness.dart`, 5×5 matrix
- [Source: architecture.md#Domain Boundary] — Pure Dart, zero Flutter dependency
- [Source: architecture.md#Structure Patterns] — `domain/type_system/` location
- [Source: architecture.md#Naming Patterns] — enum `lowerCamelCase` values
- [Source: 1-3-beginner-mode-auto-calibration.md#Dev Notes] — Drift pivot, no riverpod_generator

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created MuscleType enum with 5 values and displayName/elementName getters
- Implemented TypeEffectiveness 5×5 matrix as const Pure Dart class
- Created typeEffectivenessProvider as manual Provider
- All 25 matchup combinations tested
- Used suggested matrix from Dev Notes

### File List
- ironmon/lib/domain/type_system/muscle_type.dart (new)
- ironmon/lib/domain/type_system/type_effectiveness.dart (new)
- ironmon/lib/providers/type_system_providers.dart (new)
- ironmon/test/domain/type_system/type_effectiveness_test.dart (new)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- MuscleType enum is Pure Dart with correct 5-element mapping
- TypeEffectiveness 5×5 matrix correctly implements type advantages
- Provider is a simple const singleton — appropriate for stateless service
- All ACs verified
