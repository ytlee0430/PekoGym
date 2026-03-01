import 'package:drift/drift.dart';

/// Drift table for persisting battle state.
@DataClassName('BattleStateEntity')
class BattleStates extends Table {
  /// Auto-increment primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Serialized BattlePhase as JSON.
  TextColumn get phaseJson => text()();

  /// Serialized boss list as JSON.
  TextColumn get bossesJson => text()();

  /// Index of current boss (0-2).
  IntColumn get currentBossIndex =>
      integer().withDefault(const Constant(0))();

  /// Current player HP.
  IntColumn get playerHp =>
      integer().withDefault(const Constant(100))();

  /// Maximum player HP.
  IntColumn get maxPlayerHp =>
      integer().withDefault(const Constant(100))();

  /// Serialized completed sets as JSON.
  TextColumn get completedSetsJson =>
      text().withDefault(const Constant('[]'))();

  /// Serialized damage results as JSON.
  TextColumn get damageResultsJson =>
      text().withDefault(const Constant('[]'))();

  /// Currently selected move ID.
  TextColumn get selectedMoveId =>
      text().nullable()();

  /// Gym type value string.
  TextColumn get gymTypeValue => text()();

  /// Player muscle type value string.
  TextColumn get playerMuscleTypeValue =>
      text()();

  /// Total damage dealt.
  IntColumn get totalDamageDealt =>
      integer().withDefault(const Constant(0))();

  /// Row creation timestamp.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
