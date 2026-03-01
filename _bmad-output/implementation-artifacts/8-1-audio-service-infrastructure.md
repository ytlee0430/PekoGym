# Story 8.1: Audio Service Infrastructure

Status: ready-for-dev

## Story

As a developer,
I want a centralized audio service that manages BGM and SFX playback,
So that all screens can play audio consistently.

## Acceptance Criteria

1. **Given** the app initializes
   **When** the AudioService is created
   **Then** it supports BGM playback (loop, fade in/out, crossfade)
2. **And** it supports SFX playback (one-shot, overlapping)
3. **And** volume can be adjusted independently for BGM and SFX
4. **And** audio can be globally muted via settings
5. **And** audio assets are loaded from the assets/audio/ directory
6. **And** the service is provided via Riverpod

## Tasks / Subtasks

- [ ] Task 1: Add audioplayers dependency (AC: 1, 2)
  - [ ] 1.1 Add `audioplayers: ^6.1.0` to `pubspec.yaml` dependencies
  - [ ] 1.2 Run `flutter pub get`

- [ ] Task 2: Create AudioService (AC: 1, 2, 3, 4, 5)
  - [ ] 2.1 Create `lib/presentation/shared/audio_service.dart`
  - [ ] 2.2 BGM player: single `AudioPlayer` instance for background music
  - [ ] 2.3 SFX player pool: 3-4 `AudioPlayer` instances for overlapping SFX
  - [ ] 2.4 Method `playBgm(String assetPath, {bool loop = true})` — plays BGM with loop
  - [ ] 2.5 Method `stopBgm({Duration fadeOut})` — stops with optional fade out
  - [ ] 2.6 Method `crossfadeBgm(String newAssetPath, {Duration duration})` — crossfade to new track
  - [ ] 2.7 Method `playSfx(String assetPath)` — one-shot SFX, picks available player from pool
  - [ ] 2.8 Properties: `bgmVolume`, `sfxVolume` (0.0 - 1.0), `isMuted`
  - [ ] 2.9 Method `setMuted(bool)` — globally mute/unmute all audio
  - [ ] 2.10 Method `dispose()` — release all players

- [ ] Task 3: Create AudioSettings persistence (AC: 3, 4)
  - [ ] 3.1 Add `bgmVolume`, `sfxVolume`, `isMuted` columns to `UserProfiles` Drift table
  - [ ] 3.2 Or use `SharedPreferences` for lightweight audio settings (preferred — no schema migration)
  - [ ] 3.3 Load settings on init, save on change

- [ ] Task 4: Provider wiring (AC: 6)
  - [ ] 4.1 Create `lib/providers/audio_providers.dart`
  - [ ] 4.2 `audioServiceProvider` — singleton `AudioService`
  - [ ] 4.3 `bgmVolumeProvider` / `sfxVolumeProvider` / `isMutedProvider` — state providers

- [ ] Task 5: Add placeholder audio assets (AC: 5)
  - [ ] 5.1 Add at least one placeholder `.mp3` or `.ogg` file to `assets/audio/bgm/`
  - [ ] 5.2 Add at least one placeholder `.mp3` or `.ogg` file to `assets/audio/sfx/`
  - [ ] 5.3 Verify assets load correctly via `AudioPlayer.setSource(AssetSource(...))`

- [ ] Task 6: Tests (AC: 1-6)
  - [ ] 6.1 Unit test: AudioService initializes without errors
  - [ ] 6.2 Unit test: mute/unmute toggles correctly
  - [ ] 6.3 Unit test: volume settings persist and restore
  - [ ] 6.4 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

For audio settings, prefer `SharedPreferences` over Drift columns to avoid unnecessary schema migration. Audio settings are presentation-layer concern.

### CRITICAL — No riverpod_generator

Manual providers only.

### AudioService Is Presentation Layer

`AudioService` uses Flutter/platform APIs (`audioplayers` package), so it belongs in `lib/presentation/shared/` — same pattern as `HapticService`.

### audioplayers Package

Use `audioplayers: ^6.1.0` (latest stable). Key APIs:

```dart
import 'package:audioplayers/audioplayers.dart';

final bgmPlayer = AudioPlayer();
await bgmPlayer.play(AssetSource('audio/bgm/battle.mp3'));
await bgmPlayer.setReleaseMode(ReleaseMode.loop);
await bgmPlayer.setVolume(0.7);
```

### Crossfade Implementation

```dart
Future<void> crossfadeBgm(String newPath, {
  Duration duration = const Duration(milliseconds: 500),
}) async {
  // Fade out current
  // Start new player at volume 0
  // Fade in new player over duration
  // Swap references
}
```

### Asset Directory Structure (Already Registered)

`pubspec.yaml` already has:
```yaml
assets:
  - assets/audio/sfx/
  - assets/audio/bgm/
```

### Dependencies on Previous Stories

- None — this is infrastructure. Can be built independently.

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation Layer** | `AudioService` in `presentation/shared/` |
| **Import Style** | `package:ironmon/...` only |
| **Provider Pattern** | Manual definition in `providers/audio_providers.dart` |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/shared/audio_service.dart
ironmon/lib/providers/audio_providers.dart
ironmon/test/presentation/shared/audio_service_test.dart
ironmon/assets/audio/bgm/.gitkeep (or placeholder file)
ironmon/assets/audio/sfx/.gitkeep (or placeholder file)
```

Files to update:

```
ironmon/pubspec.yaml (add audioplayers dependency)
```

### References

- [Source: epics.md#Story 8.1] — User story, acceptance criteria
- [Source: spec.md#Section 7.1] — Audio requirements (8-bit, JRPG)
- [Source: architecture.md#Project Structure] — assets/audio/ directory

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
