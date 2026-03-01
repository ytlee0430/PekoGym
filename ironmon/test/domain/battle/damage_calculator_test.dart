import 'package:ironmon/domain/battle/damage_calculator.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';
import 'package:test/test.dart';

void main() {
  const te = TypeEffectiveness();
  const calc = DamageCalculator(typeEffectiveness: te);

  const chestMove = MoveDefinition(
    id: 'chest-1',
    name: 'Push-up',
    type: MuscleType.chest,
    power: 40,
    pp: 15,
    description: 'Basic chest',
    exerciseName: 'Push-up',
    evolutionChainId: 'chest-chain',
    evolutionStage: 1,
    unlockLevel: 1,
  );

  const baseSet = ExerciseSet(
    moveId: 'chest-1',
    weight: 80,
    reps: 10,
    rpe: 7,
    setNumber: 1,
  );

  group('DamageCalculator', () {
    test('base damage formula with known inputs', () {
      // intensity = 80/80 = 1.0
      // base = 1.0 * 40 * 10 = 400
      // type = chest vs chest = 1.0
      // rpe 7 = 1.0
      // final = 400
      final result = calc.calculate(
        exerciseSet: baseSet,
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.finalDamage, 400);
      expect(result.intensity, 1.0);
      expect(result.typeMultiplier, 1.0);
      expect(result.rpeMultiplier, 1.0);
    });

    test('RPE ≤ 5 gives 0.8x', () {
      final result = calc.calculate(
        exerciseSet: baseSet.copyWith(rpe: 5),
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.rpeMultiplier, 0.8);
      expect(result.finalDamage, 320);
    });

    test('RPE 6-7 gives 1.0x', () {
      for (final rpe in [6, 7]) {
        final result = calc.calculate(
          exerciseSet: baseSet.copyWith(rpe: rpe),
          move: chestMove,
          bossType: MuscleType.chest,
          playerFiveRm: 80,
          bossDefense: 0,
          gymType: GymType.physique,
        );
        expect(
          result.rpeMultiplier,
          1.0,
          reason: 'RPE $rpe',
        );
      }
    });

    test('RPE 8 gives 1.2x', () {
      final result = calc.calculate(
        exerciseSet: baseSet.copyWith(rpe: 8),
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.rpeMultiplier, 1.2);
      expect(result.finalDamage, 480);
    });

    test('RPE 9-10 gives 1.5x', () {
      for (final rpe in [9, 10]) {
        final result = calc.calculate(
          exerciseSet: baseSet.copyWith(rpe: rpe),
          move: chestMove,
          bossType: MuscleType.chest,
          playerFiveRm: 80,
          bossDefense: 0,
          gymType: GymType.physique,
        );
        expect(
          result.rpeMultiplier,
          1.5,
          reason: 'RPE $rpe',
        );
      }
    });

    test('super effective type gives 1.5x', () {
      // chest vs legs = 1.5x
      final result = calc.calculate(
        exerciseSet: baseSet,
        move: chestMove,
        bossType: MuscleType.legs,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.typeMultiplier, 1.5);
      expect(
        result.effectiveness,
        Effectiveness.superEffective,
      );
      expect(result.finalDamage, 600);
    });

    test('not effective type gives 0.5x', () {
      // chest vs back = 0.5x
      final result = calc.calculate(
        exerciseSet: baseSet,
        move: chestMove,
        bossType: MuscleType.back,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.typeMultiplier, 0.5);
      expect(
        result.effectiveness,
        Effectiveness.notVeryEffective,
      );
      expect(result.finalDamage, 200);
    });

    test(
      'strength gym defense threshold',
      () {
        final result = calc.calculate(
          exerciseSet: baseSet.copyWith(
            weight: 10,
            reps: 1,
          ),
          move: chestMove,
          bossType: MuscleType.chest,
          playerFiveRm: 80,
          bossDefense: 100,
          gymType: GymType.strength,
        );
        // intensity = 10/80 = 0.125
        // base = 0.125 * 40 * 1 = 5
        // final = 5 (< 100 defense)
        expect(result.isEffective, isFalse);
      },
    );

    test(
      'physique gym has no defense threshold',
      () {
        final result = calc.calculate(
          exerciseSet: baseSet.copyWith(
            weight: 10,
            reps: 1,
          ),
          move: chestMove,
          bossType: MuscleType.chest,
          playerFiveRm: 80,
          bossDefense: 100,
          gymType: GymType.physique,
        );
        expect(result.isEffective, isTrue);
      },
    );

    test('intensity clamped at 2.0', () {
      final result = calc.calculate(
        exerciseSet: baseSet.copyWith(weight: 200),
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      // 200/80 = 2.5 → clamped to 2.0
      expect(result.intensity, 2.0);
    });

    test('zero weight returns zero damage', () {
      final result = calc.calculate(
        exerciseSet: baseSet.copyWith(weight: 0),
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.finalDamage, 0);
    });

    test('zero reps returns zero result', () {
      final result = calc.calculate(
        exerciseSet: baseSet.copyWith(reps: 0),
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 80,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.finalDamage, 0);
    });

    test('zero 5RM returns zero result', () {
      final result = calc.calculate(
        exerciseSet: baseSet,
        move: chestMove,
        bossType: MuscleType.chest,
        playerFiveRm: 0,
        bossDefense: 0,
        gymType: GymType.physique,
      );
      expect(result.finalDamage, 0);
    });

    test(
      'calculation is synchronous and fast',
      () {
        final sw = Stopwatch()..start();
        for (var i = 0; i < 1000; i++) {
          calc.calculate(
            exerciseSet: baseSet,
            move: chestMove,
            bossType: MuscleType.chest,
            playerFiveRm: 80,
            bossDefense: 10,
            gymType: GymType.physique,
          );
        }
        sw.stop();
        // 1000 calculations should complete in
        // well under 16ms total
        expect(
          sw.elapsedMilliseconds,
          lessThan(16),
          reason: '1000 calcs took '
              '${sw.elapsedMilliseconds}ms',
        );
      },
    );
  });
}
