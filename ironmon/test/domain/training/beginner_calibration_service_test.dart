import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/beginner_calibration_service.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  const service = BeginnerCalibrationService();

  group('BeginnerCalibrationService', () {
    group('estimateFiveRm', () {
      test('returns correct estimate for 100 kg × 5 reps', () {
        // 100 × (1 + 5/30) = 116.666... / 1.0678 ≈ 109.26
        final result = service.estimateFiveRm(100, 5);
        expect(result, closeTo(109.3, 0.1));
      });

      test('returns correct estimate for 20 kg × 15 reps', () {
        // 20 × (1 + 15/30) = 30 / 1.0678 ≈ 28.1
        final result = service.estimateFiveRm(20, 15);
        expect(result, closeTo(28.1, 0.1));
      });

      test('returns correct estimate for 60 kg × 8 reps', () {
        // 60 × (1 + 8/30) = 76 / 1.0678 ≈ 71.2
        final result = service.estimateFiveRm(60, 8);
        expect(result, closeTo(71.2, 0.1));
      });

      test('returns 0 for zero weight', () {
        expect(service.estimateFiveRm(0, 5), 0);
      });

      test('returns 0 for negative weight', () {
        expect(service.estimateFiveRm(-10, 5), 0);
      });

      test('returns 0 for zero reps', () {
        expect(service.estimateFiveRm(100, 0), 0);
      });

      test('returns 0 for negative reps', () {
        expect(service.estimateFiveRm(100, -1), 0);
      });
    });

    group('applyCalibration', () {
      test('increments calibrationSessionsCompleted by 1', () {
        const profile = UserProfile(isBeginnerMode: true);
        final result = service.applyCalibration(profile, {});
        expect(result.calibrationSessionsCompleted, 1);
      });

      test('does not decrease squat 5RM when estimate is lower', () {
        const profile = UserProfile(
          squatFiveRm: 50,
          isBeginnerMode: true,
        );
        final result = service.applyCalibration(
          profile,
          {'squat': 30},
        );
        expect(result.squatFiveRm, 50);
      });

      test('increases squat 5RM when estimate is higher', () {
        const profile = UserProfile(
          squatFiveRm: 20,
          isBeginnerMode: true,
        );
        final result = service.applyCalibration(
          profile,
          {'squat': 50},
        );
        expect(result.squatFiveRm, 50);
      });

      test('does not decrease bench 5RM when estimate is lower', () {
        const profile = UserProfile(
          benchPressFiveRm: 40,
          isBeginnerMode: true,
        );
        final result = service.applyCalibration(
          profile,
          {'benchPress': 25},
        );
        expect(result.benchPressFiveRm, 40);
      });

      test('increases bench 5RM when estimate is higher', () {
        const profile = UserProfile(
          benchPressFiveRm: 20,
          isBeginnerMode: true,
        );
        final result = service.applyCalibration(
          profile,
          {'benchPress': 45},
        );
        expect(result.benchPressFiveRm, 45);
      });

      test('does not decrease deadlift 5RM when estimate is lower', () {
        const profile = UserProfile(
          deadliftFiveRm: 60,
          isBeginnerMode: true,
        );
        final result = service.applyCalibration(
          profile,
          {'deadlift': 35},
        );
        expect(result.deadliftFiveRm, 60);
      });

      test('does not decrease ohp 5RM when estimate is lower', () {
        const profile = UserProfile(
          overheadPressFiveRm: 30,
          isBeginnerMode: true,
        );
        final result = service.applyCalibration(
          profile,
          {'overheadPress': 15},
        );
        expect(result.overheadPressFiveRm, 30);
      });

      test('sets isBeginnerMode false when target sessions reached', () {
        const profile = UserProfile(
          isBeginnerMode: true,
          calibrationSessionsCompleted: 4,
        );
        final result = service.applyCalibration(profile, {});
        expect(result.isBeginnerMode, isFalse);
        expect(result.calibrationSessionsCompleted, 5);
      });

      test('does not exit beginner mode before target reached', () {
        const profile = UserProfile(
          isBeginnerMode: true,
          calibrationSessionsCompleted: 3,
        );
        final result = service.applyCalibration(profile, {});
        expect(result.isBeginnerMode, isTrue);
        expect(result.calibrationSessionsCompleted, 4);
      });

      test('ignores missing keys in newEstimates', () {
        const profile = UserProfile(
          squatFiveRm: 100,
          isBeginnerMode: true,
        );
        // No 'squat' key — squat should remain unchanged
        final result = service.applyCalibration(
          profile,
          {'benchPress': 50},
        );
        expect(result.squatFiveRm, 100);
        expect(result.benchPressFiveRm, 50);
      });
    });
  });
}
