import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/training/beginner_calibration_service.dart';
import 'package:ironmon/domain/training/exp_calculator.dart';
import 'package:ironmon/domain/training/level_system.dart';
import 'package:ironmon/domain/training/daily_mission_service.dart';
import 'package:ironmon/domain/training/models/daily_mission.dart';
import 'package:ironmon/domain/training/models/training_recommendation.dart';
import 'package:ironmon/domain/training/pr_detector.dart';
import 'package:ironmon/domain/training/scheduler.dart';
import 'package:ironmon/domain/moves/move_unlock_service.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';
import 'package:ironmon/providers/repository_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Singleton [BeginnerCalibrationService] provider.
/// Stateless pure-Dart service — created once and reused.
final beginnerCalibrationServiceProvider =
    Provider<BeginnerCalibrationService>((ref) {
  return const BeginnerCalibrationService();
});

/// Provides the [ExpCalculator] instance.
final expCalculatorProvider =
    Provider<ExpCalculator>((ref) {
  return const ExpCalculator();
});

/// Provides the [LevelSystem] instance.
final levelSystemProvider =
    Provider<LevelSystem>((ref) {
  return const LevelSystem();
});

/// Provides the [PRDetector] instance.
final prDetectorProvider =
    Provider<PRDetector>((ref) {
  return const PRDetector();
});

/// Provides the [MoveUnlockService] instance.
final moveUnlockServiceProvider =
    Provider<MoveUnlockService>((ref) {
  return const MoveUnlockService();
});

/// Provides the [DailyMissionService] instance.
final dailyMissionServiceProvider =
    Provider<DailyMissionService>((ref) {
  return const DailyMissionService();
});

/// Async provider for today's [DailyMission].
final dailyMissionProvider =
    FutureProvider<DailyMission?>((ref) async {
  final recAsync =
      await ref.watch(
        trainingRecommendationProvider.future,
      );
  if (recAsync == null) return null;
  final svc =
      ref.read(dailyMissionServiceProvider);
  return svc.generateMission(
    recommendation: recAsync,
    date: DateTime.now(),
  );
});

/// Provides the [TrainingScheduler] instance.
final trainingSchedulerProvider =
    Provider<TrainingScheduler>((ref) {
  return const TrainingScheduler();
});

/// Async provider that computes a
/// [TrainingRecommendation] from profile +
/// recent sessions.
final trainingRecommendationProvider =
    FutureProvider<TrainingRecommendation?>((
  ref,
) async {
  final profile =
      ref.watch(userProfileProvider).value;
  if (profile == null) return null;

  final repo = ref.read(
    workoutSessionRepositoryProvider,
  );
  final result = await repo.getSessionsByDays(7);
  final sessions = result
      is Success<List<WorkoutSession>, Exception>
      ? (result as Success<
              List<WorkoutSession>, Exception>)
          .value
      : const <WorkoutSession>[];

  final scheduler =
      ref.read(trainingSchedulerProvider);
  return scheduler.recommend(
    weeklyFrequency: profile.weeklyFrequency,
    recentSessions: sessions,
    now: DateTime.now(),
  );
});
