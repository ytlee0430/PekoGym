import 'package:flutter/foundation.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Recommendation for the next training session.
@immutable
class TrainingRecommendation {
  /// Creates a [TrainingRecommendation].
  const TrainingRecommendation({
    required this.muscleTypes,
    required this.isFullBody,
    required this.reason,
    this.confidence = 1.0,
  });

  /// Muscle groups recommended for this session.
  final List<MuscleType> muscleTypes;

  /// Whether this is a full-body session.
  final bool isFullBody;

  /// Human-readable reason for recommendation.
  final String reason;

  /// Confidence score (0.0 – 1.0).
  final double confidence;

  /// Returns a copy with updated fields.
  TrainingRecommendation copyWith({
    List<MuscleType>? muscleTypes,
    bool? isFullBody,
    String? reason,
    double? confidence,
  }) {
    return TrainingRecommendation(
      muscleTypes: muscleTypes ?? this.muscleTypes,
      isFullBody: isFullBody ?? this.isFullBody,
      reason: reason ?? this.reason,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingRecommendation &&
        listEquals(
          other.muscleTypes,
          muscleTypes,
        ) &&
        other.isFullBody == isFullBody &&
        other.reason == reason &&
        other.confidence == confidence;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(muscleTypes),
        isFullBody,
        reason,
        confidence,
      );

  @override
  String toString() =>
      'TrainingRecommendation('
      'isFullBody: $isFullBody, '
      'muscles: ${muscleTypes.map((m) => m.name).join(",")}, '
      'reason: $reason)';
}
