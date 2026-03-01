/// Immutable domain model representing a
/// completed workout session.
/// Pure Dart — zero Flutter/Drift dependency.
class WorkoutSession {
  /// Creates a [WorkoutSession].
  const WorkoutSession({
    this.id = 0,
    required this.date,
    required this.gymType,
    required this.muscleType,
    required this.totalVolume,
    required this.totalDamage,
    required this.totalSets,
    required this.isVictory,
    required this.expEarned,
    this.durationSeconds,
  });

  /// Database ID.
  final int id;

  /// Session date/time.
  final DateTime date;

  /// Gym type string value.
  final String gymType;

  /// Muscle type string value.
  final String muscleType;

  /// Total volume (weight × reps) in kg.
  final double totalVolume;

  /// Total damage dealt.
  final int totalDamage;

  /// Total sets completed.
  final int totalSets;

  /// Whether the player won.
  final bool isVictory;

  /// EXP earned from this session.
  final int expEarned;

  /// Session duration in seconds.
  final int? durationSeconds;

  /// Returns a copy with updated fields.
  WorkoutSession copyWith({
    int? id,
    DateTime? date,
    String? gymType,
    String? muscleType,
    double? totalVolume,
    int? totalDamage,
    int? totalSets,
    bool? isVictory,
    int? expEarned,
    int? durationSeconds,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      date: date ?? this.date,
      gymType: gymType ?? this.gymType,
      muscleType:
          muscleType ?? this.muscleType,
      totalVolume:
          totalVolume ?? this.totalVolume,
      totalDamage:
          totalDamage ?? this.totalDamage,
      totalSets: totalSets ?? this.totalSets,
      isVictory: isVictory ?? this.isVictory,
      expEarned: expEarned ?? this.expEarned,
      durationSeconds:
          durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutSession &&
        other.id == id &&
        other.date == date &&
        other.gymType == gymType &&
        other.muscleType == muscleType &&
        other.totalVolume == totalVolume &&
        other.totalDamage == totalDamage &&
        other.totalSets == totalSets &&
        other.isVictory == isVictory &&
        other.expEarned == expEarned &&
        other.durationSeconds ==
            durationSeconds;
  }

  @override
  int get hashCode => Object.hash(
        id,
        date,
        gymType,
        muscleType,
        totalVolume,
        totalDamage,
        totalSets,
        isVictory,
        expEarned,
        durationSeconds,
      );

  @override
  String toString() =>
      'WorkoutSession(id: $id, '
      '${isVictory ? "victory" : "defeat"}, '
      'volume: $totalVolume, '
      'exp: $expEarned)';
}
