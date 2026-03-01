import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/shared/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Test Title',
              subtitle: 'Test subtitle message',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test subtitle message'), findsOneWidget);
    });

    testWidgets('renders action button when provided', (tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Test Title',
              actionLabel: 'Test Action',
              onAction: () => buttonPressed = true,
            ),
          ),
        ),
      );

      final button = find.widgetWithText(ElevatedButton, 'Test Action');
      expect(button, findsOneWidget);
      
      await tester.tap(button);
      expect(buttonPressed, isTrue);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Test Title',
              icon: const Icon(Icons.test),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.test), findsOneWidget);
    });

    testWidgets('noTrainingHistory factory creates correct layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noTrainingHistory(),
          ),
        ),
      );

      expect(find.text('Start your first battle!'), findsOneWidget);
      expect(find.text('Complete your first workout to see your training history here.'), findsOneWidget);
      expect(find.text('Start Battle'), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('networkError factory creates correct layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.networkError(),
          ),
        ),
      );

      expect(find.text('Connection Error'), findsOneWidget);
      expect(find.text('Unable to load data. Please check your connection and try again.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('noData factory creates correct layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noData(
              title: 'No Data Found',
              subtitle: 'Try adjusting your filters',
            ),
          ),
        ),
      );

      expect(find.text('No Data Found'), findsOneWidget);
      expect(find.text('Try adjusting your filters'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });
  });
}
