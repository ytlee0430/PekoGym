import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/daily_mission_service.dart';
import 'package:ironmon/domain/training/models/daily_mission.dart';
import 'package:ironmon/domain/training/models/training_recommendation.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

void main() {
  const svc = DailyMissionService();
  final now = DateTime(2024, 1, 15);

  TrainingRecommendation _rec({
    bool isFullBody = false,
    List<MuscleType> muscles = const [
      MuscleType.chest,
    ],
  }) =>
      TrainingRecommendation(
        muscleTypes: muscles,
        isFullBody: isFullBody,
        reason: 'test reason',
      );

  WorkoutSession _session({
    String muscleType = 'chest',
    bool isVictory = true,
  }) =>
      WorkoutSession(
        date: now,
        gymType: 'normal',
        muscleType: muscleType,
        totalVolume: 500,
        totalDamage: 100,
        totalSets: 5,
        isVictory: isVictory,
        expEarned: 200,
      );

  group('DailyMissionService', () {
    group('generateMission', () {
      test('creates mission from recommendation', () {
        final rec = _rec(
          muscles: [MuscleType.chest],
        );
        final mission = svc.generateMission(
          recommendation: rec,
          date: now,
        );

        expect(
          mission.recommendedMuscleTypes,
          contains(MuscleType.chest),
        );
        expect(mission.isFullBody, isFalse);
        expect(mission.date, now);
        expect(mission.bonusExp, 20);
        expect(mission.isCompleted, isFalse);
      });

      test('full body mission reflects recommendation', () {
        final rec = _rec(
          isFullBody: true,
          muscles: MuscleType.values,
        );
        final mission = svc.generateMission(
          recommendation: rec,
          date: now,
        );

        expect(mission.isFullBody, isTrue);
        expect(
          mission.recommendedMuscleTypes.length,
          5,
        );
      });
    });

    group('checkCompletion', () {
      test('returns true when muscle type matches', () {
        final mission = DailyMission(
          recommendedMuscleTypes: [
            MuscleType.chest,
          ],
          isFullBody: false,
          reason: 'test',
          date: now,
        );
        final session =
            _session(muscleType: 'chest');
        expect(
          svc.checkCompletion(mission, session),
          isTrue,
        );
      });

      test('returns false when muscle type differs', () {
        final mission = DailyMission(
          recommendedMuscleTypes: [
            MuscleType.chest,
          ],
          isFullBody: false,
          reason: 'test',
          date: now,
        );
        final session = _session(muscleType: 'legs');
        expect(
          svc.checkCompletion(mission, session),
          isFalse,
        );
      });
    });

    group('expMultiplier', () {
      test('returns 1.2 when mission matches', () {
        final mission = DailyMission(
          recommendedMuscleTypes: [
            MuscleType.chest,
          ],
          isFullBody: false,
          reason: 'test',
          date: now,
          bonusExp: 20,
        );
        final session =
            _session(muscleType: 'chest');
        expect(
          svc.expMultiplier(mission, session),
          closeTo(1.2, 0.001),
        );
      });

      test('returns 1.0 when no mission match', () {
        final mission = DailyMission(
          recommendedMuscleTypes: [
            MuscleType.chest,
          ],
          isFullBody: false,
          reason: 'test',
          date: now,
        );
        final session = _session(muscleType: 'legs');
        expect(
          svc.expMultiplier(mission, session),
          1.0,
        );
      });

      test('returns 1.0 when mission is null', () {
        final session =
            _session(muscleType: 'chest');
        expect(
          svc.expMultiplier(null, session),
          1.0,
        );
      });

      test('bonus EXP calculation: 200 * 1.2 = 240', () {
        final multiplier = 1.2;
        expect((200 * multiplier).round(), 240);
      });
    });
  });
}
