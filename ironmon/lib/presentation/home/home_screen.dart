import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Home screen placeholder — 完整實作於 Story 1.4
class HomeScreen extends ConsumerWidget {
  /// Creates [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IronMon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Edit 5RM Values',
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: Center(
        child: profileAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
          data: (profile) {
            if (profile == null) return const Text('No profile found');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Home'),
                if (profile.isBeginnerMode) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Calibrating (${profile.calibrationSessionsCompleted}/'
                    '${profile.calibrationTargetSessions} sessions)',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
