import 'dart:math';

/// Calculates experience points earned from a
/// battle based on performance metrics.
/// Pure Dart — zero Flutter dependency.
class ExpCalculator {
  /// Creates an [ExpCalculator].
  const ExpCalculator();

  /// Calculates EXP earned from a battle.
  ///
  /// Formula:
  /// ```
  /// baseExp = (totalDamage × 0.1)
  ///         + (totalSets × 10)
  ///         + (totalVolume × 0.01)
  /// modifier = isVictory ? 1.0 : 0.6
  /// finalExp = max(1, round(baseExp × modifier))
  /// ```
  int calculateExp({
    required int totalDamage,
    required int totalSets,
    required double totalVolume,
    required bool isVictory,
  }) {
    final baseExp = (totalDamage * 0.1) +
        (totalSets * 10) +
        (totalVolume * 0.01);
    final modifier = isVictory ? 1.0 : 0.6;
    final finalExp = (baseExp * modifier).round();
    return max(1, finalExp);
  }
}
