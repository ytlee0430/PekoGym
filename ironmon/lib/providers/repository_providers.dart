import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/repositories/user_profile_repository.dart';
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
