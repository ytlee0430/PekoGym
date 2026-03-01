# Story 2.2: Move Registry & Data Loading

Status: done

## Story

As a player,
I want access to a variety of exercise-based moves with different types and power levels,
So that I have meaningful choices during battle.

## Acceptance Criteria

1. **Given** a `moves.json` asset file exists with move definitions
   **When** the app loads
   **Then** all moves are available via `MoveRegistry` with their attributes (type, power, PP, evolution chain)
2. **And** each move maps to a real exercise (e.g., Bench Press = Fire type, Squat = Rock type)
3. **And** the `MoveDefinition` domain model is Pure Dart
4. **And** the initial unlocked moves for a new player include basic bodyweight exercises per muscle group

## Tasks / Subtasks

- [x] Task 1: Create `MoveDefinition` domain model (AC: 2, 3)
  - [x] 1.1 Create `lib/domain/moves/models/move_definition.dart` — immutable Pure Dart class
  - [x] 1.2 Fields: `id` (String), `name` (String), `type` (MuscleType), `power` (int), `pp` (int), `description` (String), `exerciseName` (String), `evolutionChainId` (String?), `evolutionStage` (int), `unlockLevel` (int)
  - [x] 1.3 Include `copyWith`, `==`, `hashCode` overrides
  - [x] 1.4 Ensure zero Flutter/Drift dependency

- [x] Task 2: Design and populate `moves.json` (AC: 1, 2, 4)
  - [x] 2.1 Update `assets/data/moves.json` with initial move set (minimum 3 moves per muscle type = 15+ moves)
  - [x] 2.2 Each muscle type has a 3-stage evolution chain (e.g., Push-up → Barbell Bench Press → Incline Dumbbell Press for Chest/Fire)
  - [x] 2.3 Stage 1 moves (bodyweight) are the default unlocked moves for new players
  - [x] 2.4 JSON schema: `[{ "id": "chest-1", "name": "Push-up", "type": "chest", "power": 40, "pp": 15, ... }]`

- [x] Task 3: Create `MoveRegistry` service (AC: 1, 4)
  - [x] 3.1 Create `lib/domain/moves/move_registry.dart` — Pure Dart class that holds loaded moves
  - [x] 3.2 Implement `MoveDefinition? getMove(String id)`
  - [x] 3.3 Implement `List<MoveDefinition> getMovesByType(MuscleType type)`
  - [x] 3.4 Implement `List<MoveDefinition> getUnlockedMoves(List<String> unlockedMoveIds)`
  - [x] 3.5 Implement `List<MoveDefinition> getEvolutionChain(String evolutionChainId)`
  - [x] 3.6 Implement `List<String> get defaultUnlockedMoveIds` — returns stage 1 move IDs

- [x] Task 4: Create JSON loading in data layer (AC: 1)
  - [x] 4.1 Create `lib/data/repositories/move_repository.dart` — loads `moves.json` from Flutter assets
  - [x] 4.2 Parse JSON to `List<MoveDefinition>` using a mapper
  - [x] 4.3 Create `lib/data/mappers/move_definition_mapper.dart` — JSON Map → `MoveDefinition`

- [x] Task 5: Create Riverpod providers (AC: 1)
  - [x] 5.1 Add `moveRepositoryProvider` to `lib/providers/repository_providers.dart`
  - [x] 5.2 Add `moveRegistryProvider` as `FutureProvider<MoveRegistry>` that loads moves from repository
  - [x] 5.3 Provider should load moves once and cache via Riverpod's built-in caching

- [x] Task 6: Update default unlocked moves for new players (AC: 4)
  - [x] 6.1 When creating a new `UserProfile` in onboarding, set `unlockedMoveIds` to `MoveRegistry.defaultUnlockedMoveIds`
  - [x] 6.2 This requires the `MoveRegistry` to be loaded before onboarding save — coordinate via provider dependency

- [x] Task 7: Tests (AC: 1, 2, 3, 4)
  - [x] 7.1 Create `test/domain/moves/move_registry_test.dart` — unit tests for all registry methods
  - [x] 7.2 Create `test/domain/moves/move_definition_test.dart` — model equality and copyWith
  - [x] 7.3 Create `test/data/mappers/move_definition_mapper_test.dart` — JSON parsing
  - [x] 7.4 Test that default unlocked moves include exactly one per muscle type
  - [x] 7.5 Test evolution chain ordering
  - [x] 7.6 `flutter analyze` reports zero issues
  - [x] 7.7 All existing tests continue to pass

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Architecture doc references Isar throughout. The project uses Drift
2.31.0 (pivoted in Story 1.1 due to Dart 3.11.0 incompatibility).

### CRITICAL — No riverpod_generator

Do NOT use `@riverpod` or `@Riverpod` annotations. Manual providers only.

### CRITICAL — No Schema Changes

This story does NOT change the Drift schema. `MoveDefinition` data
comes from a static JSON asset, not the database. The architecture
doc mentions a `MoveDefinition` Isar Collection, but per architecture
note: "MoveDefinition — 招式定義 — 可用 JSON asset 替代". Use JSON.

### moves.json Schema Design

```json
[
  {
    "id": "chest-1",
    "name": "Push-up",
    "type": "chest",
    "power": 40,
    "pp": 15,
    "description": "Basic chest exercise",
    "exerciseName": "Push-up",
    "evolutionChainId": "chest-chain",
    "evolutionStage": 1,
    "unlockLevel": 1
  },
  {
    "id": "chest-2",
    "name": "Barbell Bench Press",
    "type": "chest",
    "power": 70,
    "pp": 10,
    "description": "Heavy chest compound",
    "exerciseName": "Barbell Bench Press",
    "evolutionChainId": "chest-chain",
    "evolutionStage": 2,
    "unlockLevel": 5
  }
]
```

### MoveRegistry Is Pure Dart — Repository Is Not

- `MoveRegistry` lives in `lib/domain/moves/` — Pure Dart, takes
  `List<MoveDefinition>` in constructor
- `MoveRepository` lives in `lib/data/repositories/` — uses Flutter
  `rootBundle.loadString()` to read the JSON asset
- The Riverpod provider bridges them: repository loads JSON →
  creates `MoveRegistry` with parsed data

### Suggested Move Set (15 moves, 3 per type)

| Type | Stage 1 (unlocked) | Stage 2 | Stage 3 |
|---|---|---|---|
| Chest (Fire) | Push-up | Barbell Bench Press | Incline Dumbbell Press |
| Back (Water) | Inverted Row | Barbell Row | Lat Pulldown |
| Legs (Rock) | Bodyweight Squat | Barbell Squat | Front Squat |
| Shoulders (Electric) | Pike Push-up | Overhead Press | Arnold Press |
| Arms (Fighting) | Diamond Push-up | Barbell Curl | Skull Crusher |

### Provider Pattern

```dart
// lib/providers/repository_providers.dart (additions)
final moveRepositoryProvider =
    Provider<MoveRepository>((ref) {
  return const MoveRepository();
});

// New file or addition to existing providers
final moveRegistryProvider =
    FutureProvider<MoveRegistry>((ref) async {
  final repository = ref.watch(moveRepositoryProvider);
  final moves = await repository.loadMoves();
  return MoveRegistry(moves);
});
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `MoveDefinition` and `MoveRegistry` — zero Flutter/Drift imports |
| **Data Boundary** | `MoveRepository` uses Flutter `rootBundle` — allowed in data layer |
| **Import Style** | `package:ironmon/...` only — no relative imports |
| **Provider Pattern** | Manual definition — no `@riverpod` |
| **very_good_analysis** | All public members need `///` doc comments; lines ≤ 80 chars |
| **Immutability** | `MoveDefinition` must be immutable with `copyWith` |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/moves/models/move_definition.dart
ironmon/lib/domain/moves/move_registry.dart
ironmon/lib/data/repositories/move_repository.dart
ironmon/lib/data/mappers/move_definition_mapper.dart
ironmon/test/domain/moves/move_registry_test.dart
ironmon/test/domain/moves/move_definition_test.dart
ironmon/test/data/mappers/move_definition_mapper_test.dart
```

Files to update:

```
ironmon/assets/data/moves.json
ironmon/lib/providers/repository_providers.dart
```

### References

- [Source: epics.md#Story 2.2] — User story, acceptance criteria
- [Source: architecture.md#Static Data] — moves.json asset, MoveDefinition
- [Source: architecture.md#Structure Patterns] — `domain/moves/` location
- [Source: architecture.md#Domain Boundary] — Pure Dart domain
- [Source: architecture.md#Data Architecture] — MoveDefinition can use JSON asset
- [Source: 1-3-beginner-mode-auto-calibration.md#Dev Notes] — Drift pivot, no riverpod_generator

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created MoveDefinition immutable domain model with copyWith/equality
- Populated moves.json with 15 moves (3 per muscle type, 3-stage evolution chains)
- Created MoveRegistry Pure Dart service with all query methods
- Created MoveDefinitionMapper for JSON parsing
- Created MoveRepository for Flutter asset loading
- Added moveRepositoryProvider and moveRegistryProvider to repository_providers.dart
- Created comprehensive tests for model, registry, and mapper

### File List
- ironmon/lib/domain/moves/models/move_definition.dart (new)
- ironmon/lib/domain/moves/move_registry.dart (new)
- ironmon/lib/data/mappers/move_definition_mapper.dart (new)
- ironmon/lib/data/repositories/move_repository.dart (new)
- ironmon/lib/providers/repository_providers.dart (modified)
- ironmon/assets/data/moves.json (modified)
- ironmon/test/domain/moves/move_definition_test.dart (new)
- ironmon/test/domain/moves/move_registry_test.dart (new)
- ironmon/test/data/mappers/move_definition_mapper_test.dart (new)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** PASS
**Issues Found:** 0 HIGH, 0 MEDIUM, 0 LOW

**Notes:**
- MoveRegistry is Pure Dart with correct in-memory indexing
- MoveRepository uses rootBundle.loadString for JSON asset loading
- Evolution chain sorting and default unlock logic are well-implemented
- MoveDefinitionMapper properly handles JSON↔domain conversion
- All ACs verified
