import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/presentation/shared/ironmon_theme.dart';
import 'package:ironmon/router/app_router.dart';

/// App entry point — initializes Riverpod and launches [IronMonApp]
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Drift db lifecycle managed via Riverpod provider (Story 1.2+)
  runApp(const ProviderScope(child: IronMonApp()));
}

/// Root application widget
class IronMonApp extends ConsumerWidget {
  /// Creates the root [IronMonApp]
  const IronMonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'IronMon',
      routerConfig: router,
      theme: IronMonTheme.dark(),
    );
  }
}
