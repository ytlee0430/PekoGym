import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';
import 'package:ironmon/domain/training/scheduler.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

void main() {
  const scheduler = TrainingScheduler();
  final now = DateTime(2024, 1, 15, 10);

  WorkoutSession _session({
    required String muscleType,
    int daysAgo = 1,
  }) =>
      WorkoutSession(
        date: now.subtract(Duration(days: daysAgo)),
        gymType: 'normal',
        muscleType: muscleType,
        totalVolume: 500,
        totalDamage: 100,
        totalSets: 5,
        isVictory: true,
        expEarned: 200,
      );

  group('TrainingScheduler', () {
    group('frequency < 3 → Full Body', () {
      test('frequency 1 returns full body', () {
        final rec = scheduler.recommend(
          weeklyFrequency: 1,
          recentSessions: [],
          now: now,
        );
        expect(rec.isFullBody, isTrue);
        expect(rec.muscleTypes.length, 5);
      });

      test('frequency 2 returns full body', () {
        final rec = scheduler.recommend(
          weeklyFrequency: 2,
          recentSessions: [],
          now: now,
        );
        expect(rec.isFullBody, isTrue);
      });
    });

    group('frequency >= 3 → Split', () {
      test('frequency 3 returns split', () {
        final sessions = [
          _session(muscleType: 'chest', daysAgo: 2),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 3,
          recentSessions: sessions,
          now: now,
        );
        expect(rec.isFullBody, isFalse);
      });

      test('frequency 4 returns split', () {
        final sessions = [
          _session(muscleType: 'back', daysAgo: 1),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 4,
          recentSessions: sessions,
          now: now,
        );
        expect(rec.isFullBody, isFalse);
      });
    });

    group('>3 days since last workout → Full Body override', () {
      test('4 days since last overrides to full body', () {
        final sessions = [
          _session(
            muscleType: 'chest',
            daysAgo: 4,
          ),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 5,
          recentSessions: sessions,
          now: now,
        );
        expect(rec.isFullBody, isTrue);
        expect(
          rec.reason,
          contains('Full Body'),
        );
      });

      test('no sessions → full body (999 days)', () {
        final rec = scheduler.recommend(
          weeklyFrequency: 5,
          recentSessions: [],
          now: now,
        );
        expect(rec.isFullBody, isTrue);
      });
    });

    group('PPL rotation', () {
      test('last was push → recommends pull', () {
        final sessions = [
          _session(muscleType: 'chest', daysAgo: 1),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 3,
          recentSessions: sessions,
          now: now,
        );
        expect(
          rec.muscleTypes,
          containsAll([MuscleType.back]),
        );
      });

      test('last was pull → recommends legs', () {
        final sessions = [
          _session(muscleType: 'back', daysAgo: 1),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 3,
          recentSessions: sessions,
          now: now,
        );
        expect(
          rec.muscleTypes,
          contains(MuscleType.legs),
        );
      });

      test('last was legs → recommends push', () {
        final sessions = [
          _session(muscleType: 'legs', daysAgo: 1),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 3,
          recentSessions: sessions,
          now: now,
        );
        expect(
          rec.muscleTypes,
          containsAll([MuscleType.chest]),
        );
      });
    });

    group('frequency >= 5 → 5-way least-trained', () {
      test('untrained muscle recommended first', () {
        final sessions = [
          _session(muscleType: 'chest', daysAgo: 1),
          _session(
              muscleType: 'shoulders', daysAgo: 2),
          _session(muscleType: 'arms', daysAgo: 2),
          _session(muscleType: 'back', daysAgo: 2),
        ];
        final rec = scheduler.recommend(
          weeklyFrequency: 5,
          recentSessions: sessions,
          now: now,
        );
        expect(
          rec.muscleTypes,
          contains(MuscleType.legs),
        );
        expect(rec.isFullBody, isFalse);
      });
    });

    group('All muscle groups covered in full body', () {
      test('full body has all 5 muscle types', () {
        final rec = scheduler.recommend(
          weeklyFrequency: 2,
          recentSessions: [],
          now: now,
        );
        expect(
          rec.muscleTypes,
          containsAll(MuscleType.values),
        );
      });
    });
  });
}
