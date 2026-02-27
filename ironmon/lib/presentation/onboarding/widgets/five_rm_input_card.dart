import 'package:flutter/material.dart';

/// A card widget containing a labelled 5RM text input field.
/// Validates that the entered value is a positive number.
class FiveRmInputCard extends StatelessWidget {
  /// Creates a [FiveRmInputCard] for the given [label].
  const FiveRmInputCard({
    required this.label,
    required this.controller,
    super.key,
  });

  /// Display label for the lift (e.g. 'Squat').
  final String label;

  /// Controller for the underlying [TextFormField].
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            labelText: '$label 5RM',
            suffixText: 'kg',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label 5RM';
            }
            final parsed = double.tryParse(value);
            if (parsed == null || parsed <= 0) {
              return 'Must be a valid number greater than 0';
            }
            if (parsed >= 1000) {
              return 'Must be less than 1000 kg';
            }
            return null;
          },
        ),
      ),
    );
  }
}
