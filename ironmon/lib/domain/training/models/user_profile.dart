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
    this.squatFiveRm = 0.0,
    this.benchPressFiveRm = 0.0,
    this.deadliftFiveRm = 0.0,
    this.overheadPressFiveRm = 0.0,
    this.weeklyFrequency = 3,
    this.isBeginnerMode = false,
    this.calibrationSessionsCompleted = 0,
    this.calibrationTargetSessions = 5,
    this.unlockedMoveIds = const [],
  });

  /// Database ID (always 1 for singleton pattern).
  final int id;

  /// Current player level. Starts at 1.
  final int level;

  /// Accumulated experience points.
  final int experiencePoints;

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

  /// Returns a copy of this profile with updated fields.
  UserProfile copyWith({
    int? id,
    int? level,
    int? experiencePoints,
    double? squatFiveRm,
    double? benchPressFiveRm,
    double? deadliftFiveRm,
    double? overheadPressFiveRm,
    int? weeklyFrequency,
    bool? isBeginnerMode,
    int? calibrationSessionsCompleted,
    int? calibrationTargetSessions,
    List<String>? unlockedMoveIds,
  }) {
    return UserProfile(
      id: id ?? this.id,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.level == level &&
        other.experiencePoints == experiencePoints &&
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
            .equals(other.unlockedMoveIds, unlockedMoveIds);
  }

  @override
  int get hashCode => Object.hash(
        id,
        level,
        experiencePoints,
        squatFiveRm,
        benchPressFiveRm,
        deadliftFiveRm,
        overheadPressFiveRm,
        weeklyFrequency,
        isBeginnerMode,
        calibrationSessionsCompleted,
        calibrationTargetSessions,
        const ListEquality<String>().hash(unlockedMoveIds),
      );

  @override
  String toString() {
    return 'UserProfile(id: $id, level: $level, '
        'xp: $experiencePoints, '
        'squat: $squatFiveRm, bench: $benchPressFiveRm, '
        'deadlift: $deadliftFiveRm, '
        'ohp: $overheadPressFiveRm, '
        'freq: $weeklyFrequency, '
        'beginner: $isBeginnerMode, '
        'calibSessions: $calibrationSessionsCompleted/'
        '$calibrationTargetSessions, '
        'unlocks: $unlockedMoveIds)';
  }
}
