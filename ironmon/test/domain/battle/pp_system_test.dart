import 'package:ironmon/domain/battle/battle_engine.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/damage_calculator.dart';
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
      maxHp: 9999,
      currentHp: 9999,
      defense: 5,
      stage: BossStage.minion,
    ),
    const Boss(
      name: 'Mid-Boss',
      type: MuscleType.back,
      maxHp: 9999,
      currentHp: 9999,
      defense: 10,
      stage: BossStage.midBoss,
    ),
    const Boss(
      name: 'Leader',
      type: MuscleType.legs,
      maxHp: 9999,
      currentHp: 9999,
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

  group('PP System', () {
    test('PP deduction per set in BattleEngine', () {
      var state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 110,
      );
      expect(state.playerPp, 110);
      expect(state.maxPlayerPp, 110);

      state = engine.submitSet(
        state,
        makeSet(),
        move,
        80,
      );
      // move.pp == 15, so 110 - 15 = 95
      expect(state.playerPp, 95);
      expect(state.maxPlayerPp, 110);
    });

    test('PP deducted each successive set', () {
      var state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 110,
      );

      // Submit 3 sets
      for (var i = 1; i <= 3; i++) {
        state = engine.submitSet(
          state,
          makeSet(setNumber: i),
          move,
          80,
        );
      }
      // 110 - (15 * 3) = 65
      expect(state.playerPp, 65);
    });

    test('move blocked when PP insufficient', () {
      var state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 10,
      );
      // move.pp == 15, but playerPp == 10
      final before = state;
      state = engine.submitSet(
        state,
        makeSet(),
        move,
        80,
      );
      // State should be unchanged
      expect(state.playerPp, before.playerPp);
      expect(state.completedSets.length, 0);
    });

    test('move blocked at exactly 0 PP', () {
      var state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 0,
      );
      final before = state;
      state = engine.submitSet(
        state,
        makeSet(),
        move,
        80,
      );
      expect(state.playerPp, 0);
      expect(
        state.completedSets.length,
        before.completedSets.length,
      );
    });

    test('PP initialized to max at battle start', () {
      final state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 150,
      );
      expect(state.playerPp, 150);
      expect(state.maxPlayerPp, 150);
      expect(state.phase, isA<Warmup>());
    });

    test('PP does not go below 0', () {
      // Use a move with pp = 15, start with 20 PP
      var state = engine.startBattle(
        bosses: bosses,
        gymType: GymType.physique,
        playerMuscle: MuscleType.chest,
        playerHp: 100,
        playerPp: 20,
      );
      // First set: 20 - 15 = 5
      state = engine.submitSet(
        state,
        makeSet(),
        move,
        80,
      );
      expect(state.playerPp, 5);

      // Second set: 5 < 15, should be blocked
      final before = state;
      state = engine.submitSet(
        state,
        makeSet(setNumber: 2),
        move,
        80,
      );
      expect(state.playerPp, before.playerPp);
      expect(state.completedSets.length, 1);
    });
  });
}
