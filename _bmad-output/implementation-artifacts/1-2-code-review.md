# Code Review: Story 1.2 — Player Profile Creation & Persistence

**Reviewer:** Adversarial Senior Code Review
**Date:** 2026-02-22
**Story:** 1.2 Player Profile Creation & Persistence
**Stack:** Flutter 3.41.2 / Dart 3.11.0 / Drift 2.31.0 / flutter_riverpod 3.2.1 / go_router 17.1.0

---

## Overall Assessment

**CONDITIONAL PASS**

The implementation satisfies the story's acceptance criteria at a surface level and all 33 tests pass as reported. However, there are two critical correctness bugs that will silently cause data corruption or data loss in production — one in the migration strategy and one in the `_onSubmit` error path. Additionally, the `UserProfile` equality contract is broken relative to its own `hashCode`, the `_RouterNotifier` leaks its `ChangeNotifier` subscription, `updateUserProfile` is dead code never reachable through any provider method, and the JSON decode path is fragile. These must be resolved before this code ships to TestFlight.

---

## Critical Issues (must fix before merge)

### CRIT-1 — Migration uses `deleteTable` string literal instead of Drift's `drop()` method

**File:** `lib/data/local/app_database.dart` line 25
**Severity:** Data integrity / silent failure

```dart
// ACTUAL CODE (line 25):
await m.deleteTable('user_profiles');
await m.createTable(userProfiles);

// DEV NOTES spec (story MD line 171):
await m.drop(userProfiles);
await m.createTable(userProfiles);
```

The implementation uses `m.deleteTable('user_profiles')` — a raw string — while the Dev Notes in the story spec call for `m.drop(userProfiles)` (the type-safe Drift API). This is not a stylistic difference. `Migrator.deleteTable(String)` executes a bare `DROP TABLE IF EXISTS` without Drift's schema tracking hooks, whereas `Migrator.drop(TableInfo)` integrates with Drift's migration verification and uses the correct table reference from the schema entity.

More critically: if the table name ever changes (e.g., via a `@TableIndex` override, alias, or a future rename), the string literal `'user_profiles'` will silently become a no-op `DROP TABLE IF EXISTS` on a table that no longer has that name, causing `createTable` to fail because the old table still exists. The migration is also missing a `Migrator.recreateAllTables()` wrapper that Drift's own documentation recommends for the "drop and recreate" pattern, which ensures all cascade constraints are handled correctly.

**Suggested fix:**
```dart
onUpgrade: (m, from, to) async {
  if (from < 2) {
    await m.drop(userProfiles);
    await m.createTable(userProfiles);
  }
},
```

---

### CRIT-2 — `_onSubmit` never resets `_isSaving` on failure; leaves UI permanently disabled

**File:** `lib/presentation/onboarding/onboarding_screen.dart` lines 36–48
**Severity:** Correctness — UI permanently broken on any save error

```dart
Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isSaving = true);           // set to true
  final profile = UserProfile(...);
  await ref.read(userProfileProvider.notifier).saveProfile(profile);
  if (mounted) context.go('/');               // only resets if navigation succeeds
}
```

`_isSaving` is set to `true` before the async save and is never reset to `false` in any code path. If `saveProfile` results in a `Failure` (database error, disk full, etc.), the provider state becomes `AsyncError` and the `context.go('/')` still executes unconditionally — the screen attempts to navigate away regardless of whether the save succeeded. The `mounted` guard only prevents a crash after widget disposal; it does not check whether the save actually succeeded.

There are two compounding sub-bugs here:

1. The provider's error state (`AsyncValue.error`) is never surfaced to the user. No `ref.listen` or `ref.watch` in the screen handles the error case, so a failed save is invisible to the user.
2. If navigation does not complete because the router redirects back to `/onboarding` (profile is still null after a failed save), `_isSaving` remains `true` permanently and the "Start Training" button stays disabled with no feedback.

**Suggested fix:**
```dart
Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isSaving = true);
  try {
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    // Check provider state before navigating
    final profileState = ref.read(userProfileProvider);
    if (profileState.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
      }
      return;
    }
    if (mounted) context.go('/');
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
}
```

---

### CRIT-3 — `UserProfile.operator==` and `hashCode` exclude `unlockedMoveIds`

**File:** `lib/domain/training/models/user_profile.dart` lines 79–104
**Severity:** Correctness — broken equality contract, Riverpod will miss state changes

```dart
@override
bool operator ==(Object other) {
  // ...
  other.isBeginnerMode == isBeginnerMode;
  // unlockedMoveIds is NOT compared!
}

@override
int get hashCode => Object.hash(
  id, level, experiencePoints,
  squatFiveRm, benchPressFiveRm, deadliftFiveRm,
  overheadPressFiveRm, weeklyFrequency, isBeginnerMode,
  // unlockedMoveIds is NOT hashed!
);
```

`unlockedMoveIds` is declared as a field (line 49) and is included in `copyWith` (line 62 and 74), but it is omitted from both `operator==` (lines 79–91) and `hashCode` (lines 94–104). This violates the Dart equality contract and creates concrete behavioral bugs:

- Two profiles with different unlocked moves are considered equal, so any `AsyncNotifierProvider` diff will not detect a change in `unlockedMoveIds` and will not rebuild dependent widgets.
- A `Map<UserProfile, ...>` or `Set<UserProfile>` will produce incorrect lookups.
- The test at `user_profile_test.dart:88` (`updates unlockedMoveIds`) passes only because it checks the copied field directly, not equality — it would not detect this bug.

The story spec (Dev Notes line 28) explicitly requires `unlockedMoveIds` in the domain model with full `==` and `hashCode`. The implementation fails to satisfy AC9 ("unit tests cover...domain `UserProfile.copyWith`") in its spirit since the equality contract is demonstrably broken.

**Suggested fix:** Add `unlockedMoveIds` to both `operator==` and `hashCode`. Because `unlockedMoveIds` is a `List<String>`, use `listEquals` (from `package:flutter/foundation.dart`) or `const DeepCollectionEquality().equals()` from `package:collection` for proper structural comparison rather than identity comparison:

```dart
// In operator==:
&& const ListEquality<String>().equals(other.unlockedMoveIds, unlockedMoveIds);

// In hashCode:
Object.hashAll([
  id, level, experiencePoints,
  squatFiveRm, benchPressFiveRm, deadliftFiveRm,
  overheadPressFiveRm, weeklyFrequency, isBeginnerMode,
  ...unlockedMoveIds, // spread to include list contents
]);
```

Note: `collection` is already an indirect transitive dependency via Dart's SDK. Adding it directly is cleaner.

---

## Major Issues (should fix)

### MAJ-1 — `_RouterNotifier` leaks: `ChangeNotifier` is never disposed

**File:** `lib/router/app_router.dart` lines 15–22 and 27–29
**Severity:** Memory / lifecycle leak

```dart
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<UserProfile?>>(
      userProfileProvider,
      (_, __) => notifyListeners(),
    );
  }
  // No dispose() override. No onDispose callback.
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  // notifier is never disposed
  return GoRouter(
    refreshListenable: notifier,
    // ...
  );
});
```

`_RouterNotifier extends ChangeNotifier` but never calls `super.dispose()`. When `appRouterProvider` is disposed (e.g., in tests or if the provider scope is torn down), the `ChangeNotifier` internal listener list is not cleaned up. The `GoRouter.dispose()` call will dispose the router's internal reference but the `_RouterNotifier` itself leaks. The `ref.listen` subscription is managed by Riverpod's `ref` lifecycle, but the `ChangeNotifier` remains in memory.

Additionally, `GoRouter` itself is never disposed. `appRouterProvider` should register `ref.onDispose(router.dispose)` to properly release the router's internal resources.

**Suggested fix:**
```dart
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<UserProfile?>>(
      userProfileProvider,
      (_, __) => notifyListeners(),
    );
    ref.onDispose(dispose); // tie lifecycle to Riverpod
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  final router = GoRouter(...);
  ref.onDispose(router.dispose);
  return router;
});
```

---

### MAJ-2 — `saveUserProfile` and `updateUserProfile` use unguarded null-assertion (`saved!`)

**File:** `lib/data/repositories/user_profile_repository.dart` lines 52 and 67
**Severity:** Runtime crash under concurrent access or transaction isolation issues

```dart
// saveUserProfile (line 51-52):
final saved = await _db.select(_db.userProfiles).getSingleOrNull();
return Success(UserProfileMapper.toDomain(saved!));  // CRASH if null

// updateUserProfile (line 66-67):
final updated = await _db.select(_db.userProfiles).getSingleOrNull();
return Success(UserProfileMapper.toDomain(updated!));  // CRASH if null
```

After a successful `insertOnConflictUpdate`, the code does a separate `SELECT` to get the saved row and hard-asserts it is non-null. This is a TOCTOU (Time-of-Check-Time-of-Use) race: in theory, between the INSERT and the SELECT, another concurrent operation (not possible in this app today but possible in future stories) could delete the row. More practically, if `insertOnConflictUpdate` silently fails to write due to a constraint (e.g., a schema validation failure that Drift catches internally without throwing), `saved` will be `null` and the `!` will throw an unhandled `Null check operator used on a null value` that escapes the `catch (e)` block because it is an `Error`, not an `Exception`.

Dart's `Error` (including `TypeError`, which wraps null assertion failures) is **not** caught by `on Exception catch (e)`. The try/catch here only catches `Exception`, so a `Null check operator` failure will propagate uncaught, crashing the app with an unrecoverable error rather than returning a `Failure`.

**Suggested fix:** Handle the null case explicitly and return a `Failure`:
```dart
final saved = await _db.select(_db.userProfiles).getSingleOrNull();
if (saved == null) {
  return Failure(Exception('Profile not found after save'));
}
return Success(UserProfileMapper.toDomain(saved));
```

---

### MAJ-3 — `updateUserProfile` is dead code: no provider method exposes it

**File:** `lib/providers/user_profile_providers.dart` (entire file)
**Severity:** Architecture gap — story AC is partially unimplemented

`UserProfileNotifier` exposes only `saveProfile()`, which calls `saveUserProfile()`. There is no `updateProfile()` method that calls `updateUserProfile()`. The `updateUserProfile` repository method exists (defined in the abstract interface at line 20 and implemented at line 59 of the repository) and is tested in `test/data/repositories/user_profile_repository_test.dart` at line 64, but it is completely unreachable from any widget or provider in the app.

This means any future story that needs to update a profile (e.g., incrementing XP after a battle, changing weekly frequency in settings) will have to use `saveUserProfile()` (the upsert), which overwrites the entire record. This is functionally equivalent for a singleton row but it is not the intended pattern — the abstract interface explicitly distinguishes `saveUserProfile` (create/upsert) from `updateUserProfile` (update existing). The notifier only providing one path makes `updateUserProfile` dead code today, and creates a trap for future implementers who see the abstract interface and assume there is a corresponding provider method.

**Suggested fix:** Add to `UserProfileNotifier`:
```dart
Future<void> updateProfile(UserProfile profile) async {
  state = const AsyncValue.loading();
  final result = await ref
      .read(userProfileRepositoryProvider)
      .updateUserProfile(profile);
  state = switch (result) {
    Success(:final value) => AsyncValue.data(value),
    Failure(:final error) => AsyncValue.error(error, StackTrace.current),
  };
}
```

---

### MAJ-4 — `_decodeIds` in mapper performs unguarded runtime cast

**File:** `lib/data/mappers/user_profile_mapper.dart` lines 61–64
**Severity:** Crash on malformed database content

```dart
static List<String> _decodeIds(String json) {
  final decoded = jsonDecode(json) as List<dynamic>;  // throws if not a JSON array
  return decoded.cast<String>();                       // throws if any element is not a String
}
```

Two failure modes exist with no error handling:

1. If the `unlockedMoveIds` column in the database contains malformed JSON (e.g., an empty string `''`, a JSON object `{}`, or a truncated value), `jsonDecode` throws a `FormatException` and `as List<dynamic>` throws a `TypeError`. Neither is caught. The `TypeError` will escape the repository's `on Exception catch(e)` block (it is an `Error`, not an `Exception`) and crash the app.

2. `decoded.cast<String>()` is a lazy cast in Dart. If any element in the stored JSON array is not a `String` (e.g., a number was accidentally stored), the cast does not throw immediately — it throws on first access of that element. This produces a runtime crash that is hard to trace since it occurs in whatever code iterates the list, not in the mapper.

The table default of `'[]'` protects against the empty case, but external corruption (direct SQLite writes, backup restore from a future schema version) can produce invalid values.

**Suggested fix:**
```dart
static List<String> _decodeIds(String json) {
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return [];
    return decoded.whereType<String>().toList();
  } catch (_) {
    return [];
  }
}
```

---

### MAJ-5 — GoRouter `redirect` silently swallows all database errors

**File:** `lib/router/app_router.dart` lines 37–46
**Severity:** Silent failure — database errors are invisible to the user

```dart
return profileAsync.when(
  loading: () => null,
  error: (_, __) => null,   // Swallows ALL errors — no redirect, no logging
  data: (profile) { ... },
);
```

When `userProfileProvider` is in an error state (e.g., the database is corrupt, disk is full, or Drift throws during `getUserProfile`), the router returns `null` — meaning no redirect happens. GoRouter then renders the `initialLocation` which is `/`. The `HomeScreen` at `/` is now shown to a user whose profile could not be loaded. There is no error UI, no retry mechanism, and no logging. The app silently presents a home screen with no valid profile data.

This is particularly dangerous because `HomeScreen` likely reads `userProfileProvider` directly and will itself be in an error state with no widget-level error handling shown in the review files.

**Suggested fix:** Route to a dedicated error screen or `/onboarding` as a safe fallback:
```dart
error: (error, _) {
  // Log the error in production (e.g., via a crash reporter)
  debugPrint('userProfileProvider error: $error');
  return '/onboarding'; // Safe fallback — user can at least create a profile
},
```

---

## Minor Issues (nice to have)

### MIN-1 — `autoIncrement` conflicts with the singleton pattern's intent

**File:** `lib/data/local/tables/user_profile_table.dart` line 8
**Severity:** Design clarity / future footgun

```dart
IntColumn get id => integer().autoIncrement()();
```

`autoIncrement()` means SQLite manages the ID counter. Combined with `insertOnConflictUpdate` forcing `id = Value(1)` in the mapper, this works today, but the table definition itself does not enforce the singleton constraint. Nothing at the database level prevents a second row with `id = 2` from being inserted by direct SQL, a future bug in the mapper, or a Drift migration side effect. A more explicit approach would use a `customConstraint` that enforces the singleton:

```dart
IntColumn get id => integer().withDefault(const Constant(1))
    .customConstraint('NOT NULL PRIMARY KEY CHECK (id = 1)')();
```

This makes the singleton invariant self-enforcing at the database level.

---

### MIN-2 — `FiveRmInputCard` validator accepts arbitrarily large values

**File:** `lib/presentation/onboarding/widgets/five_rm_input_card.dart` lines 33–41
**Severity:** Domain rule missing — accepts physically impossible values

```dart
validator: (value) {
  if (value == null || value.isEmpty) return 'Please enter $label 5RM';
  final parsed = double.tryParse(value);
  if (parsed == null || parsed <= 0) return 'Must be greater than 0';
  return null;
}
```

The validator accepts any positive number including `999999 kg`, which is physically impossible and will produce nonsensical game calculations. The story spec (FR1) says "5RM values for core lifts" but does not specify a max; however, applying a reasonable domain upper bound (e.g., 1000 kg) would prevent data corruption from typos. Additionally, the keyboard type `TextInputType.numberWithOptions(decimal: true)` on iOS still allows users to type non-numeric characters on some locale keyboards (e.g., a comma as decimal separator in European locales), which `double.tryParse` will reject correctly but the error message "Must be greater than 0" is misleading for that case.

---

### MIN-3 — `userProfileRepositoryProvider` uses `ref.read` instead of `ref.watch`

**File:** `lib/providers/repository_providers.dart` line 15
**Severity:** Provider lifecycle — subtle but correct for this use case, however worth flagging

```dart
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return DriftUserProfileRepository(ref.read(appDatabaseProvider));
});
```

Using `ref.read` inside a `Provider` body is unusual. The convention in Riverpod is to use `ref.watch` inside providers so that if `appDatabaseProvider` is ever replaced (e.g., in tests), the dependent `userProfileRepositoryProvider` reacts. Since `appDatabaseProvider` is a non-autoDispose `Provider` and the database is a true singleton, this is not a runtime bug today. However, in tests that use `ProviderScope` overrides, `ref.read` does not establish a dependency relationship, which means overriding `appDatabaseProvider` in a test scope may not correctly propagate to the repository if the repository provider is initialized before the override is applied. The widget test at `test/widget_test.dart` overrides `appDatabaseProvider` directly (bypassing the issue), but any test that tries to override `userProfileRepositoryProvider` indirectly by overriding `appDatabaseProvider` will silently use the wrong database.

---

### MIN-4 — `OnboardingScreen._onSubmit` calls `double.parse` without guard

**File:** `lib/presentation/onboarding/onboarding_screen.dart` line 40
**Severity:** Defensive programming gap

```dart
squatFiveRm: double.parse(_squatController.text),
```

The form validator (`FiveRmInputCard.validator`) calls `double.tryParse` and returns an error string for non-parseable values, so `validate()` at line 37 should block submission before `double.parse` is reached. However, `double.parse` is the throwing variant — if the validator logic ever changes, or if `validate()` has a defect, this line will throw an uncaught `FormatException`. Using `double.parse` where `double.tryParse` was already used in the validator is inconsistent. A guard using the already-validated `tryParse` result (or a `double.parse` wrapped in a try/catch) would be more defensive.

---

### MIN-5 — Migration strategy diverges from story spec without justification

**File:** `lib/data/local/app_database.dart` lines 22–28 vs. story spec
**Severity:** Spec divergence — traceability concern

The story spec Dev Notes (story MD, line 169) specifies:
```dart
await m.drop(userProfiles);     // type-safe Drift API
await m.createTable(userProfiles);
```

The implementation uses:
```dart
await m.deleteTable('user_profiles');   // raw string, not in spec
await m.createTable(userProfiles);
```

This was flagged as CRIT-1 for correctness. As a separate minor concern, the Completion Notes in the story file do not document this divergence — the agent notes claim "implementation completed without blockers" with no mention of the API choice. Future maintainers reading the story will see a discrepancy between spec and implementation with no explanation.

---

### MIN-6 — No `toString` or `debugFillProperties` on `UserProfile` domain model

**File:** `lib/domain/training/models/user_profile.dart`
**Severity:** Debuggability

`UserProfile` is `@immutable` and is the central state object, but it has no `toString` override. During development, `print(profile)` or Riverpod DevTools inspection will show `Instance of 'UserProfile'`, making debugging difficult. This is a `very_good_analysis` concern as well — the lint rule `prefer_to_string_in_to_string` indirectly encourages this.

---

## Test Coverage Assessment

### Missing Test Cases

**`test/domain/training/user_profile_test.dart`**

1. **`unlockedMoveIds` excluded from equality** — No test verifies that two profiles differing only in `unlockedMoveIds` are considered unequal. This test would have caught CRIT-3. Add:
   ```dart
   test('instances differing only in unlockedMoveIds are not equal', () {
     const a = UserProfile(unlockedMoveIds: ['push_up']);
     const b = UserProfile(unlockedMoveIds: ['squat']);
     expect(a, isNot(equals(b)));
   });
   ```

2. **`hashCode` includes `unlockedMoveIds`** — No test verifies that profiles with different `unlockedMoveIds` have different `hashCode`. This would also have caught CRIT-3.

3. **`copyWith` does not test resetting `unlockedMoveIds` to empty list** — The test at line 83 adds items but never tests that passing an empty list explicitly clears the field.

**`test/data/mappers/user_profile_mapper_test.dart`**

4. **No round-trip test** (entity → domain → companion → domain) — The spec at story MD line 58 explicitly requires "domain model → `UserProfilesCompanion` → back to domain model". The tests check `toDomain` and `toInsertable` separately but never chain them. A round-trip test would have caught any asymmetric encoding/decoding.

5. **No test for malformed JSON in `unlockedMoveIds`** — `_decodeIds` is brittle (MAJ-4). No test covers `'invalid-json'`, `'{}'`, `'[1, 2]'` (non-string elements), or `''` as input to `toDomain`.

6. **`toUpdateCompanion` not tested for all fields matching `toInsertable`** — The test at line 99 only checks a subset of fields. There is no test confirming `benchPressFiveRm`, `deadliftFiveRm`, `overheadPressFiveRm`, and `unlockedMoveIds` are correctly included.

**`test/data/repositories/user_profile_repository_test.dart`**

7. **No test for `updateUserProfile` on a non-existent profile** — Calling `updateUserProfile` with `id = 0` (the default) when no profile exists will execute a `WHERE id = 0` update that matches nothing, then the `getSingleOrNull()` returns null, and `updated!` crashes (MAJ-2). This case is untested.

8. **No test verifying all 9 fields are preserved on round-trip** — The story spec AC9 requires "save + retrieve preserves all 9 fields". The test at line 79 only checks `unlockedMoveIds`. A dedicated all-fields round-trip test is required by spec.

9. **No test for `getUserProfile` failure / error path** — No test exercises the `Failure` return path. Mocking a database error would require injecting a broken executor, but the absence of any error-path test means the `on Exception catch(e)` branch has 0% coverage.

**`test/widget_test.dart`**

10. **Smoke test only** — The widget test verifies the screen title appears but does not:
    - Test form validation (submitting with empty fields, zero values)
    - Test successful submit + navigation to home
    - Test that `_isSaving` correctly disables the button during save
    - Test the error case when `saveProfile` fails (CRIT-2 would be caught here)

11. **No test for redirect from `/` to `/onboarding` when profile exists** — The inverse redirect (profile exists, user navigates to `/onboarding`, should redirect to `/`) is not tested.

12. **Memory database in widget test is not properly closed** — The `AppDatabase(NativeDatabase.memory())` created in the override at line 16 is never closed in a `tearDown`. This may cause resource warnings in CI.

---

## Architecture Compliance

### Violations and Gaps

**1. Abstract interface placement violates layer boundary**

`lib/data/repositories/user_profile_repository.dart` contains both the abstract interface `UserProfileRepository` and its concrete Drift implementation `DriftUserProfileRepository` in the same file (lines 8–23 and 27–72). Per the story AC (AC6) and the architecture rules, the abstract interface is a domain-layer contract. It should live in `lib/domain/training/repositories/user_profile_repository.dart` to enforce the dependency inversion principle: the domain defines the interface, and the data layer implements it. Currently, the domain layer has zero knowledge of the repository contract, which means domain logic (future use-case classes) cannot depend on the interface without importing from the `data/` layer, violating the architecture boundary.

**2. `updateUserProfile` has no story-level traceability and no UI path**

`updateUserProfile` is defined in the repository interface (MAJ-3), implemented, and tested, but there is no provider method that calls it and no widget that uses it. It is implemented for a future story but was counted toward Story 1.2's task completion (Task 4.1). This creates a false sense of completeness — the method was checked off without a corresponding UI or provider integration for this story.

**3. Domain model `unlockedMoveIds` field is mutable by reference**

`lib/domain/training/models/user_profile.dart` line 49:
```dart
final List<String> unlockedMoveIds = const [];
```

The field is declared `final` and defaults to a `const []`, which is correct for the default. However, `copyWith` at line 74 passes the caller's `List<String>` directly into the new `UserProfile` without copying it:
```dart
unlockedMoveIds: unlockedMoveIds ?? this.unlockedMoveIds,
```

If a caller passes a mutable `List<String>` to `copyWith`, the `UserProfile` holds a reference to that same list. The caller can then mutate the list externally, breaking immutability. The class is annotated `@immutable` but the `meta` package's `@immutable` annotation does not enforce deep immutability. The fix is `List<String>.unmodifiable(unlockedMoveIds)` in the constructor and `copyWith`, or requiring callers to pass `const` lists (not enforced at compile time).

**4. `DriftUserProfileRepository` depends on `AppDatabase` concrete class, not an abstraction**

`lib/data/repositories/user_profile_repository.dart` line 31:
```dart
final AppDatabase _db;
```

The repository depends on the concrete `AppDatabase` rather than an abstract database interface. This makes the repository untestable without a real (or in-memory) Drift database — you cannot mock `AppDatabase` without a mock library specifically for Drift. The `mocktail` package is listed in `pubspec.yaml` dev dependencies but is not used in any test. All repository tests use `NativeDatabase.memory()` which is correct, but the tight coupling to `AppDatabase` means any future database refactoring requires changing the repository, not just providing a new executor.

---

## Summary Table

| ID | Severity | File | Issue |
|----|----------|------|-------|
| CRIT-1 | Critical | `app_database.dart:25` | `deleteTable` string literal instead of `drop()` — brittle migration |
| CRIT-2 | Critical | `onboarding_screen.dart:36-48` | `_isSaving` never reset on failure; no error path; unconditional navigation |
| CRIT-3 | Critical | `user_profile.dart:79-104` | `unlockedMoveIds` excluded from `operator==` and `hashCode` |
| MAJ-1 | Major | `app_router.dart:15-29` | `_RouterNotifier` and `GoRouter` never disposed |
| MAJ-2 | Major | `user_profile_repository.dart:52,67` | Null-assertion `saved!` / `updated!` not caught by `on Exception` |
| MAJ-3 | Major | `user_profile_providers.dart` | `updateUserProfile` is dead code — no provider method exposes it |
| MAJ-4 | Major | `user_profile_mapper.dart:61-64` | `_decodeIds` unguarded cast — `Error` escapes `on Exception` catch |
| MAJ-5 | Major | `app_router.dart:39` | Database errors silently swallowed in router redirect |
| MIN-1 | Minor | `user_profile_table.dart:8` | `autoIncrement` does not enforce singleton constraint at DB level |
| MIN-2 | Minor | `five_rm_input_card.dart:33-41` | No upper-bound validation on 5RM values |
| MIN-3 | Minor | `repository_providers.dart:15` | `ref.read` instead of `ref.watch` in provider body |
| MIN-4 | Minor | `onboarding_screen.dart:40` | `double.parse` without guard where `double.tryParse` was already used |
| MIN-5 | Minor | `app_database.dart:25` | Undocumented divergence from story spec's migration API |
| MIN-6 | Minor | `user_profile.dart` | No `toString` on central state object |
