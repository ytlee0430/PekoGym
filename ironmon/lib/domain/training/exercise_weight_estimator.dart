/// Static service that estimates per-exercise 5RM values from
/// 4 standard compound lifts using fixed strength ratios.
///
/// All outputs are rounded to the nearest 2.5 kg.
class ExerciseWeightEstimator {
  const ExerciseWeightEstimator._();

  /// Estimates recommended 5RM for the 4 standard compound lifts
  /// based on body weight and gender.
  ///
  /// Male ratios (of bodyweight):
  ///   Bench Press ~0.70, Barbell Row ~0.60, Squat ~0.85, OHP ~0.45
  /// Female ratios (of bodyweight):
  ///   Bench Press ~0.40, Barbell Row ~0.35, Squat ~0.60, OHP ~0.25
  static ({
    double benchPress,
    double barbellRow,
    double squat,
    double shoulderPress,
  }) estimateFromBodyWeight({
    required double bodyWeightKg,
    required String gender,
  }) {
    final isMale = gender != 'female';
    return (
      benchPress: _roundToNearest2p5(bodyWeightKg * (isMale ? 0.70 : 0.40)),
      barbellRow: _roundToNearest2p5(bodyWeightKg * (isMale ? 0.60 : 0.35)),
      squat: _roundToNearest2p5(bodyWeightKg * (isMale ? 0.85 : 0.60)),
      shoulderPress:
          _roundToNearest2p5(bodyWeightKg * (isMale ? 0.45 : 0.25)),
    );
  }

  /// Estimates 5RM for all 15 exercises from the 4 standard compound inputs.
  ///
  /// The [barbellRow] parameter maps to the `deadliftFiveRm` DB field.
  static Map<String, double> estimateAll({
    required double benchPress,
    required double barbellRow,
    required double squat,
    required double shoulderPress,
  }) {
    final raw = <String, double>{
      'chest-1': benchPress * 0.50,      // Push-up (bodyweight equiv)
      'chest-2': benchPress,              // Barbell Bench Press (direct)
      'chest-3': benchPress * 0.75,      // Incline Dumbbell Press
      'back-1':  barbellRow * 0.55,      // Inverted Row
      'back-2':  barbellRow,             // Barbell Row (direct)
      'back-3':  barbellRow * 0.70,      // Lat Pulldown
      'legs-1':  squat * 0.40,           // Bodyweight Squat
      'legs-2':  squat,                  // Barbell Squat (direct)
      'legs-3':  squat * 0.80,           // Front Squat
      'shoulders-1': shoulderPress * 0.55, // Pike Push-up
      'shoulders-2': shoulderPress,        // Overhead Press (direct)
      'shoulders-3': shoulderPress * 0.70, // Arnold Press
      'arms-1': benchPress * 0.35,         // Diamond Push-up
      'arms-2': benchPress * 0.30,         // Barbell Curl
      'arms-3': benchPress * 0.35,         // Skull Crusher
    };
    return raw.map(
      (key, value) => MapEntry(key, _roundToNearest2p5(value)),
    );
  }

  static double _roundToNearest2p5(double value) {
    if (value <= 0) return 0.0;
    return (value / 2.5).round() * 2.5;
  }
}
