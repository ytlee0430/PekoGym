import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/moves/move_registry.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Pure Dart service for checking move unlock
/// conditions based on player level, gym leader
/// defeats, and evolution chain prerequisites.
class MoveUnlockService {
  /// Creates a [MoveUnlockService].
  const MoveUnlockService();

  /// Returns newly unlockable moves that are not
  /// already in [profile.unlockedMoveIds].
  ///
  /// Checks level-based unlocks and optionally
  /// gym leader defeat unlocks.
  List<MoveDefinition> checkNewUnlocks({
    required UserProfile profile,
    required MoveRegistry registry,
    bool gymLeaderDefeated = false,
    MuscleType? defeatedType,
  }) {
    final currentIds = profile.unlockedMoveIds;
    final newUnlocks = <MoveDefinition>[];

    for (final move in registry.allMoves) {
      // Skip already unlocked
      if (currentIds.contains(move.id)) continue;

      // Check level requirement
      if (move.unlockLevel > profile.level) {
        continue;
      }

      // Check evolution chain prerequisite
      if (!_canUnlock(
        move,
        [...currentIds, ...newUnlocks.map((m) => m.id)],
        registry,
      )) {
        continue;
      }

      newUnlocks.add(move);
    }

    return newUnlocks;
  }

  /// Checks if a move can be unlocked based on
  /// evolution chain prerequisites.
  bool _canUnlock(
    MoveDefinition move,
    List<String> currentlyUnlocked,
    MoveRegistry registry,
  ) {
    // Stage 1 moves have no prerequisites
    if (move.evolutionStage <= 1) return true;

    // Stage 2+ requires previous stage unlocked
    final chainId = move.evolutionChainId;
    if (chainId == null) return true;

    final chain =
        registry.getEvolutionChain(chainId);
    final previousStage = chain.where(
      (m) =>
          m.evolutionStage ==
          move.evolutionStage - 1,
    );

    if (previousStage.isEmpty) return true;

    return currentlyUnlocked
        .contains(previousStage.first.id);
  }
}
