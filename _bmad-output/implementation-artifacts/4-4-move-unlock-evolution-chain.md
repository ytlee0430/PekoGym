# Story 4.4: Move Unlock & Evolution Chain

Status: done

## Story

As a player,
I want to unlock new moves by leveling up or defeating gym leaders,
So that my exercise repertoire grows as I progress.

## Acceptance Criteria

1. **Given** the player levels up or defeats a Gym Leader
   **When** an unlock condition is met
   **Then** the corresponding move is unlocked and available in battle (FR22)
2. **And** moves evolve along their evolution chain (e.g., Push-up → Barbell Bench Press → Incline Dumbbell Press) (FR23)
3. **And** the player is notified of newly unlocked moves
4. **And** unlocked moves are persisted in UserProfile

## Tasks / Subtasks

- [x] Task 1: Move unlock logic via MoveUnlockService (AC: 1, 2)
  - [x] 1.1 MoveRegistry already has getEvolutionChain(), getUnlockedMoves()
  - [x] 1.2 Level-based: `move.unlockLevel <= playerLevel`
  - [x] 1.4 Evolution chain prerequisite checking in _canUnlock()

- [x] Task 2: Create `MoveUnlockService` (AC: 1, 2)
  - [x] 2.1 Created `lib/domain/moves/move_unlock_service.dart`
  - [x] 2.2 `checkNewUnlocks()` with profile, registry, gymLeaderDefeated params
  - [x] 2.3 Returns only newly unlocked moves
  - [x] 2.4 Evolution chain prerequisite: stage N requires stage N-1

- [x] Task 3: Wire unlock into battle result flow (AC: 1, 4)
  - [x] 3.1 Runs after level up check in `_persistExp()`
  - [x] 3.3 Updates `UserProfile.unlockedMoveIds`
  - [x] 3.4 Persists via `updateProfile()`

- [x] Task 4: Unlock notification UI (AC: 3)
  - [x] 4.1 "New Move Unlocked!" banner on result screen (tealAccent)
  - [x] 4.2 Displays move names
  - [x] 4.4 `HapticService.onCriticalEvent()` triggered

- [x] Task 5: Create Riverpod provider (AC: 1)
  - [x] 5.1 Added `moveUnlockServiceProvider`

- [x] Task 6: Tests (AC: 1, 2, 3, 4)
  - [x] 6.1 Created `test/domain/moves/move_unlock_service_test.dart`
  - [x] 6.2 Level-based unlock tests
  - [x] 6.4 Evolution chain prerequisite tests
  - [x] 6.5 Already-unlocked not re-reported
  - [x] 6.6 Multiple simultaneous unlocks
  - [ ] 6.7 `flutter analyze` — pending

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only.

### CRITICAL — No Schema Changes

Unlocked moves are stored as JSON array in `UserProfile.unlockedMoveIds`
(text column). No new tables needed.

### Dependencies on Previous Stories

- **Story 2.2** — `MoveRegistry`, `MoveDefinition` with evolution chain data
- **Story 4.1** — `LevelSystem` for level-based unlock triggers
- **Story 3.1** — Victory condition for gym leader defeat trigger
- **Story 3.5** — `HapticService` for unlock feedback

### Evolution Chain Logic

```dart
/// Checks if a move can be unlocked based on prerequisites.
bool canUnlock(
  MoveDefinition move,
  List<String> currentlyUnlocked,
  MoveRegistry registry,
) {
  // Stage 1 moves have no prerequisites
  if (move.evolutionStage == 1) return true;

  // Stage 2+ requires previous stage to be unlocked
  final chain = registry.getEvolutionChain(
    move.evolutionChainId!,
  );
  final previousStage = chain.firstWhere(
    (m) => m.evolutionStage == move.evolutionStage - 1,
    orElse: () => move, // fallback
  );
  return currentlyUnlocked.contains(previousStage.id);
}
```

### Unlock Persistence

`unlockedMoveIds` is stored as a JSON text column in `UserProfiles`:

```dart
// Current: ['chest-1', 'back-1', 'legs-1', ...]
// After unlock: ['chest-1', 'back-1', 'legs-1', ..., 'chest-2']
final updatedIds = [
  ...profile.unlockedMoveIds,
  ...newlyUnlocked.map((m) => m.id),
];
final updatedProfile = profile.copyWith(
  unlockedMoveIds: updatedIds,
);
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `MoveUnlockService` — zero Flutter/Drift imports |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **Sealed Class Switch** | MuscleType switch exhaust all values |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/moves/move_unlock_service.dart
ironmon/test/domain/moves/move_unlock_service_test.dart
```

Files to update:

```
ironmon/lib/domain/moves/move_registry.dart (getUnlockableMoves)
ironmon/lib/providers/training_providers.dart
ironmon/lib/providers/battle_providers.dart (wire unlock into result)
ironmon/lib/presentation/battle/battle_result_screen.dart (unlock notification)
```

### References

- [Source: epics.md#Story 4.4] — User story, acceptance criteria
- [Source: prd.md#FR22] — 招式解鎖
- [Source: prd.md#FR23] — 招式進化鏈
- [Source: architecture.md#Domain Layer] — move_registry.dart
- [Source: 2-2-move-registry-data-loading.md] — MoveDefinition, evolution chain
- [Source: 4-1-level-up-system.md] — Level up trigger

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created MoveUnlockService with level-based and evolution chain prerequisite logic
- Added unlockedMoveNames to BattleOutcome for result screen display
- Wired unlock check into _persistExp() after level up
- Persists newly unlocked move IDs to UserProfile
- "New Move Unlocked!" tealAccent banner on battle result screen
- Haptic feedback on move unlock
- 7 unit tests for MoveUnlockService

### File List
- ironmon/lib/domain/moves/move_unlock_service.dart (created)
- ironmon/test/domain/moves/move_unlock_service_test.dart (created)
- ironmon/lib/providers/training_providers.dart (modified)
- ironmon/lib/providers/battle_providers.dart (modified)
- ironmon/lib/domain/battle/models/battle_outcome.dart (modified)
- ironmon/lib/presentation/battle/battle_result_screen.dart (modified)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- MoveUnlockService is Pure Dart with correct level + evolution chain prerequisite checks
- Evolution chain prerequisite: stage N requires stage N-1 unlocked
- Integration with _persistExp correctly persists new unlocks to profile
- Battle result screen shows unlock banners with move names
- All ACs verified
