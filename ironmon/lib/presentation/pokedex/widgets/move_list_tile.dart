import 'package:flutter/material.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/presentation/shared/type_badge.dart';

/// List tile for a move in the Pokédex.
/// Shows full details if unlocked, greyed-out
/// with lock icon if locked.
class MoveListTile extends StatelessWidget {
  /// Creates a [MoveListTile].
  const MoveListTile({
    required this.move,
    required this.isUnlocked,
    this.onTap,
    super.key,
  });

  /// The move to display.
  final MoveDefinition move;

  /// Whether the move is unlocked.
  final bool isUnlocked;

  /// Tap callback (only for unlocked moves).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isUnlocked) {
      return _buildUnlocked(context);
    }
    return _buildLocked(context);
  }

  Widget _buildUnlocked(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              TypeBadge.colorFor(move.type)
                  .withValues(alpha: 0.2),
          child: Text(
            'P${move.power}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color:
                  TypeBadge.colorFor(move.type),
            ),
          ),
        ),
        title: Text(
          move.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(move.exerciseName),
        trailing: TypeBadge(
          type: move.type,
          small: true,
        ),
      ),
    );
  }

  Widget _buildLocked(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      color: Colors.grey.shade900,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.grey.shade800,
          child: const Icon(
            Icons.lock,
            size: 18,
            color: Colors.grey,
          ),
        ),
        title: Text(
          move.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          'Unlock at Lv.${move.unlockLevel}',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        trailing: TypeBadge(
          type: move.type,
          small: true,
        ),
      ),
    );
  }
}
