import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';

/// Maps between [ExerciseSet] domain model
/// and Drift [ExerciseSetEntity].
class ExerciseSetMapper {
  const ExerciseSetMapper._();

  /// Converts a Drift entity to domain model.
  static ExerciseSet toDomain(
    ExerciseSetEntity entity,
  ) {
    return ExerciseSet(
      moveId: entity.moveId,
      weight: entity.weight,
      reps: entity.reps,
      rpe: entity.rpe,
      setNumber: entity.setNumber,
    );
  }

  /// Converts a domain model to Drift insertable
  /// with a session ID foreign key.
  static ExerciseSetsCompanion toInsertable(
    ExerciseSet set,
    int sessionId, {
    int damage = 0,
  }) {
    return ExerciseSetsCompanion.insert(
      sessionId: sessionId,
      moveId: set.moveId,
      setNumber: set.setNumber,
      weight: set.weight,
      reps: set.reps,
      rpe: set.rpe,
      damage: damage,
    );
  }
}
