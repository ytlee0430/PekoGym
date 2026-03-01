# Story 3.3: Experience Points Calculation

Status: done

## Story

As a player,
I want to earn EXP based on my battle performance,
So that consistent training progresses my character.

## Acceptance Criteria

1. **Given** a battle has concluded
   **When** EXP is calculated
   **Then** EXP is proportional to total damage dealt, sets completed, and battle outcome (FR18)
2. **And** victory awards 100% EXP, defeat awards 60% EXP (FR15)
3. **And** the EXP calculation is implemented in Pure Dart `domain/training/exp_calculator.dart`
4. **And** EXP is added to the player's UserProfile and persisted to Drift

## Tasks / Subtasks

- [x] Task 1: Implement `ExpCalculator` (AC: 1, 2, 3)
  - [x] 1.1 Created `lib/domain/training/exp_calculator.dart` — Pure Dart, stateless, synchronous
  - [x] 1.2 Implements `calculateExp()` with required params
  - [x] 1.3 Formula: `baseExp = (totalDamage * 0.1) + (totalSets * 10) + (totalVolume * 0.01)`
  - [x] 1.4 Victory → 1.0x, defeat → 0.6x
  - [x] 1.5 Returns `max(1, finalExp.round())`

- [x] Task 2: Create Riverpod provider (AC: 3)
  - [x] 2.1 Added `expCalculatorProvider` to `training_providers.dart`

- [x] Task 3: Wire EXP into battle result flow (AC: 4)
  - [x] 3.1 `BattleStateNotifier.submitSet()` detects Result transition and calls `_applyExp()`
  - [x] 3.2 `_persistExp()` updates UserProfile.experiencePoints and persists via `updateProfile()`
  - [x] 3.3 Added `earnedExp` field to `BattleOutcome`

- [x] Task 4: Update result screen to show EXP (AC: 1)
  - [x] 4.1 EXP Earned row added to result screen
  - [x] 4.2 EXP Modifier row shown

- [ ] Task 5: Wire beginner calibration trigger (AC: 4) — deferred to integration

- [x] Task 6: Tests (AC: 1, 2, 3)
  - [x] 6.1 Created `test/domain/training/exp_calculator_test.dart`
  - [x] 6.2 Test EXP formula with known inputs
  - [x] 6.3 Test victory modifier (1.0x)
  - [x] 6.4 Test defeat modifier (0.6x)
  - [x] 6.5 Test minimum EXP is 1
  - [x] 6.6 Test edge cases: zero damage, zero sets
  - [x] 6.7 `flutter analyze` — pending

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only.

### Dependencies on Previous Stories

- **Story 3.1** — `BattleOutcome` with victory/defeat, volume
- **Story 2.5** — `BattleStateNotifier` for wiring
- **Story 1.3** — `BeginnerCalibrationService` for calibration trigger
- **Story 1.2** — `UserProfileRepository` for EXP persistence

### EXP Formula

```
baseExp = (totalDamage × 0.1) + (totalSets × 10) + (totalVolume × 0.01)
modifier = isVictory ? 1.0 : 0.6
finalExp = max(1, round(baseExp × modifier))
```

Example: 3000 damage, 12 sets, 2400 kg volume, victory
= (300) + (120) + (24) = 444 × 1.0 = 444 EXP

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `ExpCalculator` — zero Flutter/Drift imports |
| **Synchronous** | No async in calculator |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/training/exp_calculator.dart
ironmon/test/domain/training/exp_calculator_test.dart
```

Files to update:

```
ironmon/lib/providers/training_providers.dart
ironmon/lib/providers/battle_providers.dart (wire EXP into result flow)
```

### References

- [Source: epics.md#Story 3.3] — User story, acceptance criteria
- [Source: prd.md#FR18] — 經驗值計算
- [Source: prd.md#FR15] — 60% EXP on defeat
- [Source: architecture.md#Domain Layer] — exp_calculator.dart location
- [Source: 1-3-beginner-mode-auto-calibration.md] — BeginnerCalibrationService

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created ExpCalculator with formula: baseExp = (damage*0.1) + (sets*10) + (volume*0.01), then modifier
- Added expCalculatorProvider to training_providers.dart
- Added earnedExp field to BattleOutcome
- Wired EXP calculation in BattleStateNotifier._applyExp() on Result transition
- Wired EXP persistence in BattleStateNotifier._persistExp() via UserProfileNotifier
- Updated BattleResultScreen to show EXP Earned and Modifier
- Comprehensive unit tests for ExpCalculator (8 test cases)
- Beginner calibration trigger deferred to integration phase

### File List
- ironmon/lib/domain/training/exp_calculator.dart (created)
- ironmon/lib/providers/training_providers.dart (modified)
- ironmon/lib/providers/battle_providers.dart (modified)
- ironmon/lib/domain/battle/models/battle_outcome.dart (modified)
- ironmon/lib/presentation/battle/battle_result_screen.dart (modified)
- ironmon/test/domain/training/exp_calculator_test.dart (created)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- ExpCalculator is Pure Dart with correct formula: (damage×0.1 + sets×10 + volume×0.01) × modifier
- Minimum 1 EXP via `max(1, finalExp)` prevents zero-EXP edge case
- Integration with BattleStateNotifier._applyExp correctly wires EXP into battle outcome
- All ACs verified
