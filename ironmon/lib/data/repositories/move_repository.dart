import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ironmon/data/mappers/move_definition_mapper.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';

/// Loads move definitions from the bundled JSON asset.
class MoveRepository {
  /// Creates a [MoveRepository].
  const MoveRepository();

  static const _mapper = MoveDefinitionMapper();

  /// Loads all moves from `assets/data/moves.json`.
  Future<List<MoveDefinition>> loadMoves() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/moves.json',
    );
    final jsonList =
        json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map(
          (e) => _mapper
              .fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
