import 'package:ironmon/domain/training/pr_detector.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:test/test.dart';

void main() {
  const detector = PRDetector();

  group('estimateFiveRm', () {
    test('100kg x 5 reps', () {
      // 1RM = 100 * (1 + 5/30) = 116.67
      // 5RM = 116.67 / 1.0678 ≈ 109.26
      final result = detector.estimateFiveRm(
        100,
        5,
      );
      expect(result, closeTo(109.26, 0.1));
    });

    test('80kg x 10 reps', () {
      // 1RM = 80 * (1 + 10/30) = 106.67
      // 5RM = 106.67 / 1.0678 ≈ 99.90
      final result = detector.estimateFiveRm(
        80,
        10,
      );
      expect(result, closeTo(99.90, 0.1));
    });

    test('60kg x 15 reps', () {
      // 1RM = 60 * (1 + 15/30) = 90.0
      // 5RM = 90.0 / 1.0678 ≈ 84.29
      final result = detector.estimateFiveRm(
        60,
        15,
      );
      expect(result, closeTo(84.29, 0.1));
    });

    test('zero weight returns 0', () {
      expect(
        detector.estimateFiveRm(0, 5),
        0.0,
      );
    });

    test('zero reps returns 0', () {
      expect(
        detector.estimateFiveRm(100, 0),
        0.0,
      );
    });

    test('negative weight returns 0', () {
      expect(
        detector.estimateFiveRm(-50, 5),
        0.0,
      );
    });
  });

  group('checkForPR', () {
    test('detects PR when estimate exceeds 5RM', () {
      final result = detector.checkForPR(
        weight: 100,
        reps: 5,
        currentFiveRm: 90,
        muscleType: MuscleType.chest,
      );
      expect(result.isPR, true);
      expect(result.oldFiveRm, 90);
      expect(
        result.newFiveRm,
        closeTo(109.26, 0.1),
      );
      expect(
        result.muscleType,
        MuscleType.chest,
      );
    });

    test('no PR when estimate below 5RM', () {
      final result = detector.checkForPR(
        weight: 50,
        reps: 5,
        currentFiveRm: 100,
        muscleType: MuscleType.legs,
      );
      expect(result.isPR, false);
      expect(result.muscleType, MuscleType.legs);
    });

    test('no PR on zero weight', () {
      final result = detector.checkForPR(
        weight: 0,
        reps: 5,
        currentFiveRm: 50,
        muscleType: MuscleType.back,
      );
      expect(result.isPR, false);
    });

    test('no PR on zero reps', () {
      final result = detector.checkForPR(
        weight: 100,
        reps: 0,
        currentFiveRm: 50,
        muscleType: MuscleType.shoulders,
      );
      expect(result.isPR, false);
    });

    test('PR at exact boundary', () {
      // estimated5Rm must be > currentFiveRm
      // 100 * (1 + 5/30) / 1.0678 ≈ 109.26
      final result = detector.checkForPR(
        weight: 100,
        reps: 5,
        currentFiveRm: 109.26,
        muscleType: MuscleType.arms,
      );
      // Should be very close, might not exceed
      expect(result.isPR, false);
    });

    test('includes estimated1Rm', () {
      final result = detector.checkForPR(
        weight: 100,
        reps: 5,
        currentFiveRm: 90,
        muscleType: MuscleType.chest,
      );
      // 1RM = 100 * (1 + 5/30) = 116.67
      expect(
        result.estimated1Rm,
        closeTo(116.67, 0.1),
      );
    });
  });
}
