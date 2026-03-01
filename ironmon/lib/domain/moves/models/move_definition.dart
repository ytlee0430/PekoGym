import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Immutable domain model for a battle move definition.
/// Pure Dart — zero Flutter/Drift dependency.
class MoveDefinition {
  /// Creates a [MoveDefinition].
  const MoveDefinition({
    required this.id,
    required this.name,
    required this.type,
    required this.power,
    required this.pp,
    required this.description,
    required this.exerciseName,
    required this.evolutionStage,
    required this.unlockLevel,
    this.evolutionChainId,
  });

  /// Unique identifier (e.g., "chest-1").
  final String id;

  /// Display name of the move.
  final String name;

  /// Muscle type / element.
  final MuscleType type;

  /// Base power value.
  final int power;

  /// Power points (max uses per battle).
  final int pp;

  /// Move description text.
  final String description;

  /// Real-world exercise name.
  final String exerciseName;

  /// Evolution chain group ID (null if standalone).
  final String? evolutionChainId;

  /// Stage within the evolution chain (1-based).
  final int evolutionStage;

  /// Player level required to unlock.
  final int unlockLevel;

  /// Returns a copy with updated fields.
  MoveDefinition copyWith({
    String? id,
    String? name,
    MuscleType? type,
    int? power,
    int? pp,
    String? description,
    String? exerciseName,
    String? evolutionChainId,
    int? evolutionStage,
    int? unlockLevel,
  }) {
    return MoveDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      power: power ?? this.power,
      pp: pp ?? this.pp,
      description: description ?? this.description,
      exerciseName:
          exerciseName ?? this.exerciseName,
      evolutionChainId:
          evolutionChainId ?? this.evolutionChainId,
      evolutionStage:
          evolutionStage ?? this.evolutionStage,
      unlockLevel: unlockLevel ?? this.unlockLevel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoveDefinition &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.power == power &&
        other.pp == pp &&
        other.description == description &&
        other.exerciseName == exerciseName &&
        other.evolutionChainId ==
            evolutionChainId &&
        other.evolutionStage == evolutionStage &&
        other.unlockLevel == unlockLevel;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        type,
        power,
        pp,
        description,
        exerciseName,
        evolutionChainId,
        evolutionStage,
        unlockLevel,
      );

  @override
  String toString() =>
      'MoveDefinition(id: $id, name: $name, '
      'type: ${type.name}, power: $power, '
      'pp: $pp, stage: $evolutionStage)';
}
