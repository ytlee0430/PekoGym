import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Immutable domain model representing a player's profile.
/// Pure Dart — zero Flutter/Drift dependency.
@immutable
class UserProfile {
  /// Creates a [UserProfile] with the given fields.
  const UserProfile({
    this.id = 0,
    this.level = 1,
    this.experiencePoints = 0,
    this.gender = 'male',
    this.bodyWeightKg = 70.0,
    this.squatFiveRm = 0.0,
    this.benchPressFiveRm = 0.0,
    this.deadliftFiveRm = 0.0,
    this.overheadPressFiveRm = 0.0,
    this.weeklyFrequency = 3,
    this.isBeginnerMode = false,
    this.calibrationSessionsCompleted = 0,
    this.calibrationTargetSessions = 5,
    this.unlockedMoveIds = const [],
    this.maxPp = 110,
    this.currentPp = 110,
    this.potionCount = 0,
    this.etherCount = 0,
    this.rareCandyCount = 0,
    this.coins = 0,
    this.exerciseFiveRms = const {},
  });

  /// Database ID (always 1 for singleton pattern).
  final int id;

  /// Current player level. Starts at 1.
  final int level;

  /// Accumulated experience points.
  final int experiencePoints;

  /// Player gender ('male' or 'female').
  final String gender;

  /// Player body weight in kilograms.
  final double bodyWeightKg;

  /// Squat 5-rep max in kilograms.
  final double squatFiveRm;

  /// Bench press 5-rep max in kilograms.
  final double benchPressFiveRm;

  /// Deadlift 5-rep max in kilograms.
  final double deadliftFiveRm;

  /// Overhead press 5-rep max in kilograms.
  final double overheadPressFiveRm;

  /// Weekly training frequency in days (1–7).
  final int weeklyFrequency;

  /// Whether in beginner auto-calibration mode (Story 1.3).
  final bool isBeginnerMode;

  /// Sessions completed during auto-calibration (0 to
  /// calibrationTargetSessions).
  final int calibrationSessionsCompleted;

  /// Target sessions for auto-calibration to complete (default 5).
  final int calibrationTargetSessions;

  /// List of unlocked move IDs.
  final List<String> unlockedMoveIds;

  /// Maximum PP (stamina). Derived: 100 + level * 10.
  final int maxPp;

  /// Current PP (stamina). Deducted when moves are used.
  final int currentPp;

  /// Number of Potions held.
  final int potionCount;

  /// Number of Ethers held.
  final int etherCount;

  /// Number of Rare Candies held.
  final int rareCandyCount;

  /// In-game currency balance.
  final int coins;

  /// Per-exercise 5RM overrides, keyed by move ID (e.g. 'chest-2').
  /// Populated during experienced-mode onboarding.
  final Map<String, double> exerciseFiveRms;

  /// Returns a copy of this profile with updated fields.
  UserProfile copyWith({
    int? id,
    int? level,
    int? experiencePoints,
    String? gender,
    double? bodyWeightKg,
    double? squatFiveRm,
    double? benchPressFiveRm,
    double? deadliftFiveRm,
    double? overheadPressFiveRm,
    int? weeklyFrequency,
    bool? isBeginnerMode,
    int? calibrationSessionsCompleted,
    int? calibrationTargetSessions,
    List<String>? unlockedMoveIds,
    int? maxPp,
    int? currentPp,
    int? potionCount,
    int? etherCount,
    int? rareCandyCount,
    int? coins,
    Map<String, double>? exerciseFiveRms,
  }) {
    return UserProfile(
      id: id ?? this.id,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      gender: gender ?? this.gender,
      bodyWeightKg: bodyWeightKg ?? this.bodyWeightKg,
      squatFiveRm: squatFiveRm ?? this.squatFiveRm,
      benchPressFiveRm: benchPressFiveRm ?? this.benchPressFiveRm,
      deadliftFiveRm: deadliftFiveRm ?? this.deadliftFiveRm,
      overheadPressFiveRm: overheadPressFiveRm ?? this.overheadPressFiveRm,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      isBeginnerMode: isBeginnerMode ?? this.isBeginnerMode,
      calibrationSessionsCompleted:
          calibrationSessionsCompleted ?? this.calibrationSessionsCompleted,
      calibrationTargetSessions:
          calibrationTargetSessions ?? this.calibrationTargetSessions,
      unlockedMoveIds: unlockedMoveIds != null
          ? List<String>.unmodifiable(unlockedMoveIds)
          : this.unlockedMoveIds,
      maxPp: maxPp ?? this.maxPp,
      currentPp: currentPp ?? this.currentPp,
      potionCount: potionCount ?? this.potionCount,
      etherCount: etherCount ?? this.etherCount,
      rareCandyCount:
          rareCandyCount ?? this.rareCandyCount,
      coins: coins ?? this.coins,
      exerciseFiveRms: exerciseFiveRms ?? this.exerciseFiveRms,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.level == level &&
        other.experiencePoints == experiencePoints &&
        other.gender == gender &&
        other.bodyWeightKg == bodyWeightKg &&
        other.squatFiveRm == squatFiveRm &&
        other.benchPressFiveRm == benchPressFiveRm &&
        other.deadliftFiveRm == deadliftFiveRm &&
        other.overheadPressFiveRm == overheadPressFiveRm &&
        other.weeklyFrequency == weeklyFrequency &&
        other.isBeginnerMode == isBeginnerMode &&
        other.calibrationSessionsCompleted ==
            calibrationSessionsCompleted &&
        other.calibrationTargetSessions == calibrationTargetSessions &&
        const ListEquality<String>()
            .equals(other.unlockedMoveIds, unlockedMoveIds) &&
        other.maxPp == maxPp &&
        other.currentPp == currentPp &&
        other.potionCount == potionCount &&
        other.etherCount == etherCount &&
        other.rareCandyCount == rareCandyCount &&
        other.coins == coins &&
        const MapEquality<String, double>()
            .equals(other.exerciseFiveRms, exerciseFiveRms);
  }

  @override
  int get hashCode => Object.hash(
        Object.hash(
          id,
          level,
          experiencePoints,
          gender,
          bodyWeightKg,
          squatFiveRm,
          benchPressFiveRm,
          deadliftFiveRm,
          overheadPressFiveRm,
          weeklyFrequency,
        ),
        Object.hash(
          isBeginnerMode,
          calibrationSessionsCompleted,
          calibrationTargetSessions,
          const ListEquality<String>().hash(unlockedMoveIds),
          maxPp,
          currentPp,
          potionCount,
          etherCount,
          rareCandyCount,
          coins,
          const MapEquality<String, double>().hash(exerciseFiveRms),
        ),
      );

  @override
  String toString() {
    return 'UserProfile(id: $id, level: $level, '
        'xp: $experiencePoints, '
        'gender: $gender, bodyWeight: $bodyWeightKg, '
        'squat: $squatFiveRm, bench: $benchPressFiveRm, '
        'deadlift: $deadliftFiveRm, '
        'ohp: $overheadPressFiveRm, '
        'freq: $weeklyFrequency, '
        'beginner: $isBeginnerMode, '
        'calibSessions: $calibrationSessionsCompleted/'
        '$calibrationTargetSessions, '
        'unlocks: $unlockedMoveIds, '
        'pp: $currentPp/$maxPp, '
        'inv: p=$potionCount e=$etherCount '
        'rc=$rareCandyCount coins=$coins, '
        'exerciseFiveRms: $exerciseFiveRms)';
  }
}
