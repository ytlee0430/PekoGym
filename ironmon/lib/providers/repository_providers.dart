import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/data/repositories/battle_state_repository.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/repositories/move_repository.dart';
import 'package:ironmon/data/repositories/user_profile_repository.dart';
import 'package:ironmon/data/repositories/workout_session_repository.dart';
import 'package:ironmon/domain/moves/move_registry.dart';
import 'package:ironmon/domain/training/repositories/user_profile_repository.dart';

/// Database provider. Singleton instance shared across all repositories.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Singleton [UserProfileRepository] provider.
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return DriftUserProfileRepository(ref.watch(appDatabaseProvider));
});

/// Provides the [MoveRepository] for loading move data.
final moveRepositoryProvider =
    Provider<MoveRepository>((ref) {
  return const MoveRepository();
});

/// Loads and caches the [MoveRegistry] from JSON assets.
final moveRegistryProvider =
    FutureProvider<MoveRegistry>((ref) async {
  final repository = ref.watch(moveRepositoryProvider);
  final moves = await repository.loadMoves();
  return MoveRegistry(moves);
});

/// Provides the [BattleStateRepository].
final battleStateRepositoryProvider =
    Provider<BattleStateRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BattleStateRepository(db);
});

/// Provides the [WorkoutSessionRepository].
final workoutSessionRepositoryProvider =
    Provider<WorkoutSessionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkoutSessionRepository(db);
});
