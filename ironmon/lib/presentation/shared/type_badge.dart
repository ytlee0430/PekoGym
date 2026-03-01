import 'package:flutter/material.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Colored chip badge showing the element name
/// for a [MuscleType].
class TypeBadge extends StatelessWidget {
  /// Creates a [TypeBadge].
  const TypeBadge({
    required this.type,
    this.small = false,
    super.key,
  });

  /// The muscle type to display.
  final MuscleType type;

  /// Whether to use a smaller size.
  final bool small;

  /// Color mapped to each muscle type.
  static Color colorFor(MuscleType type) {
    return IronMonColors.colorForType(type);
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(type);
    final fontSize = small ? 10.0 : 12.0;
    final hPad = small ? 6.0 : 10.0;
    final vPad = small ? 2.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: vPad,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: PixelText.label(
        type.elementName,
        color: color,
      ),
    );
  }
}
