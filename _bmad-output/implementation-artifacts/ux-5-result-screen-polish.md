# Story UX-5: Battle Result Screen Polish

Status: done

## Story

As a player,
I want the result screen to feel rewarding with juicy EXP bar animation and clear stat cards,
So that finishing a workout feels like a celebration worthy of a screenshot.

## Acceptance Criteria

1. **Given** a battle has ended (victory or defeat)
   **When** the result screen displays
   **Then** the outcome status is shown with pixel-style text and appropriate color (victory=gold, defeat=grey)
2. **And** an animated EXP bar fills from previous EXP to new EXP over 1000ms (easeInOutCubic)
3. **And** if the player leveled up, a "Level Up!" banner animates in (1500ms bounceOut) after EXP bar fills
4. **And** training stats are displayed in cards: total volume (kg), total damage dealt, sets completed, time elapsed
5. **And** each stat card uses dark surface variant background with the stat value in a large, clear font
6. **And** a prominent "Return Home" button is at the bottom (full-width, 56dp height)
7. **And** the result screen uses the dark pixel theme from UX-1
8. **And** `flutter analyze` reports zero issues

## Tasks / Subtasks

- [x] Task 1: Redesign result screen layout (AC: 1, 4, 5, 7)
  - [x] 1.1 Update `lib/presentation/battle/battle_result_screen.dart`
  - [x] 1.2 Top section: outcome banner — "VICTORY!" (gold PixelText.h1) or "DEFEAT" (grey PixelText.h1)
  - [x] 1.3 Victory: add a subtle gold glow/shimmer behind the text
  - [x] 1.4 Defeat: add supportive sub-text "You still earned 60% EXP!" in system font
  - [x] 1.5 Stat cards section: 2×2 grid of `Card` widgets with `IronMonColors.surfaceVariant` background
  - [x] 1.6 Each stat card: label (Body Small, grey), value (H3, white), icon

- [x] Task 2: Animated EXP bar (AC: 2, 3)
  - [x] 2.1 Create `lib/presentation/battle/widgets/animated_exp_bar.dart`
  - [x] 2.2 Use `AnimationController` (1000ms) + `Tween<double>` from previous EXP% to new EXP%
  - [x] 2.3 Bar color: `IronMonColors.expBar` (#58A6FF)
  - [x] 2.4 Show "EXP +{amount}" text above bar during animation
  - [x] 2.5 If level up: bar fills to 100% → flash → reset to 0% → fill to new % → trigger level up banner

- [x] Task 3: Level Up banner animation (AC: 3)
  - [x] 3.1 "Level Up!" banner slides in from top with bounceOut (1500ms)
  - [x] 3.2 New level number displayed prominently in `PixelText.h1` with gold color
  - [x] 3.3 Trigger enhanced haptic (from HapticService) on level up display
  - [x] 3.4 Banner appears after EXP bar animation completes (staggered)

- [x] Task 4: Return Home button (AC: 6)
  - [x] 4.1 Full-width `ElevatedButton` at bottom, 56dp height
  - [x] 4.2 Text: "Return Home" in system font
  - [x] 4.3 `context.go('/')` navigation (replace stack, not push)
  - [x] 4.4 SafeArea padding at bottom for iOS Home Indicator

- [x] Task 5: Tests (AC: 8)
  - [x] 5.1 Widget test: result screen shows "VICTORY!" for won battles
  - [x] 5.2 Widget test: result screen shows "DEFEAT" for lost battles
  - [x] 5.3 Widget test: stat cards display volume and damage values
  - [x] 5.4 `flutter analyze` reports zero issues

## Dev Agent Record

### Implementation Plan
- Created AnimatedExpBar widget with smooth EXP fill animation
- Redesigned BattleResultScreen with victory/defeat banners and glow effects
- Implemented 2x2 grid of stat cards with icons and clear typography
- Added level up banner with bounce animation after EXP bar fills
- Created full-width Return Home button with proper navigation

### Completion Notes
- Victory banner includes animated glow effect using AnimationController
- EXP bar fills from previous to current EXP percentage over 1000ms
- Level up banner slides in with bounceOut animation after EXP completes
- Stat cards display volume, damage, sets, and time with clear hierarchy
- Dark pixel theme applied throughout with proper color tokens

## File List

### New Files
- `ironmon/lib/presentation/battle/widgets/animated_exp_bar.dart`
- `ironmon/test/presentation/battle/battle_result_screen_test.dart`
- `ironmon/test/presentation/battle/widgets/animated_exp_bar_test.dart`

### Modified Files
- `ironmon/lib/presentation/battle/battle_result_screen.dart`

## Change Log

- 2026-02-28: Implemented battle result screen polish
  - Created animated EXP bar with level up detection
  - Redesigned layout with stat cards grid
  - Added victory glow animation and defeat supportive text
  - Implemented full-width Return Home button

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

- **Story UX-1** — Design tokens (IronMonColors)
- **Story UX-2** — PixelText widget
- **Story 3.2** — Existing BattleResultScreen to redesign
- **Story 3.3** — EXP calculation logic (ExpCalculator)
- **Story 4.1** — Level up system (level threshold, stat increases)
- **Story 3.5** — HapticService for level up haptic

### UX Spec Reference — Emotional Design

```
打倒 Gym Leader → 成就感（「我贏了！」）
PR 突破進化 → 驕傲（「我真的變強了」）→ 截圖分享
戰鬥失敗 → 不甘心但不挫敗（「還是拿了 60% 經驗值，下次再來」）
```

### UX Spec Reference — Animation Patterns

| Animation | Duration | Easing |
|---|---|---|
| EXP Bar Fill | 1000ms | easeInOutCubic |
| Level Up Popup | 1500ms | bounceOut |

### UX Spec Reference — Result Screen Content

```
Completion — 結算：
- Boss HP 歸零 → 勝利 Jingle
- 結算畫面：總容量、傷害統計、經驗值 breakdown
- Level Up 提示（如果升級）
- Evolution 動畫（如果 PR 突破）
- 「Return Home」按鈕
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Widget Pattern** | `ConsumerStatefulWidget` (AnimationControllers) |
| **Animation** | `AnimationController` + `Tween`, dispose in `dispose()` |
| **State Access** | `ref.watch()` for battle outcome data |
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **Navigation** | `context.go('/')` to replace entire stack |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/widgets/animated_exp_bar.dart
```

Files to update:

```
ironmon/lib/presentation/battle/battle_result_screen.dart
```

### References

- [Source: ux-design-specification.md#Emotional Journey Mapping] — Victory/defeat emotional goals
- [Source: ux-design-specification.md#Animation Patterns] — EXP bar, level up timing
- [Source: ux-design-specification.md#Emotional Design Principles] — Negative events positive framing
- [Source: ux-design-specification.md#Experience Mechanics — Completion] — Result screen content
- [Source: epics.md#Story 3.2] — Battle Result Screen (original)
