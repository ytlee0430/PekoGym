import 'package:ironmon/domain/training/models/user_profile.dart';

/// Pure Dart service for beginner mode 5RM auto-calibration.
/// Implements the Epley formula to estimate 5RM from actual
/// training sets.
///
/// Formula: estimated1RM = weight × (1 + reps / 30)
/// Convert to 5RM: fiveRm = estimated1RM / 1.0678
///
/// Reference: Epley B. (1985). Poundage Chart. Boyd Epley
/// Workout. Lincoln, NE: Body Enterprises.
class BeginnerCalibrationService {
  /// Creates a [BeginnerCalibrationService].
  const BeginnerCalibrationService();

  /// Estimates 5RM from a single set using the Epley formula.
  ///
  /// Returns 0.0 if [weight] or [reps] is not positive.
  double estimateFiveRm(double weight, int reps) {
    if (weight <= 0 || reps <= 0) return 0;
    final estimated1Rm = weight * (1 + reps / 30);
    return estimated1Rm / 1.0678;
  }

  /// Applies calibration estimates to [profile], updating 5RM
  /// values only when the new estimate exceeds the current value.
  ///
  /// [newEstimates] keys must be: 'squat', 'benchPress',
  /// 'deadlift', 'overheadPress'. Missing keys are ignored.
  ///
  /// Increments [UserProfile.calibrationSessionsCompleted] and
  /// transitions [UserProfile.isBeginnerMode] to false when the
  /// target is reached.
  UserProfile applyCalibration(
    UserProfile profile,
    Map<String, double> newEstimates,
  ) {
    final newSquat = newEstimates['squat'] ?? 0.0;
    final newBench = newEstimates['benchPress'] ?? 0.0;
    final newDeadlift = newEstimates['deadlift'] ?? 0.0;
    final newOhp = newEstimates['overheadPress'] ?? 0.0;

    final updatedSessions = profile.calibrationSessionsCompleted + 1;
    final calibrationComplete =
        updatedSessions >= profile.calibrationTargetSessions;

    return profile.copyWith(
      squatFiveRm: newSquat > profile.squatFiveRm
          ? newSquat
          : profile.squatFiveRm,
      benchPressFiveRm: newBench > profile.benchPressFiveRm
          ? newBench
          : profile.benchPressFiveRm,
      deadliftFiveRm: newDeadlift > profile.deadliftFiveRm
          ? newDeadlift
          : profile.deadliftFiveRm,
      overheadPressFiveRm: newOhp > profile.overheadPressFiveRm
          ? newOhp
          : profile.overheadPressFiveRm,
      calibrationSessionsCompleted: updatedSessions,
      isBeginnerMode:
          !calibrationComplete && profile.isBeginnerMode,
    );
  }
}
