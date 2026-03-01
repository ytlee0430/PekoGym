import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/battle/widgets/boss_hp_bar.dart';

void main() {
  group('BossHpBar Semantics', () {
    testWidgets('has correct semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BossHpBar(
              currentHp: 75,
              maxHp: 100,
              bossName: 'TestBoss',
            ),
          ),
        ),
      );

      // Find the semantics widget
      expect(find.byType(Semantics), findsOneWidget);
      
      // Get the semantics properties
      final semantics = tester.semantics(find.byType(Semantics));
      
      // Check the semantic label
      expect(
        semantics.label,
        contains('Boss TestBoss, HP 75 out of 100, 75 percent'),
      );
    });

    testWidgets('semantic label updates with HP changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BossHpBar(
              currentHp: 50,
              maxHp: 100,
              bossName: 'TestBoss',
            ),
          ),
        ),
      );

      // Initial semantic label
      var semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('HP 50 out of 100, 50 percent'),
      );

      // Update HP
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BossHpBar(
              currentHp: 25,
              maxHp: 100,
              bossName: 'TestBoss',
            ),
          ),
        ),
      );

      // Wait for animation
      await tester.pump();

      // Check updated semantic label
      semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('HP 25 out of 100, 25 percent'),
      );
    });

    testWidgets('handles zero max HP gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BossHpBar(
              currentHp: 0,
              maxHp: 0,
              bossName: 'TestBoss',
            ),
          ),
        ),
      );

      // Should not crash and should show 0 percent
      final semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('HP 0 out of 0, 0 percent'),
      );
    });

    testWidgets('respects reduce motion setting', (tester) async {
      // Set up with reduce motion
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              disableAnimations: true,
            ),
            child: Scaffold(
              body: BossHpBar(
                currentHp: 50,
                maxHp: 100,
                bossName: 'TestBoss',
              ),
            ),
          ),
        ),
      );

      // The widget should still render correctly
      expect(find.byType(BossHpBar), findsOneWidget);
      expect(find.text('TestBoss'), findsOneWidget);
      expect(find.text('50/100'), findsOneWidget);
    });
  });
}
