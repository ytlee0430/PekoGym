# Story 7.1: Training Scheduler Algorithm

Status: ready-for-dev

## Story

As a player,
I want the system to recommend training splits based on my weekly frequency,
So that my workout plan is balanced and optimized.

## Acceptance Criteria

1. **Given** the player has set weekly training frequency in their profile
   **When** the scheduler evaluates the next workout
   **Then** frequency < 3 days/week → recommends Full Body (mixed type gym)
2. **And** frequency >= 3 days/week → recommends Split Routine (Push/Pull/Legs or 5-way split)
3. **And** the algorithm considers last workout date: >3 days ago → Full Body, <2 days ago → Split
4. **And** the same muscle group is scheduled at least twice per week for high-frequency plans
5. **And** the scheduler is implemented in Pure Dart domain/training/scheduler.dart
6. **And** unit tests cover all frequency tiers and edge cases

## Tasks / Subtasks

- [ ] Task 1: Create TrainingScheduler domain service (AC: 1, 2, 3, 4, 5)
  - [ ] 1.1 Create `lib/domain/training/scheduler.dart` — Pure Dart
  - [ ] 1.2 Method `recommend({required int weeklyFrequency, required List<WorkoutSession> recentSessions, required DateTime now}) → TrainingRecommendation`
  - [ ] 1.3 `TrainingRecommendation` model: `muscleTypes` (List), `gymType`, `isFullBody`, `reason`
  - [ ] 1.4 Low frequency (<3/week): return all 5 muscle types (Full Body)
  - [ ] 1.5 High frequency (≥3/week): rotate through Push/Pull/Legs split based on history
  - [ ] 1.6 Override: if >3 days since last workout, always recommend Full Body regardless of frequency

- [ ] Task 2: Create TrainingRecommendation model (AC: 1, 2)
  - [ ] 2.1 Create `lib/domain/training/models/training_recommendation.dart`
  - [ ] 2.2 Fields: `muscleTypes`, `gymType`, `isFullBody`, `reason`, `confidence`
  - [ ] 2.3 Immutable with `copyWith`

- [ ] Task 3: Split rotation logic (AC: 2, 4)
  - [ ] 3.1 Push day: chest + shoulders + arms (Fire, Electric, Fighting)
  - [ ] 3.2 Pull day: back + arms (Water, Fighting)
  - [ ] 3.3 Legs day: legs (Rock)
  - [ ] 3.4 5-way split for ≥5/week: one muscle group per day
  - [ ] 3.5 Ensure each muscle group appears ≥2x per week cycle

- [ ] Task 4: History analysis (AC: 3)
  - [ ] 4.1 Query recent `WorkoutSession` records (last 7 days)
  - [ ] 4.2 Count sessions per muscle type in last 7 days
  - [ ] 4.3 Recommend least-trained muscle group first
  - [ ] 4.4 Calculate days since last session for stale-check

- [ ] Task 5: Provider wiring (AC: 5)
  - [ ] 5.1 Add `trainingSchedulerProvider` to `lib/providers/training_providers.dart`
  - [ ] 5.2 Add `trainingRecommendationProvider` — async, reads profile + recent sessions

- [ ] Task 6: Tests (AC: 1-6)
  - [ ] 6.1 Unit test: frequency < 3 returns Full Body
  - [ ] 6.2 Unit test: frequency ≥ 3 returns Split
  - [ ] 6.3 Unit test: >3 days since last workout overrides to Full Body
  - [ ] 6.4 Unit test: rotation respects recent history
  - [ ] 6.5 Unit test: each muscle group ≥ 2x per week cycle
  - [ ] 6.6 `flutter analyze` reports zero issues

## Dev Notes

### CRITICAL — Database Is Drift 2.31.0 (NOT Isar)

Project uses Drift 2.31.0. History queries via `WorkoutSessionRepository`.

### CRITICAL — No riverpod_generator

Manual providers only.

### Split Mapping

```
Push (chest + shoulders + arms):
  MuscleType.chest, MuscleType.shoulders, MuscleType.arms

Pull (back + arms):
  MuscleType.back, MuscleType.arms

Legs:
  MuscleType.legs
```

### Recommendation Algorithm Pseudocode

```
if daysSinceLastWorkout > 3:
  return FullBody
if weeklyFrequency < 3:
  return FullBody
if weeklyFrequency >= 5:
  return leastTrainedMuscleGroup (5-way split)
else:
  return nextInPushPullLegsRotation
```

### Dependencies on Previous Stories

- **Story 1.2** — `UserProfile.weeklyFrequency`
- **Story 3.4** — `WorkoutSessionRepository` for history queries
- **Story 2.3** — `MuscleType` enum

### Existing WorkoutSession Fields

`WorkoutSession` at `lib/domain/training/models/workout_session.dart` has:
- `date` (DateTime)
- `muscleType` (String — muscle type name)
- `gymType` (String)
- `totalVolume`, `isVictory`, etc.

Query recent sessions: `repo.getRecentSessions(days: 7)`. If this method doesn't exist, add it to `WorkoutSessionRepository`.

### Architecture Compliance Rules

| Rule | Description |
|---|---|
| **Domain Boundary** | `TrainingScheduler` in `domain/training/` — Pure Dart |
| **Import Style** | `package:ironmon/...` only |
| **State Update** | Immutable models with `copyWith` |
| **very_good_analysis** | `///` doc comments; lines ≤ 80 chars |

### Project Structure Notes

New files to create:

```
ironmon/lib/domain/training/scheduler.dart
ironmon/lib/domain/training/models/training_recommendation.dart
ironmon/test/domain/training/scheduler_test.dart
```

Files to update:

```
ironmon/lib/providers/training_providers.dart (add scheduler/recommendation providers)
ironmon/lib/data/repositories/workout_session_repository.dart (add getRecentSessions if missing)
```

### References

- [Source: epics.md#Story 7.1] — User story, acceptance criteria
- [Source: spec.md#Section 4.5] — Scheduler algorithm (frequency tiers, split logic)
- [Source: architecture.md#Domain Layer] — Pure Dart domain services

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
