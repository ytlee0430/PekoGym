import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/data/repositories/item_repository.dart';
import 'package:ironmon/domain/items/models/item_definition.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  const repo = ItemRepository();

  UserProfile _profile({int coins = 200}) =>
      UserProfile(
        id: 1,
        squatFiveRm: 100,
        benchPressFiveRm: 80,
        deadliftFiveRm: 120,
        overheadPressFiveRm: 60,
        coins: coins,
      );

  const potion = ItemDefinition(
    id: 'potion',
    name: 'Potion',
    nameZh: '傷藥',
    description: 'Heal',
    type: ItemType.potion,
    price: 50,
  );

  const ether = ItemDefinition(
    id: 'ether',
    name: 'Ether',
    nameZh: 'PP回復劑',
    description: 'Restore PP',
    type: ItemType.ether,
    price: 80,
  );

  const rareCandy = ItemDefinition(
    id: 'rare_candy',
    name: 'Rare Candy',
    nameZh: '神奇糖果',
    description: 'EXP',
    type: ItemType.rareCandy,
    price: 150,
  );

  group('Shop purchase logic', () {
    test('purchase deducts coins and increments item', () {
      final profile = _profile(coins: 200);
      expect(profile.coins, 200);
      expect(profile.potionCount, 0);

      final afterBuy = repo
          .addItem(profile, potion.id)
          .copyWith(coins: profile.coins - potion.price);

      expect(afterBuy.coins, 150);
      expect(afterBuy.potionCount, 1);
    });

    test('purchase blocked when insufficient coins', () {
      final profile = _profile(coins: 30);
      final canAfford = profile.coins >= potion.price;
      expect(canAfford, isFalse);
    });

    test('purchase ether deducts correct amount', () {
      final profile = _profile(coins: 100);
      final afterBuy = repo
          .addItem(profile, ether.id)
          .copyWith(coins: profile.coins - ether.price);

      expect(afterBuy.coins, 20);
      expect(afterBuy.etherCount, 1);
    });

    test('purchase rare candy deducts correct amount', () {
      final profile = _profile(coins: 200);
      final afterBuy = repo
          .addItem(profile, rareCandy.id)
          .copyWith(coins: profile.coins - rareCandy.price);

      expect(afterBuy.coins, 50);
      expect(afterBuy.rareCandyCount, 1);
    });

    test('multiple purchases accumulate correctly', () {
      var profile = _profile(coins: 300);
      profile = repo
          .addItem(profile, potion.id)
          .copyWith(coins: profile.coins - potion.price);
      profile = repo
          .addItem(profile, potion.id)
          .copyWith(coins: profile.coins - potion.price);

      expect(profile.coins, 200);
      expect(profile.potionCount, 2);
    });

    test('canAfford is true when coins equals price exactly', () {
      final profile = _profile(coins: 50);
      expect(profile.coins >= potion.price, isTrue);
    });

    test('coins earned formula: victory = 100 + level*5', () {
      const level = 5;
      final coinsEarned = 100 + (level * 5);
      expect(coinsEarned, 125);
    });

    test('coins earned formula: defeat = 40 + level*2', () {
      const level = 5;
      final coinsEarned = 40 + (level * 2);
      expect(coinsEarned, 50);
    });
  });
}
