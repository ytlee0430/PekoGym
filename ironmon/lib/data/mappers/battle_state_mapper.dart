import 'dart:convert';

import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/domain/battle/models/battle_outcome.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Maps between BattleState domain model and
/// Drift entity JSON fields.
class BattleStateMapper {
  /// Serializes [BattlePhase] to JSON string.
  static String serializePhase(BattlePhase phase) {
    final map = switch (phase) {
      Idle() => {'type': 'idle'},
      Warmup() => {'type': 'warmup'},
      MidBossPhase() => {'type': 'midBoss'},
      GymLeaderPhase() => {'type': 'gymLeader'},
      BattleResult(outcome: final o) => {
          'type': 'result',
          'isVictory': o.isVictory,
          'totalDamageDealt': o.totalDamageDealt,
          'totalSets': o.totalSets,
          'totalVolume': o.totalVolume,
        },
    };
    return jsonEncode(map);
  }

  /// Deserializes JSON string to [BattlePhase].
  static BattlePhase deserializePhase(String json) {
    final map =
        jsonDecode(json) as Map<String, dynamic>;
    return switch (map['type'] as String) {
      'idle' => const Idle(),
      'warmup' => const Warmup(),
      'midBoss' => const MidBossPhase(),
      'gymLeader' => const GymLeaderPhase(),
      'result' => BattleResult(
          outcome: BattleOutcome(
            isVictory: map['isVictory'] as bool,
            totalDamageDealt:
                map['totalDamageDealt'] as int,
            totalSets: map['totalSets'] as int,
            totalVolume:
                (map['totalVolume'] as num)
                    .toDouble(),
          ),
        ),
      _ => const Idle(),
    };
  }

  /// Serializes boss list to JSON string.
  static String serializeBosses(List<Boss> bosses) {
    return jsonEncode(
      bosses
          .map((b) => {
                'name': b.name,
                'type': b.type.name,
                'maxHp': b.maxHp,
                'currentHp': b.currentHp,
                'defense': b.defense,
                'stage': b.stage.name,
              })
          .toList(),
    );
  }

  /// Deserializes JSON string to boss list.
  static List<Boss> deserializeBosses(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map(
          (e) => Boss(
            name: (e as Map<String, dynamic>)['name']
                as String,
            type: MuscleType.values.byName(
              e['type'] as String,
            ),
            maxHp: e['maxHp'] as int,
            currentHp: e['currentHp'] as int,
            defense: e['defense'] as int,
            stage: BossStage.values.byName(
              e['stage'] as String,
            ),
          ),
        )
        .toList();
  }

  /// Serializes exercise set list to JSON.
  static String serializeSets(
    List<ExerciseSet> sets,
  ) {
    return jsonEncode(
      sets
          .map((s) => {
                'moveId': s.moveId,
                'weight': s.weight,
                'reps': s.reps,
                'rpe': s.rpe,
                'setNumber': s.setNumber,
              })
          .toList(),
    );
  }

  /// Deserializes JSON to exercise set list.
  static List<ExerciseSet> deserializeSets(
    String json,
  ) {
    final list = jsonDecode(json) as List;
    return list
        .map(
          (e) => ExerciseSet(
            moveId:
                (e as Map<String, dynamic>)['moveId']
                    as String,
            weight:
                (e['weight'] as num).toDouble(),
            reps: e['reps'] as int,
            rpe: e['rpe'] as int,
            setNumber: e['setNumber'] as int,
          ),
        )
        .toList();
  }

  /// Serializes damage result list to JSON.
  static String serializeDamageResults(
    List<DamageResult> results,
  ) {
    return jsonEncode(
      results
          .map((r) => {
                'rawDamage': r.rawDamage,
                'finalDamage': r.finalDamage,
                'typeMultiplier': r.typeMultiplier,
                'rpeMultiplier': r.rpeMultiplier,
                'intensity': r.intensity,
                'isEffective': r.isEffective,
                'effectiveness':
                    r.effectiveness.name,
              })
          .toList(),
    );
  }

  /// Deserializes JSON to damage result list.
  static List<DamageResult> deserializeDamageResults(
    String json,
  ) {
    final list = jsonDecode(json) as List;
    return list
        .map(
          (e) => DamageResult(
            rawDamage:
                ((e as Map<String, dynamic>)['rawDamage']
                        as num)
                    .toDouble(),
            finalDamage: e['finalDamage'] as int,
            typeMultiplier:
                (e['typeMultiplier'] as num)
                    .toDouble(),
            rpeMultiplier:
                (e['rpeMultiplier'] as num)
                    .toDouble(),
            intensity: (e['intensity'] as num)
                .toDouble(),
            isEffective: e['isEffective'] as bool,
            effectiveness:
                Effectiveness.values.byName(
              e['effectiveness'] as String,
            ),
          ),
        )
        .toList();
  }

  /// Converts domain [BattleState] to a map for
  /// Drift insertion.
  static Map<String, dynamic> toInsertableMap(
    BattleState state,
  ) {
    return {
      'phaseJson': serializePhase(state.phase),
      'bossesJson': serializeBosses(state.bosses),
      'currentBossIndex': state.currentBossIndex,
      'playerHp': state.playerHp,
      'maxPlayerHp': state.maxPlayerHp,
      'completedSetsJson':
          serializeSets(state.completedSets),
      'damageResultsJson':
          serializeDamageResults(
        state.damageResults,
      ),
      'selectedMoveId': state.selectedMoveId,
      'gymTypeValue': state.gymType.name,
      'playerMuscleTypeValue':
          state.playerMuscleType.name,
      'totalDamageDealt': state.totalDamageDealt,
    };
  }

  /// Converts a Drift entity map to domain
  /// [BattleState].
  static BattleState fromEntityMap(
    Map<String, dynamic> map,
  ) {
    return BattleState(
      phase: deserializePhase(
        map['phaseJson'] as String,
      ),
      bosses: deserializeBosses(
        map['bossesJson'] as String,
      ),
      currentBossIndex:
          map['currentBossIndex'] as int,
      playerHp: map['playerHp'] as int,
      maxPlayerHp: map['maxPlayerHp'] as int,
      completedSets: deserializeSets(
        map['completedSetsJson'] as String,
      ),
      damageResults: deserializeDamageResults(
        map['damageResultsJson'] as String,
      ),
      selectedMoveId:
          map['selectedMoveId'] as String?,
      gymType: GymType.values.byName(
        map['gymTypeValue'] as String,
      ),
      playerMuscleType: MuscleType.values.byName(
        map['playerMuscleTypeValue'] as String,
      ),
      totalDamageDealt:
          map['totalDamageDealt'] as int,
    );
  }
}
