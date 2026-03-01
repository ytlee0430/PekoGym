# Story UX-1: Dark Pixel Theme & Design Tokens

Status: done

## Story

As a player,
I want the app to have a dark, pixel-RPG themed visual identity,
So that the entire experience feels like playing a retro game from the moment I open the app.

## Acceptance Criteria

1. **Given** the app launches
   **When** any screen renders
   **Then** the app uses a dark theme with `surface: #0D1117` background
2. **And** the Material 3 `ColorScheme` uses all UX spec design tokens (primary `#58A6FF`, secondary `#F0C040`, error `#F85149`, etc.)
3. **And** type effectiveness colors are defined as constants matching the UX spec (FIRE `#FF6B35`, WATER `#4B9CD3`, ROCK `#A0855B`, ELECTRIC `#FFD93D`, FIGHTING `#C2185B`)
4. **And** semantic damage colors are defined (`damageNormal`, `damageCritical`, `damageSuperEffective`, `damageNotEffective`)
5. **And** semantic HP colors are defined (`hpHigh: #3FB950`, `hpMid: #F0C040`, `hpLow: #F85149`)
6. **And** spacing tokens follow an 8dp grid system (`spacing-xs: 4dp` through `spacing-2xl: 48dp`)
7. **And** all existing screens (Home, Battle, Result, Pokédex) render correctly with the new dark theme
8. **And** `flutter analyze` reports zero issues

## Tasks / Subtasks

- [x] Task 1: Create centralized design tokens file (AC: 2, 3, 4, 5, 6)
  - [x] 1.1 Create `lib/presentation/shared/design_tokens.dart`
  - [x] 1.2 Define `IronMonColors` class with all color constants from UX spec
  - [x] 1.3 Define `IronMonSpacing` class with 8dp grid spacing tokens
  - [x] 1.4 Define `IronMonSizes` class with touch target sizes (48dp min, 56dp battle buttons)
  - [x] 1.5 Define `TypeColors` extension or map linking `MuscleType` enum to hex colors

- [x] Task 2: Create IronMon ThemeData (AC: 1, 2)
  - [x] 2.1 Create `lib/presentation/shared/ironmon_theme.dart`
  - [x] 2.2 Build `ColorScheme.dark()` with all UX spec tokens mapped to Material 3 roles
  - [x] 2.3 Configure `ThemeData` with dark brightness, custom `ColorScheme`, `useMaterial3: true`
  - [x] 2.4 Override component themes: `ElevatedButtonThemeData` (56dp height, full-width for primary), `CardTheme` (surfaceVariant background), `BottomSheetThemeData` (dark surface), `SliderThemeData` (custom track/thumb colors), `NavigationBarThemeData` (dark surface)

- [x] Task 3: Wire theme into main.dart (AC: 1, 7)
  - [x] 3.1 Replace `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))` with `IronMonTheme.dark()`
  - [x] 3.2 Verify all existing screens render without visual breakage
  - [x] 3.3 Update any hardcoded colors in existing widgets to use `Theme.of(context)` or design token constants

- [x] Task 4: Update BossHpBar colors (AC: 5)
  - [x] 4.1 Replace hardcoded green/yellow/red with `IronMonColors.hpHigh/hpMid/hpLow`
  - [x] 4.2 Verify smooth color transitions at 50% and 25% thresholds

- [x] Task 5: Update DamageDisplay colors (AC: 4)
  - [x] 5.1 Replace hardcoded damage colors with `IronMonColors.damageNormal/damageCritical/damageSuperEffective/damageNotEffective`

- [x] Task 6: Update TypeBadge and MoveSelector colors (AC: 3)
  - [x] 6.1 Wire `TypeColors` mapping into `type_badge.dart`
  - [x] 6.2 Update `move_selector.dart` chips to use type-specific colors

- [x] Task 7: Tests (AC: 8)
  - [x] 7.1 Unit test: verify all `IronMonColors` constants match UX spec hex values
  - [x] 7.2 Unit test: verify `TypeColors` mapping covers all 5 `MuscleType` values
  - [x] 7.3 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is presentation-only. No Drift changes.

### Dependencies on Previous Stories

- **Story 1.1** — Project scaffold, `main.dart`
- **Story 2.1** — `MuscleType` enum for type color mapping
- **Story 2.6** — BossHpBar, DamageDisplay, MoveSelector widgets to update
- **Story 5.1** — TypeBadge widget to update

### UX Spec Reference — Color System

```
Primary Palette (Dark):
  surface:          #0D1117  (主背景)
  surfaceVariant:   #161B22  (卡片/面板)
  primary:          #58A6FF  (主要按鈕/活動狀態)
  onPrimary:        #FFFFFF  (按鈕文字)
  secondary:        #F0C040  (EXP bar/重要數字)
  error:            #F85149  (低血量/錯誤)
  onSurface:        #C9D1D9  (一般文字)
  onSurfaceVariant: #8B949E  (次要文字)

Type Effectiveness Colors:
  FIRE (Chest):       #FF6B35
  WATER (Back):       #4B9CD3
  ROCK/GROUND (Legs): #A0855B
  ELECTRIC (Shoulders):#FFD93D
  FIGHTING (Arms):    #C2185B

Semantic Damage Colors:
  damageNormal:         #FFFFFF
  damageCritical:       #FFD93D
  damageSuperEffective: #FF6B35
  damageNotEffective:   #8B949E

Semantic HP Colors:
  hpHigh (>50%):  #3FB950
  hpMid (25-50%): #F0C040
  hpLow (<25%):   #F85149

EXP Bar: #58A6FF
```

### UX Spec Reference — Spacing System

```
spacing-xs:  4dp   (內部元素間隔)
spacing-sm:  8dp   (緊密排列)
spacing-md:  16dp  (標準間距)
spacing-lg:  24dp  (Section 間距)
spacing-xl:  32dp  (主要區塊間距)
spacing-2xl: 48dp  (畫面區域間距)
```

### UX Spec Reference — Touch Targets

```
Minimum:           48 × 48dp (Material 3 standard)
Battle buttons:    56 × 56dp (glove-friendly)
±2.5kg stepper:    48 × 48dp
Attack! button:    full-width × 56dp
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **No domain changes** | Pure presentation — do NOT touch domain or data layers |
| **Theme access** | Use `Theme.of(context).colorScheme` or `IronMonColors.*` constants |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/shared/design_tokens.dart
ironmon/lib/presentation/shared/ironmon_theme.dart
ironmon/test/presentation/shared/design_tokens_test.dart
```

Files to update:

```
ironmon/lib/main.dart
ironmon/lib/presentation/battle/widgets/boss_hp_bar.dart
ironmon/lib/presentation/battle/widgets/damage_display.dart
ironmon/lib/presentation/battle/widgets/move_selector.dart
ironmon/lib/presentation/shared/type_badge.dart
```

## Dev Agent Record

### Implementation Plan

- Created centralized design tokens in `design_tokens.dart` with all UX spec colors
- Built `IronMonTheme.dark()` mapping tokens to Material 3 ColorScheme
- Updated all battle widgets to use design tokens instead of hardcoded colors
- Added comprehensive unit tests for color constants and type mapping

### Completion Notes

- All design tokens from UX spec are now available as constants
- Dark theme is active app-wide via main.dart
- HP bar colors now use semantic tokens (hpHigh/hpMid/hpLow)
- Damage colors use semantic tokens (damageNormal/damageCritical/etc.)
- Type colors are centralized and mapped from MuscleType enum
- Component themes configured for consistent pixel-RPG aesthetic

## File List

### New Files

- `ironmon/lib/presentation/shared/design_tokens.dart`
- `ironmon/lib/presentation/shared/ironmon_theme.dart`
- `ironmon/test/presentation/shared/design_tokens_test.dart`

### Modified Files

- `ironmon/lib/main.dart`
- `ironmon/lib/presentation/battle/widgets/boss_hp_bar.dart`
- `ironmon/lib/presentation/battle/widgets/damage_display.dart`
- `ironmon/lib/presentation/battle/widgets/move_selector.dart`
- `ironmon/lib/presentation/shared/type_badge.dart`

## Change Log

- 2026-02-28: Implemented dark pixel theme with design tokens
  - Created IronMonColors with all UX spec colors
  - Created IronMonSpacing (8dp grid) and IronMonSizes (touch targets)
  - Built IronMonTheme.dark() with Material 3 integration
  - Updated all battle widgets to use design tokens
  - Added unit tests for color constants

## Status

done

### References

- [Source: ux-design-specification.md#Visual Design Foundation] — Complete color system, typography, spacing
- [Source: ux-design-specification.md#Design System Foundation] — Material 3 + Custom Pixel Theme Overlay strategy
- [Source: ux-design-specification.md#Design Direction Decision] — Modern Pixel Hybrid direction
- [Source: architecture.md#Frontend Architecture] — Presentation layer structure
