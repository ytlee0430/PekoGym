import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/presentation/onboarding/onboarding_screen.dart';

void main() {
  group('OnboardingScreen', () {
    testWidgets('shows welcome page on first load', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Check welcome page elements
      expect(find.text('Welcome to IronMon!'), findsOneWidget);
      expect(find.text('Training is Battle,\nProgress is Upgrade'), findsOneWidget);
      expect(find.text('Begin Your Journey'), findsOneWidget);
      
      // Check page indicator shows first page
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('navigates to mode select page', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Begin Your Journey'));
      await tester.pumpAndSettle();

      // Check mode select page
      expect(find.text('Choose Your Path'), findsOneWidget);
      expect(find.text('Beginner Mode'), findsOneWidget);
      expect(find.text('Experienced Mode'), findsOneWidget);
    });

    testWidgets('beginner mode skips 5RM input cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Navigate to mode select
      await tester.tap(find.text('Begin Your Journey'));
      await tester.pumpAndSettle();

      // Select beginner mode
      await tester.tap(find.text('Beginner Mode'));
      await tester.pumpAndSettle();

      // Navigate to frequency page (should skip 5RM cards)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beginner Mode'));
      await tester.pumpAndSettle();

      // Check that we're on frequency page (3rd page for beginner mode)
      expect(find.text('Training Frequency'), findsOneWidget);
    });

    testWidgets('experienced mode shows 5RM input cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Navigate to mode select
      await tester.tap(find.text('Begin Your Journey'));
      await tester.pumpAndSettle();

      // Select experienced mode
      await tester.tap(find.text('Experienced Mode'));
      await tester.pumpAndSettle();

      // Navigate to first 5RM card
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Experienced Mode'));
      await tester.pumpAndSettle();

      // Should be on first 5RM page (chest)
      expect(find.text('胸部'), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
    });

    testWidgets('page indicators update correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Initial page - first indicator active
      final indicators = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(indicators.first.decoration?.shape, BoxShape.rectangle);

      // Navigate to next page
      await tester.tap(find.text('Begin Your Journey'));
      await tester.pumpAndSettle();

      // Second indicator should now be active
      final newIndicators = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      // Check that the second indicator is now wider (active state)
      expect(newIndicators.elementAt(1).constraints?.maxWidth, 24);
    });
  });
}
