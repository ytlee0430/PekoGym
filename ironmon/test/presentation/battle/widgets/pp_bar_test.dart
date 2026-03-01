import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/battle/widgets/pp_bar.dart';

void main() {
  group('PpBar', () {
    testWidgets('renders current/max PP text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PpBar(currentPp: 95, maxPp: 110),
          ),
        ),
      );

      expect(find.text('PP'), findsOneWidget);
      expect(find.text('95/110'), findsOneWidget);
    });

    testWidgets('renders with zero PP', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PpBar(currentPp: 0, maxPp: 110),
          ),
        ),
      );

      expect(find.text('0/110'), findsOneWidget);
    });

    testWidgets('renders with full PP', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PpBar(currentPp: 110, maxPp: 110),
          ),
        ),
      );

      expect(find.text('110/110'), findsOneWidget);
    });

    testWidgets(
      'updates text when PP changes',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PpBar(currentPp: 110, maxPp: 110),
            ),
          ),
        );
        expect(find.text('110/110'), findsOneWidget);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PpBar(currentPp: 95, maxPp: 110),
            ),
          ),
        );
        // After pump, the text should update
        expect(find.text('95/110'), findsOneWidget);
      },
    );

    testWidgets(
      'handles zero maxPp without crash',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PpBar(currentPp: 0, maxPp: 0),
            ),
          ),
        );

        expect(find.text('0/0'), findsOneWidget);
      },
    );
  });
}
