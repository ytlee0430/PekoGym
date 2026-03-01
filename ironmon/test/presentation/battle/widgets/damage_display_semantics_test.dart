import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/battle/damage_result.dart';
import 'package:ironmon/presentation/battle/widgets/damage_display.dart';

void main() {
  group('DamageDisplay Semantics', () {
    testWidgets('is a live region for dynamic updates', (tester) async {
      final damageResult = DamageResult(
        baseDamage: 50,
        finalDamage: 50,
        effectiveness: DamageEffectiveness.normal,
        isCritical: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: DamageDisplay(
                damage: damageResult,
                top: 50,
                left: 50,
              ),
            ),
          ),
        ),
      );

      // Find the semantics widget
      expect(find.byType(Semantics), findsOneWidget);
      
      // Get the semantics properties
      final semantics = tester.semantics(find.byType(Semantics));
      
      // Check that it's a live region
      expect(semantics.liveRegion, isTrue);
    });

    testWidgets('announces damage with effectiveness', (tester) async {
      final damageResult = DamageResult(
        baseDamage: 50,
        finalDamage: 50,
        effectiveness: DamageEffectiveness.superEffective,
        isCritical: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: DamageDisplay(
                damage: damageResult,
                top: 50,
                left: 50,
              ),
            ),
          ),
        ),
      );

      // Check the semantic label
      final semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('Dealt 50 damage, Super effective!'),
      );
    });

    testWidgets('announces critical hits', (tester) async {
      final damageResult = DamageResult(
        baseDamage: 75,
        finalDamage: 75,
        effectiveness: DamageEffectiveness.normal,
        isCritical: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: DamageDisplay(
                damage: damageResult,
                top: 50,
                left: 50,
              ),
            ),
          ),
        ),
      );

      // Check the semantic label
      final semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('Dealt 75 damage, Critical hit!'),
      );
    });

    testWidgets('announces not very effective damage', (tester) async {
      final damageResult = DamageResult(
        baseDamage: 25,
        finalDamage: 25,
        effectiveness: DamageEffectiveness.notVeryEffective,
        isCritical: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: DamageDisplay(
                damage: damageResult,
                top: 50,
                left: 50,
              ),
            ),
          ),
        ),
      );

      // Check the semantic label
      final semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('Dealt 25 damage, Not very effective'),
      );
    });

    testWidgets('announces normal damage', (tester) async {
      final damageResult = DamageResult(
        baseDamage: 40,
        finalDamage: 40,
        effectiveness: DamageEffectiveness.normal,
        isCritical: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: DamageDisplay(
                damage: damageResult,
                top: 50,
                left: 50,
              ),
            ),
          ),
        ),
      );

      // Check the semantic label
      final semantics = tester.semantics(find.byType(Semantics));
      expect(
        semantics.label,
        contains('Dealt 40 damage, Normal damage'),
      );
    });
  });
}
