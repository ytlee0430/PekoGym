# Story 1.4: Home Screen

Status: ready-for-dev

## Story

As a player,
I want to see my profile summary and a clear entry point to start
training,
so that I know my current status and can begin a battle.

## Acceptance Criteria

1. **Given** the user has completed onboarding (UserProfile exists)
   **When** the app launches
   **Then** the home screen displays player level, EXP bar, and
   current 5RM summary
2. **And** a "Start Battle" button is prominently visible
3. **And** the app navigates directly to home (skipping onboarding)
   on subsequent launches
4. **And** cold start to home screen renders in <3 seconds (NFR5)
5. **Given** the user is in beginner mode
   **When** the home screen displays
   **Then** a calibration progress indicator shows
   "Calibrating (N/M sessions)" clearly
6. **Given** the user taps "Start Battle"
   **When** the navigation occurs
   **Then** the app navigates to `/battle` route

## Tasks / Subtasks

- [ ] Task 1: Redesign `HomeScreen` widget with full profile display
  (AC: 1, 2, 5)
  - [ ] 1.1 Replace placeholder `Column` with proper layout showing
    player level, EXP progress bar, and 5RM summary card
  - [ ] 1.2 Add prominent "Start Battle" `ElevatedButton` that
    navigates to `/battle`
  - [ ] 1.3 Show calibration progress indicator when
    `profile.isBeginnerMode == true`
  - [ ] 1.4 Keep existing settings `IconButton` for `/profile/edit`
    navigation

- [ ] Task 2: Add EXP progress bar widget (AC: 1)
  - [ ] 2.1 Create `lib/presentation/home/widgets/exp_progress_bar.dart`
    — a `StatelessWidget` showing current EXP as a `LinearProgressIndicator`
  - [ ] 2.2 EXP bar label: "Lv. {level} — {currentExp}/{nextLevelExp} EXP"
  - [ ] 2.3 Use a simple level-up threshold formula for MVP:
    `nextLevelExp = level * 100` (Story 4.1 will define the real
    formula; use this placeholder)

- [ ] Task 3: Add 5RM summary card widget (AC: 1)
  - [ ] 3.1 Create
    `lib/presentation/home/widgets/five_rm_summary_card.dart` — a
    `Card` widget displaying all four 5RM values in a 2×2 grid layout
  - [ ] 3.2 Show: Squat, Bench Press, Deadlift, Overhead Press — each
    with label and value in kg

- [ ] Task 4: Onboarding skip on subsequent launches (AC: 3)
  - [ ] 4.1 Verify existing `app_router.dart` redirect logic already
    handles this (it does — `profile != null && isOnboarding → '/'`)
  - [ ] 4.2 No code change needed — just verify in test

- [ ] Task 5: Tests (AC: 1, 2, 3, 4, 5, 6)
  - [ ] 5.1 Create `test/presentation/home/home_screen_test.dart` —
    widget tests verifying:
    - Level and EXP bar rendered when profile exists
    - 5RM summary card shows all four values
    - "Start Battle" button exists and is tappable
    - Calibration indicator shown when `isBeginnerMode == true`
    - Calibration indicator hidden when `isBeginnerMode == false`
  - [ ] 5.2 `flutter analyze` reports zero issues
  - [ ] 5.3 All existing tests continue to pass

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Architecture doc references Isar throughout. The project uses Drift
2.31.0 (pivoted in Story 1.1 due to Dart 3.11.0 incompatibility).

| Architecture Doc Term | Actual Implementation |
|---|---|
| `@Collection()` | `class UserProfiles extends Table { ... }` |
| `Isar.autoIncrement` | `integer().autoIncrement()()` |
| `IsarLinks` | Drift relations (future stories) |
| `writeTxn()` | `db.transaction(() async { ... })` |
| `Isar.open([...])` | `AppDatabase(NativeDatabase.memory())` for tests |

### CRITICAL — No riverpod_generator

`riverpod_generator` is absent because `analyzer` version conflicts
with `drift_dev`. Do NOT use `@riverpod` or `@Riverpod` annotations.

All providers must be manually defined:

```dart
final someProvider = Provider<SomeType>((ref) {
  return SomeType();
});
```

### CRITICAL — Current Database Schema Version Is 3

Do NOT change `schemaVersion` or any Drift table definitions. This
story is UI-only — no data layer changes.

### Existing HomeScreen to Replace

The current `HomeScreen` at
`lib/presentation/home/home_screen.dart` is a minimal placeholder
from Story 1.2/1.3. It already:

- Watches `userProfileProvider` via `ConsumerWidget`
- Has an `AppBar` with settings `IconButton` → `/profile/edit`
- Shows calibration status text when `isBeginnerMode == true`

**Replace the `body` content** with the full layout. Keep the
`ConsumerWidget` pattern and `AppBar` actions.

### Existing Code Patterns to Follow

**Widget pattern** — use `ConsumerWidget` (not `ConsumerStatefulWidget`)
since HomeScreen has no local mutable state:

```dart
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    return Scaffold(
      appBar: AppBar(...),
      body: profileAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (profile) {
          if (profile == null) return const Text('No profile');
          return _HomeContent(profile: profile);
        },
      ),
    );
  }
}
```

**Provider access** — `ref.watch(userProfileProvider)` returns
`AsyncValue<UserProfile?>`. Use `.when()` for exhaustive handling.

**Navigation** — use `context.push('/battle')` for Start Battle
(push, not go, so user can return).

**Import style** — `package:ironmon/...` only. No relative imports.

### UserProfile Domain Model (Current Fields)

```dart
class UserProfile {
  final int id;                           // always 1
  final int level;                        // starts 1
  final int experiencePoints;             // starts 0
  final double squatFiveRm;              // kg
  final double benchPressFiveRm;         // kg
  final double deadliftFiveRm;           // kg
  final double overheadPressFiveRm;      // kg
  final int weeklyFrequency;             // 1-7
  final bool isBeginnerMode;             // Story 1.2
  final int calibrationSessionsCompleted; // Story 1.3
  final int calibrationTargetSessions;   // Story 1.3, default 5
  final List<String> unlockedMoveIds;    // JSON list
}
```

Source: `lib/domain/training/models/user_profile.dart`

### EXP Level Threshold (Placeholder)

Story 4.1 will define the real level-up formula. For this story, use
a simple placeholder:

```dart
/// Placeholder level-up threshold.
/// Story 4.1 will define the real formula.
int expForNextLevel(int currentLevel) => currentLevel * 100;
```

This means: Lv1 needs 100 EXP, Lv2 needs 200 EXP, etc. Display
the bar as `experiencePoints / expForNextLevel(level)` clamped to
0.0–1.0.

### Router — Already Handles Onboarding Skip (AC: 3)

The redirect logic in `lib/router/app_router.dart` already works:

```dart
data: (profile) {
  if (profile == null && !isOnboarding) return '/onboarding';
  if (profile != null && isOnboarding) return '/';
  return null;
},
```

No changes needed. Just verify with a test.

### Performance (NFR5 — Cold Start <3s)

No special optimization needed for this story. The app is already
lightweight (no network, no heavy assets). Just avoid doing
anything expensive in `build()`. The `userProfileProvider` async
load from Drift is fast (<200ms per NFR4).

### Project Structure Notes

New files to create:

```
ironmon/lib/presentation/home/widgets/exp_progress_bar.dart
ironmon/lib/presentation/home/widgets/five_rm_summary_card.dart
ironmon/test/presentation/home/home_screen_test.dart
```

Files to update:

```
ironmon/lib/presentation/home/home_screen.dart
```

All paths follow the architecture spec's feature-first structure
under `presentation/home/`.

### Widget Test Pattern (Riverpod + GoRouter)

For widget testing with Riverpod providers, use `ProviderScope`
overrides with a mock profile:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/home/home_screen.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

void main() {
  testWidgets('shows level and EXP bar', (tester) async {
    const profile = UserProfile(
      level: 5,
      experiencePoints: 250,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileProvider.overrideWith(
            () => _MockNotifier(profile),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lv. 5'), findsOneWidget);
  });
}

class _MockNotifier extends UserProfileNotifier {
  _MockNotifier(this._profile);
  final UserProfile _profile;

  @override
  Future<UserProfile?> build() async => _profile;
}
```

> **Note**: `UserProfileNotifier` extends `AsyncNotifier<UserProfile?>`
> which requires `build()` override. The mock returns a fixed profile.
> Use `overrideWith` (not `overrideWithValue`) for `AsyncNotifierProvider`.

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `lib/domain/` — zero changes in this story |
| **Import Style** | `package:ironmon/...` only — no relative imports |
| **Provider Pattern** | `ref.watch()` for reactive, `ref.read()` only in callbacks |
| **Widget Pattern** | `ConsumerWidget` for stateless Riverpod widgets |
| **Sealed Class Switch** | `Result` switch must exhaust `Success` and `Failure` — no `default` |
| **very_good_analysis** | All public members need `///` doc comments; lines ≤ 80 chars |
| **Navigation** | `context.push()` for forward nav, `context.go()` for replace |
| **No domain changes** | This story is pure presentation — do NOT touch domain or data layers |

### Common Pitfalls to Avoid

1. **Do NOT use `@riverpod` annotations** — codegen is unavailable.
   Use manual provider definitions only.
2. **Do NOT change schemaVersion** — this is a UI-only story.
3. **Do NOT use `setState()`** — use Riverpod `ref.watch()` pattern.
4. **Do NOT use relative imports** — always `package:ironmon/...`.
5. **Do NOT forget `///` doc comments** on public classes, methods,
   and constructors — `very_good_analysis` enforces this.
6. **Do NOT hard-code EXP formula** in multiple places — extract
   `expForNextLevel()` as a function so Story 4.1 can replace it.
7. **Line length ≤ 80 chars** — break long lines appropriately.
8. **The mock notifier pattern for testing** — use `overrideWith`
   not `overrideWithValue` for `AsyncNotifierProvider`.

### References

- [Source: epics.md#Story 1.4] — User story, acceptance criteria
- [Source: prd.md#Must-Have Capabilities] — Home screen as launch
  point for battle entry
- [Source: architecture.md#Frontend Architecture] — go_router routes,
  Riverpod patterns, `ConsumerWidget` + `select()`
- [Source: architecture.md#Structure Patterns] — `presentation/home/`
  location
- [Source: architecture.md#Routing] — `/` route = HomeScreen
- [Source: 1-3-beginner-mode-auto-calibration.md#Dev Notes] — Drift
  pivot, no riverpod_generator, schemaVersion 3
- [Source: 1-3-beginner-mode-auto-calibration.md#Calibration UX Notes]
  — Calibration progress display scoped to Story 1.4

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List

