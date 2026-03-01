import 'package:flutter/material.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Card widget for inputting 5RM values during onboarding.
///
/// Displays exercise name, icon, and numeric input field.
/// Uses dark theme styling and validates input range.
class FiveRmInputCard extends StatelessWidget {
  /// Creates a [FiveRmInputCard].
  const FiveRmInputCard({
    required this.muscleType,
    required this.value,
    required this.onChanged,
    this.validator,
    super.key,
  });

  /// The muscle type for this exercise.
  final MuscleType muscleType;

  /// Current 5RM value.
  final double value;

  /// Callback when value changes.
  final ValueChanged<double> onChanged;

  /// Optional validator for the input field.
  final String? Function(double?)? validator;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: IronMonColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise name and type
            PixelText.h2(
              muscleType.displayName,
              color: IronMonColors.colorForType(muscleType),
            ),
            const SizedBox(height: 8),
            Text(
              muscleType.elementName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            
            // Exercise icon placeholder
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: IronMonColors.colorForType(muscleType).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getExerciseIcon(muscleType),
                  size: 48,
                  color: IronMonColors.colorForType(muscleType),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Input field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: value.toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: IronMonColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: IronMonColors.onSurface.withValues(alpha: 0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: IronMonColors.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: IronMonColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    inputFormatters: [
                      _FiveRmInputFormatter(),
                    ],
                    validator: (text) {
                      final value = double.tryParse(text ?? '');
                      if (value == null) return '請輸入數字';
                      if (value < 0) return '不能小於 0';
                      if (value > 500) return '不能大於 500';
                      return validator?.call(value);
                    },
                    onSaved: (text) {
                      final value = double.tryParse(text ?? '0') ?? 0;
                      onChanged(value);
                    },
                    onChanged: (text) {
                      final value = double.tryParse(text ?? '');
                      if (value != null) {
                        onChanged(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'kg',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: IronMonColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Helper text
            Text(
              '請輸入您的 5RM 重量（最大重複 5 次的重量）',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getExerciseIcon(MuscleType type) {
    return switch (type) {
      MuscleType.chest => Icons.fitness_center,
      MuscleType.back => Icons.accessibility_new,
      MuscleType.legs => Icons.directions_run,
      MuscleType.shoulders => Icons.sports_gymnastics,
      MuscleType.core => Icons.sports_martial_arts,
    };
  }
}

/// Input formatter for 5RM values.
///
/// Ensures proper decimal format and range.
class _FiveRmInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty value
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Parse the value
    final value = double.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    // Check range
    if (value < 0 || value > 500) {
      return oldValue;
    }

    // Ensure proper decimal format (max 1 decimal place)
    final text = value.toStringAsFixed(1);
    if (text.endsWith('.0')) {
      return TextEditingValue(
        text: text.substring(0, text.length - 2),
        selection: TextSelection.collapsed(offset: text.length - 2),
      );
    }

    return newValue;
  }
}
