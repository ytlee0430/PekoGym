import 'package:drift/drift.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/mappers/user_profile_mapper.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/domain/training/repositories/user_profile_repository.dart';

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
      await _db.into(_db.userProfiles).insertOnConflictUpdate(
            UserProfileMapper.toInsertable(profile),
          );
      final saved = await _db.select(_db.userProfiles).getSingleOrNull();
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
      final update = _db.update(_db.userProfiles)
        ..where((t) => t.id.equals(profile.id));
      await update.write(UserProfileMapper.toUpdateCompanion(profile));

      final updated = await _db.select(_db.userProfiles).getSingleOrNull();
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

  @override
  Future<Result<UserProfile, Exception>> updateCalibration(
    UserProfile profile,
  ) async {
    try {
      await _db.transaction(() async {
        final update = _db.update(_db.userProfiles)
          ..where((t) => t.id.equals(profile.id));
        await update.write(UserProfileMapper.toUpdateCompanion(profile));
      });
      final updated = await _db.select(_db.userProfiles).getSingleOrNull();
      if (updated == null) {
        return Failure(
          Exception('Profile not found after calibration'),
        );
      }
      return Success(UserProfileMapper.toDomain(updated));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void, Exception>> updateFiveRm(
    String muscleField,
    double newValue,
  ) async {
    try {
      await _db.transaction(() async {
        final companion = switch (muscleField) {
          'squat' => UserProfilesCompanion(
              squatFiveRm: Value(newValue),
            ),
          'benchPress' => UserProfilesCompanion(
              benchPressFiveRm: Value(newValue),
            ),
          'deadlift' => UserProfilesCompanion(
              deadliftFiveRm: Value(newValue),
            ),
          'overheadPress' =>
            UserProfilesCompanion(
              overheadPressFiveRm:
                  Value(newValue),
            ),
          _ => throw Exception(
              'Unknown muscle field: $muscleField',
            ),
        };
        await (_db.update(_db.userProfiles)
              ..where(
                (t) => t.id.equals(1),
              ))
            .write(companion);
      });
      return const Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
