import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/data/repositories/item_repository.dart';
import 'package:ironmon/domain/items/models/item_definition.dart';
import 'package:ironmon/domain/items/models/inventory_entry.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Provides the [ItemRepository].
final itemRepositoryProvider =
    Provider<ItemRepository>((ref) {
  return const ItemRepository();
});

/// Loads and caches all [ItemDefinition]s from JSON.
final itemDefinitionsProvider =
    FutureProvider<List<ItemDefinition>>((ref) async {
  final repo = ref.watch(itemRepositoryProvider);
  return repo.loadItems();
});

/// Derives the player's current inventory from [UserProfile].
final inventoryProvider =
    Provider<List<InventoryEntry>>((ref) {
  final profileAsync = ref.watch(userProfileProvider);
  return profileAsync.when(
    data: (profile) {
      if (profile == null) return const [];
      return [
        InventoryEntry(
          itemId: 'potion',
          quantity: profile.potionCount,
        ),
        InventoryEntry(
          itemId: 'ether',
          quantity: profile.etherCount,
        ),
        InventoryEntry(
          itemId: 'rare_candy',
          quantity: profile.rareCandyCount,
        ),
      ];
    },
    loading: () => const [],
    error: (_, __) => const [],
  );
});
