import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/items/models/item_definition.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/shop/widgets/shop_item_card.dart';
import 'package:ironmon/providers/item_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Item shop screen where players spend coins on items.
class ShopScreen extends ConsumerWidget {
  /// Creates [ShopScreen].
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final itemsAsync = ref.watch(itemDefinitionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('道具商店')),
      body: profileAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile'));
          }
          return Column(
            children: [
              _CoinHeader(coins: profile.coins),
              Expanded(
                child: itemsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) =>
                      Center(child: Text('Error: $e')),
                  data: (items) => _ItemList(
                    items: items,
                    profile: profile,
                    onBuy: (item) => _handleBuy(
                      context,
                      ref,
                      profile,
                      item,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleBuy(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    ItemDefinition item,
  ) async {
    if (profile.coins < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('金幣不足！')),
      );
      return;
    }

    final itemRepo = ref.read(itemRepositoryProvider);
    final updated = itemRepo
        .addItem(profile, item.id)
        .copyWith(coins: profile.coins - item.price);

    await ref
        .read(userProfileProvider.notifier)
        .updateProfile(updated);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '購買了 ${item.nameZh}！剩餘 ${updated.coins} 金幣',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _CoinHeader extends StatelessWidget {
  const _CoinHeader({required this.coins});
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.monetization_on,
            color: Colors.amber,
          ),
          const SizedBox(width: 8),
          Text(
            '金幣: $coins',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.items,
    required this.profile,
    required this.onBuy,
  });

  final List<ItemDefinition> items;
  final UserProfile profile;
  final void Function(ItemDefinition) onBuy;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final item = items[i];
        final owned = switch (item.id) {
          'potion' => profile.potionCount,
          'ether' => profile.etherCount,
          'rare_candy' => profile.rareCandyCount,
          _ => 0,
        };
        return ShopItemCard(
          item: item,
          ownedCount: owned,
          playerCoins: profile.coins,
          onBuy: () => onBuy(item),
        );
      },
    );
  }
}
