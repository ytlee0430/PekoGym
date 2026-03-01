import 'package:flutter/material.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Item panel showing usable items with inventory counts.
/// Items are disabled when [canUse] is false (mid-set guard).
class ItemPanel extends StatelessWidget {
  /// Creates an [ItemPanel].
  const ItemPanel({
    required this.potionCount,
    required this.etherCount,
    required this.rareCandyCount,
    required this.canUse,
    required this.onUseItem,
    super.key,
  });

  /// Number of Potions held.
  final int potionCount;

  /// Number of Ethers held.
  final int etherCount;

  /// Number of Rare Candies held.
  final int rareCandyCount;

  /// Whether items can be used (false mid-set).
  final bool canUse;

  /// Called when the player taps an item button.
  final void Function(ItemType) onUseItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
      children: [
        _ItemButton(
          label: '傷藥',
          count: potionCount,
          enabled: canUse && potionCount > 0,
          onTap: () => onUseItem(ItemType.potion),
          color: IronMonColors.hpHigh,
        ),
        _ItemButton(
          label: 'PP劑',
          count: etherCount,
          enabled: canUse && etherCount > 0,
          onTap: () => onUseItem(ItemType.ether),
          color: IronMonColors.primary,
        ),
        _ItemButton(
          label: '糖果',
          count: rareCandyCount,
          enabled: canUse && rareCandyCount > 0,
          onTap: () => onUseItem(ItemType.rareCandy),
          color: IronMonColors.secondary,
        ),
      ],
    );
  }
}

class _ItemButton extends StatelessWidget {
  const _ItemButton({
    required this.label,
    required this.count,
    required this.enabled,
    required this.onTap,
    required this.color,
  });

  final String label;
  final int count;
  final bool enabled;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        enabled ? color : IronMonColors.onSurfaceVariant;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: IronMonColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: effectiveColor.withValues(
              alpha: enabled ? 1.0 : 0.4,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: effectiveColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'x$count',
              style: TextStyle(
                fontSize: 11,
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
