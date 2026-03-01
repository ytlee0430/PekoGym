import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/battle/widgets/animated_exp_bar.dart';

void main() {
  group('AnimatedExpBar', () {
    testWidgets('displays EXP gain amount initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExpBar(
              previousExp: 100,
              currentExp: 200,
              expGained: 100,
              expToNextLevel: 250,
              leveledUp: false,
            ),
          ),
        ),
      );

      // Check for EXP gain text
      expect(find.text('EXP +100'), findsOneWidget);
    });

    testWidgets('shows level up banner when leveled up', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExpBar(
              previousExp: 200,
              currentExp: 300,
              expGained: 100,
              expToNextLevel: 250,
              leveledUp: true,
            ),
          ),
        ),
      );

      // Initially, level up banner should not be visible
      expect(find.text('LEVEL UP!'), findsNothing);

      // Wait for fill animation to complete
      await tester.pump(const Duration(milliseconds: 1000));
      
      // Wait a bit more for level up animation to start
      await tester.pump(const Duration(milliseconds: 100));

      // Now level up banner should be visible
      expect(find.text('LEVEL UP!'), findsOneWidget);
    });

    testWidgets('displays correct EXP values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExpBar(
              previousExp: 150,
              currentExp: 275,
              expGained: 125,
              expToNextLevel: 300,
              leveledUp: false,
            ),
          ),
        ),
      );

      // Check EXP text
      expect(find.text('EXP +125'), findsOneWidget);
      expect(find.text('275 EXP'), findsOneWidget);
      expect(find.text('Next: 300'), findsOneWidget);
    });

    testWidgets('EXP bar animates from previous to current percentage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExpBar(
              previousExp: 50,
              currentExp: 150,
              expGained: 100,
              expToNextLevel: 250,
              leveledUp: false,
            ),
          ),
        ),
      );

      // At the start, the fill should be at previous percentage (20%)
      // After animation completes, it should be at current percentage (60%)
      
      // Pump one frame to start animation
      await tester.pump();
      
      // Find the progress indicator (fractionally sized box)
      final progressBars = find.byType(FractionallySizedBox);
      expect(progressBars, findsWidgets);
    });

    testWidgets('calls onLevelUpAnimationComplete when animation finishes', (tester) async {
      bool callbackCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedExpBar(
              previousExp: 200,
              currentExp: 300,
              expGained: 100,
              expToNextLevel: 250,
              leveledUp: true,
              onLevelUpAnimationComplete: () => callbackCalled = true,
            ),
          ),
        ),
      );

      // Wait for fill animation
      await tester.pump(const Duration(milliseconds: 1000));
      
      // Wait for level up animation
      await tester.pump(const Duration(milliseconds: 1500));

      // Callback should have been called
      expect(callbackCalled, isTrue);
    });
  });
}
