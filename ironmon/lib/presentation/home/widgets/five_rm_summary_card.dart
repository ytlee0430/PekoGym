import 'package:flutter/material.dart';

/// Displays a 2×2 grid of the four core lift 5RM values.
class FiveRmSummaryCard extends StatelessWidget {
  /// Creates a [FiveRmSummaryCard].
  const FiveRmSummaryCard({
    required this.squatFiveRm,
    required this.benchPressFiveRm,
    required this.deadliftFiveRm,
    required this.overheadPressFiveRm,
    super.key,
  });

  /// Squat 5RM in kg.
  final double squatFiveRm;

  /// Bench press 5RM in kg.
  final double benchPressFiveRm;

  /// Barbell Row 5RM in kg (stored as deadliftFiveRm internally).
  final double deadliftFiveRm;

  /// Overhead press 5RM in kg.
  final double overheadPressFiveRm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5RM Summary',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RmTile(
                    label: 'Squat',
                    value: squatFiveRm,
                  ),
                ),
                Expanded(
                  child: _RmTile(
                    label: 'Bench Press',
                    value: benchPressFiveRm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _RmTile(
                    label: 'Barbell Row',
                    value: deadliftFiveRm,
                  ),
                ),
                Expanded(
                  child: _RmTile(
                    label: 'Overhead Press',
                    value: overheadPressFiveRm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RmTile extends StatelessWidget {
  const _RmTile({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)} kg',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
