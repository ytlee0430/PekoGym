import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    group('default values', () {
      test('id defaults to 0', () {
        const profile = UserProfile();
        expect(profile.id, 0);
      });

      test('level defaults to 1', () {
        const profile = UserProfile();
        expect(profile.level, 1);
      });

      test('experiencePoints defaults to 0', () {
        const profile = UserProfile();
        expect(profile.experiencePoints, 0);
      });

      test('squatFiveRm defaults to 0.0', () {
        const profile = UserProfile();
        expect(profile.squatFiveRm, 0);
      });

      test('benchPressFiveRm defaults to 0.0', () {
        const profile = UserProfile();
        expect(profile.benchPressFiveRm, 0);
      });

      test('deadliftFiveRm defaults to 0.0', () {
        const profile = UserProfile();
        expect(profile.deadliftFiveRm, 0);
      });

      test('overheadPressFiveRm defaults to 0.0', () {
        const profile = UserProfile();
        expect(profile.overheadPressFiveRm, 0);
      });

      test('weeklyFrequency defaults to 3', () {
        const profile = UserProfile();
        expect(profile.weeklyFrequency, 3);
      });

      test('isBeginnerMode defaults to false', () {
        const profile = UserProfile();
        expect(profile.isBeginnerMode, isFalse);
      });

      test('unlockedMoveIds defaults to empty list', () {
        const profile = UserProfile();
        expect(profile.unlockedMoveIds, isEmpty);
      });
    });

    group('copyWith', () {
      test('returns unchanged copy when no args provided', () {
        const profile = UserProfile(level: 5, squatFiveRm: 100);
        expect(profile.copyWith(), equals(profile));
      });

      test('updates level without touching other fields', () {
        const profile = UserProfile(squatFiveRm: 60);
        final updated = profile.copyWith(level: 2);
        expect(updated.level, 2);
        expect(updated.squatFiveRm, 60);
      });

      test('updates multiple fields at once', () {
        const profile = UserProfile();
        final updated = profile.copyWith(
          level: 3,
          squatFiveRm: 80,
          weeklyFrequency: 5,
        );
        expect(updated.level, 3);
        expect(updated.squatFiveRm, 80);
        expect(updated.weeklyFrequency, 5);
      });

      test('updates unlockedMoveIds', () {
        const profile = UserProfile();
        final updated = profile.copyWith(
          unlockedMoveIds: ['push_up'],
        );
        expect(updated.unlockedMoveIds, ['push_up']);
      });
    });

    group('equality', () {
      test('instances with same field values are equal', () {
        const a = UserProfile(squatFiveRm: 100, weeklyFrequency: 4);
        const b = UserProfile(squatFiveRm: 100, weeklyFrequency: 4);
        expect(a, equals(b));
      });

      test('instances with different field values are not equal', () {
        const a = UserProfile(squatFiveRm: 100);
        const b = UserProfile(squatFiveRm: 110);
        expect(a, isNot(equals(b)));
      });
    });

    group('hashCode', () {
      test('equal instances share hashCode', () {
        const a = UserProfile(level: 3, squatFiveRm: 90);
        const b = UserProfile(level: 3, squatFiveRm: 90);
        expect(a.hashCode, b.hashCode);
      });
    });
  });
}
