import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/models/daily_mission.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Card displayed on the home screen showing the
/// daily recommended training mission.
class DailyMissionCard extends StatelessWidget {
  /// Creates a [DailyMissionCard].
  const DailyMissionCard({
    required this.mission,
    super.key,
  });

  /// The daily mission to display.
  final DailyMission mission;

  @override
  Widget build(BuildContext context) {
    if (mission.isCompleted) {
      return _CompletedCard();
    }

    final muscleLabel = mission.isFullBody
        ? '全身訓練'
        : mission.recommendedMuscleTypes
            .map((m) => _muscleLabel(m))
            .join(' / ');

    return Card(
      color: IronMonColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.flag,
                  color: Colors.orangeAccent,
                  size: 18,
                ),
                const SizedBox(width: 6),
                const Text(
                  '每日任務',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.orangeAccent,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green
                        .withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+${mission.bonusExp}% EXP',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              muscleLabel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mission.reason,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _acceptMission(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          IronMonColors.primary,
                    ),
                    child: const Text('接受任務'),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () =>
                      context.push('/battle/select'),
                  child: const Text(
                    '自行選擇',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _acceptMission(BuildContext context) {
    final extra = <String, String>{
      'missionMuscle': mission.isFullBody
          ? 'full_body'
          : mission.recommendedMuscleTypes.first.name,
    };
    context.push('/battle/select', extra: extra);
  }

  String _muscleLabel(MuscleType m) {
    return switch (m) {
      MuscleType.chest => '胸部',
      MuscleType.back => '背部',
      MuscleType.legs => '腿部',
      MuscleType.shoulders => '肩部',
      MuscleType.arms => '手臂',
    };
  }
}

class _CompletedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: IronMonColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text(
              '✓ 今日任務已完成！',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
