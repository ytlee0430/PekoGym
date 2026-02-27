import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

/// Abstract interface for [UserProfile] persistence.
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

  /// Atomically persists calibration-updated profile.
  /// Use this instead of [updateUserProfile] after calibration
  /// to ensure no partial writes on interruption.
  Future<Result<UserProfile, Exception>> updateCalibration(
    UserProfile profile,
  );
}
