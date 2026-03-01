# Story 9.2: Heart Rate Zone Damage System

Status: ready-for-dev

## Story

As a player,
I want my heart rate to influence battle damage,
So that training intensity is rewarded beyond manual RPE input.

## Acceptance Criteria

1. **Given** the player has a connected wearable providing heart rate data
   **When** a set is completed during battle
   **Then** the system reads the peak heart rate for that set
2. **And** Zone 1-2 (<60% max HR): 1.0x multiplier (steady damage)
3. **And** Zone 3-4 (70-85% max HR): 1.2x multiplier + increased critical hit chance (+30%)
4. **And** Zone 5 (>85% max HR): 1.5x multiplier (Dynamax Mode, see Story 9.4)
5. **And** if wearable is not connected, RPE multiplier is used instead (backward compatible)
6. **And** max HR is calculated as 220 - age (age stored in UserProfile)

## Tasks / Subtasks

- [ ] Task 1: Create HeartRateZone domain model (AC: 2, 3, 4, 6)
  - [ ] 1.1 Create `lib/domain/training/models/heart_rate_zone.dart` — Pure Dart
  - [ ] 1.2 Enum: `HeartRateZone { zone1, zone2, zone3, zone4, zone5 }`
  - [ ] 1.3 Static method `fromHeartRate(int hr, int maxHr) → HeartRateZone`
  - [ ] 1.4 Getter `damageMultiplier` → zone-based multiplier (1.0, 1.2, 1.5)
  - [ ] 1.5 Getter `criticalHitBonus` → zone 3-4 returns 0.3, else 0.0

- [ ] Task 2: Create HeartRateMultiplierService (AC: 1, 5)
  - [ ] 2.1 Create `lib/domain/training/heart_rate_service.dart` — Pure Dart
  - [ ] 2.2 Method `getMultiplier({int? heartRate, int rpe, int maxHr, bool hasWearable}) → double`
  - [ ] 2.3 If `hasWearable && heartRate != null`: use HR zone multiplier
  - [ ] 2.4 If no wearable or no HR data: fall back to existing RPE multiplier
  - [ ] 2.5 Max HR formula: `220 - age`

- [ ] Task 3: Integrate into DamageCalculator (AC: 1, 2, 3, 4, 5)
  - [ ] 3.1 Modify `DamageCalculator.calculate()` to accept optional `heartRate` param
  - [ ] 3.2 If heartRate provided, use `HeartRateMultiplierService` instead of `_getRpeMultiplier()`
  - [ ] 3.3 Include zone info in `DamageResult` for UI display
  - [ ] 3.4 Backward compatible: existing calls without heartRate still work via RPE

- [ ] Task 4: Wire into BattleStateNotifier (AC: 1)
  - [ ] 4.1 In `submitSet()`, read latest HR from `HealthService` if wearable connected
  - [ ] 4.2 Pass HR to `DamageCalculator.calculate()`
  - [ ] 4.3 Store peak HR per set in `ExerciseSet` model (optional field)

- [ ] Task 5: Display zone on battle screen (AC: 2, 3, 4)
  - [ ] 5.1 Show current HR zone badge near damage numbers
  - [ ] 5.2 Zone colors: blue (1-2), green (3), orange (4), red (5)
  - [ ] 5.3 Show "Critical!" text when zone 3-4 bonus applies

- [ ] Task 6: Tests (AC: 1-6)
  - [ ] 6.1 Unit test: HR → zone mapping for all thresholds
  - [ ] 6.2 Unit test: zone → multiplier mapping
  - [ ] 6.3 Unit test: fallback to RPE when no HR
  - [ ] 6.4 Unit test: DamageCalculator with HR produces correct damage
  - [ ] 6.5 Unit test: max HR = 220 - age
  - [ ] 6.6 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

No new tables needed. Optional `heartRate` field may be added to `ExerciseSets` table.

### CRITICAL — No riverpod_generator

Manual providers only.

### Heart Rate Zone Thresholds

Based on percentage of max HR (220 - age):

| Zone | % of Max HR | Multiplier | Extra |
|------|------------|------------|-------|
| 1-2  | < 60%      | 1.0x       | — |
| 3    | 60-70%     | 1.2x       | +30% crit |
| 4    | 70-85%     | 1.2x       | +30% crit |
| 5    | > 85%      | 1.5x       | Dynamax (Story 9.4) |

### Backward Compatibility

The existing `_getRpeMultiplier()` in `DamageCalculator` must continue to work. The HR system is an **addition**, not a replacement. When no wearable, RPE path is unchanged.

### Dependencies on Previous Stories

- **Story 9.1** — `HealthService` for heart rate data
- **Story 2.4** — `DamageCalculator` for multiplier integration
- **Story 2.5** — `BattleStateNotifier` for wiring
- **Story 1.2** — `UserProfile.age` for max HR calculation

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `HeartRateZone`, `HeartRateMultiplierService` in `domain/training/` — Pure Dart |
| **Backward Compatible** | RPE path unchanged when no wearable |
| **Import Style** | `package:ironmon/...` only |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/training/models/heart_rate_zone.dart
ironmon/lib/domain/training/heart_rate_service.dart
ironmon/test/domain/training/heart_rate_service_test.dart
ironmon/test/domain/training/models/heart_rate_zone_test.dart
```

Files to update:

```
ironmon/lib/domain/battle/damage_calculator.dart (optional heartRate param)
ironmon/lib/domain/battle/models/damage_result.dart (zone info)
ironmon/lib/providers/battle_providers.dart (read HR in submitSet)
ironmon/lib/presentation/battle/battle_screen.dart (zone badge display)
```

### References

- [Source: epics.md#Story 9.2] — User story, acceptance criteria
- [Source: spec.md#Section 4.4 Step 3] — Heart rate critical multipliers
- [Source: spec.md#Section 5.6] — Heart rate sync zones
- [Source: architecture.md#Domain Layer] — DamageCalculator

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
