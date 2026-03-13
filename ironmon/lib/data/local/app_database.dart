import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:ironmon/data/local/tables/battle_state_table.dart';
import 'package:ironmon/data/local/tables/exercise_set_table.dart';
import 'package:ironmon/data/local/tables/user_profile_table.dart';
import 'package:ironmon/data/local/tables/workout_session_table.dart';

part 'app_database.g.dart';

/// IronMon Drift database.
/// Pass a custom [executor] to inject an in-memory database for tests
/// (e.g. `NativeDatabase.memory()`).
@DriftDatabase(
  tables: [
    UserProfiles,
    BattleStates,
    WorkoutSessions,
    ExerciseSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the database using the provided or default executor.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // MVP pre-release: drop and recreate (data loss acceptable).
            await m.drop(userProfiles);
            await m.createTable(userProfiles);
          }
          if (from < 3) {
            // Additive migration — preserves existing profile data.
            await m.addColumn(
              userProfiles,
              userProfiles.calibrationSessionsCompleted,
            );
            await m.addColumn(
              userProfiles,
              userProfiles.calibrationTargetSessions,
            );
          }
          if (from < 4) {
            await m.createTable(battleStates);
          }
          if (from < 5) {
            await m.createTable(workoutSessions);
            await m.createTable(exerciseSets);
          }
          if (from < 6) {
            await m.addColumn(
              userProfiles,
              userProfiles.maxPp,
            );
            await m.addColumn(
              userProfiles,
              userProfiles.currentPp,
            );
          }
          if (from < 7) {
            await m.addColumn(
              userProfiles,
              userProfiles.potionCount,
            );
            await m.addColumn(
              userProfiles,
              userProfiles.etherCount,
            );
            await m.addColumn(
              userProfiles,
              userProfiles.rareCandyCount,
            );
          }
          if (from < 8) {
            await m.addColumn(
              userProfiles,
              userProfiles.coins,
            );
          }
          if (from < 9) {
            await m.addColumn(
              userProfiles,
              userProfiles.exerciseFiveRms,
            );
          }
          if (from < 10) {
            await m.addColumn(
              userProfiles,
              userProfiles.gender,
            );
            await m.addColumn(
              userProfiles,
              userProfiles.bodyWeightKg,
            );
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'ironmon_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            debugPrint(
              'drift_flutter: using ${result.chosenImplementation} due to '
              'missing browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }
}
