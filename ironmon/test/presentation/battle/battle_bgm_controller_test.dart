import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/models/battle_outcome.dart';
import 'package:ironmon/presentation/battle/battle_bgm_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockBattleOutcome extends Mock
    implements BattleOutcome {}

void main() {
  setUpAll(() {
    registerFallbackValue(_MockBattleOutcome());
  });

  group('BattleBgmController.trackForPhase', () {
    test('Idle returns null', () {
      expect(
        BattleBgmController.trackForPhase(
          const Idle(),
        ),
        isNull,
      );
    });

    test('Warmup returns warmup track', () {
      expect(
        BattleBgmController.trackForPhase(
          const Warmup(),
        ),
        contains('battle_warmup'),
      );
    });

    test('MidBossPhase returns midboss track', () {
      expect(
        BattleBgmController.trackForPhase(
          const MidBossPhase(),
        ),
        contains('battle_midboss'),
      );
    });

    test('GymLeaderPhase returns boss track', () {
      expect(
        BattleBgmController.trackForPhase(
          const GymLeaderPhase(),
        ),
        contains('battle_boss'),
      );
    });

    test('BattleResult returns null (stop BGM)', () {
      final mockOutcome = _MockBattleOutcome();
      expect(
        BattleBgmController.trackForPhase(
          BattleResult(outcome: mockOutcome),
        ),
        isNull,
      );
    });

    test('all non-null tracks are mp3 paths', () {
      final phases = <BattlePhase>[
        const Warmup(),
        const MidBossPhase(),
        const GymLeaderPhase(),
      ];
      for (final phase in phases) {
        final track =
            BattleBgmController.trackForPhase(phase);
        expect(track, isNotNull);
        expect(track, endsWith('.mp3'));
        expect(track, startsWith('audio/bgm/'));
      }
    });
  });
}
