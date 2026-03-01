import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/home/widgets/daily_mission_card.dart';
import 'package:ironmon/presentation/home/widgets/exp_progress_bar.dart';
import 'package:ironmon/presentation/home/widgets/five_rm_summary_card.dart';
import 'package:ironmon/providers/audio_providers.dart';
import 'package:ironmon/providers/training_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Home screen displaying player profile summary and
/// battle entry point.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref
            .read(audioServiceProvider)
            .playBgm('audio/bgm/home_theme.mp3');
      },
    );
  }

  @override
  void dispose() {
    ref.read(audioServiceProvider).stopBgm(
          fadeOut:
              const Duration(milliseconds: 300),
        );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IronMon'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
            ),
            tooltip: 'Item Shop',
            onPressed: () => context.push('/shop'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Edit 5RM Values',
            onPressed: () =>
                context.push('/profile/edit'),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) =>
            Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('No profile found'),
            );
          }
          return _HomeContent(profile: profile);
        },
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExpProgressBar(
            level: profile.level,
            currentExp: profile.experiencePoints,
          ),
          const SizedBox(height: 16),
          if (profile.isBeginnerMode) ...[
            _CalibrationIndicator(
              completed:
                  profile.calibrationSessionsCompleted,
              target:
                  profile.calibrationTargetSessions,
            ),
            const SizedBox(height: 16),
          ],
          FiveRmSummaryCard(
            squatFiveRm: profile.squatFiveRm,
            benchPressFiveRm:
                profile.benchPressFiveRm,
            deadliftFiveRm: profile.deadliftFiveRm,
            overheadPressFiveRm:
                profile.overheadPressFiveRm,
          ),
          const SizedBox(height: 16),
          ref.watch(dailyMissionProvider).when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) =>
                const SizedBox.shrink(),
            data: (mission) => mission != null
                ? DailyMissionCard(
                    mission: mission,
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () =>
                  context.push('/battle/select'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Start Battle'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalibrationIndicator extends StatelessWidget {
  const _CalibrationIndicator({
    required this.completed,
    required this.target,
  });

  final int completed;
  final int target;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.tune,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Text(
            'Calibrating '
            '($completed/$target sessions)',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
