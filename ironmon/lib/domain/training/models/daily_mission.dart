import 'package:flutter/foundation.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Represents the daily recommended training mission.
@immutable
class DailyMission {
  /// Creates a [DailyMission].
  const DailyMission({
    required this.recommendedMuscleTypes,
    required this.isFullBody,
    required this.reason,
    required this.date,
    this.bonusExp = 20,
    this.isCompleted = false,
  });

  /// Muscle groups recommended for today.
  final List<MuscleType> recommendedMuscleTypes;

  /// Whether this is a full-body mission.
  final bool isFullBody;

  /// Human-readable reason for the recommendation.
  final String reason;

  /// The date this mission was generated for.
  final DateTime date;

  /// Bonus EXP percentage (e.g., 20 = +20%).
  final int bonusExp;

  /// Whether the mission has been completed today.
  final bool isCompleted;

  /// Returns a copy with updated fields.
  DailyMission copyWith({
    List<MuscleType>? recommendedMuscleTypes,
    bool? isFullBody,
    String? reason,
    DateTime? date,
    int? bonusExp,
    bool? isCompleted,
  }) {
    return DailyMission(
      recommendedMuscleTypes:
          recommendedMuscleTypes ??
              this.recommendedMuscleTypes,
      isFullBody: isFullBody ?? this.isFullBody,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      bonusExp: bonusExp ?? this.bonusExp,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyMission &&
        listEquals(
          other.recommendedMuscleTypes,
          recommendedMuscleTypes,
        ) &&
        other.isFullBody == isFullBody &&
        other.reason == reason &&
        other.date == date &&
        other.bonusExp == bonusExp &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(recommendedMuscleTypes),
        isFullBody,
        reason,
        date,
        bonusExp,
        isCompleted,
      );

  @override
  String toString() =>
      'DailyMission('
      'isFullBody: $isFullBody, '
      'muscles: '
      '${recommendedMuscleTypes.map((m) => m.name).join(",")}, '
      'completed: $isCompleted)';
}
