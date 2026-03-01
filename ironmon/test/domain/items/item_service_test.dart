import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/items/item_service.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

void main() {
  const service = ItemService();

  BattleState activeState({
    int playerPp = 80,
    int maxPlayerPp = 110,
  }) {
    return BattleState(
      phase: const Warmup(),
      bosses: const [
        Boss(
          name: 'Test',
          type: MuscleType.chest,
          maxHp: 100,
          currentHp: 100,
          defense: 5,
          stage: BossStage.minion,
        ),
        Boss(
          name: 'Mid',
          type: MuscleType.back,
          maxHp: 100,
          currentHp: 100,
          defense: 10,
          stage: BossStage.midBoss,
        ),
        Boss(
          name: 'Boss',
          type: MuscleType.legs,
          maxHp: 100,
          currentHp: 100,
          defense: 15,
          stage: BossStage.gymLeader,
        ),
      ],
      currentBossIndex: 0,
      playerHp: 100,
      maxPlayerHp: 100,
      gymType: GymType.physique,
      playerMuscleType: MuscleType.chest,
      playerPp: playerPp,
      maxPlayerPp: maxPlayerPp,
    );
  }

  const idleState = BattleState.initial();

  group('ItemService', () {
    group('usePotion', () {
      test('sets restTimerPaused = true', () {
        final result = service.usePotion(
          activeState(),
          3,
        );
        expect(result, isA<Success>());
        final newState =
            (result as Success<BattleState, String>).value;
        expect(newState.restTimerPaused, isTrue);
      });

      test('adds potion to itemsUsed', () {
        final result = service.usePotion(
          activeState(),
          1,
        );
        final newState =
            (result as Success<BattleState, String>).value;
        expect(newState.itemsUsed, contains('potion'));
      });

      test('fails when count = 0', () {
        final result = service.usePotion(
          activeState(),
          0,
        );
        expect(result, isA<Failure>());
      });

      test('fails when state is not active', () {
        final result = service.usePotion(idleState, 5);
        expect(result, isA<Failure>());
      });
    });

    group('useEther', () {
      test('restores 50% of max PP', () {
        final result = service.useEther(
          activeState(playerPp: 40, maxPlayerPp: 110),
          2,
        );
        expect(result, isA<Success>());
        final newState =
            (result as Success<BattleState, String>).value;
        // 40 + (110 * 0.5).round() = 40 + 55 = 95
        expect(newState.playerPp, 95);
      });

      test('does not exceed maxPlayerPp', () {
        final result = service.useEther(
          activeState(playerPp: 100, maxPlayerPp: 110),
          1,
        );
        final newState =
            (result as Success<BattleState, String>).value;
        expect(newState.playerPp, lessThanOrEqualTo(110));
      });

      test('adds ether to itemsUsed', () {
        final result = service.useEther(
          activeState(),
          1,
        );
        final newState =
            (result as Success<BattleState, String>).value;
        expect(newState.itemsUsed, contains('ether'));
      });

      test('fails when count = 0', () {
        final result = service.useEther(
          activeState(),
          0,
        );
        expect(result, isA<Failure>());
      });

      test('fails when state is not active', () {
        final result = service.useEther(idleState, 3);
        expect(result, isA<Failure>());
      });
    });

    group('validateRareCandy', () {
      test('returns Success with moveId', () {
        final result = service.validateRareCandy(
          2,
          'chest-1',
        );
        expect(result, isA<Success>());
      });

      test('fails when count = 0', () {
        final result = service.validateRareCandy(
          0,
          'chest-1',
        );
        expect(result, isA<Failure>());
      });

      test('fails when moveId empty', () {
        final result = service.validateRareCandy(1, '');
        expect(result, isA<Failure>());
      });
    });

    group('canUseItem', () {
      test('true when battle active', () {
        expect(activeState().canUseItem, isTrue);
      });

      test('false when idle', () {
        expect(idleState.canUseItem, isFalse);
      });
    });

    group('itemId', () {
      test('returns correct IDs', () {
        expect(ItemService.itemId(ItemType.potion), 'potion');
        expect(ItemService.itemId(ItemType.ether), 'ether');
        expect(
          ItemService.itemId(ItemType.rareCandy),
          'rare_candy',
        );
      });
    });
  });
}
