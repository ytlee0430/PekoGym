# Story 6.4: Item Shop Screen

Status: ready-for-dev

## Story

As a player,
I want to browse and purchase items from a shop,
So that I can prepare for challenging battles.

## Acceptance Criteria

1. **Given** the player navigates to the Item Shop
   **When** the shop screen loads
   **Then** all available items are displayed with name, description, price, and current inventory count
2. **And** the player can purchase items using in-game currency (EXP-based coins)
3. **And** purchased items are added to inventory and persisted
4. **And** the shop UI follows the existing pixel-art style
5. **And** navigation uses go_router with `/shop` route

## Tasks / Subtasks

- [ ] Task 1: Define currency system (AC: 2)
  - [ ] 1.1 Add `coins` field to `UserProfile` domain model
  - [ ] 1.2 Add `coins` column to `UserProfiles` Drift table
  - [ ] 1.3 Update mapper, migration
  - [ ] 1.4 Award coins on battle completion (e.g., victory = 100 coins, defeat = 40 coins)

- [ ] Task 2: Add item pricing to item definitions (AC: 1, 2)
  - [ ] 2.1 Add `price` field to `ItemDefinition`
  - [ ] 2.2 Update `items.json` with prices: Potion = 50, Ether = 80, Rare Candy = 150

- [ ] Task 3: Create ShopScreen (AC: 1, 4, 5)
  - [ ] 3.1 Create `lib/presentation/shop/shop_screen.dart`
  - [ ] 3.2 Header: "Item Shop" title + player's coin balance
  - [ ] 3.3 Item list: each item shows icon, name, description, price, owned count
  - [ ] 3.4 Buy button per item with quantity selector (+/- buttons)
  - [ ] 3.5 Pixel-art styled card layout matching existing theme

- [ ] Task 4: Purchase logic (AC: 2, 3)
  - [ ] 4.1 Validate coins >= price before purchase
  - [ ] 4.2 Deduct coins from UserProfile
  - [ ] 4.3 Increment item count in UserProfile
  - [ ] 4.4 Persist both changes atomically via Drift transaction
  - [ ] 4.5 Show success/failure toast

- [ ] Task 5: Add route and navigation (AC: 5)
  - [ ] 5.1 Add `/shop` route to `app_router.dart`
  - [ ] 5.2 Add shop button to HomeScreen (bag icon in app bar or bottom nav)

- [ ] Task 6: Award coins on battle end (AC: 2)
  - [ ] 6.1 In `BattleStateNotifier._persistExp()`, also award coins
  - [ ] 6.2 Update `BattleOutcome` with `coinsEarned` field
  - [ ] 6.3 Display coins earned on `BattleResultScreen`

- [ ] Task 7: Tests (AC: 1-5)
  - [ ] 7.1 Unit test: purchase deducts coins and increments item
  - [ ] 7.2 Unit test: purchase blocked when insufficient coins
  - [ ] 7.3 Widget test: shop screen displays items with prices
  - [ ] 7.4 Widget test: buy button disabled when coins insufficient
  - [ ] 7.5 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0. `coins` column added to `UserProfiles` table.

### CRITICAL — No riverpod_generator

Manual providers only.

### Currency Design

Coins are a simple integer counter on UserProfile. Award formula:
- Victory: `100 + (level * 5)` coins
- Defeat: `40 + (level * 2)` coins

### Dependencies on Previous Stories

- **Story 6.2** — Item definitions, inventory fields in UserProfile
- **Story 6.3** — Item effects (so player sees value in purchasing)
- **Story 1.4** — HomeScreen for shop navigation entry point
- **Story 2.6** — Battle result screen for coins display

### Navigation Entry

Add a bag/shop icon button to `HomeScreen` app bar:

```dart
IconButton(
  icon: const Icon(Icons.shopping_bag_outlined),
  onPressed: () => context.push('/shop'),
),
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Presentation** | `ShopScreen` in `presentation/shop/` |
| **Import Style** | `package:ironmon/...` only |
| **Navigation** | go_router `/shop` route |
| **Transactions** | Purchase = Drift `transaction {}` block |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/shop/shop_screen.dart
ironmon/lib/presentation/shop/widgets/shop_item_card.dart
ironmon/test/presentation/shop/shop_screen_test.dart
```

Files to update:

```
ironmon/lib/domain/training/models/user_profile.dart (add coins)
ironmon/lib/domain/items/models/item_definition.dart (add price)
ironmon/lib/data/local/tables/user_profile_table.dart (coins column)
ironmon/lib/data/local/app_database.dart (migration)
ironmon/lib/data/mappers/user_profile_mapper.dart (coins)
ironmon/lib/domain/battle/models/battle_outcome.dart (coinsEarned)
ironmon/lib/providers/battle_providers.dart (award coins)
ironmon/lib/presentation/battle/battle_result_screen.dart (show coins)
ironmon/lib/presentation/home/home_screen.dart (shop button)
ironmon/lib/router/app_router.dart (add /shop route)
ironmon/assets/data/items.json (add price field)
```

### References

- [Source: epics.md#Story 6.4] — User story, acceptance criteria
- [Source: spec.md#Section 5.2] — Item system
- [Source: spec.md#Section 6.5] — Item shop & inventory UI
- [Source: architecture.md#Frontend Architecture] — go_router routing

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
