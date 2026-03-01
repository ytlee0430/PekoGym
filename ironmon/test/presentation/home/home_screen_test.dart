import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/home/home_screen.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

class _MockNotifier extends UserProfileNotifier {
  _MockNotifier(this._profile);
  final UserProfile? _profile;

  @override
  Future<UserProfile?> build() async => _profile;
}

void main() {
  const normalProfile = UserProfile(
    level: 5,
    experiencePoints: 750,
    squatFiveRm: 100,
    benchPressFiveRm: 80,
    deadliftFiveRm: 120,
    overheadPressFiveRm: 50,
  );

  const beginnerProfile = UserProfile(
    level: 1,
    experiencePoints: 30,
    squatFiveRm: 20,
    benchPressFiveRm: 20,
    deadliftFiveRm: 20,
    overheadPressFiveRm: 20,
    isBeginnerMode: true,
    calibrationSessionsCompleted: 2,
    calibrationTargetSessions: 5,
  );

  Widget buildApp(UserProfile? profile) {
    return ProviderScope(
      overrides: [
        userProfileProvider.overrideWith(
          () => _MockNotifier(profile),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets(
      'shows level and EXP bar when profile exists',
      (tester) async {
        await tester.pumpWidget(buildApp(normalProfile));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Lv. 5'),
          findsOneWidget,
        );
        expect(
          find.textContaining('50/150 EXP'),
          findsOneWidget,
        );
        expect(
          find.byType(LinearProgressIndicator),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      '5RM summary card shows all four values',
      (tester) async {
        await tester.pumpWidget(buildApp(normalProfile));
        await tester.pumpAndSettle();

        expect(find.text('Squat'), findsOneWidget);
        expect(
          find.text('100.0 kg'),
          findsOneWidget,
        );
        expect(
          find.text('Bench Press'),
          findsOneWidget,
        );
        expect(
          find.text('80.0 kg'),
          findsOneWidget,
        );
        expect(find.text('Deadlift'), findsOneWidget);
        expect(
          find.text('120.0 kg'),
          findsOneWidget,
        );
        expect(
          find.text('Overhead Press'),
          findsOneWidget,
        );
        expect(
          find.text('50.0 kg'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Start Battle button exists and is tappable',
      (tester) async {
        await tester.pumpWidget(buildApp(normalProfile));
        await tester.pumpAndSettle();

        final button = find.text('Start Battle');
        expect(button, findsOneWidget);
        expect(
          find.byType(ElevatedButton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'calibration indicator shown when beginner mode',
      (tester) async {
        await tester
            .pumpWidget(buildApp(beginnerProfile));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Calibrating'),
          findsOneWidget,
        );
        expect(
          find.textContaining('2/5 sessions'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'calibration indicator hidden when not beginner',
      (tester) async {
        await tester.pumpWidget(buildApp(normalProfile));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Calibrating'),
          findsNothing,
        );
      },
    );
  });
}
