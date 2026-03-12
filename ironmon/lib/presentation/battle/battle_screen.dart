import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/providers/audio_providers.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/presentation/battle/widgets/boss_hp_bar.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/presentation/battle/widgets/item_panel.dart';
import 'package:ironmon/presentation/battle/widgets/pp_bar.dart';
import 'package:ironmon/presentation/battle/widgets/damage_display.dart';
import 'package:ironmon/presentation/battle/widgets/evolution_animation.dart';
import 'package:ironmon/presentation/battle/widgets/move_selector.dart';
import 'package:ironmon/presentation/battle/widgets/set_input_panel.dart';
import 'package:ironmon/presentation/battle/widgets/screen_shake.dart';
import 'package:ironmon/presentation/battle/widgets/phase_transition.dart';
import 'package:ironmon/domain/training/pr_detector.dart';
import 'package:ironmon/providers/battle_providers.dart';
import 'package:ironmon/providers/repository_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Full battle screen with boss HP, damage display,
/// move selector, and set input.
class BattleScreen extends ConsumerStatefulWidget {
  /// Creates [BattleScreen].
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() =>
      _BattleScreenState();
}

class _BattleScreenState
    extends ConsumerState<BattleScreen> {
  int _setNumber = 1;
  int _lastPrCount = 0;
  bool _showEvolution = false;
  final GlobalKey<ScreenShakeState> _screenShakeKey = GlobalKey<ScreenShakeState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _initBattle(),
    );
    // Keep screen awake during battle
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _initBattle() {
    final muscle = ref.read(
      selectedMuscleTypeProvider,
    );
    final gym = ref.read(selectedGymTypeProvider);
    if (muscle == null) return;

    final profile = ref.read(
      userProfileProvider,
    ).value;
    final playerLevel = profile?.level ?? 1;
    final playerHp = 100 + ((playerLevel - 1) * 5);
    final playerPp = profile?.maxPp ?? (100 + playerLevel * 10);

    final generator = ref.read(
      bossGeneratorProvider,
    );
    final bosses = generator.generateLineup(
      playerMuscle: muscle,
      gymType: gym,
      playerLevel: playerLevel,
    );

    ref
        .read(
          battleStateNotifierProvider.notifier,
        )
        .startBattle(
          bosses: bosses,
          gymType: gym,
          playerMuscle: muscle,
          playerHp: playerHp,
          playerPp: playerPp,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      battleStateNotifierProvider,
    );

    // Navigate to result on battle end
    ref.listen<BattleState>(
      battleStateNotifierProvider,
      (prev, next) {
        if (next.phase is BattleResult) {
          context.push('/battle/result');
        }
        // Show evolution animation on new PR
        if (next.prEvents.length >
            _lastPrCount) {
          _lastPrCount = next.prEvents.length;
          setState(
            () => _showEvolution = true,
          );
        }
        // Trigger screen shake on critical or super effective hits
        final lastDamage = next.damageResults.isNotEmpty
            ? next.damageResults.last
            : null;
        if (lastDamage != null &&
            (lastDamage.isCritical ||
                lastDamage.effectiveness ==
                    Effectiveness.superEffective)) {
          _screenShakeKey.currentState?.shake();
        }
      },
    );

    // BGM phase transitions
    ref.listen<BattleState>(
      battleStateNotifierProvider,
      (prev, next) {
        if (prev?.phase.runtimeType !=
            next.phase.runtimeType) {
          ref
              .read(battleBgmControllerProvider)
              .onPhaseChanged(next.phase);
        }
      },
    );

    if (!state.isActive) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final boss = state.currentBoss;
    final lastDamage = state.damageResults.isEmpty
        ? null
        : state.damageResults.last;

    // Get moves for current muscle type
    final registry = ref.watch(
      moveRegistryProvider,
    );
    final moves = registry.value
            ?.getMovesByType(
              state.playerMuscleType,
            ) ??
        <MoveDefinition>[];

    final profile = ref.watch(
      userProfileProvider,
    ).value;

    // Last set for the currently selected move only
    // (not just any move — each exercise has its own weight).
    final selectedMoveId = state.selectedMoveId;
    final setsForMove = selectedMoveId == null
        ? <ExerciseSet>[]
        : state.completedSets
            .where((s) => s.moveId == selectedMoveId)
            .toList();
    final prevSetForMove =
        setsForMove.isEmpty ? null : setsForMove.last;

    // Recommended weight: use this move's per-exercise 5RM
    // when there's no history for it yet.
    final prDetector = const PRDetector();
    final recommendedWeight = prevSetForMove?.weight ??
        (profile != null && selectedMoveId != null
            ? prDetector.getFiveRmForExercise(
                profile,
                selectedMoveId,
                state.playerMuscleType,
              )
            : null);

    // Suggested reps: phase-appropriate target when no history for this move.
    final suggestedReps = prevSetForMove?.reps ??
        switch (state.phase) {
          Warmup() => 12,
          MidBossPhase() => 8,
          GymLeaderPhase() => 5,
          _ => 10,
        };

    final phaseLabel = switch (state.phase) {
      Idle() => '',
      Warmup() => 'Stage 1: Minion',
      MidBossPhase() => 'Stage 2: Mid-Boss',
      GymLeaderPhase() =>
        'Stage 3: Gym Leader',
      BattleResult() => 'Battle Complete',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(phaseLabel),
        automaticallyImplyLeading: false,
      ),
      body: ScreenShake(
        key: _screenShakeKey,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
          children: [
            // Boss area with phase transition animation
            PhaseTransition(
              phaseKey: ValueKey(state.currentBossIndex),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Boss sprite placeholder
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          boss.type.elementName,
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Damage display
                    DamageDisplay(
                      damageResult: lastDamage,
                    ),
                    // Boss HP bar
                    BossHpBar(
                      currentHp: boss.currentHp,
                      maxHp: boss.maxHp,
                      bossName: boss.name,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            // Player HP
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  const Text(
                    'Player HP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: state.maxPlayerHp > 0
                          ? state.playerHp /
                              state.maxPlayerHp
                          : 0,
                      minHeight: 10,
                      borderRadius:
                          BorderRadius.circular(
                        5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${state.playerHp}'
                    '/${state.maxPlayerHp}',
                  ),
                ],
              ),
            ),
            // Player PP bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: PpBar(
                currentPp: state.playerPp,
                maxPp: state.maxPlayerPp,
              ),
            ),
            const SizedBox(height: 4),
            // Item panel
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ItemPanel(
                potionCount: profile?.potionCount ?? 0,
                etherCount: profile?.etherCount ?? 0,
                rareCandyCount:
                    profile?.rareCandyCount ?? 0,
                canUse: state.canUseItem,
                onUseItem: (ItemType type) {
                  ref
                      .read(
                        battleStateNotifierProvider
                            .notifier,
                      )
                      .useItem(type);
                },
              ),
            ),
            const SizedBox(height: 8),
            // Move selector
            MoveSelector(
              moves: moves,
              selectedMoveId:
                  state.selectedMoveId,
              onMoveSelected: (id) => ref
                  .read(
                    battleStateNotifierProvider
                        .notifier,
                  )
                  .selectMove(id),
            ),
            const SizedBox(height: 8),
            // Set input panel
            Padding(
              padding: const EdgeInsets.all(8),
              child: SetInputPanel(
                previousWeight: recommendedWeight,
                previousReps: suggestedReps,
                onSubmit: (weight, reps, rpe) {
                  final moveId =
                      state.selectedMoveId;
                  if (moveId == null) return;

                  final move = moves.firstWhere(
                    (m) => m.id == moveId,
                    orElse: () => moves.first,
                  );

                  // Block if PP insufficient
                  if (state.playerPp < move.pp) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Not enough PP!',
                        ),
                        duration: Duration(
                          seconds: 2,
                        ),
                      ),
                    );
                    return;
                  }

                  final exerciseSet = ExerciseSet(
                    moveId: moveId,
                    weight: weight,
                    reps: reps,
                    rpe: rpe,
                    setNumber: _setNumber,
                  );

                  final detector = const PRDetector();
                  final fiveRm = profile != null
                      ? detector.getFiveRmForExercise(
                          profile,
                          move.id,
                          state.playerMuscleType,
                        )
                      : 80.0;

                  ref
                      .read(
                        battleStateNotifierProvider
                            .notifier,
                      )
                      .submitSet(
                        exerciseSet,
                        move,
                        fiveRm,
                      );
                  setState(
                    () => _setNumber++,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
      // Evolution animation overlay
      if (_showEvolution &&
          state.prEvents.isNotEmpty)
        Positioned.fill(
          child: ColoredBox(
            color:
                Colors.black.withValues(alpha: 0.7),
            child: EvolutionAnimation(
              prResult:
                  state.prEvents.last,
              onComplete: () => setState(
                () => _showEvolution = false,
              ),
            ),
          ),
        ),
      ],
        ),
      ),
    );
  }
}
