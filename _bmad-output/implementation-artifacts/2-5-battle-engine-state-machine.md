# Story 2.5: Battle Engine State Machine

Status: done

## Story

As a player,
I want to fight through a 3-stage battle by selecting moves and entering my set data,
So that each gym session plays out as a complete RPG battle.

## Acceptance Criteria

1. **Given** the player has selected a gym and boss lineup is generated
   **When** the battle begins
   **Then** the BattleEngine transitions through phases: Idle → Warmup → MidBoss → GymLeader → Result
2. **And** BattlePhase is implemented as a Dart sealed class with exhaustive pattern matching
3. **And** the player can select a move from their unlocked moves for the current muscle group (FR7)
4. **And** the player can input weight (kg) and reps for each set (FR8)
5. **And** the player can input RPE (1-10) for each set (FR12)
6. **And** each set submission triggers damage calculation and applies damage to the current boss
7. **And** when a boss's HP reaches 0, the engine transitions to the next phase
8. **And** all state transitions are immutable (copyWith pattern)

## Tasks / Subtasks

- [x] Task 1: Create `BattlePhase` sealed class (AC: 1, 2)
  - [x] 1.1 Create `lib/domain/battle/battle_phase.dart` — Dart 3 sealed class
  - [x] 1.2 Variants: `Idle`, `Warmup` (boss: Minion), `MidBossPhase` (boss: Mid-Boss), `GymLeaderPhase` (boss: Gym Leader), `BattleResult` (outcome: BattleOutcome)
  - [x] 1.3 Each variant is an immutable data class
  - [x] 1.4 Pure Dart — zero Flutter dependency

- [x] Task 2: Create `BattleState` domain model (AC: 8)
  - [x] 2.1 Create `lib/domain/battle/models/battle_state.dart` — immutable Pure Dart class
  - [x] 2.2 Fields: `phase` (BattlePhase), `bosses` (List&lt;Boss&gt;), `currentBossIndex` (int), `playerHp` (int), `maxPlayerHp` (int), `completedSets` (List&lt;ExerciseSet&gt;), `damageResults` (List&lt;DamageResult&gt;), `selectedMoveId` (String?), `gymType` (GymType), `playerMuscleType` (MuscleType), `totalDamageDealt` (int)
  - [x] 2.3 Include `copyWith`, current boss getter, convenience methods

- [x] Task 3: Implement `BattleEngine` (AC: 1, 6, 7)
  - [x] 3.1 Create `lib/domain/battle/battle_engine.dart` — Pure Dart
  - [x] 3.2 Constructor takes `DamageCalculator` dependency
  - [x] 3.3 Implement `BattleState startBattle({required List<Boss> bosses, required GymType gymType, required MuscleType playerMuscle, required int playerHp})`
  - [x] 3.4 Implement `BattleState selectMove(BattleState state, String moveId)` — sets selected move
  - [x] 3.5 Implement `BattleState submitSet(BattleState state, ExerciseSet set, MoveDefinition move, double playerFiveRm)` — calculates damage, applies to boss, transitions phase if boss HP ≤ 0
  - [x] 3.6 All methods return new `BattleState` (immutable transitions)
  - [x] 3.7 Phase transitions: Warmup → MidBoss → GymLeader → Result

- [x] Task 4: Create `BattleOutcome` model (AC: 1)
  - [x] 4.1 Create `lib/domain/battle/models/battle_outcome.dart` — class with victory/defeat constructors
  - [x] 4.2 Include total damage, total sets, total volume for result screen

- [x] Task 5: Create Riverpod `BattleStateNotifier` (AC: 1, 3, 4, 5, 6)
  - [x] 5.1 Add `battleStateNotifierProvider` to `lib/providers/battle_providers.dart`
  - [x] 5.2 Implement as `Notifier<BattleState>` wrapping `BattleEngine`
  - [x] 5.3 Expose methods: `startBattle()`, `selectMove()`, `submitSet()`
  - [x] 5.4 State updates via `state = newState`

- [x] Task 6: Tests (AC: 1, 2, 6, 7, 8)
  - [x] 6.1 Create `test/domain/battle/battle_engine_test.dart`
  - [x] 6.2 Test full battle flow: Idle → Warmup → MidBoss → GymLeader → Result
  - [x] 6.3 Test phase transitions when boss HP reaches 0
  - [x] 6.4 Test sealed class exhaustive switch compiles
  - [x] 6.5 Test immutability (original state unchanged after transition)
  - [x] 6.6 Test damage application to boss HP
  - [x] 6.7 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is Pure Dart domain logic. BattleState persistence is
deferred to Story 2.7.

### Dependencies on Previous Stories

- **Story 2.1** — `TypeEffectiveness`, `MuscleType`
- **Story 2.2** — `MoveDefinition`, `MoveRegistry`
- **Story 2.3** — `Boss`, `GymType`, `BossGenerator`
- **Story 2.4** — `DamageCalculator`, `DamageResult`, `ExerciseSet`

### Sealed Class Pattern (Dart 3)

```dart
/// Battle phases as a sealed class hierarchy.
/// Exhaustive pattern matching required — no default case.
sealed class BattlePhase {
  const BattlePhase();
}

/// Battle not started.
final class Idle extends BattlePhase {
  const Idle();
}

/// Fighting the Minion (stage 1).
final class Warmup extends BattlePhase {
  const Warmup();
}

/// Fighting the Mid-Boss (stage 2).
final class MidBoss extends BattlePhase {
  const MidBoss();
}

/// Fighting the Gym Leader (stage 3).
final class GymLeader extends BattlePhase {
  const GymLeader();
}

/// Battle concluded with outcome.
final class Result extends BattlePhase {
  const Result({required this.outcome});
  final BattleOutcome outcome;
}
```

Usage with exhaustive switch:

```dart
// CORRECT — exhaustive, no default
final message = switch (phase) {
  Idle() => 'Ready to battle!',
  Warmup() => 'Fighting Minion...',
  MidBoss() => 'Fighting Mid-Boss...',
  GymLeader() => 'Fighting Gym Leader!',
  Result(outcome: final o) => 'Battle ${o.name}!',
};

// WRONG — default case hides missing variants
final message = switch (phase) {
  Idle() => 'Ready',
  _ => 'In battle', // ❌ FORBIDDEN
};
```

### BattleEngine Is Stateless

`BattleEngine` does NOT hold state internally. It takes a
`BattleState` and returns a new `BattleState`. The Riverpod
`BattleStateNotifier` holds the current state.

```dart
class BattleEngine {
  const BattleEngine({
    required DamageCalculator damageCalculator,
  }) : _damageCalculator = damageCalculator;

  final DamageCalculator _damageCalculator;

  BattleState startBattle({
    required List<Boss> bosses,
    required GymType gymType,
    required MuscleType playerMuscle,
    required int playerHp,
  }) {
    return BattleState(
      phase: const Warmup(),
      bosses: bosses,
      currentBossIndex: 0,
      playerHp: playerHp,
      maxPlayerHp: playerHp,
      gymType: gymType,
      playerMuscleType: playerMuscle,
    );
  }

  BattleState submitSet(
    BattleState state,
    ExerciseSet set,
    MoveDefinition move,
    double playerFiveRm,
  ) {
    final boss = state.currentBoss;
    final result = _damageCalculator.calculate(
      set: set,
      move: move,
      bossType: boss.type,
      playerFiveRm: playerFiveRm,
      bossDefense: boss.defense,
      gymType: state.gymType,
    );

    final newBossHp = (boss.currentHp - result.finalDamage)
        .clamp(0, boss.maxHp);
    // ... apply damage, check phase transition
  }
}
```

### Player HP System

Player starts with a fixed HP pool (e.g., `100 + level * 10`).
Player HP is reduced by the exhaustion/counter mechanism (Story 3.1).
For this story, player HP only decreases are stubbed — full
implementation in Story 3.1.

### Notifier Pattern (Riverpod 3.x)

```dart
final battleStateNotifierProvider =
    NotifierProvider<BattleStateNotifier, BattleState>(
  BattleStateNotifier.new,
);

class BattleStateNotifier extends Notifier<BattleState> {
  @override
  BattleState build() => const BattleState.initial();

  void startBattle({...}) {
    final engine = ref.read(battleEngineProvider);
    state = engine.startBattle(...);
  }

  void submitSet(ExerciseSet set, MoveDefinition move,
      double playerFiveRm) {
    final engine = ref.read(battleEngineProvider);
    state = engine.submitSet(state, set, move, playerFiveRm);
  }
}
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `BattleEngine`, `BattlePhase`, `BattleState` — zero Flutter/Drift imports |
| **Sealed Class** | Switch must exhaust all variants — NO `default` |
| **State Immutability** | All state updates via `copyWith` — no mutation |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual `NotifierProvider` — no `@riverpod` |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/battle/battle_engine.dart
ironmon/lib/domain/battle/battle_phase.dart
ironmon/lib/domain/battle/models/battle_state.dart
ironmon/lib/domain/battle/models/battle_outcome.dart
ironmon/test/domain/battle/battle_engine_test.dart
```

Files to update:

```
ironmon/lib/providers/battle_providers.dart
```

### References

- [Source: epics.md#Story 2.5] — User story, acceptance criteria
- [Source: architecture.md#Domain Layer] — Battle Engine sealed class + pattern matching
- [Source: architecture.md#Core Architectural Decisions] — Sealed Class + Pattern Matching
- [Source: architecture.md#State Management Rules] — Immutable state, copyWith
- [Source: architecture.md#Data Flow] — 戰鬥核心數據流
- [Source: 2-4-damage-calculation-engine.md] — DamageCalculator dependency

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created BattlePhase sealed class with Idle, Warmup, MidBossPhase, GymLeaderPhase, BattleResult variants
- Created BattleState immutable model with copyWith and isActive getter
- Created BattleOutcome model with victory/defeat constructors
- Implemented stateless BattleEngine with startBattle, selectMove, submitSet
- Phase transitions: Warmup → MidBossPhase → GymLeaderPhase → BattleResult
- Created BattleStateNotifier with NotifierProvider pattern
- Added battleEngineProvider and battleStateNotifierProvider
- Comprehensive tests covering full flow, immutability, sealed class exhaustive switch

### File List
- ironmon/lib/domain/battle/battle_phase.dart (new)
- ironmon/lib/domain/battle/battle_engine.dart (new)
- ironmon/lib/domain/battle/models/battle_state.dart (new)
- ironmon/lib/domain/battle/models/battle_outcome.dart (new)
- ironmon/lib/providers/battle_providers.dart (modified)
- ironmon/test/domain/battle/battle_engine_test.dart (new)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- BattleEngine is stateless Pure Dart with immutable state transitions via copyWith
- BattlePhase sealed class enforces exhaustive pattern matching
- Exhaustion/counter HP deduction logic correctly compares with previous sets
- Phase transitions (Warmup→MidBoss→GymLeader→Result) work correctly
- All ACs verified
