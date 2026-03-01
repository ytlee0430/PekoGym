# Story 9.4: Dynamax Mode

Status: ready-for-dev

## Story

As a player,
I want an extreme power mode when my heart rate hits Zone 5,
So that pushing to maximum intensity has both high reward and risk.

## Acceptance Criteria

1. **Given** the player's heart rate enters Zone 5 (>85% max HR)
   **When** damage is calculated for that set
   **Then** damage multiplier is 1.5x (Dynamax Mode activated)
2. **And** the player loses 5% of max HP per turn while in Dynamax Mode
3. **And** a visual "Dynamax" overlay effect appears on the battle screen
4. **And** enhanced haptic feedback accompanies Dynamax activation
5. **And** the self-damage mechanic is clearly communicated to the player via UI indicator

## Tasks / Subtasks

- [ ] Task 1: Dynamax HP drain in BattleEngine (AC: 1, 2)
  - [ ] 1.1 In `BattleEngine.submitSet()`, after damage calculation, check if zone == zone5
  - [ ] 1.2 If Dynamax active: deduct `(maxPlayerHp * 0.05).round()` from player HP
  - [ ] 1.3 Add `isDynamaxActive` flag to `BattleState`
  - [ ] 1.4 Player can still be defeated by Dynamax self-damage (same defeat flow)

- [ ] Task 2: Dynamax visual overlay (AC: 3)
  - [ ] 2.1 Create `lib/presentation/battle/widgets/dynamax_overlay.dart`
  - [ ] 2.2 Full-screen semi-transparent red pulse effect when Dynamax active
  - [ ] 2.3 "DYNAMAX" text badge displayed prominently
  - [ ] 2.4 Energy crackling animation at screen edges (optional polish)
  - [ ] 2.5 Use `RepaintBoundary` to isolate animation

- [ ] Task 3: Dynamax HP warning indicator (AC: 5)
  - [ ] 3.1 Show "-5% HP" warning text near player HP bar when Dynamax active
  - [ ] 3.2 Flash player HP bar red during Dynamax self-damage
  - [ ] 3.3 Show "Zone 5 — Dynamax! High damage but draining HP" tooltip on first activation

- [ ] Task 4: Haptic feedback for Dynamax (AC: 4)
  - [ ] 4.1 Trigger `HapticService.onCriticalEvent()` when Dynamax first activates
  - [ ] 4.2 Trigger `HapticService.onPlayerDamage()` on each self-damage tick

- [ ] Task 5: Dynamax exit (AC: 1, 2)
  - [ ] 5.1 Dynamax deactivates when HR drops below Zone 5 threshold
  - [ ] 5.2 Clear visual overlay and warning indicators
  - [ ] 5.3 If no wearable, Dynamax is never triggered (RPE 9-10 uses 1.5x but no self-damage)

- [ ] Task 6: Tests (AC: 1-5)
  - [ ] 6.1 Unit test: Dynamax triggers at Zone 5
  - [ ] 6.2 Unit test: 5% HP drain per set during Dynamax
  - [ ] 6.3 Unit test: player defeat via Dynamax self-damage
  - [ ] 6.4 Unit test: Dynamax not triggered without wearable (RPE path unchanged)
  - [ ] 6.5 Widget test: overlay appears when isDynamaxActive
  - [ ] 6.6 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No database changes in this story.

### CRITICAL — No riverpod_generator

Manual providers only.

### RPE vs Heart Rate Dynamax Difference

**With wearable (HR Zone 5):** 1.5x damage + 5% HP self-damage per set. High risk/reward.

**Without wearable (RPE 9-10):** 1.5x damage only. No self-damage. This preserves backward compatibility — Dynamax self-damage is a wearable-exclusive mechanic.

### Dependencies on Previous Stories

- **Story 9.1** — `HealthService` for wearable detection
- **Story 9.2** — `HeartRateZone` for zone detection
- **Story 9.3** — Heart Rate HUD (Dynamax enhances the visual)
- **Story 2.5** — `BattleEngine` for HP drain logic
- **Story 3.5** — `HapticService` for feedback

### Self-Damage Formula

```dart
if (zone == HeartRateZone.zone5 && hasWearable) {
  final selfDamage = (state.maxPlayerHp * 0.05).round();
  newState = newState.copyWith(
    playerHp: (newState.playerHp - selfDamage)
        .clamp(0, newState.maxPlayerHp),
    isDynamaxActive: true,
  );
}
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | HP drain logic in `domain/battle/battle_engine.dart` — Pure Dart |
| **Presentation** | Overlay in `presentation/battle/widgets/` |
| **Backward Compatible** | RPE path has no self-damage |
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/widgets/dynamax_overlay.dart
ironmon/test/domain/battle/dynamax_test.dart
ironmon/test/presentation/battle/widgets/dynamax_overlay_test.dart
```

Files to update:

```
ironmon/lib/domain/battle/models/battle_state.dart (isDynamaxActive)
ironmon/lib/domain/battle/battle_engine.dart (Dynamax HP drain)
ironmon/lib/providers/battle_providers.dart (Dynamax haptic)
ironmon/lib/presentation/battle/battle_screen.dart (add overlay)
```

### References

- [Source: epics.md#Story 9.4] — User story, acceptance criteria
- [Source: spec.md#Section 4.4 Step 3] — Zone 5: 1.5x damage + self HP drain
- [Source: architecture.md#Battle Engine] — BattleState transitions

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
