import 'package:drift/drift.dart';
import 'package:ironmon/data/local/tables/workout_session_table.dart';

/// Drift table for exercise sets linked to
/// workout sessions.
@DataClassName('ExerciseSetEntity')
class ExerciseSets extends Table {
  /// Auto-increment primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to WorkoutSessions.
  IntColumn get sessionId => integer()
      .references(WorkoutSessions, #id)();

  /// Move ID used for this set.
  TextColumn get moveId => text()();

  /// Set number within the session.
  IntColumn get setNumber => integer()();

  /// Weight lifted in kg.
  RealColumn get weight => real()();

  /// Number of reps completed.
  IntColumn get reps => integer()();

  /// Rate of perceived exertion (1-10).
  IntColumn get rpe => integer()();

  /// Damage dealt by this set.
  IntColumn get damage => integer()();
}
