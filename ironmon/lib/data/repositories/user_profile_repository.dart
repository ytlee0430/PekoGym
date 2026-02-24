import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/mappers/user_profile_mapper.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

/// Abstract interface for [UserProfile] persistence.
/// Implemented by [DriftUserProfileRepository].
abstract class UserProfileRepository {
  /// Returns the singleton [UserProfile] or null on first launch.
  Future<Result<UserProfile?, Exception>> getUserProfile();

  /// Upserts [profile] using singleton id=1.
  /// Returns the saved profile (with generated id) on success.
  Future<Result<UserProfile, Exception>> saveUserProfile(
    UserProfile profile,
  );

  /// Updates the existing [profile] fields.
  /// Profile must already exist (id > 0).
  Future<Result<UserProfile, Exception>> updateUserProfile(
    UserProfile profile,
  );
}

/// Drift-backed implementation of [UserProfileRepository].
/// All Drift entity mapping is delegated to [UserProfileMapper].
class DriftUserProfileRepository implements UserProfileRepository {
  /// Creates a [DriftUserProfileRepository] with the given [_db].
  const DriftUserProfileRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<UserProfile?, Exception>> getUserProfile() async {
    try {
      final row = await _db.select(_db.userProfiles).getSingleOrNull();
      return Success(row != null ? UserProfileMapper.toDomain(row) : null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<UserProfile, Exception>> saveUserProfile(
    UserProfile profile,
  ) async {
    try {
      await _db
          .into(_db.userProfiles)
          .insertOnConflictUpdate(
            UserProfileMapper.toInsertable(profile),
          );
      final saved =
          await _db.select(_db.userProfiles).getSingleOrNull();
      if (saved == null) {
        return Failure(
          Exception('Profile not found after save'),
        );
      }
      return Success(UserProfileMapper.toDomain(saved));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<UserProfile, Exception>> updateUserProfile(
    UserProfile profile,
  ) async {
    try {
      await (_db.update(_db.userProfiles)
            ..where((t) => t.id.equals(profile.id)))
          .write(UserProfileMapper.toUpdateCompanion(profile));
      final updated =
          await _db.select(_db.userProfiles).getSingleOrNull();
      if (updated == null) {
        return Failure(
          Exception('Profile not found after update'),
        );
      }
      return Success(UserProfileMapper.toDomain(updated));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
