import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Immutable result of a PR check.
class PRResult {
  /// Creates a [PRResult].
  const PRResult({
    required this.isPR,
    required this.oldFiveRm,
    required this.newFiveRm,
    required this.estimated1Rm,
    required this.muscleType,
  });

  /// No PR detected.
  const PRResult.noPR({
    required this.muscleType,
    this.oldFiveRm = 0,
    this.estimated1Rm = 0,
  })  : isPR = false,
        newFiveRm = 0;

  /// Whether a PR was detected.
  final bool isPR;

  /// Previous 5RM value.
  final double oldFiveRm;

  /// New estimated 5RM (only meaningful if PR).
  final double newFiveRm;

  /// Estimated 1RM from Epley formula.
  final double estimated1Rm;

  /// Muscle type this PR applies to.
  final MuscleType muscleType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PRResult &&
        other.isPR == isPR &&
        other.oldFiveRm == oldFiveRm &&
        other.newFiveRm == newFiveRm &&
        other.estimated1Rm == estimated1Rm &&
        other.muscleType == muscleType;
  }

  @override
  int get hashCode => Object.hash(
        isPR,
        oldFiveRm,
        newFiveRm,
        estimated1Rm,
        muscleType,
      );

  @override
  String toString() => isPR
      ? 'PRResult(PR! $oldFiveRm → '
          '$newFiveRm kg, $muscleType)'
      : 'PRResult(noPR, $muscleType)';
}

/// Detects personal records using the Epley
/// formula.
/// Pure Dart — zero Flutter dependency.
class PRDetector {
  /// Creates a [PRDetector].
  const PRDetector();

  /// Estimates 5RM from weight and reps using
  /// the Epley formula.
  ///
  /// `estimated1RM = weight × (1 + reps / 30)`
  /// `estimated5RM = estimated1RM / 1.0678`
  double estimateFiveRm(
    double weight,
    int reps,
  ) {
    if (weight <= 0 || reps <= 0) return 0.0;
    final estimated1Rm =
        weight * (1 + reps / 30);
    return estimated1Rm / 1.0678;
  }

  /// Returns the current 5RM for [muscleType]
  /// from [profile].
  double getFiveRmForType(
    UserProfile profile,
    MuscleType muscleType,
  ) {
    return switch (muscleType) {
      MuscleType.chest =>
        profile.benchPressFiveRm,
      MuscleType.back =>
        profile.deadliftFiveRm,
      MuscleType.legs =>
        profile.squatFiveRm,
      MuscleType.shoulders =>
        profile.overheadPressFiveRm,
      // Arms has no dedicated 5RM field (PRD FR1 specifies 4 core lifts).
      // Uses benchPress as proxy since arm exercises overlap with pressing.
      MuscleType.arms =>
        profile.benchPressFiveRm,
    };
  }

  /// Checks if a set represents a new PR.
  PRResult checkForPR({
    required double weight,
    required int reps,
    required double currentFiveRm,
    required MuscleType muscleType,
  }) {
    final estimated5Rm =
        estimateFiveRm(weight, reps);
    final estimated1Rm =
        weight * (1 + reps / 30);

    if (estimated5Rm <= 0) {
      return PRResult.noPR(
        muscleType: muscleType,
      );
    }

    if (estimated5Rm > currentFiveRm) {
      return PRResult(
        isPR: true,
        oldFiveRm: currentFiveRm,
        newFiveRm: estimated5Rm,
        estimated1Rm: estimated1Rm,
        muscleType: muscleType,
      );
    }

    return PRResult(
      isPR: false,
      oldFiveRm: currentFiveRm,
      newFiveRm: 0,
      estimated1Rm: estimated1Rm,
      muscleType: muscleType,
    );
  }
}
