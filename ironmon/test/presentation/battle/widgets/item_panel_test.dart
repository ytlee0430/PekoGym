import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/presentation/battle/widgets/item_panel.dart';

void main() {
  group('ItemPanel', () {
    testWidgets('renders item labels and counts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemPanel(
              potionCount: 3,
              etherCount: 1,
              rareCandyCount: 0,
              canUse: true,
              onUseItem: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('傷藥'), findsOneWidget);
      expect(find.text('PP劑'), findsOneWidget);
      expect(find.text('糖果'), findsOneWidget);
      expect(find.text('x3'), findsOneWidget);
      expect(find.text('x1'), findsOneWidget);
      expect(find.text('x0'), findsOneWidget);
    });

    testWidgets('calls onUseItem with correct type', (tester) async {
      ItemType? used;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemPanel(
              potionCount: 1,
              etherCount: 1,
              rareCandyCount: 1,
              canUse: true,
              onUseItem: (type) => used = type,
            ),
          ),
        ),
      );

      await tester.tap(find.text('傷藥'));
      expect(used, equals(ItemType.potion));

      await tester.tap(find.text('PP劑'));
      expect(used, equals(ItemType.ether));
    });

    testWidgets('items with 0 count do not trigger callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemPanel(
              potionCount: 0,
              etherCount: 0,
              rareCandyCount: 0,
              canUse: true,
              onUseItem: (_) => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('傷藥'));
      expect(tapped, isFalse);
    });

    testWidgets('canUse=false disables all buttons', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemPanel(
              potionCount: 5,
              etherCount: 5,
              rareCandyCount: 5,
              canUse: false,
              onUseItem: (_) => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('傷藥'));
      expect(tapped, isFalse);
    });
  });
}
