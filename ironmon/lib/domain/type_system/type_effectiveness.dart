import 'package:ironmon/domain/type_system/muscle_type.dart';

/// 5×5 type effectiveness matrix for muscle-type battle
/// system. Pure Dart — zero Flutter dependency.
class TypeEffectiveness {
  /// Creates a [TypeEffectiveness] instance.
  const TypeEffectiveness();

  /// Super effective multiplier.
  static const superEffective = 1.5;

  /// Not very effective multiplier.
  static const notEffective = 0.5;

  /// Neutral multiplier.
  static const neutral = 1.0;

  static const _matrix =
      <MuscleType, Map<MuscleType, double>>{
    MuscleType.chest: {
      MuscleType.chest: neutral,
      MuscleType.back: notEffective,
      MuscleType.legs: superEffective,
      MuscleType.shoulders: neutral,
      MuscleType.arms: neutral,
    },
    MuscleType.back: {
      MuscleType.chest: superEffective,
      MuscleType.back: neutral,
      MuscleType.legs: neutral,
      MuscleType.shoulders: notEffective,
      MuscleType.arms: neutral,
    },
    MuscleType.legs: {
      MuscleType.chest: neutral,
      MuscleType.back: neutral,
      MuscleType.legs: neutral,
      MuscleType.shoulders: superEffective,
      MuscleType.arms: notEffective,
    },
    MuscleType.shoulders: {
      MuscleType.chest: neutral,
      MuscleType.back: superEffective,
      MuscleType.legs: notEffective,
      MuscleType.shoulders: neutral,
      MuscleType.arms: neutral,
    },
    MuscleType.arms: {
      MuscleType.chest: neutral,
      MuscleType.back: neutral,
      MuscleType.legs: superEffective,
      MuscleType.shoulders: neutral,
      MuscleType.arms: neutral,
    },
  };

  /// Returns the damage multiplier for [attacker]
  /// vs [defender].
  ///
  /// - 1.5 = Super Effective
  /// - 0.5 = Not Very Effective
  /// - 1.0 = Neutral
  double getMultiplier(
    MuscleType attacker,
    MuscleType defender,
  ) {
    return _matrix[attacker]![defender]!;
  }
}
