import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/battle/battle_engine.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/boss_generator.dart';
import 'package:ironmon/domain/battle/damage_calculator.dart';
import 'package:ironmon/domain/battle/models/battle_outcome.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/haptic_service.dart';
import 'package:ironmon/providers/repository_providers.dart';
import 'package:ironmon/providers/training_providers.dart';
import 'package:ironmon/providers/type_system_providers.dart';
import 'package:ironmon/domain/items/item_service.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/daily_mission_service.dart';
import 'package:ironmon/providers/item_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Provides the [ItemService].
final itemServiceProvider =
    Provider<ItemService>((ref) {
  return const ItemService();
});

/// Provides the [BossGenerator] instance.
final bossGeneratorProvider =
    Provider<BossGenerator>((ref) {
  final te = ref.watch(typeEffectivenessProvider);
  return BossGenerator(te);
});

/// Selected muscle type for gym selection screen.
final selectedMuscleTypeProvider =
    NotifierProvider<SelectedMuscleType,
        MuscleType?>(
  SelectedMuscleType.new,
);

/// Notifier for selected muscle type.
class SelectedMuscleType
    extends Notifier<MuscleType?> {
  @override
  MuscleType? build() => null;
}

/// Selected gym type for gym selection screen.
final selectedGymTypeProvider =
    NotifierProvider<SelectedGymType, GymType>(
  SelectedGymType.new,
);

/// Notifier for selected gym type.
class SelectedGymType extends Notifier<GymType> {
  @override
  GymType build() => GymType.physique;
}

/// Provides the [DamageCalculator] instance.
final damageCalculatorProvider =
    Provider<DamageCalculator>((ref) {
  final te = ref.watch(typeEffectivenessProvider);
  return DamageCalculator(typeEffectiveness: te);
});

/// Provides the [BattleEngine] instance.
final battleEngineProvider =
    Provider<BattleEngine>((ref) {
  final dc = ref.watch(damageCalculatorProvider);
  return BattleEngine(damageCalculator: dc);
});

/// Provides the [HapticService] instance.
final hapticServiceProvider =
    Provider<HapticService>((ref) {
  return const HapticService();
});

/// Notifier that holds and manages [BattleState].
final battleStateNotifierProvider =
    NotifierProvider<BattleStateNotifier,
        BattleState>(
  BattleStateNotifier.new,
);

/// Manages battle state transitions via
/// [BattleEngine].
class BattleStateNotifier
    extends Notifier<BattleState> {
  @override
  BattleState build() =>
      const BattleState.initial();

  /// Starts a new battle.
  void startBattle({
    required List<Boss> bosses,
    required GymType gymType,
    required MuscleType playerMuscle,
    required int playerHp,
    required int playerPp,
  }) {
    final engine = ref.read(battleEngineProvider);
    state = engine.startBattle(
      bosses: bosses,
      gymType: gymType,
      playerMuscle: playerMuscle,
      playerHp: playerHp,
      playerPp: playerPp,
    );
  }

  /// Selects a move for the current turn.
  void selectMove(String moveId) {
    final engine = ref.read(battleEngineProvider);
    state = engine.selectMove(state, moveId);
  }

  /// Uses an item during battle.
  Future<void> useItem(ItemType type) async {
    final profile =
        ref.read(userProfileProvider).value;
    if (profile == null) return;
    final svc = ref.read(itemServiceProvider);
    final itemRepo =
        ref.read(itemRepositoryProvider);
    final id = ItemService.itemId(type);
    final count = itemRepo.getQuantity(profile, id);

    BattleState? newState;
    switch (type) {
      case ItemType.potion:
        final result = svc.usePotion(state, count);
        if (result is Failure) return;
        newState = (result as Success<BattleState, String>).value;
      case ItemType.ether:
        final result = svc.useEther(state, count);
        if (result is Failure) return;
        newState = (result as Success<BattleState, String>).value;
      case ItemType.rareCandy:
        final result = svc.validateRareCandy(
          count,
          state.selectedMoveId ?? '',
        );
        if (result is Failure) return;
        newState = svc.recordRareCandyUse(state);
    }

    // Deduct item from profile
    final updated =
        itemRepo.removeItem(profile, id);
    await ref
        .read(userProfileProvider.notifier)
        .updateProfile(updated);

    state = newState;
    ref.read(hapticServiceProvider).onSelectionClick();
  }

  /// Submits a training set.
  void submitSet(
    ExerciseSet exerciseSet,
    MoveDefinition move,
    double playerFiveRm,
  ) {
    final prevState = state;
    final engine = ref.read(battleEngineProvider);
    var newState = engine.submitSet(
      state,
      exerciseSet,
      move,
      playerFiveRm,
    );

    // PR detection
    newState = _checkPR(
      newState,
      exerciseSet,
      playerFiveRm,
    );

    // If battle just ended, calculate EXP
    if (newState.phase is BattleResult &&
        prevState.phase is! BattleResult) {
      state = _applyExp(newState);
      _persistExp();
      _triggerHaptic(prevState, state);
    } else {
      state = newState;
      _triggerHaptic(prevState, newState);
    }
  }

  /// Checks for a PR after each set.
  BattleState _checkPR(
    BattleState s,
    ExerciseSet set,
    double currentFiveRm,
  ) {
    final detector =
        ref.read(prDetectorProvider);
    final result = detector.checkForPR(
      weight: set.weight,
      reps: set.reps,
      currentFiveRm: currentFiveRm,
      muscleType: s.playerMuscleType,
    );
    if (result.isPR) {
      // Persist 5RM atomically
      _persistFiveRm(
        s.playerMuscleType,
        result.newFiveRm,
      );
      // Haptic for PR
      ref
          .read(hapticServiceProvider)
          .onCriticalEvent();
      return s.copyWith(
        prEvents: [...s.prEvents, result],
      );
    }
    return s;
  }

  /// Persists the new 5RM atomically (NFR10).
  Future<void> _persistFiveRm(
    MuscleType type,
    double newValue,
  ) async {
    final field = switch (type) {
      MuscleType.chest => 'benchPress',
      MuscleType.back => 'deadlift',
      MuscleType.legs => 'squat',
      MuscleType.shoulders => 'overheadPress',
      MuscleType.arms => 'benchPress',
    };
    final repo = ref.read(
      userProfileRepositoryProvider,
    );
    await repo.updateFiveRm(field, newValue);
  }

  /// Triggers haptic feedback based on state
  /// changes.
  void _triggerHaptic(
    BattleState prev,
    BattleState next,
  ) {
    final haptic =
        ref.read(hapticServiceProvider);

    // Boss defeated → heavy impact
    if (prev.currentBossIndex !=
            next.currentBossIndex ||
        (next.phase is BattleResult &&
            prev.phase is! BattleResult)) {
      haptic.onCriticalEvent();
      return;
    }

    // Player took exhaustion/counter damage
    if (next.playerHp < prev.playerHp) {
      haptic.onPlayerDamage();
      return;
    }

    // Check last damage result effectiveness
    if (next.damageResults.isNotEmpty) {
      final last = next.damageResults.last;
      if (last.effectiveness ==
          Effectiveness.superEffective) {
        haptic.onSuperEffective();
        return;
      }
    }

    // Normal hit
    haptic.onAttackHit();
  }

  /// Calculates and applies EXP to outcome,
  /// applying daily mission bonus if applicable.
  BattleState _applyExp(BattleState s) {
    final result = s.phase as BattleResult;
    final outcome = result.outcome;
    final calc =
        ref.read(expCalculatorProvider);
    var exp = calc.calculateExp(
      totalDamage: outcome.totalDamageDealt,
      totalSets: outcome.totalSets,
      totalVolume: outcome.totalVolume,
      isVictory: outcome.isVictory,
    );

    // Apply daily mission bonus (+20%)
    final mission = ref
        .read(dailyMissionProvider)
        .value;
    if (mission != null) {
      final missionSvc =
          ref.read(dailyMissionServiceProvider);
      final mockSession = WorkoutSession(
        date: DateTime.now(),
        gymType: s.gymType.name,
        muscleType: s.playerMuscleType.name,
        totalVolume: 0,
        totalDamage: 0,
        totalSets: 0,
        isVictory: outcome.isVictory,
        expEarned: 0,
      );
      final multiplier = missionSvc
          .expMultiplier(mission, mockSession);
      exp = (exp * multiplier).round();
    }
    final updated = BattleOutcome(
      isVictory: outcome.isVictory,
      totalDamageDealt:
          outcome.totalDamageDealt,
      totalSets: outcome.totalSets,
      totalVolume: outcome.totalVolume,
      expModifier: outcome.expModifier,
      exhaustionEvents:
          outcome.exhaustionEvents,
      counterEvents: outcome.counterEvents,
      earnedExp: exp,
    );
    return s.copyWith(
      phase: BattleResult(outcome: updated),
    );
  }

  /// Persists EXP and level up to user profile,
  /// then saves workout session history.
  Future<void> _persistExp() async {
    final result =
        state.phase as BattleResult;
    final outcome = result.outcome;
    final profileAsync = ref.read(
      userProfileProvider,
    );
    final profile = profileAsync.value;
    if (profile == null) return;

    // Check level up
    final levelSys =
        ref.read(levelSystemProvider);
    final lvResult = levelSys.checkLevelUp(
      profile,
      outcome.earnedExp,
    );

    final updated = profile.copyWith(
      experiencePoints: lvResult.remainingExp,
      level: lvResult.newLevel,
    );
    await ref
        .read(userProfileProvider.notifier)
        .updateProfile(updated);

    // Check move unlocks
    final unlockSvc =
        ref.read(moveUnlockServiceProvider);
    final registry =
        ref.read(moveRegistryProvider).value;
    final unlockedNames = <String>[];
    if (registry != null) {
      final newMoves = unlockSvc.checkNewUnlocks(
        profile: updated,
        registry: registry,
      );
      if (newMoves.isNotEmpty) {
        unlockedNames.addAll(
          newMoves.map((m) => m.name),
        );
        final updatedWithMoves =
            updated.copyWith(
          unlockedMoveIds: [
            ...updated.unlockedMoveIds,
            ...newMoves.map((m) => m.id),
          ],
        );
        await ref
            .read(
              userProfileProvider.notifier,
            )
            .updateProfile(updatedWithMoves);

        // Haptic for unlock
        ref
            .read(hapticServiceProvider)
            .onCriticalEvent();
      }
    }

    // Award coins based on battle result
    final coinsEarned = outcome.isVictory
        ? 100 + (lvResult.newLevel * 5)
        : 40 + (lvResult.newLevel * 2);
    final profileForCoins =
        ref.read(userProfileProvider).value;
    if (profileForCoins != null) {
      await ref
          .read(userProfileProvider.notifier)
          .updateProfile(
            profileForCoins.copyWith(
              coins:
                  profileForCoins.coins +
                  coinsEarned,
            ),
          );
    }

    // Award 1 random item on victory
    final awardedItems = <String>[];
    if (outcome.isVictory) {
      const itemIds = ['potion', 'ether', 'rare_candy'];
      final awarded =
          itemIds[Random().nextInt(itemIds.length)];
      awardedItems.add(awarded);
      final itemRepo =
          ref.read(itemRepositoryProvider);
      final profileAfterUnlocks = ref
          .read(userProfileProvider)
          .value;
      if (profileAfterUnlocks != null) {
        final withItem = itemRepo.addItem(
          profileAfterUnlocks,
          awarded,
        );
        await ref
            .read(
              userProfileProvider.notifier,
            )
            .updateProfile(withItem);
      }
    }

    // Update outcome with level & unlock info
    final updatedOutcome = BattleOutcome(
      isVictory: outcome.isVictory,
      totalDamageDealt:
          outcome.totalDamageDealt,
      totalSets: outcome.totalSets,
      totalVolume: outcome.totalVolume,
      expModifier: outcome.expModifier,
      exhaustionEvents:
          outcome.exhaustionEvents,
      counterEvents: outcome.counterEvents,
      earnedExp: outcome.earnedExp,
      levelsGained: lvResult.levelsGained,
      newLevel: lvResult.newLevel,
      unlockedMoveNames: unlockedNames,
      awardedItems: awardedItems,
      coinsEarned: coinsEarned,
    );
    state = state.copyWith(
      phase: BattleResult(
        outcome: updatedOutcome,
      ),
    );

    if (lvResult.didLevelUp) {
      // Haptic for level up
      ref
          .read(hapticServiceProvider)
          .onCriticalEvent();
    }

    // Save workout session history
    await _saveWorkoutSession();
  }

  /// Saves the workout session and sets to
  /// history storage.
  Future<void> _saveWorkoutSession() async {
    final result =
        state.phase as BattleResult;
    final outcome = result.outcome;
    final session = WorkoutSession(
      date: DateTime.now(),
      gymType: state.gymType.name,
      muscleType:
          state.playerMuscleType.name,
      totalVolume: outcome.totalVolume,
      totalDamage: outcome.totalDamageDealt,
      totalSets: outcome.totalSets,
      isVictory: outcome.isVictory,
      expEarned: outcome.earnedExp,
    );
    final damages = state.damageResults
        .map((r) => r.finalDamage)
        .toList();
    final repo = ref.read(
      workoutSessionRepositoryProvider,
    );
    await repo.saveSession(
      session,
      state.completedSets,
      damages: damages,
    );
  }
}
