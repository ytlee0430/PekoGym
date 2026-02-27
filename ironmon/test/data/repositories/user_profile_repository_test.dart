import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/repositories/user_profile_repository.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  group('DriftUserProfileRepository', () {
    late AppDatabase db;
    late DriftUserProfileRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftUserProfileRepository(db);
    });

    tearDown(() async => db.close());

    test('getUserProfile returns null when table is empty', () async {
      final result = await repo.getUserProfile();
      expect(result, isA<Success<UserProfile?, Exception>>());
      expect((result as Success<UserProfile?, Exception>).value, isNull);
    });

    test('saveUserProfile inserts profile and returns it with id = 1',
        () async {
      const profile = UserProfile(
        squatFiveRm: 100,
        benchPressFiveRm: 80,
        deadliftFiveRm: 120,
        overheadPressFiveRm: 60,
      );
      final result = await repo.saveUserProfile(profile);
      expect(result, isA<Success<UserProfile, Exception>>());
      final saved = (result as Success<UserProfile, Exception>).value;
      expect(saved.id, 1);
      expect(saved.squatFiveRm, 100);
    });

    test('getUserProfile returns saved profile', () async {
      const profile = UserProfile(level: 3, squatFiveRm: 80);
      await repo.saveUserProfile(profile);

      final result = await repo.getUserProfile();
      final found = (result as Success<UserProfile?, Exception>).value;
      expect(found, isNotNull);
      expect(found!.level, 3);
      expect(found.squatFiveRm, 80);
    });

    test('saveUserProfile upserts — second call overwrites first', () async {
      const first = UserProfile(squatFiveRm: 100);
      const second = UserProfile(squatFiveRm: 120, weeklyFrequency: 5);
      await repo.saveUserProfile(first);

      final result = await repo.saveUserProfile(second);
      final saved = (result as Success<UserProfile, Exception>).value;
      expect(saved.id, 1);
      expect(saved.squatFiveRm, 120);
      expect(saved.weeklyFrequency, 5);
    });

    test('updateUserProfile updates fields of existing profile', () async {
      const initial = UserProfile(squatFiveRm: 80);
      await repo.saveUserProfile(initial);

      final updated = initial.copyWith(
        id: 1,
        level: 5,
        squatFiveRm: 100,
      );
      final result = await repo.updateUserProfile(updated);
      final profile = (result as Success<UserProfile, Exception>).value;
      expect(profile.level, 5);
      expect(profile.squatFiveRm, 100);
    });

    test('saveUserProfile preserves unlockedMoveIds round-trip', () async {
      const profile = UserProfile(
        unlockedMoveIds: ['push_up', 'squat'],
      );
      final result = await repo.saveUserProfile(profile);
      final saved = (result as Success<UserProfile, Exception>).value;
      expect(saved.unlockedMoveIds, ['push_up', 'squat']);
    });

    test('saveUserProfile persists calibration fields', () async {
      const profile = UserProfile(
        isBeginnerMode: true,
        calibrationSessionsCompleted: 2,
      );
      final result = await repo.saveUserProfile(profile);
      final saved = (result as Success<UserProfile, Exception>).value;
      expect(saved.isBeginnerMode, isTrue);
      expect(saved.calibrationSessionsCompleted, 2);
      expect(saved.calibrationTargetSessions, 5);
    });

    test('updateCalibration atomically persists all calibration fields',
        () async {
      const initial = UserProfile(
        squatFiveRm: 20,
        isBeginnerMode: true,
      );
      await repo.saveUserProfile(initial);

      final updated = initial.copyWith(
        id: 1,
        squatFiveRm: 45,
        calibrationSessionsCompleted: 1,
      );
      final result = await repo.updateCalibration(updated);
      expect(result, isA<Success<UserProfile, Exception>>());
      final saved = (result as Success<UserProfile, Exception>).value;
      expect(saved.squatFiveRm, 45);
      expect(saved.calibrationSessionsCompleted, 1);
      expect(saved.isBeginnerMode, isTrue);
    });

    test(
        'updateCalibration sets isBeginnerMode false when sessions '
        'reach target', () async {
      const initial = UserProfile(
        isBeginnerMode: true,
        calibrationSessionsCompleted: 4,
      );
      await repo.saveUserProfile(initial);

      final updated = initial.copyWith(
        id: 1,
        calibrationSessionsCompleted: 5,
        isBeginnerMode: false,
      );
      final result = await repo.updateCalibration(updated);
      final saved = (result as Success<UserProfile, Exception>).value;
      expect(saved.calibrationSessionsCompleted, 5);
      expect(saved.isBeginnerMode, isFalse);
    });
  });
}
