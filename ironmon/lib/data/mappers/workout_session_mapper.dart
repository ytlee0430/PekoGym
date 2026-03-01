import 'package:drift/drift.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';

/// Maps between [WorkoutSession] domain model
/// and Drift [WorkoutSessionEntity].
class WorkoutSessionMapper {
  const WorkoutSessionMapper._();

  /// Converts a Drift entity to domain model.
  static WorkoutSession toDomain(
    WorkoutSessionEntity entity,
  ) {
    return WorkoutSession(
      id: entity.id,
      date: entity.date,
      gymType: entity.gymType,
      muscleType: entity.muscleType,
      totalVolume: entity.totalVolume,
      totalDamage: entity.totalDamage,
      totalSets: entity.totalSets,
      isVictory: entity.isVictory,
      expEarned: entity.expEarned,
      durationSeconds: entity.durationSeconds,
    );
  }

  /// Converts a domain model to Drift insertable.
  static WorkoutSessionsCompanion toInsertable(
    WorkoutSession session,
  ) {
    return WorkoutSessionsCompanion.insert(
      date: session.date,
      gymType: session.gymType,
      muscleType: session.muscleType,
      totalVolume: session.totalVolume,
      totalDamage: session.totalDamage,
      totalSets: session.totalSets,
      isVictory: session.isVictory,
      expEarned: session.expEarned,
      durationSeconds: Value(
        session.durationSeconds,
      ),
    );
  }
}
