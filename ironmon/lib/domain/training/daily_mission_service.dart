import 'package:ironmon/domain/training/models/daily_mission.dart';
import 'package:ironmon/domain/training/models/training_recommendation.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';

/// Pure-Dart service for generating and checking
/// daily training missions.
class DailyMissionService {
  /// Creates a [DailyMissionService].
  const DailyMissionService();

  /// Generates a [DailyMission] from a
  /// [TrainingRecommendation].
  DailyMission generateMission({
    required TrainingRecommendation recommendation,
    required DateTime date,
  }) {
    return DailyMission(
      recommendedMuscleTypes:
          recommendation.muscleTypes,
      isFullBody: recommendation.isFullBody,
      reason: recommendation.reason,
      date: date,
      bonusExp: 20,
    );
  }

  /// Checks whether a [WorkoutSession] satisfies
  /// a [DailyMission] (muscle type must match).
  bool checkCompletion(
    DailyMission mission,
    WorkoutSession session,
  ) {
    return mission.recommendedMuscleTypes
        .any((m) => m.name == session.muscleType);
  }

  /// Returns the EXP multiplier for a session.
  /// 1.2 if it matches the mission, else 1.0.
  double expMultiplier(
    DailyMission? mission,
    WorkoutSession session,
  ) {
    if (mission == null) return 1.0;
    if (!checkCompletion(mission, session)) {
      return 1.0;
    }
    return 1.0 + mission.bonusExp / 100.0;
  }
}
