import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';

/// Synchronous damage calculator for battle system.
/// Pure Dart — zero Flutter dependency.
/// Completes in <16ms (NFR1).
class DamageCalculator {
  /// Creates a [DamageCalculator].
  const DamageCalculator({
    required TypeEffectiveness typeEffectiveness,
  }) : _typeEffectiveness = typeEffectiveness;

  final TypeEffectiveness _typeEffectiveness;

  /// Calculates damage for a single training set.
  DamageResult calculate({
    required ExerciseSet exerciseSet,
    required MoveDefinition move,
    required MuscleType bossType,
    required double playerFiveRm,
    required int bossDefense,
    required GymType gymType,
  }) {
    if (playerFiveRm <= 0 ||
        exerciseSet.reps <= 0) {
      return const DamageResult.zero();
    }

    final intensity =
        (exerciseSet.weight / playerFiveRm)
            .clamp(0.0, 2.0);
    final baseDamage =
        intensity * move.power * exerciseSet.reps;

    final typeMultiplier =
        _typeEffectiveness.getMultiplier(
      move.type,
      bossType,
    );
    final rpeMultiplier =
        _getRpeMultiplier(exerciseSet.rpe);

    final rawDamage =
        baseDamage * typeMultiplier * rpeMultiplier;
    final finalDamage = rawDamage.round();

    final isEffective =
        gymType != GymType.strength ||
            finalDamage >= bossDefense;

    final effectiveness =
        _toEffectiveness(typeMultiplier);

    return DamageResult(
      rawDamage: rawDamage,
      finalDamage: finalDamage,
      typeMultiplier: typeMultiplier,
      rpeMultiplier: rpeMultiplier,
      intensity: intensity,
      isEffective: isEffective,
      effectiveness: effectiveness,
    );
  }

  /// Returns the RPE multiplier for the given
  /// [rpe] value.
  double _getRpeMultiplier(int rpe) {
    if (rpe >= 9) return 1.5;
    if (rpe == 8) return 1.2;
    if (rpe >= 6) return 1.0;
    return 0.8;
  }

  /// Converts a type multiplier to an
  /// [Effectiveness] enum.
  Effectiveness _toEffectiveness(double mult) {
    if (mult >= TypeEffectiveness.superEffective) {
      return Effectiveness.superEffective;
    }
    if (mult <= TypeEffectiveness.notEffective) {
      return Effectiveness.notVeryEffective;
    }
    return Effectiveness.neutral;
  }
}
