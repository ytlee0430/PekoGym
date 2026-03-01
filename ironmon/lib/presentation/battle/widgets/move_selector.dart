import 'package:flutter/material.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Horizontal scrollable move selector chips.
class MoveSelector extends StatelessWidget {
  /// Creates a [MoveSelector].
  const MoveSelector({
    required this.moves,
    required this.selectedMoveId,
    required this.onMoveSelected,
    super.key,
  });

  /// Available moves for the current muscle type.
  final List<MoveDefinition> moves;

  /// Currently selected move ID.
  final String? selectedMoveId;

  /// Callback when a move is selected.
  final ValueChanged<String> onMoveSelected;

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        itemCount: moves.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final move = moves[index];
          final isSelected =
              move.id == selectedMoveId;
          final typeColor =
              IronMonColors.colorForType(move.type);
          return ChoiceChip(
            label: Text(move.name),
            selected: isSelected,
            selectedColor: typeColor.withValues(
              alpha: 0.3,
            ),
            side: isSelected
                ? BorderSide(color: typeColor)
                : BorderSide.none,
            onSelected: (_) =>
                onMoveSelected(move.id),
          );
        },
      ),
    );
  }
}
