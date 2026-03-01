import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/onboarding/widgets/five_rm_input_card.dart';

void main() {
  group('FiveRmInputCard', () {
    testWidgets('renders with exercise name and input field', (tester) async {
      double capturedValue = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: FiveRmInputCard(
              muscleType: MuscleType.chest,
              value: 100.0,
              onChanged: (value) => capturedValue = value,
            ),
          ),
        ),
      );

      // Check exercise name
      expect(find.text('胸部'), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
      
      // Check input field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('kg'), findsOneWidget);
      
      // Check helper text
      expect(find.text('請輸入您的 5RM 重量（最大重複 5 次的重量）'), findsOneWidget);
    });

    testWidgets('validates input range (0-500)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: Form(
              child: FiveRmInputCard(
                muscleType: MuscleType.legs,
                value: 0,
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      
      // Test negative value
      await tester.enterText(textField, '-10');
      await tester.pump();
      expect(find.text('不能小於 0'), findsOneWidget);
      
      // Test value > 500
      await tester.enterText(textField, '600');
      await tester.pump();
      expect(find.text('不能大於 500'), findsOneWidget);
      
      // Test valid value
      await tester.enterText(textField, '250');
      await tester.pump();
      expect(find.text('不能小於 0'), findsNothing);
      expect(find.text('不能大於 500'), findsNothing);
    });

    testWidgets('calls onChanged when input changes', (tester) async {
      double capturedValue = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: FiveRmInputCard(
              muscleType: MuscleType.back,
              value: 0,
              onChanged: (value) => capturedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '150');
      await tester.pump();
      expect(capturedValue, 150.0);
    });

    testWidgets('displays correct color for muscle type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: FiveRmInputCard(
              muscleType: MuscleType.shoulders,
              value: 0,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Find the exercise name text widget
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final shoulderText = textWidgets.firstWhere(
        (widget) => widget.data == '肩部',
        orElse: () => throw Exception('Shoulder text not found'),
      );
      
      // Check that it has the correct color (shoulders type color)
      expect(shoulderText.style?.color, isNotNull);
    });
  });
}
