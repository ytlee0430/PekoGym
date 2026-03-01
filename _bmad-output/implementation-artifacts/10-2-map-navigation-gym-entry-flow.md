# Story 10.2: Map Navigation & Gym Entry Flow

Status: ready-for-dev

## Story

As a player,
I want to tap a gym on the map to start a battle there,
So that gym selection feels like an adventure rather than a menu.

## Acceptance Criteria

1. **Given** the player taps a gym icon on the map
   **When** the gym is selected
   **Then** a gym preview panel slides up showing gym name, type, recommended level, and daily mission indicator
2. **And** the player can confirm entry to start the battle (replaces current gym selection flow)
3. **And** the daily mission gym is highlighted with a special marker
4. **And** navigation transitions smoothly from map → gym preview → battle screen
5. **And** the existing gym selection logic (muscle group + gym type) is preserved underneath

## Tasks / Subtasks

- [ ] Task 1: Gym tap interaction (AC: 1)
  - [ ] 1.1 Add `GestureDetector` / `InkWell` on each `GymMapIcon`
  - [ ] 1.2 On tap, animate player sprite walking to tapped gym position
  - [ ] 1.3 After walk animation, show preview panel

- [ ] Task 2: Create GymPreviewPanel (AC: 1, 2, 3)
  - [ ] 2.1 Create `lib/presentation/home/widgets/gym_preview_panel.dart`
  - [ ] 2.2 Bottom sheet or sliding panel showing:
        - Gym name and type badge
        - Boss preview (type + difficulty indicator)
        - Recommended player level
        - Gym type selector (Strength / Physique toggle)
        - Daily mission indicator if this gym matches today's mission
  - [ ] 2.3 "Enter Gym" button → starts battle
  - [ ] 2.4 "Back" button → dismisses panel

- [ ] Task 3: Daily mission highlight (AC: 3)
  - [ ] 3.1 If daily mission exists (Story 7.2), highlight recommended gym with pulsing glow
  - [ ] 3.2 Show "Daily Mission!" badge on the highlighted gym icon
  - [ ] 3.3 In preview panel, show "+20% EXP Bonus" if this is the mission gym

- [ ] Task 4: Battle entry flow (AC: 2, 4, 5)
  - [ ] 4.1 "Enter Gym" triggers same logic as current `GymSelectionScreen` confirm
  - [ ] 4.2 Set `selectedMuscleTypeProvider` and `selectedGymTypeProvider` from panel selection
  - [ ] 4.3 Generate bosses via `BossGenerator`
  - [ ] 4.4 Navigate to `/battle` screen
  - [ ] 4.5 Smooth page transition animation (slide up or fade)

- [ ] Task 5: Preserve backward compatibility (AC: 5)
  - [ ] 5.1 Keep `/battle/select` route working for direct navigation
  - [ ] 5.2 Map → preview → battle is an alternative path, not replacement
  - [ ] 5.3 Both paths converge at the same `BattleStateNotifier.startBattle()` call

- [ ] Task 6: Tests (AC: 1-5)
  - [ ] 6.1 Widget test: tapping gym icon shows preview panel
  - [ ] 6.2 Widget test: preview panel displays correct gym info
  - [ ] 6.3 Widget test: "Enter Gym" navigates to battle
  - [ ] 6.4 Widget test: daily mission gym has highlight
  - [ ] 6.5 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No database changes in this story.

### CRITICAL — No riverpod_generator

Manual providers only.

### Walk Animation

Simple tween animation moving player sprite from current position to target gym:

```dart
final tween = Tween<Offset>(
  begin: currentPosition,
  end: targetGymPosition,
);
// Duration: 300-500ms
```

### GymPreviewPanel as BottomSheet

Use `showModalBottomSheet` or a custom `DraggableScrollableSheet`:

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => GymPreviewPanel(
    gym: selectedGym,
    isDailyMission: isDailyMission,
  ),
);
```

### Dependencies on Previous Stories

- **Story 10.1** — Map UI with gym icons (tap targets)
- **Story 7.2** — Daily mission for highlighting (optional — graceful fallback if not yet implemented)
- **Story 2.3** — `BossGenerator`, `GymSelectionScreen` logic
- **Story 2.5** — `BattleStateNotifier.startBattle()`

### Existing Gym Selection Logic

Current flow in `GymSelectionScreen`:
1. Player selects `MuscleType` (dropdown/buttons)
2. Player selects `GymType` (Strength/Physique toggle)
3. Confirm → generate bosses → navigate to `/battle`

The new map flow replaces steps 1-2 with tap-on-gym, but step 3 logic is reused.

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation** | All widgets in `presentation/home/widgets/` |
| **Import Style** | `package:ironmon/...` only |
| **Navigation** | go_router for battle entry |
| **Backward Compatible** | `/battle/select` route still works |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/home/widgets/gym_preview_panel.dart
ironmon/test/presentation/home/widgets/gym_preview_panel_test.dart
```

Files to update:

```
ironmon/lib/presentation/home/widgets/gym_map_icon.dart (add tap handler)
ironmon/lib/presentation/home/widgets/world_map.dart (player walk animation)
ironmon/lib/presentation/home/home_screen.dart (wire tap → preview → battle)
```

### References

- [Source: epics.md#Story 10.2] — User story, acceptance criteria
- [Source: spec.md#Section 6.2] — Map with selectable gyms
- [Source: architecture.md#Frontend Architecture] — go_router navigation

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
