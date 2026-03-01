import 'package:flutter/material.dart';
import 'package:ironmon/domain/items/models/item_definition.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Card displaying a single item for purchase in the shop.
class ShopItemCard extends StatelessWidget {
  /// Creates a [ShopItemCard].
  const ShopItemCard({
    required this.item,
    required this.ownedCount,
    required this.playerCoins,
    required this.onBuy,
    super.key,
  });

  /// The item definition to display.
  final ItemDefinition item;

  /// Number of this item the player already holds.
  final int ownedCount;

  /// Player's current coin balance.
  final int playerCoins;

  /// Called when the buy button is tapped.
  final VoidCallback onBuy;

  bool get _canAfford => playerCoins >= item.price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: IronMonColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.nameZh} (${item.name})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.price}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '所持: $ownedCount',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Buy button
            ElevatedButton(
              onPressed: _canAfford ? onBuy : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    IronMonColors.primary,
              ),
              child: const Text('購買'),
            ),
          ],
        ),
      ),
    );
  }
}
