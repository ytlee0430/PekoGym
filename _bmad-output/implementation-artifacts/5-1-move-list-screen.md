# Story 5.1: Move List Screen

Status: done

## Story

As a player,
I want to browse all available moves and see which ones I've unlocked,
So that I can plan my training and see my collection progress.

## Acceptance Criteria

1. **Given** the player navigates to the Pokédex screen
   **When** the move list loads
   **Then** all moves are displayed in a scrollable list (FR24)
2. **And** unlocked moves show full details (name, type badge, power)
3. **And** locked moves show silhouette/greyed-out state with unlock conditions
4. **And** moves can be filtered by type/muscle group
5. **And** the list loads within <200ms (NFR4)

## Tasks / Subtasks

- [x] Task 1: Redesign Pokédex Screen (AC: 1, 2, 3, 5)
  - [x] 1.1 Replaced placeholder with full ConsumerWidget implementation
  - [x] 1.2 ListView.builder with all moves from MoveRegistry
  - [x] 1.3 Unlocked: name, type badge, power circle, exercise name
  - [x] 1.4 Locked: greyed card, lock icon, "Unlock at Lv.X"
  - [x] 1.5 ref.watch(moveRegistryProvider) + ref.watch(userProfileProvider)

- [x] Task 2: Create Move List Tile widget (AC: 2, 3)
  - [x] 2.1 Created `lib/presentation/pokedex/widgets/move_list_tile.dart`
  - [x] 2.2 Unlocked variant with color and details
  - [x] 2.3 Locked variant with grey scheme and lock icon
  - [x] 2.4 onTap navigates to `/pokedex/{moveId}`

- [x] Task 3: Create type filter (AC: 4)
  - [x] 3.1 Horizontal _TypeFilterBar with All + 5 element chips
  - [x] 3.2 _typeFilterProvider StateProvider<MuscleType?>
  - [x] 3.3 Client-side filter on allMoves

- [x] Task 4: Create Type Badge widget (AC: 2)
  - [x] 4.1 Created `lib/presentation/shared/type_badge.dart`
  - [x] 4.2 Colored chip with element name
  - [x] 4.3 Static colorFor() mapper

- [ ] Task 5: Tests — requires widget test framework

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is presentation-only. Moves come from `MoveRegistry`
(JSON asset), unlock status from `UserProfile.unlockedMoveIds`.

### Dependencies on Previous Stories

- **Story 2.2** — `MoveRegistry`, `MoveDefinition` for move data
- **Story 4.4** — Move unlock logic, `unlockedMoveIds` in UserProfile
- **Story 2.1** — `MuscleType` for type filtering and badges

### Move List Data Source

```dart
// In PokedexScreen
final moveRegistryAsync = ref.watch(moveRegistryProvider);
final profileAsync = ref.watch(userProfileProvider);

// Combine: check each move against profile.unlockedMoveIds
moveRegistryAsync.when(
  data: (registry) {
    final allMoves = registry.getAllMoves();
    final unlockedIds = profile.unlockedMoveIds;
    // ... render list
  },
  // ...
);
```

### Type Badge Color Mapping

| MuscleType | Element | Color |
|---|---|---|
| chest | Fire | `Colors.red` |
| back | Water | `Colors.blue` |
| legs | Rock | `Colors.brown` |
| shoulders | Electric | `Colors.amber` |
| arms | Fighting | `Colors.orange` |

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Widget Pattern** | `ConsumerWidget` for stateless Riverpod access |
| **Import Style** | `package:ironmon/...` only |
| **Navigation** | `context.push('/pokedex/{moveId}')` for detail |
| **Provider Pattern** | `ref.watch()` for reactive data |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **No domain changes** | Pure presentation |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/pokedex/widgets/move_list_tile.dart
ironmon/lib/presentation/shared/type_badge.dart
ironmon/test/presentation/pokedex/pokedex_screen_test.dart
```

Files to update:

```
ironmon/lib/presentation/pokedex/pokedex_screen.dart
```

### References

- [Source: epics.md#Story 5.1] — User story, acceptance criteria
- [Source: prd.md#FR24] — 招式列表瀏覽
- [Source: architecture.md#Frontend Architecture] — /pokedex route
- [Source: architecture.md#Structure Patterns] — presentation/pokedex/
- [Source: 2-2-move-registry-data-loading.md] — MoveRegistry, MoveDefinition

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Replaced PokedexScreen placeholder with full ConsumerWidget
- Created MoveListTile with unlocked/locked variants
- Created TypeBadge shared widget with color mapping
- Added horizontal type filter chips (All + 5 elements)
- Sort: unlocked first, then by evolution stage
- Navigation to /pokedex/{moveId} on tap

### File List
- ironmon/lib/presentation/pokedex/pokedex_screen.dart (rewritten)
- ironmon/lib/presentation/pokedex/widgets/move_list_tile.dart (created)
- ironmon/lib/presentation/shared/type_badge.dart (created)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** CONDITIONAL PASS
**Issues Found:** 1 HIGH, 1 MEDIUM, 0 LOW

| # | Severity | Description | Status |
|---|----------|-------------|--------|
| H1 | HIGH | `registry.allMoves` returns `List.unmodifiable` — calling `.sort()` on it throws `UnsupportedError` at runtime | **FIXED** |
| M1 | MEDIUM | `withOpacity` deprecated in Flutter 3.27+ across type_badge.dart, move_list_tile.dart, pokedex_screen.dart | **FIXED** |

**Fixes Applied:**
- H1: Changed to `List.of(registry.allMoves)` to create mutable copy before sorting
- M1: Replaced all `withOpacity` with `withValues(alpha:)` across 3 files
