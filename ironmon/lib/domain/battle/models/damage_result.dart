/// Effectiveness category for a damage hit.
enum Effectiveness {
  /// 1.5x damage — attacker has type advantage.
  superEffective,

  /// 1.0x damage — neutral matchup.
  neutral,

  /// 0.5x damage — defender resists.
  notVeryEffective,
}

/// Immutable result of a damage calculation.
/// Pure Dart — zero Flutter dependency.
class DamageResult {
  /// Creates a [DamageResult].
  const DamageResult({
    required this.rawDamage,
    required this.finalDamage,
    required this.typeMultiplier,
    required this.rpeMultiplier,
    required this.intensity,
    required this.isEffective,
    required this.effectiveness,
    this.isCritical = false,
  });

  /// Creates a zero-damage result.
  const DamageResult.zero()
      : rawDamage = 0,
        finalDamage = 0,
        typeMultiplier = 1.0,
        rpeMultiplier = 1.0,
        intensity = 0,
        isEffective = false,
        effectiveness = Effectiveness.neutral,
        isCritical = false;

  /// Unrounded damage value.
  final double rawDamage;

  /// Final rounded damage dealt.
  final int finalDamage;

  /// Type effectiveness multiplier applied.
  final double typeMultiplier;

  /// RPE-based multiplier applied.
  final double rpeMultiplier;

  /// Weight / 5RM ratio (clamped 0.0–2.0).
  final double intensity;

  /// Whether the hit exceeded the boss defense
  /// threshold (always true in Physique gym).
  final bool isEffective;

  /// Type effectiveness category.
  final Effectiveness effectiveness;

  /// Whether this hit was a critical hit.
  final bool isCritical;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DamageResult &&
        other.rawDamage == rawDamage &&
        other.finalDamage == finalDamage &&
        other.typeMultiplier == typeMultiplier &&
        other.rpeMultiplier == rpeMultiplier &&
        other.intensity == intensity &&
        other.isEffective == isEffective &&
        other.effectiveness == effectiveness &&
        other.isCritical == isCritical;
  }

  @override
  int get hashCode => Object.hash(
        rawDamage,
        finalDamage,
        typeMultiplier,
        rpeMultiplier,
        intensity,
        isEffective,
        effectiveness,
        isCritical,
      );

  @override
  String toString() =>
      'DamageResult(damage: $finalDamage, '
      'type: ${typeMultiplier}x, '
      'rpe: ${rpeMultiplier}x, '
      'intensity: $intensity, '
      'effective: $isEffective)';
}
