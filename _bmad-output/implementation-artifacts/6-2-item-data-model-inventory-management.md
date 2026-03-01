# Story 6.2: Item Data Model & Inventory Management

Status: ready-for-dev

## Story

As a player,
I want to own and manage an inventory of items,
So that I can use them strategically during or between battles.

## Acceptance Criteria

1. **Given** the item system defines three core items: Potion, Ether, Rare Candy
   **When** the player acquires items (battle rewards or shop purchase)
   **Then** items are stored in the player's inventory within UserProfile
2. **And** inventory counts are persisted to Drift database
3. **And** the Item domain model is Pure Dart with no Flutter dependency
4. **And** an ItemRepository handles CRUD operations through the data layer

## Tasks / Subtasks

- [ ] Task 1: Create Item domain model (AC: 1, 3)
  - [ ] 1.1 Create `lib/domain/items/models/item_definition.dart` — immutable, Pure Dart
  - [ ] 1.2 Define enum `ItemType { potion, ether, rareCandy }`
  - [ ] 1.3 Fields: `id`, `name`, `nameZh`, `description`, `type`, `maxStack`
  - [ ] 1.4 Create `lib/domain/items/models/inventory_entry.dart` — `itemId` + `quantity`

- [ ] Task 2: Create item definitions data (AC: 1)
  - [ ] 2.1 Create `assets/data/items.json` with three core items:
        - Potion: pauses rest timer without evaluation penalty
        - Ether: restores 50% max PP
        - Rare Candy: grants move evolution XP
  - [ ] 2.2 Register `assets/data/` in pubspec.yaml (already registered)

- [ ] Task 3: Add inventory to UserProfile (AC: 1, 2)
  - [ ] 3.1 Add `potionCount`, `etherCount`, `rareCandyCount` int columns to `UserProfiles` Drift table
  - [ ] 3.2 Update `UserProfile` domain model with inventory fields
  - [ ] 3.3 Update `UserProfileMapper` for inventory fields
  - [ ] 3.4 Increment `schemaVersion` in `AppDatabase`, add migration

- [ ] Task 4: Create ItemRepository (AC: 4)
  - [ ] 4.1 Create `lib/data/repositories/item_repository.dart`
  - [ ] 4.2 Methods: `loadItems()` from JSON asset, `getInventory()`, `addItem()`, `removeItem()`
  - [ ] 4.3 Inventory read/write delegates to `UserProfileRepository` for persistence

- [ ] Task 5: Create Riverpod providers (AC: 4)
  - [ ] 5.1 Create `lib/providers/item_providers.dart`
  - [ ] 5.2 `itemDefinitionsProvider` — loads from JSON asset
  - [ ] 5.3 `itemRepositoryProvider` — provides ItemRepository
  - [ ] 5.4 `inventoryProvider` — reads inventory counts from UserProfile

- [ ] Task 6: Award items on battle victory (AC: 1)
  - [ ] 6.1 In `BattleStateNotifier._persistExp()`, after victory, award 1 random item
  - [ ] 6.2 Update `BattleOutcome` with `awardedItems` list for result screen display

- [ ] Task 7: Tests (AC: 1-4)
  - [ ] 7.1 Unit test: ItemDefinition model creation and equality
  - [ ] 7.2 Unit test: inventory add/remove in repository
  - [ ] 7.3 Unit test: items.json loads correctly
  - [ ] 7.4 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0. Current schema version is **5** (or **6** if Story 6.1 done first). Inventory columns go on `UserProfiles` table.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### Inventory Storage Strategy

Store inventory as individual int columns on `UserProfiles` table (flat strategy, fast reads). Only 3 items in MVP — no need for a separate inventory table.

```dart
// In user_profile_table.dart
IntColumn get potionCount =>
    integer().withDefault(const Constant(0))();
IntColumn get etherCount =>
    integer().withDefault(const Constant(0))();
IntColumn get rareCandyCount =>
    integer().withDefault(const Constant(0))();
```

### Item Definitions JSON Format

```json
[
  {
    "id": "potion",
    "name": "Potion",
    "name_zh": "傷藥",
    "description": "Pause rest timer without penalty",
    "type": "potion",
    "max_stack": 99
  },
  {
    "id": "ether",
    "name": "Ether",
    "name_zh": "PP回復劑",
    "description": "Restore 50% of max PP",
    "type": "ether",
    "max_stack": 99
  },
  {
    "id": "rare_candy",
    "name": "Rare Candy",
    "name_zh": "神奇糖果",
    "description": "Grant move evolution experience",
    "type": "rare_candy",
    "max_stack": 99
  }
]
```

### Dependencies on Previous Stories

- **Story 1.2** — `UserProfile` and `UserProfileRepository` for inventory storage
- **Story 6.1** — PP system (Ether restores PP)
- **Story 2.2** — `MoveDefinition` for Rare Candy target

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `domain/items/` — Pure Dart, no Flutter imports |
| **Data Boundary** | JSON loading in `data/repositories/` |
| **Import Style** | `package:ironmon/...` only |
| **State Update** | `copyWith` only — no mutation |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/items/models/item_definition.dart
ironmon/lib/domain/items/models/inventory_entry.dart
ironmon/lib/data/repositories/item_repository.dart
ironmon/lib/providers/item_providers.dart
ironmon/assets/data/items.json
ironmon/test/domain/items/item_definition_test.dart
ironmon/test/data/repositories/item_repository_test.dart
```

Files to update:

```
ironmon/lib/domain/training/models/user_profile.dart (add inventory fields)
ironmon/lib/data/local/tables/user_profile_table.dart (add columns)
ironmon/lib/data/local/app_database.dart (schema version bump, migration)
ironmon/lib/data/mappers/user_profile_mapper.dart (map inventory)
ironmon/lib/providers/battle_providers.dart (award items on victory)
ironmon/lib/domain/battle/models/battle_outcome.dart (awardedItems field)
```

### References

- [Source: epics.md#Story 6.2] — User story, acceptance criteria
- [Source: spec.md#Section 5.2] — Item definitions (Potion, Ether, Rare Candy)
- [Source: spec.md#Section 3.1] — Inventory in user profile
- [Source: architecture.md#Data Architecture] — Flat storage for frequent reads

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
