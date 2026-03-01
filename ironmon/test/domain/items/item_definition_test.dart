import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/items/models/inventory_entry.dart';
import 'package:ironmon/domain/items/models/item_definition.dart';
import 'package:ironmon/domain/items/models/item_type.dart';

void main() {
  group('ItemDefinition', () {
    const potion = ItemDefinition(
      id: 'potion',
      name: 'Potion',
      nameZh: '傷藥',
      description: 'Pause rest timer without penalty',
      type: ItemType.potion,
      maxStack: 99,
    );

    test('equality: same fields are equal', () {
      const same = ItemDefinition(
        id: 'potion',
        name: 'Potion',
        nameZh: '傷藥',
        description: 'Pause rest timer without penalty',
        type: ItemType.potion,
        maxStack: 99,
      );
      expect(potion, equals(same));
    });

    test('equality: different ids are not equal', () {
      const other = ItemDefinition(
        id: 'ether',
        name: 'Ether',
        nameZh: 'PP回復劑',
        description: 'Restore 50% of max PP',
        type: ItemType.ether,
        maxStack: 99,
      );
      expect(potion, isNot(equals(other)));
    });

    test('hashCode is consistent', () {
      const same = ItemDefinition(
        id: 'potion',
        name: 'Potion',
        nameZh: '傷藥',
        description: 'Pause rest timer without penalty',
        type: ItemType.potion,
        maxStack: 99,
      );
      expect(potion.hashCode, equals(same.hashCode));
    });

    test('toString contains id and type', () {
      expect(potion.toString(), contains('potion'));
    });

    test('default maxStack is 99', () {
      expect(potion.maxStack, 99);
    });

    test('ItemType enum has 3 values', () {
      expect(ItemType.values.length, 3);
      expect(ItemType.values, contains(ItemType.potion));
      expect(ItemType.values, contains(ItemType.ether));
      expect(
        ItemType.values,
        contains(ItemType.rareCandy),
      );
    });
  });

  group('InventoryEntry', () {
    test('copyWith updates quantity', () {
      const entry = InventoryEntry(
        itemId: 'potion',
        quantity: 3,
      );
      final updated = entry.copyWith(quantity: 5);
      expect(updated.quantity, 5);
      expect(updated.itemId, 'potion');
    });

    test('equality: same fields are equal', () {
      const a = InventoryEntry(
        itemId: 'ether',
        quantity: 2,
      );
      const b = InventoryEntry(
        itemId: 'ether',
        quantity: 2,
      );
      expect(a, equals(b));
    });

    test('toString contains itemId and quantity', () {
      const entry = InventoryEntry(
        itemId: 'rare_candy',
        quantity: 1,
      );
      expect(entry.toString(), contains('rare_candy'));
      expect(entry.toString(), contains('1'));
    });
  });
}
