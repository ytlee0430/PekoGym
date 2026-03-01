import 'package:ironmon/data/mappers/battle_state_mapper.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/models/battle_outcome.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:test/test.dart';

void main() {
  group('BattleStateMapper', () {
    group('BattlePhase serialization', () {
      test('Idle round-trip', () {
        const phase = Idle();
        final json =
            BattleStateMapper.serializePhase(phase);
        final result =
            BattleStateMapper.deserializePhase(json);
        expect(result, isA<Idle>());
      });

      test('Warmup round-trip', () {
        const phase = Warmup();
        final json =
            BattleStateMapper.serializePhase(phase);
        final result =
            BattleStateMapper.deserializePhase(json);
        expect(result, isA<Warmup>());
      });

      test('MidBossPhase round-trip', () {
        const phase = MidBossPhase();
        final json =
            BattleStateMapper.serializePhase(phase);
        final result =
            BattleStateMapper.deserializePhase(json);
        expect(result, isA<MidBossPhase>());
      });

      test('GymLeaderPhase round-trip', () {
        const phase = GymLeaderPhase();
        final json =
            BattleStateMapper.serializePhase(phase);
        final result =
            BattleStateMapper.deserializePhase(json);
        expect(result, isA<GymLeaderPhase>());
      });

      test('BattleResult round-trip', () {
        const phase = BattleResult(
          outcome: BattleOutcome.victory(
            totalDamageDealt: 500,
            totalSets: 10,
            totalVolume: 5000,
          ),
        );
        final json =
            BattleStateMapper.serializePhase(phase);
        final result =
            BattleStateMapper.deserializePhase(json);
        expect(result, isA<BattleResult>());
        final br = result as BattleResult;
        expect(br.outcome.isVictory, isTrue);
        expect(br.outcome.totalDamageDealt, 500);
        expect(br.outcome.totalSets, 10);
        expect(br.outcome.totalVolume, 5000.0);
      });
    });

    group('Boss serialization', () {
      test('round-trip preserves all fields', () {
        final bosses = [
          const Boss(
            name: 'Minion',
            type: MuscleType.chest,
            maxHp: 50,
            currentHp: 30,
            defense: 5,
            stage: BossStage.minion,
          ),
          const Boss(
            name: 'Leader',
            type: MuscleType.back,
            maxHp: 200,
            currentHp: 200,
            defense: 15,
            stage: BossStage.gymLeader,
          ),
        ];
        final json =
            BattleStateMapper.serializeBosses(
          bosses,
        );
        final result =
            BattleStateMapper.deserializeBosses(
          json,
        );
        expect(result.length, 2);
        expect(result[0].name, 'Minion');
        expect(result[0].type, MuscleType.chest);
        expect(result[0].currentHp, 30);
        expect(result[1].name, 'Leader');
        expect(
          result[1].stage,
          BossStage.gymLeader,
        );
      });
    });

    group('ExerciseSet serialization', () {
      test('round-trip preserves all fields', () {
        final sets = [
          const ExerciseSet(
            moveId: 'chest-1',
            weight: 80.5,
            reps: 10,
            rpe: 8,
            setNumber: 1,
          ),
        ];
        final json =
            BattleStateMapper.serializeSets(sets);
        final result =
            BattleStateMapper.deserializeSets(json);
        expect(result.length, 1);
        expect(result[0].moveId, 'chest-1');
        expect(result[0].weight, 80.5);
        expect(result[0].reps, 10);
        expect(result[0].rpe, 8);
      });
    });

    group('DamageResult serialization', () {
      test('round-trip preserves all fields', () {
        final results = [
          const DamageResult(
            rawDamage: 400.5,
            finalDamage: 401,
            typeMultiplier: 1.5,
            rpeMultiplier: 1.2,
            intensity: 1.0,
            isEffective: true,
            effectiveness:
                Effectiveness.superEffective,
          ),
        ];
        final json = BattleStateMapper
            .serializeDamageResults(results);
        final result = BattleStateMapper
            .deserializeDamageResults(json);
        expect(result.length, 1);
        expect(result[0].rawDamage, 400.5);
        expect(result[0].finalDamage, 401);
        expect(result[0].typeMultiplier, 1.5);
        expect(
          result[0].effectiveness,
          Effectiveness.superEffective,
        );
      });
    });

    group('Full BattleState', () {
      test('toInsertableMap and fromEntityMap', () {
        final state = BattleState(
          phase: const Warmup(),
          bosses: const [
            Boss(
              name: 'Test',
              type: MuscleType.legs,
              maxHp: 100,
              currentHp: 75,
              defense: 10,
              stage: BossStage.minion,
            ),
          ],
          currentBossIndex: 0,
          playerHp: 90,
          maxPlayerHp: 100,
          gymType: GymType.strength,
          playerMuscleType: MuscleType.chest,
          completedSets: const [
            ExerciseSet(
              moveId: 'c1',
              weight: 60,
              reps: 8,
              rpe: 7,
              setNumber: 1,
            ),
          ],
          damageResults: const [
            DamageResult(
              rawDamage: 200,
              finalDamage: 200,
              typeMultiplier: 1.0,
              rpeMultiplier: 1.0,
              intensity: 0.75,
              isEffective: true,
              effectiveness:
                  Effectiveness.neutral,
            ),
          ],
          selectedMoveId: 'c1',
          totalDamageDealt: 200,
        );

        final map =
            BattleStateMapper.toInsertableMap(
          state,
        );
        final restored =
            BattleStateMapper.fromEntityMap(map);

        expect(restored.phase, isA<Warmup>());
        expect(restored.bosses.length, 1);
        expect(
          restored.bosses[0].currentHp,
          75,
        );
        expect(restored.playerHp, 90);
        expect(
          restored.gymType,
          GymType.strength,
        );
        expect(
          restored.playerMuscleType,
          MuscleType.chest,
        );
        expect(
          restored.completedSets.length,
          1,
        );
        expect(
          restored.damageResults.length,
          1,
        );
        expect(
          restored.selectedMoveId,
          'c1',
        );
        expect(
          restored.totalDamageDealt,
          200,
        );
      });
    });
  });
}
