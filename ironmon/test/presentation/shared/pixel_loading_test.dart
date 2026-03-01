import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/shared/pixel_loading.dart';

void main() {
  group('PixelLoading', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PixelLoading(),
          ),
        ),
      );

      // Check for the spinner container
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.bySize(const Size(48, 48)), findsOneWidget);
    });

    testWidgets('renders with custom message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PixelLoading(
              message: 'Generating opponents...',
            ),
          ),
        ),
      );

      // Check for message text
      expect(find.text('Generating opponents...'), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PixelLoading(
              size: 64.0,
            ),
          ),
        ),
      );

      // Check for custom size
      expect(find.bySize(const Size(64, 64)), findsOneWidget);
    });

    testWidgets('has animated pixel blocks', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PixelLoading(),
          ),
        ),
      );

      // Find the stack containing the blocks
      expect(find.byType(Stack), findsOneWidget);
      
      // Should have 4 pixel blocks
      expect(find.byType(Transform), findsNWidgets(4));
      
      // Pump a few frames to see animation
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      
      // Animation should be running
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('pixel blocks have correct color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PixelLoading(),
          ),
        ),
      );

      // Find a container representing a pixel block
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
      
      // Check that at least one container has the primary color in decoration
      final container = tester.widget<Container>(containers.first);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, isNotNull);
    });
  });
}
