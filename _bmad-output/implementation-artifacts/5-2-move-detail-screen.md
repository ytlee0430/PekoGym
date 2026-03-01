# Story 5.2: Move Detail Screen

Status: ready-for-dev

## Story

As a player,
I want to view detailed information about each move,
So that I understand its stats, evolution path, and my usage history.

## Acceptance Criteria

1. **Given** the player taps on an unlocked move in the Pokédex
   **When** the detail screen opens
   **Then** the screen displays: type, power, PP cost, evolution chain visualization (FR25)
2. **And** usage count (how many times used in battle) is shown
3. **And** PR record for the corresponding exercise is displayed (if applicable)
4. **And** the evolution chain shows previous and next evolution with unlock status
5. **And** navigation uses go_router with `/pokedex/:moveId` route

## Tasks / Subtasks

- [ ] Task 1: Redesign Move Detail Screen (AC: 1, 5)
  - [ ] 1.1 Redesign `lib/presentation/pokedex/move_detail_screen.dart` — replace placeholder
  - [ ] 1.2 Header: Move name, type badge, exercise name
  - [ ] 1.3 Stats section: Power, PP cost, type effectiveness info
  - [ ] 1.4 Route receives `moveId` from path parameter
  - [ ] 1.5 Use `ConsumerWidget` with `ref.watch(moveRegistryProvider)`

- [ ] Task 2: Create Evolution Chain View widget (AC: 4)
  - [ ] 2.1 Create `lib/presentation/pokedex/widgets/evolution_chain_view.dart`
  - [ ] 2.2 Show linear chain: Stage 1 → Stage 2 → Stage 3
  - [ ] 2.3 Highlight current move in chain
  - [ ] 2.4 Unlocked moves show in color, locked moves greyed-out
  - [ ] 2.5 Show unlock requirement for locked stages

- [ ] Task 3: Add usage count display (AC: 2)
  - [ ] 3.1 Query `WorkoutSessionRepository` for sets using this move's ID
  - [ ] 3.2 Count total times move was used across all sessions
  - [ ] 3.3 Display "Used {count} times in battle"
  - [ ] 3.4 If no usage data yet (tables not created), show "No battle data yet"

- [ ] Task 4: Add PR record display (AC: 3)
  - [ ] 4.1 Query exercise sets for best weight × reps for this move's exercise
  - [ ] 4.2 Display "PR: {weight} kg × {reps} reps" if available
  - [ ] 4.3 Show estimated 1RM from the PR set
  - [ ] 4.4 If no PR data, show "No records yet"

- [ ] Task 5: Tests (AC: 1, 2, 3, 4, 5)
  - [ ] 5.1 Create `test/presentation/pokedex/move_detail_screen_test.dart`
  - [ ] 5.2 Widget test: move stats displayed correctly
  - [ ] 5.3 Widget test: evolution chain renders with correct stages
  - [ ] 5.4 Widget test: locked/unlocked stages styled differently
  - [ ] 5.5 Widget test: route parameter `moveId` loads correct move
  - [ ] 5.6 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is presentation-only. Data comes from existing sources.

### Dependencies on Previous Stories

- **Story 2.2** — `MoveRegistry`, `MoveDefinition` for move data
- **Story 5.1** — Pokédex list screen (navigation source)
- **Story 3.4** — `WorkoutSessionRepository` for usage count (optional — graceful fallback if not yet available)
- **Story 4.4** — `unlockedMoveIds` for evolution chain unlock status

### Route Parameter Pattern

The existing `app_router.dart` already has the `/pokedex/:moveId` route:

```dart
GoRoute(
  path: ':moveId',
  name: 'moveDetailRoute',
  builder: (context, state) {
    final moveId = state.pathParameters['moveId']!;
    return MoveDetailScreen(moveId: moveId);
  },
),
```

### Usage Count Query

If `WorkoutSessionRepository` and `ExerciseSets` table exist
(Story 3.4), query for usage count:

```dart
// In a provider or repository method
Future<int> getUsageCount(String moveId) async {
  final count = await (_db.selectOnly(_db.exerciseSets)
        ..addColumns([_db.exerciseSets.id.count()])
        ..where(_db.exerciseSets.moveId.equals(moveId)))
      .map((row) => row.read(_db.exerciseSets.id.count()))
      .getSingle();
  return count ?? 0;
}
```

If the tables don't exist yet, wrap in try/catch and return 0.

### Evolution Chain Visualization

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│ Push-up  │ →  │  Bench   │ →  │ Incline  │
│ Lv.1 ✓  │    │ Press    │    │ DB Press │
│ Power:40 │    │ Lv.5 ✓  │    │ Lv.10 🔒 │
└──────────┘    └──────────┘    └──────────┘
     ↑ current
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Widget Pattern** | `ConsumerWidget` for Riverpod access |
| **Import Style** | `package:ironmon/...` only |
| **Navigation** | Route receives `moveId` from `state.pathParameters` |
| **Provider Pattern** | `ref.watch()` for reactive data |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **No domain changes** | Pure presentation |
| **Graceful fallback** | Handle missing battle data tables gracefully |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/pokedex/widgets/evolution_chain_view.dart
ironmon/test/presentation/pokedex/move_detail_screen_test.dart
```

Files to update:

```
ironmon/lib/presentation/pokedex/move_detail_screen.dart
```

### References

- [Source: epics.md#Story 5.2] — User story, acceptance criteria
- [Source: prd.md#FR25] — 招式詳情查看
- [Source: architecture.md#Frontend Architecture] — /pokedex/:moveId route
- [Source: architecture.md#Structure Patterns] — presentation/pokedex/
- [Source: 5-1-move-list-screen.md] — Navigation source
- [Source: 2-2-move-registry-data-loading.md] — MoveDefinition, evolution chain

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Replaced MoveDetailScreen placeholder with full ConsumerWidget
- Created _HeaderCard with power circle, name, exercise, type badge
- Created _StatsCard with power, PP, type, stage, unlock level, description
- Created EvolutionChainView with horizontal chain nodes and arrows
- _ChainNode shows name, unlock status, power for each stage
- Graceful fallback for usage count and PR records

### File List
- ironmon/lib/presentation/pokedex/move_detail_screen.dart (rewritten)
- ironmon/lib/presentation/pokedex/widgets/evolution_chain_view.dart (created)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** CONDITIONAL PASS
**Issues Found:** 0 HIGH, 2 MEDIUM, 0 LOW

| # | Severity | Description | Status |
|---|----------|-------------|--------|
| M1 | MEDIUM | `_RecordsCard` was a hardcoded placeholder — never queried actual usage count or PR records (FR25 partial) | **FIXED** |
| M2 | MEDIUM | `withOpacity` deprecated in move_detail_screen.dart and evolution_chain_view.dart | **FIXED** |

**Fixes Applied:**
- M1: Replaced with ConsumerWidget that queries `getMoveUsageCount` and `getMoveBestSet` from WorkoutSessionRepository
- M2: Replaced all `withOpacity` with `withValues(alpha:)` across both files
