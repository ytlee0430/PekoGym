import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/battle/widgets/screen_shake.dart';

void main() {
  group('ScreenShake', () {
    testWidgets('can trigger shake animation', (tester) async {
      final shakeKey = GlobalKey<_ScreenShakeState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenShake(
              key: shakeKey,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Test Content'), findsOneWidget);
      
      // Trigger shake
      shakeKey.currentState?.shake();
      await tester.pump();
      
      // Verify animation is running
      expect(shakeKey.currentState?._controller.status, AnimationStatus.forward);
    });

    testWidgets('shake animation completes and resets', (tester) async {
      final shakeKey = GlobalKey<_ScreenShakeState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenShake(
              key: shakeKey,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Trigger shake
      shakeKey.currentState?.shake();
      await tester.pump();
      
      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 50));
      
      // Verify controller reset
      expect(shakeKey.currentState?._controller.status, AnimationStatus.dismissed);
    });

    testWidgets('multiple shakes queue properly', (tester) async {
      final shakeKey = GlobalKey<_ScreenShakeState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenShake(
              key: shakeKey,
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      // Trigger shake while already shaking (should be ignored)
      shakeKey.currentState?.shake();
      await tester.pump();
      shakeKey.currentState?.shake();
      
      // Animation should still complete normally
      await tester.pump(const Duration(milliseconds: 200));
      expect(shakeKey.currentState?._controller.status, AnimationStatus.dismissed);
    });
  });
}
