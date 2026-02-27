# Code Review: Story 1.3 — Beginner Mode & Auto-Calibration

**Reviewer:** Adversarial Senior Code Review
**Date:** 2026-02-27
**Story:** 1.3 Beginner Mode & Auto-Calibration
**Stack:** Flutter 3.41.2 / Dart 3.11.0 / Drift 2.31.0 / flutter_riverpod 3.2.1 / go_router 17.1.0

---

## Overall Assessment

**CONDITIONAL PASS**

The implementation covers all 15 acceptance criteria at the structural level. The domain service (`BeginnerCalibrationService`) is clean, well-tested, and architecturally compliant. The Drift schema migration is correctly additive. However, there are 2 HIGH issues (one will cause a runtime crash, one is a missing provider method that blocks future story integration), 3 MEDIUM issues, and 2 LOW issues that should be addressed.

**Git vs Story Discrepancies:** 0 — Story File List matches git diff exactly (22 files).

**Issues Found:** 2 High, 3 Medium, 2 Low

---

## 🔴 HIGH ISSUES (must fix before merge)

### HIGH-1 — `DropdownButtonFormField` uses non-existent `initialValue` parameter → runtime crash

**File:** `lib/presentation/onboarding/onboarding_screen.dart` line 135
**Severity:** Runtime crash — will fail at compile or throw at runtime

```dart
// ACTUAL CODE (line 134-135):
DropdownButtonFormField<int>(
  initialValue: _weeklyFrequency,
```

`DropdownButtonFormField` does not have an `initialValue` parameter. The correct parameter is `value`. This will cause either a compile error (if strict analysis catches it) or a runtime crash when the widget is built.

**Suggested fix:**
```dart
DropdownButtonFormField<int>(
  value: _weeklyFrequency,
```

---

### HIGH-2 — `UserProfileNotifier` has no `updateCalibration` method — dead repository code

**File:** `lib/providers/user_profile_providers.dart`
**Severity:** Integration blocker for Epic 2

The `UserProfileRepository.updateCalibration()` method was correctly added to the abstract interface and `DriftUserProfileRepository`, but `UserProfileNotifier` does not expose it. The notifier only has `saveProfile()` and `updateProfile()`. When Epic 2's battle engine needs to call calibration after a session, there is no provider-level method to invoke `updateCalibration`.

Additionally, `ProfileEditScreen` calls `saveProfile(updated)` (line 70) which does an `insertOnConflictUpdate` — this works but bypasses the `updateUserProfile` / `updateCalibration` methods entirely. While functionally correct for now, it establishes a pattern where the "update" path is never exercised through providers.

**Suggested fix:** Add `updateCalibration` method to `UserProfileNotifier`:
```dart
/// Persists calibration results atomically.
Future<void> updateCalibration(UserProfile profile) async {
  state = const AsyncValue.loading();
  final result = await ref
      .read(userProfileRepositoryProvider)
      .updateCalibration(profile);
  state = switch (result) {
    Success(:final value) => AsyncValue.data(value),
    Failure(:final error) =>
        AsyncValue.error(error, StackTrace.current),
  };
}
```

---

## 🟡 MEDIUM ISSUES (should fix)

### MED-1 — `ProfileEditScreen.initState` calls `ref.read()` — unsafe in `initState`

**File:** `lib/presentation/profile/profile_edit_screen.dart` lines 27-37
**Severity:** Potential null/stale state, violates Riverpod best practices

```dart
@override
void initState() {
  super.initState();
  ref.read(userProfileProvider).whenData((profile) {
    if (profile != null) {
      _currentProfile = profile;
      _squatController.text = profile.squatFiveRm.toString();
      // ...
    }
  });
}
```

In `ConsumerStatefulWidget`, `ref` should not be used in `initState` — it may not be fully initialized. The Riverpod documentation recommends reading provider state in `build()` or using `ref.listen` / `ref.read` after the first frame. If the `userProfileProvider` is still in `AsyncLoading` state when `initState` runs, `whenData` will not fire and `_currentProfile` will remain `null`, making the save button permanently non-functional.

**Suggested fix:** Move the initialization logic into the `build` method or use a `ref.listen` callback, or defer with `WidgetsBinding.instance.addPostFrameCallback`.

---

### MED-2 — `OnboardingScreen` does not pass `calibrationSessionsCompleted` and `calibrationTargetSessions` explicitly

**File:** `lib/presentation/onboarding/onboarding_screen.dart` lines 41-48
**Severity:** Relies on default values — fragile

```dart
final profile = UserProfile(
  squatFiveRm: double.tryParse(_squatController.text) ?? 0.0,
  // ...
  isBeginnerMode: _isBeginnerMode,
);
```

The story spec (Dev Notes line 553-554) explicitly sets `calibrationSessionsCompleted: 0` and `calibrationTargetSessions: 5`. The implementation relies on the domain model's default values instead of explicitly passing them. While functionally equivalent today, if the defaults ever change, beginner profiles would be created with incorrect calibration state.

**Suggested fix:** Explicitly pass `calibrationSessionsCompleted: 0` and `calibrationTargetSessions: 5` in the `UserProfile` constructor call.

---

### MED-3 — `ProfileEditScreen` uses `saveProfile` (upsert) instead of `updateProfile` (update)

**File:** `lib/presentation/profile/profile_edit_screen.dart` line 70
**Severity:** Semantic correctness — uses wrong repository path

```dart
await ref
    .read(userProfileProvider.notifier)
    .saveProfile(updated);
```

The profile already exists when `ProfileEditScreen` is reached (it's only accessible from `HomeScreen` which requires a profile). Using `saveProfile` triggers `insertOnConflictUpdate` instead of `updateUserProfile`. While the end result is the same for a singleton row, this bypasses any future update-specific hooks (e.g., audit logging, optimistic concurrency) and makes the code semantically misleading.

**Suggested fix:** Use `updateProfile(updated)` instead of `saveProfile(updated)`.

---

## 🟢 LOW ISSUES (nice to fix)

### LOW-1 — `estimateFiveRm` doc says "Returns 0.0" but returns `0` (int literal)

**File:** `lib/domain/training/beginner_calibration_service.dart` line 20
**Severity:** Style / `very_good_analysis` lint consistency

```dart
/// Returns 0.0 if [weight] or [reps] is not positive.
double estimateFiveRm(double weight, int reps) {
  if (weight <= 0 || reps <= 0) return 0;
```

The doc comment says "Returns 0.0" but the code returns `0` (an int literal). While Dart auto-promotes `0` to `0.0` for the `double` return type, `prefer_int_literals` lint may not apply here since the return type is explicitly `double`. Using `0.0` would be more explicit and consistent with the doc comment.

---

### LOW-2 — `_BattleResultPlaceholder` in `app_router.dart` — scope creep beyond Story 1.3

**File:** `lib/router/app_router.dart` lines 104-176
**Severity:** Scope creep — minor

The `_BattleResultPlaceholder` widget includes calibration-complete UI logic (lines 124-163) that references `calibrationSessionsCompleted` and `calibrationTargetSessions`. This is technically part of AC 11 ("user is notified on the result screen that calibration is complete") but the story spec's Calibration UX Notes say this notification is scoped to "the actual session-end calibration trigger" which "will be wired in the battle stories (Epic 2)."

The placeholder logic uses a heuristic (`!profile.isBeginnerMode && sessions >= target`) that will always show the "Calibration Complete!" banner for any non-beginner user whose sessions equal or exceed the target — including users who never used beginner mode. This is not a bug now (placeholder screen), but should be noted for Epic 2.

---

## Acceptance Criteria Verification

| AC | Status | Evidence |
|----|--------|----------|
| 1. Beginner Mode toggle visible | ✅ IMPLEMENTED | `onboarding_screen.dart:94-112` — `SwitchListTile` |
| 2. Pre-fill 20 kg | ✅ IMPLEMENTED | `onboarding_screen.dart:104-108` |
| 3. `isBeginnerMode` stored | ✅ IMPLEMENTED | `onboarding_screen.dart:47`, table + mapper |
| 4. `calibrationSessionsCompleted` stored | ✅ IMPLEMENTED | Domain model, table, mapper |
| 5. `calibrationTargetSessions` stored | ✅ IMPLEMENTED | Domain model, table, mapper |
| 6. UI shows "Calibrating (0/5)" | ✅ IMPLEMENTED | `home_screen.dart:36-46`, `profile_edit_screen.dart:131-144` |
| 7. Session increments counter | ✅ IMPLEMENTED | `beginner_calibration_service.dart:43` |
| 8. Epley formula computes 5RM | ✅ IMPLEMENTED | `beginner_calibration_service.dart:19-22` |
| 9. Only increases 5RM (no regression) | ✅ IMPLEMENTED | `beginner_calibration_service.dart:48-59` |
| 10. Exits beginner mode at target | ✅ IMPLEMENTED | `beginner_calibration_service.dart:44-45, 61-62` |
| 11. Calibration complete notification | ✅ PARTIAL | Placeholder in `app_router.dart:124-163` — adequate for story scope |
| 12. Manual 5RM override | ✅ IMPLEMENTED | `profile_edit_screen.dart` |
| 13. Manual override doesn't exit beginner mode | ✅ IMPLEMENTED | `profile_edit_screen.dart:56-65` — `copyWith` preserves calibration fields |
| 14. `flutter analyze` zero issues | ⚠️ UNVERIFIED | Claimed in story but not verified in this review (HIGH-1 may cause analysis failure) |
| 15. Unit tests cover required areas | ✅ IMPLEMENTED | 4 test files, 63 tests claimed passing |

---

## Task Completion Audit

All 9 tasks marked `[x]` are verified as actually implemented in the source code. No false claims detected.

---

## Architecture Compliance

| Rule | Status |
|------|--------|
| Domain Boundary (no Flutter/Drift imports in `lib/domain/`) | ✅ PASS |
| `BeginnerCalibrationService` pure Dart, stateless, sync | ✅ PASS |
| Repository never returns entities — always maps through `UserProfileMapper` | ✅ PASS |
| State immutability via `copyWith` | ✅ PASS |
| Import style: `package:ironmon/...` only | ✅ PASS |
| Provider naming: `beginnerCalibrationServiceProvider` | ✅ PASS |
| `Result` sealed class switch exhaustive | ✅ PASS |
| `very_good_analysis` compliance | ⚠️ HIGH-1 may violate |
| Drift defaults use `const Constant(0)` for int columns | ✅ PASS |

---

## Verdict

**CONDITIONAL PASS** — Fix HIGH-1 and HIGH-2 before merge. MED-1 through MED-3 should be addressed but are not blockers.
