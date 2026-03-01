# Story 6.3: Item Effects & Battle Integration

Status: ready-for-dev

## Story

As a player,
I want to use items during battle to gain tactical advantages,
So that I can recover from difficult situations mid-workout.

## Acceptance Criteria

1. **Given** the player has items in inventory
   **When** the player uses a Potion during battle
   **Then** the rest timer is paused/extended without reducing battle evaluation score
2. **And** when the player uses an Ether (confirms supplement intake)
   **Then** PP is partially restored (50% of max PP)
3. **And** when the player uses a Rare Candy on a move
   **Then** the target move gains experience toward its next evolution
4. **And** item usage is integrated into the BattleEngine state machine
5. **And** items can only be used between sets (not mid-set)

## Tasks / Subtasks

- [ ] Task 1: Create ItemService in domain layer (AC: 1, 2, 3, 4)
  - [ ] 1.1 Create `lib/domain/items/item_service.dart` — Pure Dart
  - [ ] 1.2 Method `usePotion(BattleState) → BattleState` — sets `restTimerPaused = true`
  - [ ] 1.3 Method `useEther(BattleState) → BattleState` — restores 50% max PP
  - [ ] 1.4 Method `useRareCandy(String moveId, UserProfile) → UserProfile` — increments move evolution XP
  - [ ] 1.5 Validate item availability before use (return Result type on failure)

- [ ] Task 2: Add item usage to BattleState (AC: 4, 5)
  - [ ] 2.1 Add `restTimerPaused` (bool) field to `BattleState`
  - [ ] 2.2 Add `itemsUsed` (List<String>) to track items used this battle
  - [ ] 2.3 Add `canUseItem` getter — true only when not mid-set (between sets)

- [ ] Task 3: Item usage UI in battle screen (AC: 1, 2, 3, 5)
  - [ ] 3.1 Create `lib/presentation/battle/widgets/item_panel.dart`
  - [ ] 3.2 Show item buttons with inventory counts (bag icon)
  - [ ] 3.3 Potion button: triggers rest timer pause, shows "Rest extended" toast
  - [ ] 3.4 Ether button: restores PP with animation on PP bar
  - [ ] 3.5 Rare Candy button: opens move selector dialog, applies to chosen move
  - [ ] 3.6 Disable all item buttons during set input (mid-set guard)
  - [ ] 3.7 Grey out items with 0 count

- [ ] Task 4: Wire into BattleStateNotifier (AC: 1, 2, 3, 4)
  - [ ] 4.1 Add `useItem(ItemType)` method to `BattleStateNotifier`
  - [ ] 4.2 Deduct item from inventory via `UserProfileRepository`
  - [ ] 4.3 Apply item effect via `ItemService`
  - [ ] 4.4 Trigger haptic feedback on item use (`HapticService.onSelectionClick()`)

- [ ] Task 5: Rest timer integration for Potion (AC: 1)
  - [ ] 5.1 If rest timer exists in battle UI, respect `restTimerPaused` flag
  - [ ] 5.2 If no rest timer exists yet, add a basic rest timer widget that Potion can pause
  - [ ] 5.3 Reset `restTimerPaused` to false when next set begins

- [ ] Task 6: Tests (AC: 1-5)
  - [ ] 6.1 Unit test: Ether restores exactly 50% max PP
  - [ ] 6.2 Unit test: Potion sets restTimerPaused flag
  - [ ] 6.3 Unit test: item blocked when inventory count = 0
  - [ ] 6.4 Unit test: item blocked during mid-set
  - [ ] 6.5 Widget test: item panel renders with correct counts
  - [ ] 6.6 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0. Inventory persisted via UserProfile columns.

### CRITICAL — No riverpod_generator

Manual providers only.

### Dependencies on Previous Stories

- **Story 6.1** — PP system (Ether restores PP)
- **Story 6.2** — Item definitions, inventory in UserProfile
- **Story 2.5** — BattleEngine, BattleStateNotifier
- **Story 2.6** — Battle screen UI for item panel placement
- **Story 3.5** — HapticService for item use feedback

### Potion Rest Timer Behavior

The spec says Potion pauses the rest timer. If no explicit rest timer widget exists in the current battle screen, create a minimal `RestTimerWidget` that counts seconds between sets and respect the pause flag. The evaluation score should not penalize longer rest when Potion is active.

### Ether PP Restoration Formula

```dart
final restored = (state.maxPlayerPp * 0.5).round();
final newPp = (state.playerPp + restored)
    .clamp(0, state.maxPlayerPp);
```

### Rare Candy — Move Evolution XP

Track per-move evolution XP in UserProfile or a new lightweight field. When accumulated XP meets threshold, the move auto-evolves to next in chain (leverages `MoveDefinition.evolutionChain` from Story 2.2).

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `ItemService` in `domain/items/` — Pure Dart |
| **Presentation** | `ItemPanel` widget in `presentation/battle/widgets/` |
| **Import Style** | `package:ironmon/...` only |
| **State Update** | `copyWith` only — no mutation |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/items/item_service.dart
ironmon/lib/presentation/battle/widgets/item_panel.dart
ironmon/test/domain/items/item_service_test.dart
ironmon/test/presentation/battle/widgets/item_panel_test.dart
```

Files to update:

```
ironmon/lib/domain/battle/models/battle_state.dart (restTimerPaused, itemsUsed)
ironmon/lib/providers/battle_providers.dart (useItem method, itemServiceProvider)
ironmon/lib/presentation/battle/battle_screen.dart (add ItemPanel)
```

### References

- [Source: epics.md#Story 6.3] — User story, acceptance criteria
- [Source: spec.md#Section 5.2] — Item effects (Potion, Ether, Rare Candy)
- [Source: spec.md#Section 6.5] — Item shop / inventory UI

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
