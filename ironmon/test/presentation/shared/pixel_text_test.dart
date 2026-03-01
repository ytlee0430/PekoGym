import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

void main() {
  group('PixelText', () {
    testWidgets('display constructor renders 48sp text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.display('Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontSize, 48);
      expect(textWidget.style?.fontFamily, 'PressStart2P');
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('h1 constructor renders 32sp text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.h1('Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontSize, 32);
      expect(textWidget.style?.fontFamily, 'PressStart2P');
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('h2 constructor renders 24sp text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.h2('Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontSize, 24);
      expect(textWidget.style?.fontFamily, 'PressStart2P');
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('label constructor renders 12sp text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.label('Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontSize, 12);
      expect(textWidget.style?.fontFamily, 'PressStart2P');
      expect(textWidget.style?.fontWeight, FontWeight.w500);
    });

    testWidgets('applies custom color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.display(
              'Test',
              color: Colors.red,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('applies default shadow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.display('Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.shadows, isNotNull);
      expect(textWidget.style?.shadows!.length, 1);
      expect(textWidget.style?.shadows!.first.color, Colors.black);
      expect(textWidget.style?.shadows!.first.offset, const Offset(1, 1));
      expect(textWidget.style?.shadows!.first.blurRadius, 4);
    });

    testWidgets('applies custom shadows', (tester) async {
      const customShadow = Shadow(
        blurRadius: 2,
        color: Colors.blue,
        offset: Offset.zero,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.display(
              'Test',
              shadows: [customShadow],
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.shadows, [customShadow]);
    });

    testWidgets('applies textAlign', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: PixelText.display(
              'Test',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.textAlign, TextAlign.center);
    });
  });
}
