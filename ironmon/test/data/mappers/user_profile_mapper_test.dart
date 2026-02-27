import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/mappers/user_profile_mapper.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  group('UserProfileMapper', () {
    const entity = UserProfileEntity(
      id: 1,
      level: 5,
      experiencePoints: 200,
      squatFiveRm: 100,
      benchPressFiveRm: 80,
      deadliftFiveRm: 120,
      overheadPressFiveRm: 60,
      weeklyFrequency: 4,
      isBeginnerMode: true,
      calibrationSessionsCompleted: 2,
      calibrationTargetSessions: 5,
      unlockedMoveIds: '["push_up","squat"]',
    );

    group('toDomain', () {
      test('maps all scalar fields correctly', () {
        final profile = UserProfileMapper.toDomain(entity);
        expect(profile.id, 1);
        expect(profile.level, 5);
        expect(profile.experiencePoints, 200);
        expect(profile.squatFiveRm, 100);
        expect(profile.benchPressFiveRm, 80);
        expect(profile.deadliftFiveRm, 120);
        expect(profile.overheadPressFiveRm, 60);
        expect(profile.weeklyFrequency, 4);
        expect(profile.isBeginnerMode, isTrue);
        expect(profile.calibrationSessionsCompleted, 2);
        expect(profile.calibrationTargetSessions, 5);
      });

      test('decodes JSON unlockedMoveIds to List<String>', () {
        final profile = UserProfileMapper.toDomain(entity);
        expect(profile.unlockedMoveIds, ['push_up', 'squat']);
      });

      test('decodes empty JSON array to empty list', () {
        final empty = entity.copyWith(unlockedMoveIds: '[]');
        final profile = UserProfileMapper.toDomain(empty);
        expect(profile.unlockedMoveIds, isEmpty);
      });
    });

    group('toInsertable', () {
      test('forces id = Value(1) for singleton upsert', () {
        const profile = UserProfile(id: 99);
        final companion = UserProfileMapper.toInsertable(profile);
        expect(companion.id, const Value(1));
      });

      test('encodes unlockedMoveIds as JSON string', () {
        const profile = UserProfile(
          unlockedMoveIds: ['push_up', 'squat'],
        );
        final companion = UserProfileMapper.toInsertable(profile);
        expect(companion.unlockedMoveIds.value, '["push_up","squat"]');
      });

      test('encodes empty unlockedMoveIds as empty JSON array', () {
        const profile = UserProfile();
        final companion = UserProfileMapper.toInsertable(profile);
        expect(companion.unlockedMoveIds.value, '[]');
      });

      test('maps all numeric fields', () {
        const profile = UserProfile(
          level: 3,
          experiencePoints: 50,
          squatFiveRm: 90,
          benchPressFiveRm: 70,
          deadliftFiveRm: 110,
          overheadPressFiveRm: 55,
          weeklyFrequency: 5,
          isBeginnerMode: true,
        );
        final companion = UserProfileMapper.toInsertable(profile);
        expect(companion.level.value, 3);
        expect(companion.experiencePoints.value, 50);
        expect(companion.squatFiveRm.value, 90);
        expect(companion.benchPressFiveRm.value, 70);
        expect(companion.deadliftFiveRm.value, 110);
        expect(companion.overheadPressFiveRm.value, 55);
        expect(companion.weeklyFrequency.value, 5);
        expect(companion.isBeginnerMode.value, isTrue);
      });

      test('maps calibration fields in toInsertable', () {
        const profile = UserProfile(calibrationSessionsCompleted: 3);
        final companion = UserProfileMapper.toInsertable(profile);
        expect(companion.calibrationSessionsCompleted.value, 3);
        expect(companion.calibrationTargetSessions.value, 5);
      });

      test('round-trips calibrationSessionsCompleted through '
          'toInsertable → toDomain', () {
        const profile = UserProfile(
          id: 1,
          calibrationSessionsCompleted: 3,
        );
        final companion = UserProfileMapper.toInsertable(profile);
        final reconstructed = UserProfileEntity(
          id: companion.id.value,
          level: companion.level.value,
          experiencePoints: companion.experiencePoints.value,
          squatFiveRm: companion.squatFiveRm.value,
          benchPressFiveRm: companion.benchPressFiveRm.value,
          deadliftFiveRm: companion.deadliftFiveRm.value,
          overheadPressFiveRm: companion.overheadPressFiveRm.value,
          weeklyFrequency: companion.weeklyFrequency.value,
          isBeginnerMode: companion.isBeginnerMode.value,
          calibrationSessionsCompleted:
              companion.calibrationSessionsCompleted.value,
          calibrationTargetSessions:
              companion.calibrationTargetSessions.value,
          unlockedMoveIds: companion.unlockedMoveIds.value,
        );
        final domain = UserProfileMapper.toDomain(reconstructed);
        expect(domain.calibrationSessionsCompleted, 3);
        expect(domain.calibrationTargetSessions, 5);
      });
    });

    group('toUpdateCompanion', () {
      test('omits id field (present == false)', () {
        const profile = UserProfile(id: 1, level: 7);
        final companion = UserProfileMapper.toUpdateCompanion(profile);
        expect(companion.id.present, isFalse);
      });

      test('includes all non-id fields', () {
        const profile = UserProfile(
          level: 7,
          experiencePoints: 300,
          squatFiveRm: 110,
          weeklyFrequency: 6,
          isBeginnerMode: true,
        );
        final companion = UserProfileMapper.toUpdateCompanion(profile);
        expect(companion.level.value, 7);
        expect(companion.experiencePoints.value, 300);
        expect(companion.squatFiveRm.value, 110);
        expect(companion.weeklyFrequency.value, 6);
        expect(companion.isBeginnerMode.value, isTrue);
      });

      test('maps calibration fields in toUpdateCompanion', () {
        const profile = UserProfile(
          id: 1,
          calibrationSessionsCompleted: 2,
        );
        final companion = UserProfileMapper.toUpdateCompanion(profile);
        expect(companion.calibrationSessionsCompleted.value, 2);
        expect(companion.calibrationTargetSessions.value, 5);
      });
    });
  });
}
