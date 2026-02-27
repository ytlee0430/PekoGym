import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/providers/repository_providers.dart';

/// Loads and caches the [UserProfile] asynchronously.
/// Returns null when no profile exists (first launch).
final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

/// Notifier that manages [UserProfile] load and save operations.
class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final result =
        await ref.watch(userProfileRepositoryProvider).getUserProfile();
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }

  /// Saves [profile] to the database and updates provider state.
  Future<void> saveProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(userProfileRepositoryProvider)
        .saveUserProfile(profile);
    state = switch (result) {
      Success(:final value) => AsyncValue.data(value),
      Failure(:final error) => AsyncValue.error(error, StackTrace.current),
    };
  }

  /// Updates an existing [profile] in the database and updates provider state.
  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(userProfileRepositoryProvider)
        .updateUserProfile(profile);
    state = switch (result) {
      Success(:final value) => AsyncValue.data(value),
      Failure(:final error) => AsyncValue.error(error, StackTrace.current),
    };
  }

  /// Persists calibration results atomically.
  Future<void> updateCalibration(UserProfile profile) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(userProfileRepositoryProvider)
        .updateCalibration(profile);
    state = switch (result) {
      Success(:final value) => AsyncValue.data(value),
      Failure(:final error) =>
        AsyncValue.error(error, StackTrace.current),
    };
  }
}
