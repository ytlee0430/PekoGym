import 'package:flutter/material.dart';

/// Pixel size variants.
enum _PixelSize { display, h1, h2, label }

/// Pixel-styled text widget using Press Start 2P font.
///
/// Use for RPG-style text like damage numbers, boss names,
/// and battle messages. Functional UI should use system font.
///
/// Reference: UX Design Specification — Typography System
class PixelText extends StatelessWidget {
  /// Creates pixel text for display size (48sp).
  const PixelText.display(
    this.text, {
    super.key,
    this.color,
    this.shadows,
    this.textAlign,
  }) : _size = _PixelSize.display;

  /// Creates pixel text for H1 size (32sp).
  const PixelText.h1(
    this.text, {
    super.key,
    this.color,
    this.shadows,
    this.textAlign,
  }) : _size = _PixelSize.h1;

  /// Creates pixel text for H2 size (24sp).
  const PixelText.h2(
    this.text, {
    super.key,
    this.color,
    this.shadows,
    this.textAlign,
  }) : _size = _PixelSize.h2;

  /// Creates pixel text for label size (12sp).
  const PixelText.label(
    this.text, {
    super.key,
    this.color,
    this.shadows,
    this.textAlign,
  }) : _size = _PixelSize.label;

  /// The text to display.
  final String text;

  /// Text color. Defaults to current theme color.
  final Color? color;

  /// Text shadows. Defaults to black shadow for readability.
  final List<Shadow>? shadows;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Internal size variant.
  final _PixelSize _size;

  /// Default shadow for pixel text readability.
  static const _defaultShadow = Shadow(
    blurRadius: 4,
    color: Colors.black,
    offset: Offset(1, 1),
  );

  @override
  Widget build(BuildContext context) {
    final style = _getTextStyle(context);
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.onSurface;
    final effectiveShadows = shadows ?? [_defaultShadow];

    return switch (_size) {
      _PixelSize.display => TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFamily: 'PressStart2P',
        color: color ?? defaultColor,
        shadows: effectiveShadows,
      ),
      _PixelSize.h1 => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'PressStart2P',
        color: color ?? defaultColor,
        shadows: effectiveShadows,
      ),
      _PixelSize.h2 => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'PressStart2P',
        color: color ?? defaultColor,
        shadows: effectiveShadows,
      ),
      _PixelSize.label => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'PressStart2P',
        color: color ?? defaultColor,
        shadows: effectiveShadows,
      ),
    };
  }
}
