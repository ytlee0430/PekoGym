import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/battle/battle_screen.dart';
import 'package:ironmon/presentation/home/home_screen.dart';
import 'package:ironmon/presentation/onboarding/onboarding_screen.dart';
import 'package:ironmon/presentation/pokedex/move_detail_screen.dart';
import 'package:ironmon/presentation/pokedex/pokedex_screen.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Bridges Riverpod state changes to GoRouter's [Listenable] interface.
/// Notifies the router to re-evaluate `redirect` whenever
/// [userProfileProvider] emits a new value.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<UserProfile?>>(
      userProfileProvider,
      (_, __) => notifyListeners(),
    );
  }
}

/// App-wide go_router configuration with onboarding redirect.
/// Routes: / → /onboarding → /battle → /battle/result
///         → /pokedex → /pokedex/:moveId
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final profileAsync = ref.read(userProfileProvider);
      final isOnboarding = state.matchedLocation == '/onboarding';

      return profileAsync.when(
        // No redirect while loading — GoRouter shows initialLocation.
        loading: () => null,
        error: (_, __) => null,
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
});

/// Battle result placeholder — 完整實作於 Story 3.2
class _BattleResultPlaceholder extends StatelessWidget {
  const _BattleResultPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Battle Result')),
    );
  }
}
