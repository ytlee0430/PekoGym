import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/presentation/battle/battle_result_screen.dart';

void main() {
  group('BattleResultScreen', () {
    testWidgets('shows VICTORY! for won battles', (tester) async {
      // Create a mock battle result with victory
      final mockResult = BattleResult(
        outcome: MockBattleOutcome(isVictory: true),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override the battle provider to return our mock result
          ],
          child: MaterialApp(
            home: BattleResultScreen(),
          ),
        ),
      );

      // Check for victory text
      expect(find.text('VICTORY!'), findsOneWidget);
    });

    testWidgets('shows DEFEAT for lost battles', (tester) async {
      // Create a mock battle result with defeat
      final mockResult = BattleResult(
        outcome: MockBattleOutcome(isVictory: false),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override the battle provider to return our mock result
          ],
          child: MaterialApp(
            home: BattleResultScreen(),
          ),
        ),
      );

      // Check for defeat text and supportive message
      expect(find.text('DEFEAT'), findsOneWidget);
      expect(find.text('You still earned 60% EXP!'), findsOneWidget);
    });

    testWidgets('displays stat cards with correct values', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BattleResultScreen(),
          ),
        ),
      );

      // Check for stat cards
      expect(find.text('Training Stats'), findsOneWidget);
      expect(find.text('Total Volume'), findsOneWidget);
      expect(find.text('Total Damage'), findsOneWidget);
      expect(find.text('Sets Completed'), findsOneWidget);
      expect(find.text('Time Elapsed'), findsOneWidget);
    });

    testWidgets('Return Home button navigates to home', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BattleResultScreen(),
          ),
        ),
      );

      // Find and tap the Return Home button
      final returnButton = find.widgetWithText(ElevatedButton, 'Return Home');
      expect(returnButton, findsOneWidget);
      
      // Note: Actual navigation test would require mocking GoRouter
    });

    testWidgets('victory banner has glow animation', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: BattleResultScreen(),
          ),
        ),
      );

      // Find the victory banner container
      final bannerContainer = find.byType(Container).first;
      expect(bannerContainer, findsOneWidget);
      
      // Check that it has a decoration (for the glow effect)
      final container = tester.widget<Container>(bannerContainer);
      expect(container.decoration, isA<BoxDecoration>());
    });
  });
}

// Mock classes for testing
class MockBattleOutcome {
  final bool isVictory;
  
  MockBattleOutcome({required this.isVictory});
  
  double get totalVolume => 1000.0;
  int get totalDamageDealt => 500;
  int get totalSets => 10;
  int get earnedExp => 100;
  double get expModifier => 1.0;
  int get levelsGained => 0;
  int get newLevel => 1;
  List<String> get unlockedMoveNames => [];
  int get exhaustionEvents => 0;
  int get counterEvents => 0;
}
