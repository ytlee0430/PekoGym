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
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/presentation/battle/widgets/item_panel.dart';
import 'package:ironmon/presentation/battle/widgets/damage_display.dart';
import 'package:ironmon/presentation/battle/widgets/evolution_animation.dart';
import 'package:ironmon/presentation/battle/widgets/set_input_panel.dart';
import 'package:ironmon/presentation/battle/widgets/screen_shake.dart';
import 'package:ironmon/presentation/battle/widgets/boss_sprite.dart';
import 'package:ironmon/presentation/battle/widgets/sprites.dart';
import 'package:ironmon/presentation/battle/widgets/attack_effect.dart';
import 'package:ironmon/domain/training/pr_detector.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/providers/battle_providers.dart';
import 'package:ironmon/providers/repository_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

/// Which panel is shown at the bottom of the battle screen.
enum _ActionMode { action, fight, bag, setInput }

/// Pokemon GBA-style battle screen.
///
/// Layout:
///   Top ~55 %: Battle scene - enemy sprite top-right, player bottom-left,
///              name plates on opposite sides, grass platforms.
///   Bottom ~45 %: Action panel - FIGHT / BAG / POKeMON / RUN -> moves ->
///              set input.
class BattleScreen extends ConsumerStatefulWidget {
  /// Creates [BattleScreen].
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen>
    with TickerProviderStateMixin {
  int _setNumber = 1;
  int _lastPrCount = 0;
  bool _showEvolution = false;
  bool _showBossDefeated = false;
  String _defeatedBossName = '';
  _ActionMode _actionMode = _ActionMode.action;
  final GlobalKey<ScreenShakeState> _screenShakeKey =
      GlobalKey<ScreenShakeState>();

  // Trainer intro state
  bool _showIntro = true;
  late AnimationController _introController;
  late AnimationController _introSlideController;
  int _introTextIndex = 0; // for typewriter text

  // Attack effect state
  bool _showAttackEffect = false;
  MuscleType _attackMoveType = MuscleType.chest;
  bool _bossHitFlash = false;

  // Boss faint state
  bool _bossFainting = false;
  late AnimationController _faintController;

  // -- Lifecycle --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _introSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _faintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initBattle();
      _startIntroTypewriter();
      // Start slide-in animations for trainers
      _introSlideController.forward();
    });
    // Keep screen awake during battle
    WakelockPlus.enable();
  }

  void _startIntroTypewriter() {
    // Animate text character by character
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted || !_showIntro) return false;
      setState(() => _introTextIndex++);
      return _introTextIndex < 100; // safety cap
    });
  }

  void _dismissIntro() {
    if (!_showIntro) return;
    _introController.forward().then((_) {
      if (mounted) setState(() => _showIntro = false);
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _introSlideController.dispose();
    _faintController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _initBattle() {
    final muscle = ref.read(selectedMuscleTypeProvider);
    final gym = ref.read(selectedGymTypeProvider);
    if (muscle == null) return;

    final profile = ref.read(userProfileProvider).value;
    final playerLevel = profile?.level ?? 1;
    final playerHp = 100 + ((playerLevel - 1) * 5);
    final playerPp = profile?.maxPp ?? (100 + playerLevel * 10);

    final generator = ref.read(bossGeneratorProvider);
    final bosses = generator.generateLineup(
      playerMuscle: muscle,
      gymType: gym,
      playerLevel: playerLevel,
    );

    ref.read(battleStateNotifierProvider.notifier).startBattle(
          bosses: bosses,
          gymType: gym,
          playerMuscle: muscle,
          playerHp: playerHp,
          playerPp: playerPp,
        );
  }

  // -- Build ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(battleStateNotifierProvider);

    // Navigate to result on battle end & detect PR / screen-shake
    ref.listen<BattleState>(
      battleStateNotifierProvider,
      (prev, next) {
        if (next.phase is BattleResult) {
          context.push('/battle/result');
        }
        // Show evolution animation on new PR
        if (next.prEvents.length > _lastPrCount) {
          _lastPrCount = next.prEvents.length;
          setState(() => _showEvolution = true);
        }
        // Trigger screen shake on critical or super effective hits
        final lastDmg =
            next.damageResults.isNotEmpty ? next.damageResults.last : null;
        if (lastDmg != null &&
            (lastDmg.isCritical ||
                lastDmg.effectiveness == Effectiveness.superEffective)) {
          _screenShakeKey.currentState?.shake();
        }
        // Reset to main action menu when a new boss appears
        if (prev != null &&
            prev.currentBossIndex != next.currentBossIndex) {
          final defeated = prev.bosses[prev.currentBossIndex];
          // Trigger faint animation first
          setState(() => _bossFainting = true);
          _faintController.forward().then((_) {
            if (!mounted) return;
            _faintController.reset();
            setState(() {
              _bossFainting = false;
              _actionMode = _ActionMode.action;
              _showBossDefeated = true;
              _defeatedBossName = defeated.name;
            });
            // Auto-dismiss defeated overlay after 1.5s
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) setState(() => _showBossDefeated = false);
            });
          });
        }
      },
    );

    // BGM phase transitions
    ref.listen<BattleState>(
      battleStateNotifierProvider,
      (prev, next) {
        if (prev?.phase.runtimeType != next.phase.runtimeType) {
          ref.read(battleBgmControllerProvider).onPhaseChanged(next.phase);
        }
      },
    );

    if (!state.isActive) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show trainer intro before battle
    if (_showIntro) {
      return _buildTrainerIntro(state);
    }

    final boss = state.currentBoss;
    final lastDamage =
        state.damageResults.isEmpty ? null : state.damageResults.last;

    // Get moves for current muscle type
    final registry = ref.watch(moveRegistryProvider);
    final moves = registry.value
            ?.getMovesByType(state.playerMuscleType) ??
        <MoveDefinition>[];

    final profile = ref.watch(userProfileProvider).value;

    // Last set for the currently selected move only
    final selectedMoveId = state.selectedMoveId;
    final setsForMove = selectedMoveId == null
        ? <ExerciseSet>[]
        : state.completedSets
            .where((s) => s.moveId == selectedMoveId)
            .toList();
    final prevSetForMove = setsForMove.isEmpty ? null : setsForMove.last;

    // Recommended weight
    final prDetector = const PRDetector();
    final recommendedWeight = prevSetForMove?.weight ??
        (profile != null && selectedMoveId != null
            ? prDetector.getFiveRmForExercise(
                profile,
                selectedMoveId,
                state.playerMuscleType,
              )
            : null);

    // Suggested reps
    final suggestedReps = prevSetForMove?.reps ??
        switch (state.phase) {
          Warmup() => 12,
          MidBossPhase() => 8,
          GymLeaderPhase() => 5,
          _ => 10,
        };

    final phaseLabel = switch (state.phase) {
      Idle() => '',
      Warmup() => 'Minion',
      MidBossPhase() => 'Mid-Boss',
      GymLeaderPhase() => 'Gym Leader',
      BattleResult() => 'Complete',
    };

    final playerLevel = profile?.level ?? 1;

    return Scaffold(
      backgroundColor: IronMonColors.surface,
      body: ScreenShake(
        key: _screenShakeKey,
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // == TOP: Battle Scene (55 %) ==
                  Expanded(
                    flex: 55,
                    child: _BattleScene(
                      key: ValueKey(state.currentBossIndex),
                      boss: boss,
                      phaseLabel: phaseLabel,
                      playerLevel: playerLevel,
                      playerHp: state.playerHp,
                      maxPlayerHp: state.maxPlayerHp,
                      playerPp: state.playerPp,
                      maxPlayerPp: state.maxPlayerPp,
                      completedSets: state.completedSets.length,
                      lastDamage: lastDamage,
                      bossHitFlash: _bossHitFlash,
                      faintAnimation: _bossFainting ? _faintController : null,
                    ),
                  ),

                  // == BOTTOM: Action Panel (45 %) ==
                  Expanded(
                    flex: 45,
                    child: _buildActionPanel(
                      state: state,
                      moves: moves,
                      profile: profile,
                      recommendedWeight: recommendedWeight,
                      suggestedReps: suggestedReps,
                    ),
                  ),
                ],
              ),
            ),

            // Evolution animation overlay
            if (_showEvolution && state.prEvents.isNotEmpty)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: EvolutionAnimation(
                    prResult: state.prEvents.last,
                    onComplete: () => setState(() => _showEvolution = false),
                  ),
                ),
              ),

            // Boss defeated overlay
            if (_showBossDefeated)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'DEFEATED!',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 24,
                            color: IronMonColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _defeatedBossName,
                          style: const TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 12,
                            color: IronMonColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Next: $phaseLabel',
                          style: const TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 10,
                            color: IronMonColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Attack type effect overlay
            if (_showAttackEffect)
              Positioned.fill(
                child: AttackEffect(
                  moveType: _attackMoveType,
                  onComplete: () {
                    if (mounted) setState(() => _showAttackEffect = false);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Trainer Intro Screen (Pokemon Crystal style)
  // ---------------------------------------------------------------------------

  Widget _buildTrainerIntro(BattleState state) {
    final gym = state.gymType;
    final muscle = state.playerMuscleType;
    final bossCount = state.bosses.length;
    final typeColor = IronMonColors.colorForType(muscle);

    // Trainer title
    final trainerTitle = '${gym.displayName} Gym Leader';
    final introText = '$trainerTitle wants to battle!';
    final visibleText = introText.substring(
      0,
      _introTextIndex.clamp(0, introText.length),
    );

    return Scaffold(
      backgroundColor: IronMonColors.surface,
      body: GestureDetector(
        onTap: _dismissIntro,
        behavior: HitTestBehavior.opaque,
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(
            CurvedAnimation(parent: _introController, curve: Curves.easeIn),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // === Battle Scene: Two trainers facing each other ===
                Expanded(
                  flex: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1A2332),
                          typeColor.withValues(alpha: 0.15),
                          IronMonColors.surface,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Ground line
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 60,
                          child: Container(
                            height: 2,
                            color: IronMonColors.outline.withValues(alpha: 0.4),
                          ),
                        ),

                        // Enemy trainer (left side) - slides in from left
                        Positioned(
                          left: 24,
                          bottom: 70,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-2, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _introSlideController,
                              curve: Curves.easeOutBack,
                            )),
                            child: TrainerSprite(
                              typeColor: typeColor,
                              size: 100,
                            ),
                          ),
                        ),

                        // Player trainer (right side) - slides in from right
                        Positioned(
                          right: 24,
                          bottom: 70,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(2, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _introSlideController,
                              curve: Curves.easeOutBack,
                            )),
                            child: PlayerSprite(size: 100),
                          ),
                        ),

                        // Pokeball indicators (enemy team count) - right of enemy trainer
                        Positioned(
                          left: 120,
                          bottom: 65,
                          child: Row(
                            children: List.generate(bossCount, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: IronMonColors.error,
                                    border: Border.all(
                                      color: IronMonColors.onSurface,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: IronMonColors.onSurface,
                                        border: Border.all(
                                          color: IronMonColors.outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        // VS text in center
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              'VS',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 32,
                                color: IronMonColors.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // === Bottom: Text box with typewriter text ===
                Expanded(
                  flex: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: IronMonColors.surfaceVariant,
                      border: Border(
                        top: BorderSide(
                          color: IronMonColors.outline,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Typewriter intro text
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: IronMonColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: IronMonColors.outline,
                                width: 3,
                              ),
                            ),
                            child: Text(
                              visibleText,
                              style: const TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 12,
                                color: IronMonColors.onSurface,
                                height: 1.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Boss lineup preview
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.bosses.asMap().entries.map((e) {
                              final boss = e.value;
                              final stageLabel = switch (e.key) {
                                0 => 'Minion',
                                1 => 'Mid-Boss',
                                _ => 'Leader',
                              };
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: IronMonColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: IronMonColors.outline,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        boss.type.elementName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: IronMonColors.colorForType(
                                            boss.type,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        stageLabel,
                                        style: const TextStyle(
                                          fontFamily: 'PressStart2P',
                                          fontSize: 7,
                                          color: IronMonColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Spacer(),
                          // Tap to continue hint
                          Center(
                            child: Text(
                              _introTextIndex >= introText.length
                                  ? 'Tap to start!'
                                  : '',
                              style: const TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 10,
                                color: IronMonColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Panel (bottom half)
  // ---------------------------------------------------------------------------

  Widget _buildActionPanel({
    required BattleState state,
    required List<MoveDefinition> moves,
    required UserProfile? profile,
    required double? recommendedWeight,
    required int suggestedReps,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: IronMonColors.surfaceVariant,
        border: Border(
          top: BorderSide(color: IronMonColors.outline, width: 4),
        ),
      ),
      child: switch (_actionMode) {
        _ActionMode.action => _buildMainActionMenu(),
        _ActionMode.fight => _buildFightPanel(state, moves),
        _ActionMode.bag => _buildBagPanel(state, profile),
        _ActionMode.setInput => _buildSetInputArea(
            state, moves, profile, recommendedWeight, suggestedReps),
      },
    );
  }

  // -- Main Action Menu (FIGHT / BAG / POKeMON / RUN) -------------------------

  Widget _buildMainActionMenu() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Text prompt (left side)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: IronMonColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: IronMonColors.outline, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What will\nyou do?',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 13,
                      color: IronMonColors.onSurface,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Blinking triangle (GBA style)
                  const _BlinkingTriangle(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 2x2 action grid (right side)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _GbaActionButton(
                          label: 'FIGHT',
                          color: const Color(0xFFE05038),
                          onTap: () => setState(
                              () => _actionMode = _ActionMode.fight),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _GbaActionButton(
                          label: 'BAG',
                          color: const Color(0xFFF0C040),
                          onTap: () => setState(
                              () => _actionMode = _ActionMode.bag),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _GbaActionButton(
                          label: 'POKeMON',
                          color: const Color(0xFF78C850),
                          disabled: true,
                          onTap: () {}, // placeholder
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _GbaActionButton(
                          label: 'RUN',
                          color: const Color(0xFF6890F0),
                          onTap: _showRunDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRunDialog() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: IronMonColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: IronMonColors.outline, width: 2),
        ),
        title: const Text(
          'Run Away?',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 12,
            color: IronMonColors.onSurface,
          ),
        ),
        content: const Text(
          'Got away safely...?',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 9,
            color: IronMonColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Stay',
              style: TextStyle(fontFamily: 'PressStart2P', fontSize: 10),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              context.pop();
            },
            child: const Text(
              'Run!',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 10,
                color: IronMonColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -- FIGHT panel (2x2 move grid) --------------------------------------------

  Widget _buildFightPanel(BattleState state, List<MoveDefinition> moves) {
    if (moves.isEmpty) {
      return Center(
        child: PixelText.label(
          'No moves available',
          color: IronMonColors.onSurfaceVariant,
        ),
      );
    }

    final displayMoves = moves.take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Back row
          Row(
            children: [
              _SmallBackButton(
                onTap: () =>
                    setState(() => _actionMode = _ActionMode.action),
              ),
              const SizedBox(width: 8),
              Text(
                'Choose a move',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 10,
                  color: IronMonColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 2x2 move grid
          Expanded(
            child: Column(
              children: [
                for (var row = 0; row < 2; row++) ...[
                  if (row > 0) const SizedBox(height: 6),
                  Expanded(
                    child: Row(
                      children: [
                        for (var col = 0; col < 2; col++) ...[
                          if (col > 0) const SizedBox(width: 6),
                          Expanded(
                            child: _buildMoveButton(
                              displayMoves, row * 2 + col, state),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveButton(
    List<MoveDefinition> moves,
    int index,
    BattleState state,
  ) {
    if (index >= moves.length) {
      return Container(
        decoration: BoxDecoration(
          color: IronMonColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: IronMonColors.outline, width: 2),
        ),
        child: const Center(
          child: Text(
            '-',
            style: TextStyle(
              color: IronMonColors.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final move = moves[index];
    final typeColor = IronMonColors.colorForType(move.type);
    final isSelected = move.id == state.selectedMoveId;
    final hasEnoughPp = state.playerPp >= move.pp;

    return Material(
      color: hasEnoughPp
          ? typeColor.withValues(alpha: 0.25)
          : IronMonColors.surface.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: hasEnoughPp
            ? () {
                ref
                    .read(battleStateNotifierProvider.notifier)
                    .selectMove(move.id);
                setState(() => _actionMode = _ActionMode.setInput);
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.white : typeColor,
              width: isSelected ? 3 : 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                move.name,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 9,
                  color: hasEnoughPp
                      ? IronMonColors.onSurface
                      : IronMonColors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      move.type.displayName,
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'PP ${move.pp}',
                    style: TextStyle(
                      fontSize: 7,
                      fontFamily: 'PressStart2P',
                      color: hasEnoughPp
                          ? IronMonColors.onSurfaceVariant
                          : IronMonColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -- BAG panel (items) ------------------------------------------------------

  Widget _buildBagPanel(BattleState state, UserProfile? profile) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              _SmallBackButton(
                onTap: () =>
                    setState(() => _actionMode = _ActionMode.action),
              ),
              const SizedBox(width: 8),
              Text(
                'Items',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 10,
                  color: IronMonColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: ItemPanel(
                potionCount: profile?.potionCount ?? 0,
                etherCount: profile?.etherCount ?? 0,
                rareCandyCount: profile?.rareCandyCount ?? 0,
                canUse: state.canUseItem,
                onUseItem: (ItemType type) {
                  ref
                      .read(battleStateNotifierProvider.notifier)
                      .useItem(type);
                  setState(() => _actionMode = _ActionMode.action);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -- Set Input panel --------------------------------------------------------

  Widget _buildSetInputArea(
    BattleState state,
    List<MoveDefinition> moves,
    UserProfile? profile,
    double? recommendedWeight,
    int suggestedReps,
  ) {
    return Column(
      children: [
        // Back + selected move info
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              _SmallBackButton(
                onTap: () =>
                    setState(() => _actionMode = _ActionMode.fight),
              ),
              const SizedBox(width: 8),
              if (state.selectedMoveId != null)
                Expanded(
                  child: Text(
                    moves
                            .where((m) => m.id == state.selectedMoveId)
                            .map((m) => m.name)
                            .firstOrNull ??
                        '',
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 10,
                      color: IronMonColors.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        // Scrollable set input
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SetInputPanel(
              previousWeight: recommendedWeight,
              previousReps: suggestedReps,
              onSubmit: (weight, reps, rpe) {
                final moveId = state.selectedMoveId;
                if (moveId == null) return;

                final move = moves.firstWhere(
                  (m) => m.id == moveId,
                  orElse: () => moves.first,
                );

                // Block if PP insufficient
                if (state.playerPp < move.pp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Not enough PP!'),
                      duration: Duration(seconds: 2),
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
                    .read(battleStateNotifierProvider.notifier)
                    .submitSet(exerciseSet, move, fiveRm);

                // Trigger attack effect + boss hit flash
                setState(() {
                  _setNumber++;
                  _showAttackEffect = true;
                  _attackMoveType = move.type;
                  _bossHitFlash = true;
                });
                // Clear hit flash after brief delay
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) setState(() => _bossHitFlash = false);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Battle Scene (top half - extracted StatelessWidget)
// =============================================================================

class _BattleScene extends StatelessWidget {
  const _BattleScene({
    super.key,
    required this.boss,
    required this.phaseLabel,
    required this.playerLevel,
    required this.playerHp,
    required this.maxPlayerHp,
    required this.playerPp,
    required this.maxPlayerPp,
    required this.completedSets,
    required this.lastDamage,
    this.bossHitFlash = false,
    this.faintAnimation,
  });

  final Boss boss;
  final String phaseLabel;
  final int playerLevel;
  final int playerHp;
  final int maxPlayerHp;
  final int playerPp;
  final int maxPlayerPp;
  final int completedSets;
  final DamageResult? lastDamage;
  final bool bossHitFlash;
  final Animation<double>? faintAnimation;

  int get _bossLevel => (boss.maxHp ~/ 20).clamp(1, 100);

  Widget _buildBossSprite() {
    Widget sprite = AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: bossHitFlash ? 0.3 : 1.0,
      child: BossSprite(boss: boss, size: 90),
    );

    // Faint animation: scale down vertically + slide down
    if (faintAnimation != null) {
      sprite = AnimatedBuilder(
        animation: faintAnimation!,
        builder: (context, child) {
          final t = faintAnimation!.value; // 0 → 1
          return Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..scale(1.0, 1.0 - t) // shrink vertically
              ..translate(0.0, t * 40), // slide down
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: sprite,
      );
    }

    return sprite;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = IronMonColors.colorForType(boss.type);
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A2332), // dark arena ceiling
            Color(0xFF0F1923), // mid
            Color(0xFF162D1E), // greenish ground
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // -- Ground / grass floor -------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1E3A2A).withValues(alpha: 0.4),
                    const Color(0xFF162D1E),
                  ],
                ),
              ),
            ),
          ),

          // -- Enemy grass platform (top-right) -------------------------------
          Positioned(
            top: 100,
            right: 24,
            child: Container(
              width: 110,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3A6A3A).withValues(alpha: 0.5),
                    const Color(0xFF1E3A1E).withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),

          // -- Enemy sprite (top-right, CustomPaint creature) ---------------
          Positioned(
            top: 16,
            right: 20,
            child: _buildBossSprite(),
          ),

          // -- Damage display (over enemy) ------------------------------------
          Positioned(
            top: 24,
            right: 16,
            child: SizedBox(
              height: 50,
              width: 120,
              child: DamageDisplay(damageResult: lastDamage),
            ),
          ),

          // -- Enemy HP name plate (top-left) ---------------------------------
          Positioned(
            top: 12,
            left: 8,
            right: screenW * 0.36,
            child: _GbaNamePlate(
              name: boss.name,
              level: _bossLevel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ThinHpBar(current: boss.currentHp, max: boss.maxHp),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${boss.currentHp} / ${boss.maxHp}',
                      style: const TextStyle(
                        fontSize: 8,
                        fontFamily: 'PressStart2P',
                        color: IronMonColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -- Player grass platform (bottom-left) ----------------------------
          Positioned(
            bottom: 70,
            left: 16,
            child: Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3A6A3A).withValues(alpha: 0.6),
                    const Color(0xFF1E3A1E).withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),
          ),

          // -- Player sprite (bottom-left, back view CustomPaint) -------------
          Positioned(
            bottom: 72,
            left: 24,
            child: PlayerSprite(size: 72),
          ),

          // -- Player name plate (bottom-right) -------------------------------
          Positioned(
            bottom: 4,
            right: 8,
            left: screenW * 0.34,
            child: _GbaNamePlate(
              name: 'TRAINER',
              level: playerLevel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HP bar
                  _ThinHpBar(current: playerHp, max: maxPlayerHp),
                  const SizedBox(height: 1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$playerHp / $maxPlayerHp',
                      style: const TextStyle(
                        fontSize: 8,
                        fontFamily: 'PressStart2P',
                        color: IronMonColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  // PP bar
                  _ThinPpBar(current: playerPp, max: maxPlayerPp),
                  const SizedBox(height: 4),
                  // EXP bar
                  _ExpBar(completedSets: completedSets),
                ],
              ),
            ),
          ),

          // -- Phase label (top center pill) ----------------------------------
          Positioned(
            top: 2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: IronMonColors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: IronMonColors.outline),
                ),
                child: Text(
                  phaseLabel,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 9,
                    color: IronMonColors.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Pokemon GBA-style reusable UI components
// =============================================================================

/// Name plate with thick border, name + "LvXX", and child content.
class _GbaNamePlate extends StatelessWidget {
  const _GbaNamePlate({
    required this.name,
    required this.level,
    required this.child,
  });

  final String name;
  final int level;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: IronMonColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: IronMonColors.outline, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name + Level row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 11,
                    color: IronMonColors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Lv$level',
                style: const TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 10,
                  color: IronMonColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

/// Thin HP bar (8 px) with green "HP" label, like GBA Pokemon.
class _ThinHpBar extends StatelessWidget {
  const _ThinHpBar({required this.current, required this.max});

  final int current;
  final int max;

  @override
  Widget build(BuildContext context) {
    final ratio = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    final color = ratio > 0.5
        ? IronMonColors.hpHigh
        : ratio > 0.25
            ? IronMonColors.hpMid
            : IronMonColors.hpLow;

    return Row(
      children: [
        // "HP" label badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: const Color(0xFF484848),
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Text(
            'HP',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 7,
              color: IronMonColors.hpHigh,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Bar
        Expanded(
          child: SizedBox(
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(color: IronMonColors.hpBarTrack),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Thin PP bar with "PP" label and count text.
class _ThinPpBar extends StatelessWidget {
  const _ThinPpBar({required this.current, required this.max});

  final int current;
  final int max;

  @override
  Widget build(BuildContext context) {
    final ratio = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;

    return Row(
      children: [
        const Text(
          'PP',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 7,
            color: IronMonColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: SizedBox(
            height: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(color: IronMonColors.hpBarTrack),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: IronMonColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$current/$max',
          style: const TextStyle(
            fontSize: 7,
            fontFamily: 'PressStart2P',
            color: IronMonColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Small EXP-like bar at the bottom of the player name plate.
class _ExpBar extends StatelessWidget {
  const _ExpBar({required this.completedSets});

  final int completedSets;

  @override
  Widget build(BuildContext context) {
    // Cycles every 8 sets to give a filling-up visual.
    final ratio = (completedSets % 8) / 8.0;

    return Row(
      children: [
        const Text(
          'EXP',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 6,
            color: IronMonColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: SizedBox(
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Container(color: IronMonColors.hpBarTrack),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: IronMonColors.expBar,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// GBA-style action button with solid fill and thick border.
class _GbaActionButton extends StatelessWidget {
  const _GbaActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.disabled = false,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final bg =
        disabled ? color.withValues(alpha: 0.12) : color.withValues(alpha: 0.22);
    final fg = disabled ? color.withValues(alpha: 0.35) : color;
    final borderClr =
        disabled ? color.withValues(alpha: 0.25) : color;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderClr, width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 10,
                color: fg,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small arrow-back button used in sub-panels (FIGHT, BAG, SetInput).
class _SmallBackButton extends StatelessWidget {
  const _SmallBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: IronMonColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: IronMonColors.outline, width: 2),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 16,
          color: IronMonColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Blinking triangle indicator in the text box (GBA "press A" prompt).
class _BlinkingTriangle extends StatefulWidget {
  const _BlinkingTriangle();

  @override
  State<_BlinkingTriangle> createState() => _BlinkingTriangleState();
}

class _BlinkingTriangleState extends State<_BlinkingTriangle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.arrow_drop_down,
          size: 18,
          color: IronMonColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
