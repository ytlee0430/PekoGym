import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/damage_calculator.dart';
import 'package:ironmon/domain/battle/models/battle_outcome.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Stateless battle engine that processes state
/// transitions.
/// Pure Dart — zero Flutter dependency.
class BattleEngine {
  /// Creates a [BattleEngine].
  const BattleEngine({
    required DamageCalculator damageCalculator,
  }) : _damageCalculator = damageCalculator;

  final DamageCalculator _damageCalculator;

  /// Starts a new battle with the given lineup.
  BattleState startBattle({
    required List<Boss> bosses,
    required GymType gymType,
    required MuscleType playerMuscle,
    required int playerHp,
    required int playerPp,
  }) {
    return BattleState(
      phase: const Warmup(),
      bosses: bosses,
      currentBossIndex: 0,
      playerHp: playerHp,
      maxPlayerHp: playerHp,
      gymType: gymType,
      playerMuscleType: playerMuscle,
      playerPp: playerPp,
      maxPlayerPp: playerPp,
    );
  }

  /// Sets the selected move for the current turn.
  BattleState selectMove(
    BattleState state,
    String moveId,
  ) {
    return state.copyWith(selectedMoveId: moveId);
  }

  /// Submits a training set, calculates damage,
  /// applies it to the current boss, and
  /// transitions phase if the boss is defeated.
  BattleState submitSet(
    BattleState state,
    ExerciseSet exerciseSet,
    MoveDefinition move,
    double playerFiveRm,
  ) {
    if (!state.isActive) return state;

    // PP check: block move if insufficient PP
    if (state.playerPp < move.pp) return state;

    final boss = state.currentBoss;
    final result = _damageCalculator.calculate(
      exerciseSet: exerciseSet,
      move: move,
      bossType: boss.type,
      playerFiveRm: playerFiveRm,
      bossDefense: boss.defense,
      gymType: state.gymType,
    );

    final newBossHp =
        (boss.currentHp - result.finalDamage)
            .clamp(0, boss.maxHp);

    final updatedBoss =
        boss.copyWith(currentHp: newBossHp);

    final updatedBosses =
        List<Boss>.from(state.bosses);
    updatedBosses[state.currentBossIndex] =
        updatedBoss;

    final newSets = [
      ...state.completedSets,
      exerciseSet,
    ];
    final newResults = [
      ...state.damageResults,
      result,
    ];
    final newTotalDamage =
        state.totalDamageDealt + result.finalDamage;

    // Deduct PP for the move used
    final newPp =
        (state.playerPp - move.pp).clamp(0, state.maxPlayerPp);

    var newState = state.copyWith(
      bosses: updatedBosses,
      completedSets: newSets,
      damageResults: newResults,
      totalDamageDealt: newTotalDamage,
      playerPp: newPp,
    );

    // Check exhaustion → deduct player HP
    newState = _applyExhaustion(
      newState,
      exerciseSet,
      state,
    );

    // Check defeat (player HP ≤ 0)
    if (newState.playerHp <= 0) {
      return _buildDefeatResult(newState);
    }

    // Check if boss is defeated
    if (newBossHp <= 0) {
      newState = _transitionToNextPhase(newState);
    }

    return newState;
  }

  BattleState _transitionToNextPhase(
    BattleState state,
  ) {
    final nextIndex = state.currentBossIndex + 1;

    // All bosses defeated → victory
    if (nextIndex >= state.bosses.length) {
      final totalVolume =
          state.completedSets.fold<double>(
        0,
        (sum, s) => sum + s.weight * s.reps,
      );
      return state.copyWith(
        phase: BattleResult(
          outcome: BattleOutcome.victory(
            totalDamageDealt:
                state.totalDamageDealt,
            totalSets:
                state.completedSets.length,
            totalVolume: totalVolume,
            exhaustionEvents:
                state.exhaustionEvents,
            counterEvents:
                state.counterEvents,
          ),
        ),
      );
    }

    // Move to next boss
    final nextPhase = switch (nextIndex) {
      1 => const MidBossPhase(),
      2 => const GymLeaderPhase(),
      _ => const GymLeaderPhase(),
    };

    return state.copyWith(
      phase: nextPhase,
      currentBossIndex: nextIndex,
    );
  }

  /// Checks exhaustion and counter conditions,
  /// deducts player HP accordingly.
  BattleState _applyExhaustion(
    BattleState newState,
    ExerciseSet currentSet,
    BattleState previousState,
  ) {
    // Find previous sets with same move
    final previousSets = previousState
        .completedSets
        .where(
          (s) => s.moveId == currentSet.moveId,
        )
        .toList();

    if (previousSets.isEmpty) return newState;

    final lastSet = previousSets.last;

    // Miss: reps dropped from previous set
    if (currentSet.reps < lastSet.reps) {
      final hpLoss =
          (newState.maxPlayerHp * 0.1).round();
      final newHp =
          (newState.playerHp - hpLoss).clamp(
        0,
        newState.maxPlayerHp,
      );
      return newState.copyWith(
        playerHp: newHp,
        exhaustionEvents:
            newState.exhaustionEvents + 1,
      );
    }

    // Counter: reps below suggested minimum
    final suggestedReps =
        _getSuggestedReps(newState.phase);
    if (currentSet.reps < suggestedReps) {
      final hpLoss =
          (newState.maxPlayerHp * 0.15).round();
      final newHp =
          (newState.playerHp - hpLoss).clamp(
        0,
        newState.maxPlayerHp,
      );
      return newState.copyWith(
        playerHp: newHp,
        counterEvents:
            newState.counterEvents + 1,
      );
    }

    return newState;
  }

  /// Gets suggested minimum reps per phase.
  int _getSuggestedReps(BattlePhase phase) {
    return switch (phase) {
      Warmup() => 12,
      MidBossPhase() => 8,
      GymLeaderPhase() => 5,
      Idle() => 0,
      BattleResult() => 0,
    };
  }

  /// Builds a defeat result state.
  BattleState _buildDefeatResult(
    BattleState state,
  ) {
    final totalVolume =
        state.completedSets.fold<double>(
      0,
      (sum, s) => sum + s.weight * s.reps,
    );
    return state.copyWith(
      playerHp: 0,
      phase: BattleResult(
        outcome: BattleOutcome.defeat(
          totalDamageDealt:
              state.totalDamageDealt,
          totalSets:
              state.completedSets.length,
          totalVolume: totalVolume,
          exhaustionEvents:
              state.exhaustionEvents,
          counterEvents:
              state.counterEvents,
        ),
      ),
    );
  }
}
