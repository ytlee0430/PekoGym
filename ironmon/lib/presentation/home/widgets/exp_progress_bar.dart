import 'package:flutter/material.dart';
import 'package:ironmon/domain/training/level_system.dart';

const _levelSystem = LevelSystem();

/// Displays the player's current EXP as a progress bar
/// with a label showing level and EXP values.
class ExpProgressBar extends StatelessWidget {
  /// Creates an [ExpProgressBar].
  const ExpProgressBar({
    required this.level,
    required this.currentExp,
    super.key,
  });

  /// Current player level.
  final int level;

  /// Current accumulated experience points.
  final int currentExp;

  @override
  Widget build(BuildContext context) {
    final expNeeded =
        _levelSystem.expToNextLevel(level);
    final expProgress =
        _levelSystem.expInCurrentLevel(
      currentExp,
      level,
    );
    final progress = expNeeded > 0
        ? (expProgress / expNeeded).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Lv. $level — $expProgress/$expNeeded EXP',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
