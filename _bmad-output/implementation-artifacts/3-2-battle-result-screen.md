# Story 3.2: Battle Result Screen

Status: done

## Story

As a player,
I want to see a summary of my workout performance after battle,
So that I know how much I accomplished and what rewards I earned.

## Acceptance Criteria

1. **Given** a battle has ended (victory or defeat)
   **When** the result screen displays
   **Then** total training volume (kg) is shown (FR17)
2. **And** damage statistics per stage are displayed (FR17)
3. **And** EXP earned is displayed with a breakdown
4. **And** victory/defeat status is clearly indicated
5. **And** a "Return Home" button navigates back to the home screen

## Tasks / Subtasks

- [x] Task 1: Create Battle Result Screen (AC: 1, 2, 3, 4, 5)
  - [x] 1.1 Created `battle_result_screen.dart` — replaced placeholder
  - [x] 1.2 Header section: Victory/Defeat banner with green/red color
  - [x] 1.3 Stats section: Total volume (kg), total sets, total damage dealt
  - [x] 1.4 Stage breakdown: Per-boss status (defeated/HP remaining)
  - [x] 1.5 EXP section: EXP modifier display (100% or 60%)
  - [x] 1.6 "Return Home" button using `context.go('/')`

- [x] Task 2: Pass battle outcome data to result screen (AC: 1, 2, 3)
  - [x] 2.1 BattleScreen listener navigates to `/battle/result` on BattleResult phase
  - [x] 2.2 Result screen reads from `battleStateNotifierProvider`

- [x] Task 3: Stage breakdown integrated inline (AC: 2)
  - [x] 3.1 Stage breakdown shown inline via _StatCard with boss iteration
  - [x] 3.2 Shows per-boss: name, defeated/HP status

- [x] Task 4: EXP display (AC: 3)
  - [x] 4.1 EXP modifier shown in _StatCard
  - [x] 4.2 Defeat shows 60% modifier

- [x] Task 5: Router & integration (AC: 5)
  - [x] 5.1 Updated app_router.dart to use BattleResultScreen
  - [x] 5.2 Removed old placeholder widget

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0, not Isar.

### CRITICAL — No riverpod_generator

Manual providers only. No `@riverpod` annotations.

### CRITICAL — No Schema Changes

This story is presentation-only. No Drift changes.

### Dependencies on Previous Stories

- **Story 2.5** — `BattleState`, `BattlePhase` (Result variant)
- **Story 3.1** — `BattleOutcome` with victory/defeat, EXP modifier, volume

### Navigation Pattern

Use `context.go('/')` (not `context.push`) for "Return Home" because
we want to clear the navigation stack — the player should not be able
to press back and return to the battle result or battle screen.

### Result Screen Layout

```
┌─────────────────────────┐
│     🏆 VICTORY! 🏆      │  (or ❌ DEFEAT)
├─────────────────────────┤
│  Total Volume: 2,450 kg │
│  Total Sets: 12         │
│  Total Damage: 3,200    │
├─────────────────────────┤
│  Stage Breakdown:       │
│  ├ Minion: 800 dmg ✓    │
│  ├ Mid-Boss: 1,200 dmg ✓│
│  └ Gym Leader: 1,200 dmg│
├─────────────────────────┤
│  EXP Earned: +450       │
│  (Base: 450 × 1.0)      │
├─────────────────────────┤
│   [ Return Home ]        │
└─────────────────────────┘
```

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Widget Pattern** | `ConsumerWidget` — read outcome from provider |
| **Import Style** | `package:ironmon/...` only |
| **Navigation** | `context.go('/')` for return home (stack clear) |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |
| **No domain changes** | Pure presentation |

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/battle/widgets/stage_breakdown.dart
ironmon/test/presentation/battle/battle_result_screen_test.dart
```

Files to update:

```
ironmon/lib/presentation/battle/battle_result_screen.dart
```

### References

- [Source: epics.md#Story 3.2] — User story, acceptance criteria
- [Source: prd.md#FR17] — 訓練統計摘要
- [Source: architecture.md#Frontend Architecture] — go_router, /battle/result route
- [Source: 3-1-win-lose-conditions.md] — BattleOutcome model

## Dev Agent Record

### Agent Model Used
Claude Sonnet 4 via Cascade

### Debug Log References
No issues encountered.

### Completion Notes List
- Created BattleResultScreen as ConsumerWidget reading from battleStateNotifierProvider
- Victory/Defeat banner with green/red color coding
- Training stats: volume, sets, damage
- Stage breakdown showing per-boss defeated/surviving status
- Battle events section for exhaustion/counter counts
- EXP modifier display (100%/60%)
- Return Home via context.go('/') to clear navigation stack
- Router updated, old placeholder removed
- Battle screen already has ref.listen navigation to /battle/result

### File List
- ironmon/lib/presentation/battle/battle_result_screen.dart (created)
- ironmon/lib/router/app_router.dart (modified)

## Senior Developer Review (AI)

**Reviewer:** Cascade (adversarial review)
**Date:** 2026-02-28
**Verdict:** CONDITIONAL PASS
**Issues Found:** 0 HIGH, 1 MEDIUM, 0 LOW

| # | Severity | Description | Status |
|---|----------|-------------|--------|
| M1 | MEDIUM | Multiple `withOpacity` calls deprecated in Flutter 3.27+ | **FIXED** |

**Fixes Applied:**
- M1: Replaced all `withOpacity` with `withValues(alpha:)` across battle_result_screen.dart
