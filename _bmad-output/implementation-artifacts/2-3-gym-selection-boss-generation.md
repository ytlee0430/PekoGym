# Story 2.3: Gym Selection & Boss Generation

Status: done

## Story

As a player,
I want to choose my muscle group and gym type to face a challenging boss lineup,
So that my real workout drives a strategic battle.

## Acceptance Criteria

1. **Given** the player taps "Start Battle" on the home screen
   **When** the player selects a muscle group (FR4) and gym type (Strength or Physique) (FR5)
   **Then** the system generates a 3-stage enemy lineup: Minion → Mid-Boss → Gym Leader (FR6)
2. **And** Strength Gym bosses have high defense, low HP
3. **And** Physique Gym bosses have low defense, high HP
4. **And** boss types are assigned based on the selected muscle group's type effectiveness relationships
5. **And** boss stats scale with the player's current level

## Tasks / Subtasks

- [x] Task 1: Create `Boss` domain model (AC: 2, 3, 5)
  - [x] 1.1 Create `lib/domain/battle/models/boss.dart` — immutable Pure Dart class
  - [x] 1.2 Fields: `name` (String), `type` (MuscleType), `maxHp` (int), `currentHp` (int), `defense` (int), `stage` (BossStage enum: minion, midBoss, gymLeader)
  - [x] 1.3 Include `copyWith`, `==`, `hashCode`

- [x] Task 2: Create `GymType` enum (AC: 2, 3)
  - [x] 2.1 Create or add to `lib/domain/battle/models/gym_type.dart` — enum with `strength` and `physique`
  - [x] 2.2 Strength: high defense multiplier, low HP multiplier
  - [x] 2.3 Physique: low defense multiplier, high HP multiplier

- [x] Task 3: Implement `BossGenerator` (AC: 1, 2, 3, 4, 5)
  - [x] 3.1 Create `lib/domain/battle/boss_generator.dart` — Pure Dart
  - [x] 3.2 Implement `List<Boss> generateLineup(MuscleType playerMuscle, GymType gymType, int playerLevel)`
  - [x] 3.3 Generate exactly 3 bosses: Minion (weakest), Mid-Boss, Gym Leader (strongest)
  - [x] 3.4 Assign boss types using `TypeEffectiveness` — Gym Leader should be the type that resists the player's type
  - [x] 3.5 Scale boss HP and defense based on `playerLevel`
  - [x] 3.6 Apply gym type modifiers (Strength: defense ×2, HP ×0.5; Physique: defense ×0.5, HP ×2)

- [x] Task 4: Create Gym Selection UI (AC: 1)
  - [x] 4.1 Create `lib/presentation/battle/gym_selection_screen.dart` — screen for choosing muscle group and gym type
  - [x] 4.2 Display 5 muscle type buttons with element icons/colors
  - [x] 4.3 Display 2 gym type buttons (Strength / Physique) with descriptions
  - [x] 4.4 "Start Battle" button generates lineup and navigates to battle screen
  - [x] 4.5 Use `ConsumerWidget` pattern

- [x] Task 5: Update routing (AC: 1)
  - [x] 5.1 Add `/battle/select` route to `app_router.dart` for gym selection
  - [x] 5.2 Home screen "Start Battle" navigates to `/battle/select` instead of `/battle`
  - [x] 5.3 Gym selection navigates to `/battle` with generated lineup data

- [x] Task 6: Create Riverpod providers (AC: 1)
  - [x] 6.1 Add `bossGeneratorProvider` to `lib/providers/battle_providers.dart`
  - [x] 6.2 `BossGenerator` depends on `TypeEffectiveness` — inject via provider

- [x] Task 7: Tests (AC: 1, 2, 3, 4, 5)
  - [x] 7.1 Create `test/domain/battle/boss_generator_test.dart`
  - [x] 7.2 Test lineup always produces exactly 3 bosses in correct order
  - [x] 7.3 Test Strength gym produces high defense, low HP bosses
  - [x] 7.4 Test Physique gym produces low defense, high HP bosses
  - [x] 7.5 Test boss stats scale with player level
  - [x] 7.6 Test boss type assignment uses type effectiveness
  - [x] 7.7 `flutter analyze` reports zero issues
  - [x] 7.8 All existing tests continue to pass

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Architecture doc references Isar throughout. The project uses Drift
2.31.0 (pivoted in Story 1.1 due to Dart 3.11.0 incompatibility).

### CRITICAL — No riverpod_generator

Do NOT use `@riverpod` annotations. Manual providers only.

### CRITICAL — No Schema Changes

This story does NOT change the Drift schema. Boss data is generated
in-memory and persisted later via `BattleState` (Story 2.7).

### Dependencies on Previous Stories

- **Story 2.1** — `TypeEffectiveness` and `MuscleType` must exist
- **Story 2.2** — `MoveDefinition` for knowing which moves match which type (optional for this story but useful for context)

### Boss Stat Scaling Formula (Suggested)

```dart
// Base stats (before gym type modifier)
final baseHp = 100 + (playerLevel * 20);
final baseDefense = 10 + (playerLevel * 2);

// Stage multipliers
// Minion: 0.5x, Mid-Boss: 0.8x, Gym Leader: 1.0x
final stageMultiplier = switch (stage) {
  BossStage.minion => 0.5,
  BossStage.midBoss => 0.8,
  BossStage.gymLeader => 1.0,
};

// Gym type modifiers
final (hpMod, defMod) = switch (gymType) {
  GymType.strength => (0.5, 2.0),
  GymType.physique => (2.0, 0.5),
};

final hp = (baseHp * stageMultiplier * hpMod).round();
final defense = (baseDefense * stageMultiplier * defMod).round();
```

### Boss Type Assignment Strategy

For strategic depth, assign boss types that create interesting
matchups:
- **Minion**: Same type as player (neutral damage, easy warmup)
- **Mid-Boss**: Random non-resistant type (moderate challenge)
- **Gym Leader**: The type that resists the player's type (hardest — forces higher weight/reps to deal enough damage)

### Gym Selection UI Pattern

```dart
class GymSelectionScreen extends ConsumerWidget {
  const GymSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State: selected muscle type and gym type
    // Show muscle type grid (5 options)
    // Show gym type toggle (Strength / Physique)
    // "Start Battle" button
  }
}
```

Use `StateProvider` for selection state (lightweight UI-only state):

```dart
final selectedMuscleTypeProvider =
    StateProvider<MuscleType?>((ref) => null);
final selectedGymTypeProvider =
    StateProvider<GymType>((ref) => GymType.physique);
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `Boss`, `BossGenerator`, `GymType` — zero Flutter/Drift imports |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition — no `@riverpod` |
| **Sealed Class Switch** | Enum switch must exhaust all values — no `default` |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **State Immutability** | `Boss` uses `copyWith` |
| **Navigation** | `context.push()` for forward nav |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/battle/models/boss.dart
ironmon/lib/domain/battle/models/gym_type.dart
ironmon/lib/domain/battle/boss_generator.dart
ironmon/lib/presentation/battle/gym_selection_screen.dart
ironmon/test/domain/battle/boss_generator_test.dart
```

Files to update:

```
ironmon/lib/router/app_router.dart
ironmon/lib/providers/battle_providers.dart
ironmon/lib/presentation/home/home_screen.dart (Start Battle → /battle/select)
```

### References

- [Source: epics.md#Story 2.3] — User story, acceptance criteria
- [Source: architecture.md#Domain Layer] — `boss_generator.dart`, `boss.dart` locations
- [Source: architecture.md#Structure Patterns] — `domain/battle/` location
- [Source: architecture.md#Frontend Architecture] — Routing, Riverpod patterns
- [Source: 1-4-home-screen.md] — Home screen "Start Battle" button
- [Source: 2-1-type-effectiveness-system.md] — TypeEffectiveness dependency

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created Boss immutable domain model with BossStage enum
- Created GymType enum with HP/defense multipliers
- Implemented BossGenerator with type effectiveness-based lineup
- Created GymSelectionScreen with muscle type grid and gym type selector
- Added /battle/select route, updated HomeScreen navigation
- Created battle_providers.dart with bossGeneratorProvider and selection state
- Comprehensive BossGenerator tests covering all ACs

### File List
- ironmon/lib/domain/battle/models/boss.dart (new)
- ironmon/lib/domain/battle/models/gym_type.dart (new)
- ironmon/lib/domain/battle/boss_generator.dart (new)
- ironmon/lib/presentation/battle/gym_selection_screen.dart (new)
- ironmon/lib/providers/battle_providers.dart (new)
- ironmon/lib/router/app_router.dart (modified)
- ironmon/lib/presentation/home/home_screen.dart (modified)
- ironmon/test/domain/battle/boss_generator_test.dart (new)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- BossGenerator correctly creates 3-stage lineup with strategic type selection
- GymSelectionScreen properly uses Riverpod StateProviders for selection state
- Fallback logic for resistant/neutral type finding is robust
- Boss stat scaling with gym type multipliers matches architecture spec
