import 'package:flutter/material.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/presentation/shared/type_badge.dart';

/// Displays an evolution chain as a horizontal
/// sequence of move cards with arrows.
class EvolutionChainView extends StatelessWidget {
  /// Creates an [EvolutionChainView].
  const EvolutionChainView({
    required this.chain,
    required this.currentMoveId,
    required this.unlockedIds,
    super.key,
  });

  /// Moves in the evolution chain, sorted by
  /// stage.
  final List<MoveDefinition> chain;

  /// ID of the currently viewed move.
  final String currentMoveId;

  /// IDs of unlocked moves.
  final List<String> unlockedIds;

  @override
  Widget build(BuildContext context) {
    if (chain.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < chain.length; i++)
            ...[
              _ChainNode(
                move: chain[i],
                isCurrent:
                    chain[i].id == currentMoveId,
                isUnlocked: unlockedIds
                    .contains(chain[i].id),
              ),
              if (i < chain.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
            ],
        ],
      ),
    );
  }
}

/// A single node in the evolution chain.
class _ChainNode extends StatelessWidget {
  const _ChainNode({
    required this.move,
    required this.isCurrent,
    required this.isUnlocked,
  });

  final MoveDefinition move;
  final bool isCurrent;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final color = isUnlocked
        ? TypeBadge.colorFor(move.type)
        : Colors.grey;

    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withValues(alpha: 0.2)
            : Colors.transparent,
        border: Border.all(
          color: color,
          width: isCurrent ? 2 : 1,
        ),
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            move.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isCurrent
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isUnlocked
                  ? Colors.white
                  : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            isUnlocked
                ? 'Lv.${move.unlockLevel} ✓'
                : 'Lv.${move.unlockLevel} 🔒',
            style: TextStyle(
              fontSize: 10,
              color: isUnlocked
                  ? Colors.green
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'P${move.power}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
