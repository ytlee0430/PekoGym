import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/battle/widgets/set_input_panel.dart';

void main() {
  group('SetInputPanel RPE Quick Buttons', () {
    testWidgets('tapping Easy button sets RPE to 7', (tester) async {
      double submittedWeight = 0;
      int submittedReps = 0;
      int submittedRpe = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SetInputPanel(
              onSubmit: (weight, reps, rpe) {
                submittedWeight = weight;
                submittedReps = reps;
                submittedRpe = rpe;
              },
            ),
          ),
        ),
      );

      // Tap Easy button
      await tester.tap(find.text('Easy'));
      await tester.pump();

      // Verify RPE is set to 7
      expect(find.text('RPE: 7'), findsOneWidget);

      // Submit to verify RPE value
      await tester.tap(find.text('Attack!'));
      await tester.pump();

      expect(submittedRpe, 7);
    });

    testWidgets('tapping Medium button sets RPE to 8', (tester) async {
      double submittedWeight = 0;
      int submittedReps = 0;
      int submittedRpe = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SetInputPanel(
              onSubmit: (weight, reps, rpe) {
                submittedWeight = weight;
                submittedReps = reps;
                submittedRpe = rpe;
              },
            ),
          ),
        ),
      );

      // Tap Medium button
      await tester.tap(find.text('Medium'));
      await tester.pump();

      // Verify RPE is set to 8
      expect(find.text('RPE: 8'), findsOneWidget);

      // Submit to verify RPE value
      await tester.tap(find.text('Attack!'));
      await tester.pump();

      expect(submittedRpe, 8);
    });

    testWidgets('tapping Hard button sets RPE to 10', (tester) async {
      double submittedWeight = 0;
      int submittedReps = 0;
      int submittedRpe = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SetInputPanel(
              onSubmit: (weight, reps, rpe) {
                submittedWeight = weight;
                submittedReps = reps;
                submittedRpe = rpe;
              },
            ),
          ),
        ),
      );

      // Tap Hard button
      await tester.tap(find.text('Hard'));
      await tester.pump();

      // Verify RPE is set to 10
      expect(find.text('RPE: 10'), findsOneWidget);

      // Submit to verify RPE value
      await tester.tap(find.text('Attack!'));
      await tester.pump();

      expect(submittedRpe, 10);
    });

    testWidgets('quick buttons have correct colors when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SetInputPanel(
              onSubmit: (weight, reps, rpe) {},
            ),
          ),
        ),
      );

      // Tap Easy button
      await tester.tap(find.text('Easy'));
      await tester.pump();

      final easyButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Easy'),
      );
      expect(easyButton.style?.backgroundColor?.resolve({}), 
             isA<Color>().having((c) => c.value, 'value', 0xFF4CAF50)); // Green

      // Tap Medium button
      await tester.tap(find.text('Medium'));
      await tester.pump();

      final mediumButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Medium'),
      );
      expect(mediumButton.style?.backgroundColor?.resolve({}),
             isA<Color>().having((c) => c.value, 0xFFFFC107)); // Yellow

      // Tap Hard button
      await tester.tap(find.text('Hard'));
      await tester.pump();

      final hardButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Hard'),
      );
      expect(hardButton.style?.backgroundColor?.resolve({}),
             isA<Color>().having((c) => c.value, 0xFFE53935)); // Red
    });
  });
}
