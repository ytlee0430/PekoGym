import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Maps JSON data to [MoveDefinition] domain models.
class MoveDefinitionMapper {
  /// Creates a [MoveDefinitionMapper].
  const MoveDefinitionMapper();

  /// Converts a JSON map to a [MoveDefinition].
  MoveDefinition fromJson(Map<String, dynamic> json) {
    return MoveDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _parseType(json['type'] as String),
      power: json['power'] as int,
      pp: json['pp'] as int,
      description: json['description'] as String,
      exerciseName:
          json['exerciseName'] as String,
      evolutionChainId:
          json['evolutionChainId'] as String?,
      evolutionStage:
          json['evolutionStage'] as int,
      unlockLevel: json['unlockLevel'] as int,
    );
  }

  /// Parses a [MuscleType] from its string name.
  MuscleType _parseType(String typeName) {
    return MuscleType.values.firstWhere(
      (t) => t.name == typeName,
      orElse: () => throw ArgumentError(
        'Unknown muscle type: $typeName',
      ),
    );
  }
}
