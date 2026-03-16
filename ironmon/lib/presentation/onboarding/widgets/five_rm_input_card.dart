import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Card widget for inputting 5RM values during onboarding.
///
/// Displays exercise name, icon, and numeric input field.
/// Uses dark theme styling and validates input range.
/// When a recommended value is provided, it shows as pre-filled
/// and auto-selects on focus so the user can type to replace.
class FiveRmInputCard extends StatefulWidget {
  /// Creates a [FiveRmInputCard].
  const FiveRmInputCard({
    required this.muscleType,
    required this.value,
    required this.onChanged,
    this.validator,
    this.exerciseName,
    this.exerciseSubtitle,
    this.recommendedValue,
    this.exerciseIcon,
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

  /// Optional override for the display name (e.g. "Barbell Bench Press").
  final String? exerciseName;

  /// Optional override for the subtitle (e.g. "Primary chest compound").
  final String? exerciseSubtitle;

  /// Recommended value based on body weight/gender. Shown as pre-filled.
  final double? recommendedValue;

  /// Optional exercise-specific icon override.
  final IconData? exerciseIcon;

  @override
  State<FiveRmInputCard> createState() => _FiveRmInputCardState();
}

class _FiveRmInputCardState extends State<FiveRmInputCard> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasUserEdited = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _displayValue,
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  String get _displayValue {
    final v = widget.value;
    if (v == 0.0 && !_hasUserEdited) return '';
    return v == v.roundToDouble()
        ? v.round().toString()
        : v.toStringAsFixed(1);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Select all text on focus so user can type to replace
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    }
  }

  @override
  void didUpdateWidget(FiveRmInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If value changed externally (e.g. from recommended), update controller
    if (widget.value != oldWidget.value && !_focusNode.hasFocus) {
      _controller.text = _displayValue;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommended = widget.recommendedValue;

    return Card(
      color: IronMonColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise name and type
            PixelText.h2(
              widget.exerciseName ?? widget.muscleType.displayName,
              color: IronMonColors.colorForType(widget.muscleType),
            ),
            const SizedBox(height: 8),
            Text(
              widget.exerciseSubtitle ?? widget.muscleType.elementName,
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
                  color: IronMonColors.colorForType(widget.muscleType)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.exerciseIcon ?? _getExerciseIcon(widget.muscleType),
                  size: 48,
                  color: IronMonColors.colorForType(widget.muscleType),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recommended value hint
            if (recommended != null && recommended > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Text(
                    'Recommended: ${recommended == recommended.roundToDouble() ? recommended.round() : recommended.toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: IronMonColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            
            // Input field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: IronMonColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: recommended != null && recommended > 0
                          ? '${recommended == recommended.roundToDouble() ? recommended.round() : recommended.toStringAsFixed(1)}'
                          : '0',
                      hintStyle: TextStyle(
                        color: IronMonColors.onSurface.withValues(alpha: 0.3),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: IronMonColors.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: IronMonColors.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                    onChanged: (text) {
                      _hasUserEdited = true;
                      final value = double.tryParse(text);
                      if (value != null && value >= 0 && value <= 500) {
                        widget.onChanged(value);
                      } else if (text.isEmpty) {
                        // If field is empty, use recommended or 0
                        widget.onChanged(recommended ?? 0.0);
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
              'Enter your 5RM weight (max weight for 5 reps)',
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
      MuscleType.arms => Icons.sports_martial_arts,
    };
  }
}
