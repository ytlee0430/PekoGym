import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// In-memory registry of all available battle moves.
/// Pure Dart — zero Flutter dependency.
class MoveRegistry {
  /// Creates a [MoveRegistry] from a list of moves.
  MoveRegistry(List<MoveDefinition> moves)
      : _moves = Map.fromEntries(
          moves.map((m) => MapEntry(m.id, m)),
        );

  final Map<String, MoveDefinition> _moves;

  /// Returns all loaded moves.
  List<MoveDefinition> get allMoves =>
      List.unmodifiable(_moves.values);

  /// Returns a move by [id], or null if not found.
  MoveDefinition? getMove(String id) => _moves[id];

  /// Returns all moves of the given [type].
  List<MoveDefinition> getMovesByType(
    MuscleType type,
  ) {
    return _moves.values
        .where((m) => m.type == type)
        .toList();
  }

  /// Returns moves whose IDs are in [unlockedMoveIds].
  List<MoveDefinition> getUnlockedMoves(
    List<String> unlockedMoveIds,
  ) {
    return unlockedMoveIds
        .map((id) => _moves[id])
        .whereType<MoveDefinition>()
        .toList();
  }

  /// Returns all moves in the given evolution chain,
  /// sorted by [evolutionStage].
  List<MoveDefinition> getEvolutionChain(
    String evolutionChainId,
  ) {
    return _moves.values
        .where(
          (m) => m.evolutionChainId == evolutionChainId,
        )
        .toList()
      ..sort(
        (a, b) =>
            a.evolutionStage.compareTo(b.evolutionStage),
      );
  }

  /// Returns IDs of stage-1 moves (default unlocks).
  List<String> get defaultUnlockedMoveIds {
    final seen = <MuscleType>{};
    final ids = <String>[];
    final stage1 = _moves.values
        .where((m) => m.evolutionStage == 1)
        .toList()
      ..sort((a, b) => a.type.index.compareTo(
            b.type.index,
          ));
    for (final move in stage1) {
      if (seen.add(move.type)) {
        ids.add(move.id);
      }
    }
    return ids;
  }
}
