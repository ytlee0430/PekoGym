import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/main.dart';
import 'package:ironmon/providers/repository_providers.dart';

void main() {
  testWidgets(
    'App smoke test — first launch redirects to onboarding',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(
              AppDatabase(NativeDatabase.memory()),
            ),
          ],
          child: const IronMonApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Create Your Profile'), findsOneWidget);
    },
  );
}
