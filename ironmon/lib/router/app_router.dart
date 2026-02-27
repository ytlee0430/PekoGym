import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/battle/battle_screen.dart';
import 'package:ironmon/presentation/home/home_screen.dart';
import 'package:ironmon/presentation/onboarding/onboarding_screen.dart';
import 'package:ironmon/presentation/pokedex/move_detail_screen.dart';
import 'package:ironmon/presentation/pokedex/pokedex_screen.dart';
import 'package:ironmon/presentation/profile/profile_edit_screen.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Bridges Riverpod state changes to GoRouter's [Listenable] interface.
/// Notifies the router to re-evaluate `redirect` whenever
/// [userProfileProvider] emits a new value.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref
      ..listen<AsyncValue<UserProfile?>>(
        userProfileProvider,
        (_, __) => notifyListeners(),
      )
      ..onDispose(dispose);
  }
}

/// App-wide go_router configuration with onboarding redirect.
/// Routes: / → /onboarding → /battle → /battle/result
///         → /pokedex → /pokedex/:moveId
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final profileAsync = ref.read(userProfileProvider);
      final isOnboarding = state.matchedLocation == '/onboarding';

      return profileAsync.when(
        // No redirect while loading — GoRouter shows initialLocation.
        loading: () => null,
        error: (error, _) {
          debugPrint('userProfileProvider error: $error');
          return '/onboarding'; // Safe fallback
        },
        data: (profile) {
          if (profile == null && !isOnboarding) return '/onboarding';
          if (profile != null && isOnboarding) return '/';
          return null;
        },
      );
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'homeRoute',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboardingRoute',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profileEditRoute',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/battle',
        name: 'battleRoute',
        builder: (context, state) => const BattleScreen(),
        routes: [
          GoRoute(
            path: 'result',
            name: 'battleResultRoute',
            builder: (context, state) => const _BattleResultPlaceholder(),
          ),
        ],
      ),
      GoRoute(
        path: '/pokedex',
        name: 'pokedexRoute',
        builder: (context, state) => const PokedexScreen(),
        routes: [
          GoRoute(
            path: ':moveId',
            name: 'moveDetailRoute',
            builder: (context, state) {
              final moveId = state.pathParameters['moveId']!;
              return MoveDetailScreen(moveId: moveId);
            },
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

/// Battle result placeholder — 完整實作於 Story 3.2
class _BattleResultPlaceholder extends ConsumerWidget {
  const _BattleResultPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Battle Result')),
      body: Center(
        child: profileAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text('Error: $err'),
          data: (profile) {
            if (profile == null) return const Text('No profile found');

            // Logic to determine if calibration JUST finished would normally
            // come from the battle session result, but for this placeholder
            // we'll show a message if it's recently finished (e.g. at target)
            final isRecentlyFinished = !profile.isBeginnerMode &&
                profile.calibrationSessionsCompleted >=
                    profile.calibrationTargetSessions;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Battle Result Placeholder'),
                if (isRecentlyFinished) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Calibration Complete!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text('Your finalized 5RM values:'),
                        const SizedBox(height: 8),
                        Text('Squat: ${profile.squatFiveRm} kg'),
                        Text('Bench: ${profile.benchPressFiveRm} kg'),
                        Text('Deadlift: ${profile.deadliftFiveRm} kg'),
                        Text('OHP: ${profile.overheadPressFiveRm} kg'),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back to Home'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
