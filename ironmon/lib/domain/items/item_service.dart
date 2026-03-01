import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/domain/shared/result.dart';

/// Pure-Dart service that applies item effects to [BattleState].
/// Items can only be used between sets (when [BattleState.canUseItem]).
class ItemService {
  /// Creates an [ItemService].
  const ItemService();

  /// Applies a Potion: pauses the rest timer.
  /// Returns [Failure] when item cannot be used.
  Result<BattleState, String> usePotion(
    BattleState state,
    int potionCount,
  ) {
    if (!state.canUseItem) {
      return const Failure('Cannot use items mid-set');
    }
    if (potionCount <= 0) {
      return const Failure('No Potions remaining');
    }
    return Success(
      state.copyWith(
        restTimerPaused: true,
        itemsUsed: [...state.itemsUsed, 'potion'],
      ),
    );
  }

  /// Applies an Ether: restores 50% of max PP.
  /// Returns [Failure] when item cannot be used.
  Result<BattleState, String> useEther(
    BattleState state,
    int etherCount,
  ) {
    if (!state.canUseItem) {
      return const Failure('Cannot use items mid-set');
    }
    if (etherCount <= 0) {
      return const Failure('No Ethers remaining');
    }
    final restored =
        (state.maxPlayerPp * 0.5).round();
    final newPp =
        (state.playerPp + restored)
            .clamp(0, state.maxPlayerPp);
    return Success(
      state.copyWith(
        playerPp: newPp,
        itemsUsed: [...state.itemsUsed, 'ether'],
      ),
    );
  }

  /// Validates a Rare Candy use (inventory check).
  /// Actual move XP is applied via UserProfile.
  Result<String, String> validateRareCandy(
    int rareCandyCount,
    String moveId,
  ) {
    if (rareCandyCount <= 0) {
      return const Failure('No Rare Candies remaining');
    }
    if (moveId.isEmpty) {
      return const Failure('No move selected');
    }
    return Success(moveId);
  }

  /// Marks a Rare Candy as used in battle state.
  BattleState recordRareCandyUse(BattleState state) {
    return state.copyWith(
      itemsUsed: [...state.itemsUsed, 'rare_candy'],
    );
  }

  /// Returns the item ID from [type].
  static String itemId(ItemType type) {
    return switch (type) {
      ItemType.potion => 'potion',
      ItemType.ether => 'ether',
      ItemType.rareCandy => 'rare_candy',
    };
  }
}
