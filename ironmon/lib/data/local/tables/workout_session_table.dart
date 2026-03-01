import 'package:drift/drift.dart';

/// Drift table for workout session history.
@DataClassName('WorkoutSessionEntity')
class WorkoutSessions extends Table {
  /// Auto-increment primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Session date/time.
  DateTimeColumn get date => dateTime()();

  /// Gym type value string.
  TextColumn get gymType => text()();

  /// Player muscle type value string.
  TextColumn get muscleType => text()();

  /// Total volume (weight × reps) in kg.
  RealColumn get totalVolume => real()();

  /// Total damage dealt.
  IntColumn get totalDamage => integer()();

  /// Total sets completed.
  IntColumn get totalSets => integer()();

  /// Whether the player won.
  BoolColumn get isVictory => boolean()();

  /// EXP earned from this session.
  IntColumn get expEarned => integer()();

  /// Session duration in seconds (optional).
  IntColumn get durationSeconds =>
      integer().nullable()();
}
