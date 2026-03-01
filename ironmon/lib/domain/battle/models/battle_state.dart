import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/training/pr_detector.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Immutable state of a battle in progress.
/// Pure Dart — zero Flutter dependency.
class BattleState {
  /// Creates a [BattleState].
  const BattleState({
    required this.phase,
    required this.bosses,
    required this.currentBossIndex,
    required this.playerHp,
    required this.maxPlayerHp,
    required this.gymType,
    required this.playerMuscleType,
    this.completedSets = const [],
    this.damageResults = const [],
    this.selectedMoveId,
    this.totalDamageDealt = 0,
    this.exhaustionEvents = 0,
    this.counterEvents = 0,
    this.prEvents = const [],
    this.playerPp = 0,
    this.maxPlayerPp = 0,
    this.restTimerPaused = false,
    this.itemsUsed = const [],
  });

  /// Creates an initial idle state.
  const BattleState.initial()
      : phase = const Idle(),
        bosses = const [],
        currentBossIndex = 0,
        playerHp = 0,
        maxPlayerHp = 0,
        completedSets = const [],
        damageResults = const [],
        selectedMoveId = null,
        gymType = GymType.physique,
        playerMuscleType = MuscleType.chest,
        totalDamageDealt = 0,
        exhaustionEvents = 0,
        counterEvents = 0,
        prEvents = const [],
        playerPp = 0,
        maxPlayerPp = 0,
        restTimerPaused = false,
        itemsUsed = const [];

  /// Current battle phase.
  final BattlePhase phase;

  /// Boss lineup (3 bosses).
  final List<Boss> bosses;

  /// Index of the current boss (0-2).
  final int currentBossIndex;

  /// Current player HP.
  final int playerHp;

  /// Maximum player HP.
  final int maxPlayerHp;

  /// All completed exercise sets.
  final List<ExerciseSet> completedSets;

  /// Damage results for each set.
  final List<DamageResult> damageResults;

  /// Currently selected move ID.
  final String? selectedMoveId;

  /// Gym type for this battle.
  final GymType gymType;

  /// Player's chosen muscle type.
  final MuscleType playerMuscleType;

  /// Accumulated damage dealt.
  final int totalDamageDealt;

  /// Number of exhaustion (Miss) events.
  final int exhaustionEvents;

  /// Number of counter events.
  final int counterEvents;

  /// PR events detected during this battle.
  final List<PRResult> prEvents;

  /// Current player PP (stamina).
  final int playerPp;

  /// Maximum player PP (stamina).
  final int maxPlayerPp;

  /// Whether the rest timer is paused (Potion effect).
  final bool restTimerPaused;

  /// Item IDs used during this battle.
  final List<String> itemsUsed;

  /// Gets the current boss.
  Boss get currentBoss => bosses[currentBossIndex];

  /// Whether items can be used (between sets).
  bool get canUseItem => isActive;

  /// Whether the battle is active (not idle or
  /// result).
  bool get isActive {
    return switch (phase) {
      Idle() => false,
      BattleResult() => false,
      Warmup() => true,
      MidBossPhase() => true,
      GymLeaderPhase() => true,
    };
  }

  /// Returns a copy with updated fields.
  BattleState copyWith({
    BattlePhase? phase,
    List<Boss>? bosses,
    int? currentBossIndex,
    int? playerHp,
    int? maxPlayerHp,
    List<ExerciseSet>? completedSets,
    List<DamageResult>? damageResults,
    String? selectedMoveId,
    GymType? gymType,
    MuscleType? playerMuscleType,
    int? totalDamageDealt,
    int? exhaustionEvents,
    int? counterEvents,
    List<PRResult>? prEvents,
    int? playerPp,
    int? maxPlayerPp,
    bool? restTimerPaused,
    List<String>? itemsUsed,
  }) {
    return BattleState(
      phase: phase ?? this.phase,
      bosses: bosses ?? this.bosses,
      currentBossIndex:
          currentBossIndex ?? this.currentBossIndex,
      playerHp: playerHp ?? this.playerHp,
      maxPlayerHp:
          maxPlayerHp ?? this.maxPlayerHp,
      completedSets:
          completedSets ?? this.completedSets,
      damageResults:
          damageResults ?? this.damageResults,
      selectedMoveId:
          selectedMoveId ?? this.selectedMoveId,
      gymType: gymType ?? this.gymType,
      playerMuscleType:
          playerMuscleType ?? this.playerMuscleType,
      totalDamageDealt:
          totalDamageDealt ?? this.totalDamageDealt,
      exhaustionEvents:
          exhaustionEvents ?? this.exhaustionEvents,
      counterEvents:
          counterEvents ?? this.counterEvents,
      prEvents: prEvents ?? this.prEvents,
      playerPp: playerPp ?? this.playerPp,
      maxPlayerPp:
          maxPlayerPp ?? this.maxPlayerPp,
      restTimerPaused:
          restTimerPaused ?? this.restTimerPaused,
      itemsUsed: itemsUsed ?? this.itemsUsed,
    );
  }
}
