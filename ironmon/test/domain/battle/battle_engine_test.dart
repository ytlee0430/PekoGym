import 'package:ironmon/domain/battle/battle_engine.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/damage_calculator.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';
import 'package:test/test.dart';

void main() {
  const te = TypeEffectiveness();
  const dc = DamageCalculator(typeEffectiveness: te);
  const engine = BattleEngine(damageCalculator: dc);

  final bosses = [
    const Boss(
      name: 'Minion',
      type: MuscleType.chest,
      maxHp: 50,
      currentHp: 50,
      defense: 5,
      stage: BossStage.minion,
    ),
    const Boss(
      name: 'Mid-Boss',
      type: MuscleType.back,
      maxHp: 100,
      currentHp: 100,
      defense: 10,
      stage: BossStage.midBoss,
    ),
    const Boss(
      name: 'Leader',
      type: MuscleType.legs,
      maxHp: 200,
      currentHp: 200,
      defense: 15,
      stage: BossStage.gymLeader,
    ),
  ];

  const move = MoveDefinition(
    id: 'chest-1',
    name: 'Bench Press',
    type: MuscleType.chest,
    power: 40,
    pp: 15,
    description: 'Basic chest press',
    exerciseName: 'Bench Press',
    evolutionChainId: 'chest-chain',
    evolutionStage: 1,
    unlockLevel: 1,
  );

  ExerciseSet makeSet({
    double weight = 80,
    int reps = 10,
    int rpe = 7,
    int setNumber = 1,
  }) {
    return ExerciseSet(
      moveId: 'chest-1',
      weight: weight,
      reps: reps,
      rpe: rpe,
      setNumber: setNumber,
    );
  }

  group('BattleEngine', () {
    test('startBattle creates Warmup phase', () {
      final state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 110,
      );
      expect(state.phase, isA<Warmup>());
      expect(state.currentBossIndex, 0);
      expect(state.playerHp, 100);
      expect(state.playerPp, 110);
      expect(state.maxPlayerPp, 110);
      expect(state.bosses.length, 3);
    });

    test('selectMove updates selectedMoveId', () {
      final state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 110,
      );
      final updated =
          engine.selectMove(state, 'chest-1');
      expect(updated.selectedMoveId, 'chest-1');
    });

    test('submitSet applies damage to boss', () {
      final state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 110,
      );
      final updated = engine.submitSet(
        state,
        makeSet(weight: 10, reps: 1, rpe: 5),
        move,
        80,
      );
      // Small damage — boss should still be alive
      expect(
        updated.currentBoss.currentHp,
        lessThan(50),
      );
      expect(updated.completedSets.length, 1);
      expect(updated.damageResults.length, 1);
    });

    test(
      'phase transitions Warmup → MidBoss on '
      'boss defeat',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // Deal massive damage to kill minion
        state = engine.submitSet(
          state,
          makeSet(weight: 160, reps: 50, rpe: 10),
          move,
          80,
        );
        expect(state.phase, isA<MidBossPhase>());
        expect(state.currentBossIndex, 1);
      },
    );

    test(
      'full battle flow to victory',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );

        // Phase 1: Kill minion (50 HP)
        expect(state.phase, isA<Warmup>());
        state = engine.submitSet(
          state,
          makeSet(weight: 160, reps: 50, rpe: 10),
          move,
          80,
        );
        expect(state.phase, isA<MidBossPhase>());

        // Phase 2: Kill mid-boss (100 HP)
        // chest vs back = 0.5x, need more damage
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 100,
            rpe: 10,
          ),
          move,
          80,
        );
        expect(
          state.phase,
          isA<GymLeaderPhase>(),
        );

        // Phase 3: Kill gym leader (200 HP)
        // chest vs legs = 1.5x super effective
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 100,
            rpe: 10,
          ),
          move,
          80,
        );
        expect(state.phase, isA<BattleResult>());
        final result =
            state.phase as BattleResult;
        expect(result.outcome.isVictory, isTrue);
        expect(
          result.outcome.totalSets,
          3,
        );
      },
    );

    test(
      'immutability: original state unchanged',
      () {
        final original = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        final updated = engine.submitSet(
          original,
          makeSet(),
          move,
          80,
        );
        // Original should be untouched
        expect(original.completedSets.length, 0);
        expect(original.damageResults.length, 0);
        expect(original.totalDamageDealt, 0);
        // Updated should have changes
        expect(updated.completedSets.length, 1);
        expect(
          updated.totalDamageDealt,
          greaterThan(0),
        );
      },
    );

    test('submitSet on inactive state is no-op', () {
      const initial =
          BattleState.initial();
      final result = engine.submitSet(
        initial,
        makeSet(),
        move,
        80,
      );
      // Should return same state (Idle is
      // inactive)
      expect(result.phase, isA<Idle>());
      expect(result.completedSets.length, 0);
    });

    test(
      'sealed class exhaustive switch compiles',
      () {
        final state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // This verifies exhaustive pattern
        // matching compiles
        final message = switch (state.phase) {
          Idle() => 'idle',
          Warmup() => 'warmup',
          MidBossPhase() => 'mid-boss',
          GymLeaderPhase() => 'gym-leader',
          BattleResult() => 'result',
        };
        expect(message, 'warmup');
      },
    );

    test(
      'boss HP does not go below 0',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // Deal way more damage than boss HP
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 999,
            rpe: 10,
          ),
          move,
          80,
        );
        // Minion should be at 0, not negative
        expect(
          state.bosses[0].currentHp,
          0,
        );
      },
    );

    test(
      'exhaustion: reps drop deducts player HP',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // First set: 10 reps
        state = engine.submitSet(
          state,
          makeSet(
            weight: 10,
            reps: 15,
            rpe: 7,
            setNumber: 1,
          ),
          move,
          80,
        );
        expect(state.playerHp, 100);

        // Second set: fewer reps → exhaustion
        state = engine.submitSet(
          state,
          makeSet(
            weight: 10,
            reps: 8,
            rpe: 7,
            setNumber: 2,
          ),
          move,
          80,
        );
        // 10% of 100 = 10 HP loss
        expect(state.playerHp, 90);
        expect(state.exhaustionEvents, 1);
      },
    );

    test(
      'counter: reps below suggested deducts HP',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // First set with low reps (Warmup
        // suggests 12)
        state = engine.submitSet(
          state,
          makeSet(
            weight: 10,
            reps: 5,
            rpe: 7,
            setNumber: 1,
          ),
          move,
          80,
        );
        // No counter on first set (no previous)
        expect(state.counterEvents, 0);

        // Second set with same low reps
        // (5 < 12 suggested, but 5 == 5 prev)
        // Not a miss (same reps) but below
        // suggested → counter
        state = engine.submitSet(
          state,
          makeSet(
            weight: 10,
            reps: 5,
            rpe: 7,
            setNumber: 2,
          ),
          move,
          80,
        );
        // 15% of 100 = 15 HP loss
        expect(state.playerHp, 85);
        expect(state.counterEvents, 1);
      },
    );

    test(
      'defeat: player HP reaches 0',
      () {
        // Use high-HP bosses so they survive long
        // enough for the player to be defeated.
        final tankBosses = [
          const Boss(
            name: 'Tank1',
            type: MuscleType.chest,
            maxHp: 9999,
            currentHp: 9999,
            defense: 5,
            stage: BossStage.minion,
          ),
          const Boss(
            name: 'Tank2',
            type: MuscleType.back,
            maxHp: 9999,
            currentHp: 9999,
            defense: 10,
            stage: BossStage.midBoss,
          ),
          const Boss(
            name: 'Tank3',
            type: MuscleType.legs,
            maxHp: 9999,
            currentHp: 9999,
            defense: 15,
            stage: BossStage.gymLeader,
          ),
        ];
        var state = engine.startBattle(
          bosses: tankBosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 10,
          playerPp: 9999,
        );
        // First set
        state = engine.submitSet(
          state,
          makeSet(
            weight: 10,
            reps: 15,
            rpe: 7,
            setNumber: 1,
          ),
          move,
          80,
        );
        // Second set with fewer reps →
        // exhaustion (10% of 10 = 1 HP)
        state = engine.submitSet(
          state,
          makeSet(
            weight: 10,
            reps: 14,
            rpe: 7,
            setNumber: 2,
          ),
          move,
          80,
        );
        expect(state.playerHp, 9);

        // Keep dropping reps to drain HP
        for (var i = 13; i > 0; i--) {
          if (!state.isActive) break;
          state = engine.submitSet(
            state,
            makeSet(
              weight: 10,
              reps: i,
              rpe: 7,
              setNumber: 3 + (13 - i),
            ),
            move,
            80,
          );
        }

        expect(state.phase, isA<BattleResult>());
        final result =
            state.phase as BattleResult;
        expect(
          result.outcome.isVictory,
          isFalse,
        );
        expect(
          result.outcome.expModifier,
          0.6,
        );
        expect(state.playerHp, 0);
      },
    );

    test(
      'victory includes expModifier 1.0',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // Kill all bosses quickly
        state = engine.submitSet(
          state,
          makeSet(weight: 160, reps: 50, rpe: 10),
          move,
          80,
        );
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 100,
            rpe: 10,
          ),
          move,
          80,
        );
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 100,
            rpe: 10,
          ),
          move,
          80,
        );
        final result =
            state.phase as BattleResult;
        expect(
          result.outcome.expModifier,
          1.0,
        );
      },
    );

    test(
      'volume calculation is accurate',
      () {
        var state = engine.startBattle(
          bosses: bosses,
          gymType: GymType.physique,
          playerMuscle: MuscleType.chest,
          playerHp: 100,
          playerPp: 110,
        );
        // Kill all bosses
        state = engine.submitSet(
          state,
          makeSet(weight: 160, reps: 50, rpe: 10),
          move,
          80,
        );
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 100,
            rpe: 10,
          ),
          move,
          80,
        );
        state = engine.submitSet(
          state,
          makeSet(
            weight: 160,
            reps: 100,
            rpe: 10,
          ),
          move,
          80,
        );
        final result =
            state.phase as BattleResult;
        // 160*50 + 160*100 + 160*100 = 40000
        expect(
          result.outcome.totalVolume,
          8000 + 16000 + 16000,
        );
      },
    );
  });
}
