/// Immutable domain model for a single training set.
/// Pure Dart — zero Flutter dependency.
class ExerciseSet {
  /// Creates an [ExerciseSet].
  const ExerciseSet({
    required this.moveId,
    required this.weight,
    required this.reps,
    required this.rpe,
    required this.setNumber,
  });

  /// ID of the move used in this set.
  final String moveId;

  /// Weight lifted in kilograms.
  final double weight;

  /// Number of repetitions completed.
  final int reps;

  /// Rate of perceived exertion (1–10).
  final int rpe;

  /// Set number within the battle (1-based).
  final int setNumber;

  /// Returns a copy with updated fields.
  ExerciseSet copyWith({
    String? moveId,
    double? weight,
    int? reps,
    int? rpe,
    int? setNumber,
  }) {
    return ExerciseSet(
      moveId: moveId ?? this.moveId,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      setNumber: setNumber ?? this.setNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSet &&
        other.moveId == moveId &&
        other.weight == weight &&
        other.reps == reps &&
        other.rpe == rpe &&
        other.setNumber == setNumber;
  }

  @override
  int get hashCode => Object.hash(
        moveId,
        weight,
        reps,
        rpe,
        setNumber,
      );

  @override
  String toString() =>
      'ExerciseSet(move: $moveId, '
      '${weight}kg × $reps @ RPE $rpe, '
      'set #$setNumber)';
}
