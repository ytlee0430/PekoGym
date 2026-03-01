import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';

/// Generates a 3-stage boss lineup for a battle.
/// Pure Dart — zero Flutter dependency.
class BossGenerator {
  /// Creates a [BossGenerator] with the given
  /// [TypeEffectiveness] matrix.
  const BossGenerator(this._typeEffectiveness);

  final TypeEffectiveness _typeEffectiveness;

  /// Generates a 3-boss lineup: Minion → Mid-Boss →
  /// Gym Leader.
  ///
  /// Boss types are chosen strategically:
  /// - Minion: same type (neutral warmup)
  /// - Mid-Boss: random non-resistant type
  /// - Gym Leader: type that resists player's type
  List<Boss> generateLineup({
    required MuscleType playerMuscle,
    required GymType gymType,
    required int playerLevel,
  }) {
    final resistantType =
        _findResistantType(playerMuscle);
    final neutralType =
        _findNeutralType(playerMuscle, resistantType);

    return [
      _createBoss(
        stage: BossStage.minion,
        type: playerMuscle,
        gymType: gymType,
        playerLevel: playerLevel,
      ),
      _createBoss(
        stage: BossStage.midBoss,
        type: neutralType,
        gymType: gymType,
        playerLevel: playerLevel,
      ),
      _createBoss(
        stage: BossStage.gymLeader,
        type: resistantType,
        gymType: gymType,
        playerLevel: playerLevel,
      ),
    ];
  }

  Boss _createBoss({
    required BossStage stage,
    required MuscleType type,
    required GymType gymType,
    required int playerLevel,
  }) {
    final baseHp = 100 + (playerLevel * 20);
    final baseDefense = 10 + (playerLevel * 2);
    final sm = stage.stageMultiplier;

    final hp = (baseHp *
            sm *
            gymType.hpMultiplier)
        .round();
    final defense = (baseDefense *
            sm *
            gymType.defenseMultiplier)
        .round();

    return Boss(
      name: _bossName(type, stage),
      type: type,
      maxHp: hp,
      currentHp: hp,
      defense: defense,
      stage: stage,
    );
  }

  /// Finds the type that resists [playerType]
  /// (i.e., where player deals 0.5x damage).
  MuscleType _findResistantType(
    MuscleType playerType,
  ) {
    for (final defender in MuscleType.values) {
      final m = _typeEffectiveness.getMultiplier(
        playerType,
        defender,
      );
      if (m == TypeEffectiveness.notEffective) {
        return defender;
      }
    }
    // Fallback: if no resistant type (e.g., Arms),
    // use a different type.
    return MuscleType.values.firstWhere(
      (t) => t != playerType,
    );
  }

  /// Finds a neutral type that is neither the
  /// player's type nor the resistant type.
  MuscleType _findNeutralType(
    MuscleType playerType,
    MuscleType resistantType,
  ) {
    for (final t in MuscleType.values) {
      if (t != playerType && t != resistantType) {
        final m = _typeEffectiveness.getMultiplier(
          playerType,
          t,
        );
        if (m == TypeEffectiveness.neutral) {
          return t;
        }
      }
    }
    // Fallback: any type different from player
    // and resistant.
    return MuscleType.values.firstWhere(
      (t) => t != playerType && t != resistantType,
    );
  }

  String _bossName(MuscleType type, BossStage stage) {
    final prefix = switch (stage) {
      BossStage.minion => 'Wild',
      BossStage.midBoss => 'Elite',
      BossStage.gymLeader => 'Leader',
    };
    return '$prefix ${type.displayName}';
  }
}
