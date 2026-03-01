# Story 8.2: Battle BGM & Stage Transitions

Status: review

## Story

As a player,
I want different music for each battle stage,
So that the workout feels progressively more intense.

## Acceptance Criteria

1. **Given** a battle is in progress
   **When** the battle transitions between stages (Warmup → MidBoss → GymLeader)
   **Then** the BGM crossfades to the corresponding track
2. **And** Warmup uses a light/upbeat track
3. **And** MidBoss uses a mid-intensity battle track
4. **And** GymLeader uses a high-intensity boss battle track
5. **And** the home screen plays an ambient/exploration BGM
6. **And** BGM transitions do not cause audio gaps or stuttering

## Tasks / Subtasks

- [ ] Task 1: Source or create audio tracks (AC: 2, 3, 4, 5)
  - [ ] 1.1 Obtain 4 royalty-free tracks (8-bit / chiptune style):
        - `home_theme.mp3` — ambient exploration
        - `battle_warmup.mp3` — light upbeat
        - `battle_midboss.mp3` — mid-intensity
        - `battle_boss.mp3` — high-intensity boss theme
  - [ ] 1.2 Place in `assets/audio/bgm/`
  - [ ] 1.3 Ensure files are compressed (≤2MB each for mobile)

- [ ] Task 2: Create BattleBgmController (AC: 1, 6)
  - [ ] 2.1 Create `lib/presentation/battle/battle_bgm_controller.dart`
  - [ ] 2.2 Method `onPhaseChanged(BattlePhase)` — maps phase to track and triggers crossfade
  - [ ] 2.3 Phase → track mapping:
        - `Warmup` → `battle_warmup.mp3`
        - `MidBossPhase` → `battle_midboss.mp3`
        - `GymLeaderPhase` → `battle_boss.mp3`
        - `BattleResult` → stop BGM (victory/defeat jingle handled by Story 8.3)
  - [ ] 2.4 Uses `AudioService.crossfadeBgm()` for smooth transitions

- [ ] Task 3: Wire BGM into BattleScreen (AC: 1, 6)
  - [ ] 3.1 In `BattleScreen`, listen to `battleStateNotifierProvider` phase changes
  - [ ] 3.2 On phase change, call `BattleBgmController.onPhaseChanged()`
  - [ ] 3.3 Start warmup BGM when battle begins
  - [ ] 3.4 Stop BGM when leaving battle screen (dispose)

- [ ] Task 4: Home screen BGM (AC: 5)
  - [ ] 4.1 In `HomeScreen`, start `home_theme.mp3` BGM on screen mount
  - [ ] 4.2 Stop/fade when navigating to battle
  - [ ] 4.3 Resume when returning from battle

- [ ] Task 5: Provider wiring (AC: 1)
  - [ ] 5.1 Add `battleBgmControllerProvider` to `providers/audio_providers.dart`
  - [ ] 5.2 Depends on `audioServiceProvider`

- [ ] Task 6: Tests (AC: 1-6)
  - [ ] 6.1 Unit test: phase-to-track mapping is correct
  - [ ] 6.2 Unit test: crossfade triggered on phase change
  - [ ] 6.3 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No database changes in this story.

### CRITICAL — No riverpod_generator

Manual providers only.

### Dependencies on Previous Stories

- **Story 8.1** — `AudioService` for BGM playback
- **Story 2.5** — `BattlePhase` sealed class for phase detection
- **Story 2.6** — `BattleScreen` for BGM integration
- **Story 1.4** — `HomeScreen` for home BGM

### BattlePhase Sealed Class (Existing)

At `lib/domain/battle/battle_phase.dart`:

```dart
sealed class BattlePhase { ... }
class Idle extends BattlePhase { ... }
class Warmup extends BattlePhase { ... }
class MidBossPhase extends BattlePhase { ... }
class GymLeaderPhase extends BattlePhase { ... }
class BattleResult extends BattlePhase { ... }
```

Use exhaustive switch for phase → track mapping.

### Audio Source for Royalty-Free Music

Recommended sources from spec:
- [OpenGameArt.org](https://opengameart.org) — search "JRPG Battle" or "8-bit"
- [Maoudamashii (魔王魂)](https://maou.audio) — Japanese game music
- [Peritune](https://peritune.com) — RPG style

If no tracks available yet, use silent placeholder files and document where to source them.

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation Layer** | `BattleBgmController` in `presentation/battle/` |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/battle_bgm_controller.dart
ironmon/assets/audio/bgm/home_theme.mp3
ironmon/assets/audio/bgm/battle_warmup.mp3
ironmon/assets/audio/bgm/battle_midboss.mp3
ironmon/assets/audio/bgm/battle_boss.mp3
ironmon/test/presentation/battle/battle_bgm_controller_test.dart
```

Files to update:

```
ironmon/lib/providers/audio_providers.dart (battleBgmControllerProvider)
ironmon/lib/presentation/battle/battle_screen.dart (wire BGM)
ironmon/lib/presentation/home/home_screen.dart (home BGM)
```

### References

- [Source: epics.md#Story 8.2] — User story, acceptance criteria
- [Source: spec.md#Section 7.1] — Audio requirements (BGM per stage)
- [Source: architecture.md#Battle Engine] — BattlePhase transitions

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

- Created BattleBgmController with phase-to-track mapping using exhaustive switch
- Added battleBgmControllerProvider to audio_providers.dart
- Integrated BGM phase transitions in BattleScreen via ref.listen
- Converted HomeScreen to ConsumerStatefulWidget to manage home theme BGM lifecycle
- Wrote unit tests covering all phase mappings (6/6 pass)
- No actual audio files added yet; placeholders documented in assets/audio/bgm/

### File List

**Created:**
- lib/presentation/battle/battle_bgm_controller.dart
- test/presentation/battle/battle_bgm_controller_test.dart

**Updated:**
- lib/providers/audio_providers.dart (added battleBgmControllerProvider)
- lib/presentation/battle/battle_screen.dart (added BGM phase listener)
- lib/presentation/home/home_screen.dart (converted to ConsumerStatefulWidget for BGM)
