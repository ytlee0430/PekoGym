import 'package:ironmon/domain/training/models/training_recommendation.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// All five muscle types for full-body training.
const _allMuscles = [
  MuscleType.chest,
  MuscleType.back,
  MuscleType.legs,
  MuscleType.shoulders,
  MuscleType.arms,
];

/// Push day muscle groups (chest + shoulders + arms).
const _pushMuscles = [
  MuscleType.chest,
  MuscleType.shoulders,
  MuscleType.arms,
];

/// Pull day muscle groups (back + arms).
const _pullMuscles = [
  MuscleType.back,
  MuscleType.arms,
];

/// Legs day muscle groups.
const _legsMuscles = [MuscleType.legs];

/// Push/Pull/Legs rotation order.
const _pplRotation = [
  _pushMuscles,
  _pullMuscles,
  _legsMuscles,
];

/// Pure-Dart domain service that recommends the
/// next training split based on frequency and
/// workout history.
class TrainingScheduler {
  /// Creates a [TrainingScheduler].
  const TrainingScheduler();

  /// Returns a [TrainingRecommendation] for the
  /// next session.
  ///
  /// Algorithm:
  /// - If >3 days since last workout → Full Body
  /// - If weeklyFrequency < 3 → Full Body
  /// - If weeklyFrequency >= 5 → least-trained
  ///   muscle (5-way split)
  /// - Otherwise → Push/Pull/Legs rotation
  TrainingRecommendation recommend({
    required int weeklyFrequency,
    required List<WorkoutSession> recentSessions,
    required DateTime now,
  }) {
    final daysSinceLast = _daysSinceLast(
      recentSessions,
      now,
    );

    // Override: stale — always full body
    if (daysSinceLast > 3) {
      return TrainingRecommendation(
        muscleTypes: List.unmodifiable(_allMuscles),
        isFullBody: true,
        reason: '${daysSinceLast}d since last '
            'workout — Full Body recovery',
      );
    }

    // Low frequency → Full Body
    if (weeklyFrequency < 3) {
      return TrainingRecommendation(
        muscleTypes: List.unmodifiable(_allMuscles),
        isFullBody: true,
        reason: 'Low frequency '
            '($weeklyFrequency/wk) — Full Body',
      );
    }

    // High frequency ≥5 → 5-way least-trained
    if (weeklyFrequency >= 5) {
      final muscle = _leastTrained(
        recentSessions,
        now,
      );
      return TrainingRecommendation(
        muscleTypes: [muscle],
        isFullBody: false,
        reason: 'High frequency — '
            '${muscle.name} least trained',
        confidence: 0.9,
      );
    }

    // 3–4/week → Push/Pull/Legs rotation
    final next = _nextPpl(recentSessions);
    return TrainingRecommendation(
      muscleTypes: List.unmodifiable(next),
      isFullBody: false,
      reason: 'Push/Pull/Legs rotation',
    );
  }

  /// Days since the most recent session.
  /// Returns 999 if no sessions exist.
  double _daysSinceLast(
    List<WorkoutSession> sessions,
    DateTime now,
  ) {
    if (sessions.isEmpty) return 999;
    final sorted = [...sessions]
      ..sort((a, b) => b.date.compareTo(a.date));
    final diff = now.difference(sorted.first.date);
    return diff.inHours / 24.0;
  }

  /// Returns the muscle group with the fewest
  /// sessions in the last 7 days.
  MuscleType _leastTrained(
    List<WorkoutSession> sessions,
    DateTime now,
  ) {
    final cutoff =
        now.subtract(const Duration(days: 7));
    final recent = sessions
        .where((s) => s.date.isAfter(cutoff))
        .toList();

    final counts = <MuscleType, int>{
      for (final m in _allMuscles) m: 0,
    };
    for (final s in recent) {
      final m = _parseMuscle(s.muscleType);
      if (m != null) counts[m] = (counts[m]! + 1);
    }

    // Sort by count ascending, then by enum index
    // for deterministic results
    return _allMuscles.reduce((a, b) {
      final diff = counts[a]! - counts[b]!;
      if (diff != 0) return diff < 0 ? a : b;
      return a.index < b.index ? a : b;
    });
  }

  /// Determines the next PPL slot based on history.
  List<MuscleType> _nextPpl(
    List<WorkoutSession> sessions,
  ) {
    if (sessions.isEmpty) return _pushMuscles;

    // Find the last session muscle type
    final sorted = [...sessions]
      ..sort((a, b) => b.date.compareTo(a.date));
    final lastMuscle =
        _parseMuscle(sorted.first.muscleType);

    // Advance rotation based on last day
    if (lastMuscle == null) return _pushMuscles;
    if (_pushMuscles.contains(lastMuscle)) {
      return _pullMuscles;
    }
    if (_pullMuscles.contains(lastMuscle)) {
      return _legsMuscles;
    }
    return _pushMuscles;
  }

  MuscleType? _parseMuscle(String raw) {
    return MuscleType.values.where(
      (m) => m.name == raw,
    ).firstOrNull;
  }
}
