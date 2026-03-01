# Story UX-2: Pixel Font & Typography System

Status: done

## Story

As a player,
I want damage numbers, boss names, and battle messages displayed in pixel-style font,
So that the RPG battle atmosphere feels authentic and retro.

## Acceptance Criteria

1. **Given** the app launches
   **When** any pixel-styled text renders
   **Then** it uses the "Press Start 2P" (or Silkscreen) pixel bitmap font
2. **And** a reusable `PixelText` widget exists with variants: Display (48sp), Heading (24-32sp), Label (12sp)
3. **And** damage numbers on the battle screen use `PixelText.display` with text shadow
4. **And** boss names use `PixelText.heading`
5. **And** battle messages ("Super Effective!", "Not Very Effective...") use `PixelText.heading`
6. **And** type badges use `PixelText.label`
7. **And** all functional UI text (buttons, inputs, descriptions) continues using the system font (SF Pro on iOS)
8. **And** the typography scale matches UX spec: Display 48sp, H1 32sp, H2 24sp, H3 20sp, Body 16sp, Label 12sp
9. **And** `flutter analyze` reports zero issues

## Tasks / Subtasks

- [x] Task 1: Add pixel font asset (AC: 1)
  - [x] 1.1 Download "Press Start 2P" font from Google Fonts (OFL license)
  - [x] 1.2 Place `.ttf` file in `ironmon/assets/fonts/PressStart2P-Regular.ttf`
  - [x] 1.3 Register font in `pubspec.yaml` under `fonts:` section
  - [x] 1.4 Verify font loads without error on iOS simulator

- [x] Task 2: Create PixelText widget (AC: 2, 3, 4, 5, 6)
  - [x] 2.1 Create `lib/presentation/shared/pixel_text.dart`
  - [x] 2.2 Implement `PixelText` StatelessWidget with named constructors:
    - `PixelText.display()` — 48sp Bold, for damage numbers
    - `PixelText.h1()` — 32sp Bold, for evolution/level-up titles
    - `PixelText.h2()` — 24sp Bold, for boss names, screen titles
    - `PixelText.label()` — 12sp Medium, for type badges, stat labels
  - [x] 2.3 Support optional `color`, `shadows`, `textAlign` parameters
  - [x] 2.4 Default shadow: `Shadow(blurRadius: 4, color: Colors.black, offset: Offset(1, 1))`

- [x] Task 3: Update IronMon theme typography (AC: 7, 8)
  - [x] 3.1 Update `ironmon_theme.dart` (from UX-1) to define `TextTheme` with type scale
  - [x] 3.2 H3 (20sp SemiBold), Body Large (18sp), Body (16sp), Body Small (14sp) use system font
  - [x] 3.3 Pixel font is NOT set as default — only used explicitly via `PixelText` widget

- [x] Task 4: Update DamageDisplay to use PixelText (AC: 3, 5)
  - [x] 4.1 Replace `fontFamily: 'monospace'` in `damage_display.dart` with `PixelText.display`
  - [x] 4.2 Effectiveness text ("Super Effective!") uses `PixelText.h2`

- [x] Task 5: Update BossHpBar to use PixelText (AC: 4)
  - [x] 5.1 Boss name text uses `PixelText.h2`
  - [x] 5.2 HP numbers continue using system font (readability for numbers)

- [x] Task 6: Update TypeBadge to use PixelText (AC: 6)
  - [x] 6.1 Type label text uses `PixelText.label`

- [x] Task 7: Tests (AC: 9)
  - [x] 7.1 Widget test: PixelText renders with correct font family
  - [x] 7.2 Widget test: PixelText.display uses 48sp size
  - [x] 7.3 `flutter analyze` reports zero issues

## Dev Agent Record

### Implementation Plan

- Added Press Start 2P font to pubspec.yaml
- Created PixelText widget with named constructors (display/h1/h2/label)
- Updated IronMonTheme with complete TextTheme using system font
- Replaced hardcoded fonts in battle widgets with PixelText
- Added comprehensive widget tests for PixelText

### Completion Notes

- Pixel font is used selectively for RPG elements (damage, boss names, type badges)
- System font remains default for functional UI (buttons, inputs, descriptions)
- All PixelText variants include default shadow for readability
- Typography scale matches UX spec (Display 48sp through Label 12sp)
- Battle screen now has authentic pixel-RPG feel

## File List

### New Files

- `ironmon/lib/presentation/shared/pixel_text.dart`
- `ironmon/test/presentation/shared/pixel_text_test.dart`

### Modified Files

- `ironmon/pubspec.yaml` (added font declaration)
- `ironmon/lib/presentation/shared/ironmon_theme.dart` (added TextTheme)
- `ironmon/lib/presentation/battle/widgets/damage_display.dart`
- `ironmon/lib/presentation/battle/widgets/boss_hp_bar.dart`
- `ironmon/lib/presentation/shared/type_badge.dart`

## Change Log

- 2026-02-28: Implemented pixel font typography system
  - Added Press Start 2P font asset and registration
  - Created PixelText widget with 4 size variants
  - Updated battle widgets to use pixel font appropriately
  - Added TextTheme with system font for functional UI
  - Added widget tests for all PixelText constructors

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

- **Story UX-1** — Dark theme and design tokens (IronMonColors, IronMonTheme)
- **Story 2.6** — BossHpBar, DamageDisplay widgets to update
- **Story 5.1** — TypeBadge widget to update

### UX Spec Reference — Typography System

```
Primary Font: System default (SF Pro on iOS)
  — All functional text: buttons, inputs, descriptions

Accent Font: Pixel-style bitmap font (Press Start 2P)
  — Damage numbers, Boss names, battle messages, type labels

Type Scale:
  Display:    48sp Bold   Pixel  → damage numbers
  H1:         32sp Bold   Pixel  → evolution/level-up titles
  H2:         24sp Bold   Pixel  → boss names, screen titles
  H3:         20sp SemiBold System → section titles
  Body Large: 18sp Regular System → main content
  Body:       16sp Regular System → general text
  Body Small: 14sp Regular System → secondary text
  Label:      12sp Medium  Pixel  → type badges, stat labels
```

### UX Spec Reference — Design Direction

**"戰鬥是遊戲，輸入是工具"**
- Boss sprites, damage numbers, battle messages, evolution animation → **Pixel font**
- Weight/reps input, buttons, navigation, settings → **System font**

### Font Loading in Flutter

```yaml
# pubspec.yaml addition
fonts:
  - family: PressStart2P
    fonts:
      - asset: assets/fonts/PressStart2P-Regular.ttf
```

### PixelText Widget Signature

```dart
class PixelText extends StatelessWidget {
  const PixelText.display(this.text, {super.key, this.color, this.shadows});
  const PixelText.h1(this.text, {super.key, this.color, this.shadows});
  const PixelText.h2(this.text, {super.key, this.color, this.shadows});
  const PixelText.label(this.text, {super.key, this.color, this.shadows});

  final String text;
  final Color? color;
  final List<Shadow>? shadows;
  // ...
}
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **No domain changes** | Pure presentation — do NOT touch domain or data layers |
| **Widget Pattern** | `StatelessWidget` for PixelText (no state needed) |

### Project Structure Notes

New files to create:

```
ironmon/assets/fonts/PressStart2P-Regular.ttf
ironmon/lib/presentation/shared/pixel_text.dart
ironmon/test/presentation/shared/pixel_text_test.dart
```

Files to update:

```
ironmon/pubspec.yaml (add fonts section)
ironmon/lib/presentation/shared/ironmon_theme.dart (add TextTheme)
ironmon/lib/presentation/battle/widgets/damage_display.dart
ironmon/lib/presentation/battle/widgets/boss_hp_bar.dart
ironmon/lib/presentation/shared/type_badge.dart
```

### References

- [Source: ux-design-specification.md#Typography System] — Font choices, type scale
- [Source: ux-design-specification.md#Design Direction Decision] — Pixel font vs system font split
- [Source: ux-design-specification.md#Component Strategy — PixelText] — Widget spec
- [Source: architecture.md#Frontend Architecture] — presentation/shared/ location
