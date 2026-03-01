# Story 3.1: Win & Lose Conditions

Status: done

## Story

As a player,
I want the battle to end appropriately when I beat the boss or run out of HP,
So that every workout has a clear outcome.

## Acceptance Criteria

1. **Given** a battle is in progress
   **When** the Gym Leader's HP reaches 0
   **Then** the battle is marked as victory and transitions to Result phase (FR14)
2. **And** when the player's HP reaches 0, the battle is marked as defeat (FR15)
3. **And** when the player's set reps are lower than the previous set or system-suggested reps, it triggers exhaustion (Miss/Counter) and deducts player HP (FR16)
4. **And** defeat still awards 60% of the total earned EXP (FR15)

## Tasks / Subtasks

- [x] Task 1: Implement victory condition in BattleEngine (AC: 1)
  - [x] 1.1 Update `BattleEngine.submitSet()` — when Gym Leader (stage 3) HP ≤ 0, transition to `Result(outcome: victory)`
  - [x] 1.2 Victory `BattleOutcome` includes full EXP (100%), total damage, total volume, total sets

- [x] Task 2: Implement exhaustion/counter mechanism (AC: 3)
  - [x] 2.1 Add exhaustion detection to `BattleEngine`: compare current set reps with previous set reps for the same move
  - [x] 2.2 If `currentReps < previousReps` → trigger exhaustion (Miss)
  - [x] 2.3 Define suggested reps per boss stage (Minion: 12, Mid-Boss: 8, Gym Leader: 5)
  - [x] 2.4 If `currentReps < suggestedReps` → trigger counter
  - [x] 2.5 Exhaustion deducts player HP: `hpLoss = maxPlayerHp * 0.1` (10%)
  - [x] 2.6 Counter deducts player HP: `hpLoss = maxPlayerHp * 0.15` (15%)

- [x] Task 3: Implement defeat condition (AC: 2, 4)
  - [x] 3.1 After exhaustion HP deduction, check if `playerHp <= 0`
  - [x] 3.2 If player HP ≤ 0, transition to `Result(outcome: defeat)`
  - [x] 3.3 Defeat `BattleOutcome` includes 60% EXP modifier

- [x] Task 4: Update BattleOutcome model (AC: 1, 2, 4)
  - [x] 4.1 Updated `battle_outcome.dart` with `expModifier`, `exhaustionEvents`, `counterEvents`

- [x] Task 5: Add volume calculation (AC: 1, 2)
  - [x] 5.1 Total volume = Σ(weight × reps) computed at battle end
  - [x] 5.2 Track exhaustion/counter events in `BattleState`

- [x] Task 6: Tests (AC: 1, 2, 3, 4)
  - [x] 6.1 Updated `test/domain/battle/battle_engine_test.dart`
  - [x] 6.2 Test victory: Gym Leader HP → 0 triggers Result(victory)
  - [x] 6.3 Test defeat: Player HP → 0 triggers Result(defeat)
  - [x] 6.4 Test exhaustion: reps drop triggers HP deduction
  - [x] 6.5 Test counter: reps below suggested triggers HP deduction
  - [x] 6.6 Test defeat awards 60% EXP modifier
  - [x] 6.7 Test volume calculation accuracy
  - [x] 6.8 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story modifies only domain logic. No Drift changes.

### Dependencies on Previous Stories

- **Story 2.5** — `BattleEngine`, `BattleState`, `BattlePhase` (being extended)
- **Story 2.4** — `DamageCalculator`, `ExerciseSet`

### Exhaustion Detection Logic

```dart
/// Checks if the current set triggers exhaustion.
/// Returns the HP penalty (0 if no exhaustion).
int checkExhaustion(
  BattleState state,
  ExerciseSet currentSet,
) {
  // Find previous set with same move
  final previousSets = state.completedSets
      .where((s) => s.moveId == currentSet.moveId)
      .toList();

  if (previousSets.isEmpty) return 0;

  final lastSet = previousSets.last;

  // Miss: reps dropped from previous set
  if (currentSet.reps < lastSet.reps) {
    return (state.maxPlayerHp * 0.1).round(); // 10% HP loss
  }

  // Counter: reps below suggested minimum
  final suggestedReps = _getSuggestedReps(state.phase);
  if (currentSet.reps < suggestedReps) {
    return (state.maxPlayerHp * 0.15).round(); // 15% HP loss
  }

  return 0;
}

int _getSuggestedReps(BattlePhase phase) {
  return switch (phase) {
    Warmup() => 12,
    MidBoss() => 8,
    GymLeader() => 5,
    Idle() => 0,
    Result() => 0,
  };
}
```

### Updated submitSet Flow

```
1. Calculate damage (existing)
2. Apply damage to boss (existing)
3. Check exhaustion → deduct player HP (NEW)
4. Check player HP ≤ 0 → defeat (NEW)
5. Check boss HP ≤ 0 → phase transition or victory (existing, extended)
6. Return new BattleState
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | All logic in `lib/domain/battle/` — zero Flutter/Drift imports |
| **Sealed Class Switch** | BattlePhase switch must exhaust all variants |
| **State Immutability** | All updates via `copyWith` |
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

Files to update:

```
ironmon/lib/domain/battle/battle_engine.dart
ironmon/lib/domain/battle/models/battle_outcome.dart
ironmon/lib/domain/battle/models/battle_state.dart
ironmon/test/domain/battle/battle_engine_test.dart
```

### References

- [Source: epics.md#Story 3.1] — User story, acceptance criteria
- [Source: prd.md#FR14] — 勝利判定
- [Source: prd.md#FR15] — 失敗 + 60% 經驗值
- [Source: prd.md#FR16] — 力竭/Counter 機制
- [Source: architecture.md#Domain Layer] — BattleEngine state transitions

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Added expModifier (1.0 victory / 0.6 defeat), exhaustionEvents, counterEvents to BattleOutcome
- Added exhaustionEvents, counterEvents tracking to BattleState
- Implemented _applyExhaustion in BattleEngine: Miss (reps drop → 10% HP) and Counter (below suggested → 15% HP)
- Implemented defeat condition: playerHp ≤ 0 → BattleResult(defeat)
- Suggested reps per phase: Warmup=12, MidBoss=8, GymLeader=5
- Volume computed as Σ(weight × reps) at battle end
- Comprehensive tests for exhaustion, counter, defeat, victory expModifier, volume

### File List
- ironmon/lib/domain/battle/models/battle_outcome.dart (modified)
- ironmon/lib/domain/battle/models/battle_state.dart (modified)
- ironmon/lib/domain/battle/battle_engine.dart (modified)
- ironmon/test/domain/battle/battle_engine_test.dart (modified)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- Victory/defeat conditions correctly implemented in BattleEngine
- BattleOutcome properly distinguishes victory (expModifier=1.0) vs defeat (expModifier=0.6)
- Player HP deduction from exhaustion/counter events works correctly
- All ACs verified
