# Story UX-3: Battle Screen Visual Polish

Status: done

## Story

As a player,
I want the battle screen to have screen shake on crits, smooth phase transitions, and RPE quick buttons,
So that every attack feels impactful and input stays fast even with gloves on.

## Acceptance Criteria

1. **Given** a critical hit or Super Effective attack occurs
   **When** the damage animation plays
   **Then** the screen shakes briefly (200ms, elastic easing)
2. **And** the screen shake is implemented with `Transform.translate` + `AnimationController`, NOT by rebuilding the widget tree
3. **Given** a boss is defeated and the next phase begins
   **When** the phase transition occurs
   **Then** a 600ms fade/slide transition animates the new boss in (easeInOut)
4. **Given** the player needs to input RPE
   **When** the Set Input Panel renders
   **Then** 3 quick-tap buttons are available: Easy (RPE 6-7), Medium (RPE 8), Hard (RPE 9-10)
5. **And** quick-tap RPE buttons are ≥48×48dp touch targets with clear visual distinction
6. **And** the existing RPE slider remains available as an alternative (expandable)
7. **Given** the battle screen is active
   **When** the screen renders
   **Then** the device screen stays awake (WakelockPlus or equivalent)
8. **And** `flutter analyze` reports zero issues

## Tasks / Subtasks

- [x] Task 1: Implement screen shake animation (AC: 1, 2)
  - [x] 1.1 Create `lib/presentation/battle/widgets/screen_shake.dart` — a wrapper widget
  - [x] 1.2 Use `AnimationController` (200ms) + `Tween<Offset>` with elastic curve
  - [x] 1.3 Expose `shake()` method via GlobalKey or controller pattern
  - [x] 1.4 Trigger shake from `ref.listen` on `lastDamageResult` when `isCritical || isSuperEffective`
  - [x] 1.5 Wrap battle screen content in `ScreenShake` widget

- [x] Task 2: Implement phase transition animation (AC: 3)
  - [x] 2.1 Create `lib/presentation/battle/widgets/phase_transition.dart`
  - [x] 2.2 On phase change: old boss fades out (300ms) → new boss slides in from right (300ms)
  - [x] 2.3 Use `AnimatedSwitcher` with custom `transitionBuilder` or explicit `AnimationController`
  - [x] 2.4 Trigger transition when `battleStateNotifierProvider.select((s) => s.currentPhase)` changes

- [x] Task 3: Add RPE quick-tap buttons (AC: 4, 5, 6)
  - [x] 3.1 Update `set_input_panel.dart` — add 3 `SegmentedButton` or `ChoiceChip` row above existing slider
  - [x] 3.2 "Easy" button → sets RPE to 7, color: `IronMonColors.hpHigh` (green)
  - [x] 3.3 "Medium" button → sets RPE to 8, color: `IronMonColors.secondary` (yellow)
  - [x] 3.4 "Hard" button → sets RPE to 10, color: `IronMonColors.error` (red)
  - [x] 3.5 Tapping a quick button updates the RPE slider value (two-way sync)
  - [x] 3.6 Each button ≥48×48dp, with clear label and color coding

- [x] Task 4: Implement screen-always-on during battle (AC: 7)
  - [x] 4.1 Add `wakelock_plus` package to `pubspec.yaml`
  - [x] 4.2 In `BattleScreen.initState()`: `WakelockPlus.enable()`
  - [x] 4.3 In `BattleScreen.dispose()`: `WakelockPlus.disable()`
  - [x] 4.4 Ensure wakelock is released even if user navigates away (use `ref.onDispose` or `dispose`)

- [x] Task 5: Polish damage display colors (AC: 1)
  - [x] 5.1 Verify damage colors match UX spec tokens (from UX-1)
  - [x] 5.2 Critical hit: yellow (`#FFD93D`) + enlarged text (1.3x scale)
  - [x] 5.3 Super Effective: orange (`#FF6B35`) + enlarged text (1.2x scale)
  - [x] 5.4 Not Effective: grey (`#8B949E`) + shrunk text (0.8x scale)
  - [x] 5.5 Normal: white (`#FFFFFF`)

- [x] Task 6: Tests (AC: 8)
  - [x] 6.1 Widget test: screen shake triggers on critical damage
  - [x] 6.2 Widget test: RPE quick buttons update RPE value
  - [x] 6.3 `flutter analyze` reports zero issues

## Dev Agent Record

### Implementation Plan
- Created ScreenShake widget with elastic animation for critical hits
- Created PhaseTransition widget for smooth boss phase changes
- Added RPE quick-tap buttons (Easy/Medium/Hard) to SetInputPanel
- Implemented wakelock to keep screen awake during battle
- Added text scaling animations to damage display

### Completion Notes
- Screen shake triggers on critical hits and super effective attacks
- RPE quick buttons provide fast input with 48dp minimum touch targets
- Wakelock ensures screen stays on during active battles
- Damage numbers scale based on effectiveness (1.3x critical, 1.2x super, 0.8x not effective)
- All animations use proper AnimationController patterns

## File List

### New Files
- `ironmon/lib/presentation/battle/widgets/screen_shake.dart`
- `ironmon/lib/presentation/battle/widgets/phase_transition.dart`
- `ironmon/test/presentation/battle/widgets/screen_shake_test.dart`
- `ironmon/test/presentation/battle/widgets/set_input_panel_test.dart`

### Modified Files
- `ironmon/pubspec.yaml` (added wakelock_plus)
- `ironmon/lib/presentation/battle/battle_screen.dart`
- `ironmon/lib/presentation/battle/widgets/set_input_panel.dart`
- `ironmon/lib/presentation/battle/widgets/damage_display.dart`

## Change Log

- 2026-02-28: Implemented battle screen visual polish
  - Added screen shake animation for impactful hits
  - Created phase transition animations
  - Added RPE quick-tap buttons with color coding
  - Implemented screen wakelock during battles
  - Added damage text scaling based on effectiveness

## Status

done

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is presentation-only. No Drift changes.

### Dependencies on Previous Stories

- **Story UX-1** — Design tokens (IronMonColors for damage/HP colors)
- **Story UX-2** — PixelText widget for damage display
- **Story 2.5** — `BattleStateNotifier`, `BattlePhase` for phase detection
- **Story 2.6** — BattleScreen, DamageDisplay, SetInputPanel to update
- **Story 3.5** — HapticService for coordinating haptic + screen shake

### UX Spec Reference — Animation Patterns

| Animation | Duration | Easing | Trigger |
|---|---|---|---|
| HP Bar Drain | 500ms | easeOutCubic | Every damage dealt |
| Damage Number Float | 800ms | easeOut + fade | Every attack confirm |
| Screen Shake | 200ms | elastic | Critical / Counter |
| Phase Transition | 600ms | easeInOut | Boss switch |
| EXP Bar Fill | 1000ms | easeInOutCubic | Result screen |

### UX Spec Reference — Feedback Patterns

**Damage (normal):** light haptic + white number float
**Critical:** heavy haptic + yellow enlarged number + screen shake
**Super Effective:** heavy haptic + orange enlarged number + screen shake
**Not Effective:** error notification haptic + grey shrunk number
**Warning:** orange pulse when player HP < 25%

### UX Spec Reference — RPE Quick Buttons

```
RPE 三按鈕：
  Easy (RPE 6-7)  → 1.0x damage multiplier → green
  Medium (RPE 8)  → 1.2x damage multiplier → yellow
  Hard (RPE 9-10) → 1.5x damage multiplier → red
```

### Screen Shake Implementation Pattern

```dart
class ScreenShake extends StatefulWidget {
  // Wraps child with Transform.translate
  // shake() applies a quick oscillating offset
}

// Usage in BattleScreen:
ref.listen(battleStateNotifierProvider.select((s) => s.lastDamageResult), (prev, next) {
  if (next != null && (next.isCritical || next.effectiveness > 1.0)) {
    _shakeKey.currentState?.shake();
  }
});
```

### Wakelock Integration

```yaml
# pubspec.yaml addition
dependencies:
  wakelock_plus: ^1.2.8
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Widget Pattern** | `ConsumerStatefulWidget` for BattleScreen (already is) |
| **Animation** | `AnimationController` in `State`, dispose in `dispose()` |
| **State Access** | `ref.watch()` with `select()` for phase/damage changes |
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **No domain changes** | Pure presentation — do NOT touch domain or data layers |
| **Performance** | `RepaintBoundary` around shake area, 60fps target |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/widgets/screen_shake.dart
ironmon/lib/presentation/battle/widgets/phase_transition.dart
```

Files to update:

```
ironmon/pubspec.yaml (add wakelock_plus)
ironmon/lib/presentation/battle/battle_screen.dart
ironmon/lib/presentation/battle/widgets/set_input_panel.dart
ironmon/lib/presentation/battle/widgets/damage_display.dart
```

### References

- [Source: ux-design-specification.md#Animation Patterns] — Duration, easing, triggers
- [Source: ux-design-specification.md#Feedback Patterns] — Layered response pattern
- [Source: ux-design-specification.md#Effortless Interactions] — RPE quick buttons
- [Source: ux-design-specification.md#Experience Principles] — Instant Feedback <200ms
- [Source: architecture.md#Performance Optimization] — 60fps, RepaintBoundary
