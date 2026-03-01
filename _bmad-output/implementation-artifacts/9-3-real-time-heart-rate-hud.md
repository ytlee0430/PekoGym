# Story 9.3: Real-time Heart Rate HUD

Status: ready-for-dev

## Story

As a player,
I want to see my heart rate and current zone on the battle screen,
So that I can adjust my intensity in real-time.

## Acceptance Criteria

1. **Given** a battle is in progress and wearable is connected
   **When** the battle screen renders
   **Then** a heart rate overlay displays in the top-right corner
2. **And** the display shows current BPM and zone color (blue/green/orange/red)
3. **And** the HUD updates in real-time (<1s delay)
4. **And** the HUD is hidden when no wearable is connected
5. **And** the HUD uses RepaintBoundary to avoid unnecessary rebuilds

## Tasks / Subtasks

- [ ] Task 1: Create HeartRateHud widget (AC: 1, 2, 5)
  - [ ] 1.1 Create `lib/presentation/battle/widgets/heart_rate_hud.dart`
  - [ ] 1.2 Display: heart icon + BPM number + zone color indicator
  - [ ] 1.3 Zone colors: blue (zone 1-2), green (zone 3), orange (zone 4), red (zone 5)
  - [ ] 1.4 Pulsing heart animation synced to approximate BPM
  - [ ] 1.5 Wrap in `RepaintBoundary` to isolate repaints

- [ ] Task 2: Stream integration (AC: 3)
  - [ ] 2.1 Use `heartRateStreamProvider` from Story 9.1
  - [ ] 2.2 `ConsumerWidget` watches stream and updates BPM display
  - [ ] 2.3 Debounce updates to max 1 per second to avoid excessive rebuilds
  - [ ] 2.4 Show "—" when no data received yet

- [ ] Task 3: Conditional visibility (AC: 4)
  - [ ] 3.1 Read `hasWearableProvider` — if false, render `SizedBox.shrink()`
  - [ ] 3.2 If wearable connected but stream errors, show "❤️ --" greyed out

- [ ] Task 4: Position on battle screen (AC: 1)
  - [ ] 4.1 Place in top-right corner of battle screen using `Positioned` in `Stack`
  - [ ] 4.2 Semi-transparent background pill shape
  - [ ] 4.3 Ensure it doesn't overlap boss HP bar or damage display

- [ ] Task 5: Tests (AC: 1-5)
  - [ ] 5.1 Widget test: HUD shows BPM when stream emits
  - [ ] 5.2 Widget test: HUD hidden when no wearable
  - [ ] 5.3 Widget test: correct zone color for different HR values
  - [ ] 5.4 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No database changes in this story.

### CRITICAL — No riverpod_generator

Manual providers only.

### Dependencies on Previous Stories

- **Story 9.1** — `HealthService`, `heartRateStreamProvider`, `hasWearableProvider`
- **Story 9.2** — `HeartRateZone` model for zone calculation and colors
- **Story 2.6** — `BattleScreen` for HUD placement

### Heart Animation

Simple pulsing animation using `AnimationController`:

```dart
// Pulse period ≈ 60000 / bpm milliseconds
// At 120 BPM → pulse every 500ms
_controller = AnimationController(
  vsync: this,
  duration: Duration(milliseconds: 60000 ~/ bpm),
)..repeat(reverse: true);
```

### Zone Color Mapping

```dart
Color zoneColor(HeartRateZone zone) => switch (zone) {
  HeartRateZone.zone1 => Colors.blue,
  HeartRateZone.zone2 => Colors.blue,
  HeartRateZone.zone3 => Colors.green,
  HeartRateZone.zone4 => Colors.orange,
  HeartRateZone.zone5 => Colors.red,
};
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Widget Pattern** | `ConsumerWidget` with `RepaintBoundary` |
| **Import Style** | `package:ironmon/...` only |
| **Performance** | Debounce stream, RepaintBoundary isolation |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/widgets/heart_rate_hud.dart
ironmon/test/presentation/battle/widgets/heart_rate_hud_test.dart
```

Files to update:

```
ironmon/lib/presentation/battle/battle_screen.dart (add HUD to Stack)
```

### References

- [Source: epics.md#Story 9.3] — User story, acceptance criteria
- [Source: spec.md#Section 6.3] — Live heart rate overlay, zone colors
- [Source: architecture.md#Performance Optimization] — RepaintBoundary, select()

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
