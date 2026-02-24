import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ironmon/data/local/tables/user_profile_table.dart';

part 'app_database.g.dart';

/// IronMon Drift database.
/// Pass a custom [executor] to inject an in-memory database for tests
/// (e.g. `NativeDatabase.memory()`).
@DriftDatabase(tables: [UserProfiles])
class AppDatabase extends _$AppDatabase {
  /// Opens the database using the provided or default executor.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // MVP pre-release: drop and recreate (data loss acceptable).
            await m.drop(userProfiles);
            await m.createTable(userProfiles);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ironmon_db');
  }
}
