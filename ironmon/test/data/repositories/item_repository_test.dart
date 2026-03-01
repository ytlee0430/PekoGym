import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/data/repositories/item_repository.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

void main() {
  const repo = ItemRepository();

  group('ItemRepository inventory operations', () {
    const base = UserProfile(
      potionCount: 2,
      etherCount: 1,
      rareCandyCount: 0,
    );

    group('getQuantity', () {
      test('returns potionCount', () {
        expect(repo.getQuantity(base, 'potion'), 2);
      });

      test('returns etherCount', () {
        expect(repo.getQuantity(base, 'ether'), 1);
      });

      test('returns rareCandyCount', () {
        expect(repo.getQuantity(base, 'rare_candy'), 0);
      });

      test('returns 0 for unknown item', () {
        expect(repo.getQuantity(base, 'unknown'), 0);
      });
    });

    group('addItem', () {
      test('increments potionCount', () {
        final updated = repo.addItem(base, 'potion');
        expect(updated.potionCount, 3);
        expect(updated.etherCount, 1);
      });

      test('increments etherCount', () {
        final updated = repo.addItem(base, 'ether');
        expect(updated.etherCount, 2);
      });

      test('increments rareCandyCount', () {
        final updated = repo.addItem(base, 'rare_candy');
        expect(updated.rareCandyCount, 1);
      });

      test('clamps to maxStack', () {
        const full = UserProfile(potionCount: 99);
        final updated =
            repo.addItem(full, 'potion', maxStack: 99);
        expect(updated.potionCount, 99);
      });

      test('supports custom amount', () {
        final updated =
            repo.addItem(base, 'potion', amount: 5);
        expect(updated.potionCount, 7);
      });

      test('unknown itemId returns unchanged profile', () {
        final updated = repo.addItem(base, 'mystery');
        expect(updated, equals(base));
      });
    });

    group('removeItem', () {
      test('decrements potionCount', () {
        final updated = repo.removeItem(base, 'potion');
        expect(updated.potionCount, 1);
      });

      test('does not go below 0', () {
        final updated = repo.removeItem(base, 'rare_candy');
        expect(updated.rareCandyCount, 0);
      });

      test('returns unchanged when count is 0', () {
        final updated = repo.removeItem(base, 'rare_candy');
        expect(updated, equals(base));
      });
    });
  });
}
