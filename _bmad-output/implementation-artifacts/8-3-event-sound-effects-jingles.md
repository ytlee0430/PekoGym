# Story 8.3: Event Sound Effects & Jingles

Status: ready-for-dev

## Story

As a player,
I want to hear satisfying sound effects for key game events,
So that achievements and actions feel impactful.

## Acceptance Criteria

1. **Given** a game event occurs
   **When** the event type is: attack hit, critical hit, super effective, level up, evolution, victory, defeat
   **Then** the corresponding SFX or jingle plays
2. **And** victory jingle plays on the result screen for wins
3. **And** level up jingle plays during the level up animation
4. **And** evolution jingle plays during the evolution animation sequence
5. **And** SFX do not interrupt or conflict with BGM playback

## Tasks / Subtasks

- [ ] Task 1: Source or create SFX assets (AC: 1)
  - [ ] 1.1 Obtain 8-bit style SFX files:
        - `hit_normal.mp3` — normal attack hit
        - `hit_critical.mp3` — critical / super effective hit
        - `hit_ineffective.mp3` — not very effective
        - `player_damage.mp3` — player takes HP damage
        - `victory.mp3` — victory jingle (3-5 seconds)
        - `defeat.mp3` — defeat jingle (3-5 seconds)
        - `level_up.mp3` — level up jingle (2-3 seconds)
        - `evolution.mp3` — evolution fanfare (3-5 seconds)
        - `item_use.mp3` — item usage sound
  - [ ] 1.2 Place in `assets/audio/sfx/`
  - [ ] 1.3 Keep files small (≤500KB each)

- [ ] Task 2: Create BattleSfxController (AC: 1, 5)
  - [ ] 2.1 Create `lib/presentation/battle/battle_sfx_controller.dart`
  - [ ] 2.2 Method `onDamageDealt(DamageResult)` — plays hit SFX based on effectiveness
  - [ ] 2.3 Method `onPlayerDamage()` — plays player damage SFX
  - [ ] 2.4 Method `onItemUsed()` — plays item use SFX
  - [ ] 2.5 All methods use `AudioService.playSfx()` which doesn't interrupt BGM

- [ ] Task 3: Wire SFX into battle flow (AC: 1)
  - [ ] 3.1 In `BattleStateNotifier._triggerHaptic()`, also trigger corresponding SFX
  - [ ] 3.2 Or create a new `_triggerFeedback()` method that combines haptic + SFX
  - [ ] 3.3 Map: normal hit → `hit_normal`, super effective → `hit_critical`, ineffective → `hit_ineffective`
  - [ ] 3.4 Player damage → `player_damage`

- [ ] Task 4: Victory/defeat jingles on result screen (AC: 2)
  - [ ] 4.1 In `BattleResultScreen`, play `victory.mp3` or `defeat.mp3` on mount
  - [ ] 4.2 Stop any BGM before playing jingle
  - [ ] 4.3 After jingle completes, remain silent or play ambient

- [ ] Task 5: Level up and evolution jingles (AC: 3, 4)
  - [ ] 5.1 In `BattleStateNotifier._persistExp()`, when `lvResult.didLevelUp`, trigger level up SFX
  - [ ] 5.2 In evolution animation widget, play `evolution.mp3` synchronized with animation start
  - [ ] 5.3 Briefly duck BGM volume during jingle, restore after

- [ ] Task 6: Provider wiring (AC: 1)
  - [ ] 6.1 Add `battleSfxControllerProvider` to `providers/audio_providers.dart`

- [ ] Task 7: Tests (AC: 1-5)
  - [ ] 7.1 Unit test: damage result maps to correct SFX file
  - [ ] 7.2 Unit test: victory/defeat plays correct jingle
  - [ ] 7.3 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No database changes in this story.

### CRITICAL — No riverpod_generator

Manual providers only.

### Dependencies on Previous Stories

- **Story 8.1** — `AudioService` for SFX playback
- **Story 8.2** — BGM system (SFX must coexist without conflicts)
- **Story 3.5** — `HapticService` — SFX triggers should align with haptic triggers
- **Story 4.3** — `EvolutionAnimation` widget for evolution jingle sync
- **Story 4.1** — Level up event for level up jingle

### Combining Haptic + Audio Feedback

Current `_triggerHaptic()` in `BattleStateNotifier` handles haptic. Consider renaming to `_triggerFeedback()` and adding SFX calls alongside haptic calls. Or keep separate and call both from `submitSet()`.

### SFX Source Recommendations

- [OpenGameArt.org](https://opengameart.org) — search "8-bit sfx" or "RPG sound effects"
- [freesound.org](https://freesound.org) — CC0 sound effects
- [Kenney.nl](https://kenney.nl) — game audio packs

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation Layer** | `BattleSfxController` in `presentation/battle/` |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition |
| **SFX + BGM** | SFX uses separate player pool — never interrupts BGM |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/battle_sfx_controller.dart
ironmon/assets/audio/sfx/hit_normal.mp3
ironmon/assets/audio/sfx/hit_critical.mp3
ironmon/assets/audio/sfx/hit_ineffective.mp3
ironmon/assets/audio/sfx/player_damage.mp3
ironmon/assets/audio/sfx/victory.mp3
ironmon/assets/audio/sfx/defeat.mp3
ironmon/assets/audio/sfx/level_up.mp3
ironmon/assets/audio/sfx/evolution.mp3
ironmon/assets/audio/sfx/item_use.mp3
ironmon/test/presentation/battle/battle_sfx_controller_test.dart
```

Files to update:

```
ironmon/lib/providers/audio_providers.dart (battleSfxControllerProvider)
ironmon/lib/providers/battle_providers.dart (_triggerHaptic → add SFX calls)
ironmon/lib/presentation/battle/battle_result_screen.dart (victory/defeat jingle)
ironmon/lib/presentation/battle/widgets/evolution_animation.dart (evolution jingle)
```

### References

- [Source: epics.md#Story 8.3] — User story, acceptance criteria
- [Source: spec.md#Section 7.1] — Audio: victory jingle, upgrade jingle, battle SFX
- [Source: 3-5-haptic-feedback-system.md] — Haptic trigger patterns to align with

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
