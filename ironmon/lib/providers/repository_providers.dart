import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/repositories/user_profile_repository.dart';

/// Singleton [AppDatabase] provider — shared across all repositories.
/// Disposes the database connection when the provider is disposed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Singleton [UserProfileRepository] provider.
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return DriftUserProfileRepository(ref.read(appDatabaseProvider));
});
