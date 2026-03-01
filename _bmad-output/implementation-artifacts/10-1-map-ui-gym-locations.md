# Story 10.1: Map UI & Gym Locations

Status: ready-for-dev

## Story

As a player,
I want to see a game world map on the home screen with multiple gym locations,
So that choosing a workout feels like exploring a game world.

## Acceptance Criteria

1. **Given** the player is on the home screen
   **When** the map loads
   **Then** a 2D pixel-art map displays with gym icons for each muscle group/type
2. **And** each gym shows its type badge (Fire/Water/Rock/Electric/Fighting)
3. **And** completed gyms show a badge/checkmark indicator
4. **And** the player's character is visible on the map
5. **And** the map scrolls/pans smoothly if larger than screen

## Tasks / Subtasks

- [ ] Task 1: Create map asset (AC: 1)
  - [ ] 1.1 Design or source a pixel-art world map image (tileable or single large image)
  - [ ] 1.2 Place in `assets/images/ui/world_map.png`
  - [ ] 1.3 Define gym positions as coordinate data (JSON or hardcoded)

- [ ] Task 2: Create MapScreen widget (AC: 1, 5)
  - [ ] 2.1 Create `lib/presentation/home/widgets/world_map.dart`
  - [ ] 2.2 Use `InteractiveViewer` for pan/zoom support
  - [ ] 2.3 Render map background image
  - [ ] 2.4 Overlay gym icons at predefined positions using `Stack` + `Positioned`

- [ ] Task 3: Gym icons with type badges (AC: 2)
  - [ ] 3.1 Create `lib/presentation/home/widgets/gym_map_icon.dart`
  - [ ] 3.2 Each icon shows: gym building sprite + type badge (Fire/Water/Rock/Electric/Fighting)
  - [ ] 3.3 Use existing `TypeBadge` widget from `presentation/shared/type_badge.dart`
  - [ ] 3.4 Gym name label below icon

- [ ] Task 4: Completion indicators (AC: 3)
  - [ ] 4.1 Query today's `WorkoutSession` records per muscle type
  - [ ] 4.2 If a gym's muscle type was trained today, show ✓ checkmark badge
  - [ ] 4.3 Animate checkmark appearance (scale in)

- [ ] Task 5: Player character on map (AC: 4)
  - [ ] 5.1 Add a small player sprite at the center or last-visited gym position
  - [ ] 5.2 Idle bounce animation (subtle up/down movement)
  - [ ] 5.3 Source or create a simple pixel character sprite

- [ ] Task 6: Integrate into HomeScreen (AC: 1)
  - [ ] 6.1 Replace or augment current HomeScreen layout with map view
  - [ ] 6.2 Keep player stats (level, EXP bar, 5RM summary) as overlay or header above map
  - [ ] 6.3 Daily mission card overlays on map or sits below it

- [ ] Task 7: Tests (AC: 1-5)
  - [ ] 7.1 Widget test: map renders with 5 gym icons
  - [ ] 7.2 Widget test: type badges display correctly
  - [ ] 7.3 Widget test: completed gym shows checkmark
  - [ ] 7.4 Widget test: InteractiveViewer allows panning
  - [ ] 7.5 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No database changes. Completion data queried from existing `WorkoutSession` records.

### CRITICAL — No riverpod_generator

Manual providers only.

### Gym Position Data

Hardcode 5 gym positions for MVP. Each gym maps to one `MuscleType`:

```dart
const gymPositions = [
  GymPosition(type: MuscleType.chest, x: 0.2, y: 0.3, name: 'Fire Gym'),
  GymPosition(type: MuscleType.back, x: 0.7, y: 0.2, name: 'Water Gym'),
  GymPosition(type: MuscleType.legs, x: 0.5, y: 0.7, name: 'Rock Gym'),
  GymPosition(type: MuscleType.shoulders, x: 0.8, y: 0.6, name: 'Electric Gym'),
  GymPosition(type: MuscleType.arms, x: 0.3, y: 0.8, name: 'Fighting Gym'),
];
```

Positions are relative (0.0-1.0) to map image dimensions.

### InteractiveViewer for Map Scrolling

```dart
InteractiveViewer(
  boundaryMargin: const EdgeInsets.all(20),
  minScale: 0.5,
  maxScale: 2.0,
  child: Stack(
    children: [
      Image.asset('assets/images/ui/world_map.png'),
      ...gymIcons,
      playerSprite,
    ],
  ),
)
```

### Dependencies on Previous Stories

- **Story 1.4** — `HomeScreen` being replaced/augmented
- **Story 3.4** — `WorkoutSessionRepository` for completion check
- **Story 2.1** — `MuscleType` enum and type badges

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation** | All widgets in `presentation/home/widgets/` |
| **Import Style** | `package:ironmon/...` only |
| **Widget Pattern** | `ConsumerWidget` for gym completion data |
| **Performance** | `RepaintBoundary` on animated elements |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/home/widgets/world_map.dart
ironmon/lib/presentation/home/widgets/gym_map_icon.dart
ironmon/assets/images/ui/world_map.png (placeholder)
ironmon/test/presentation/home/widgets/world_map_test.dart
```

Files to update:

```
ironmon/lib/presentation/home/home_screen.dart (integrate map)
```

### References

- [Source: epics.md#Story 10.1] — User story, acceptance criteria
- [Source: spec.md#Section 6.2] — Home as map with gym locations
- [Source: architecture.md#Frontend Architecture] — presentation/home/

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
