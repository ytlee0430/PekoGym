import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Stage of a boss in the 3-stage battle lineup.
enum BossStage {
  /// First enemy — weakest.
  minion,

  /// Second enemy — moderate.
  midBoss,

  /// Final enemy — strongest.
  gymLeader;

  /// Stage multiplier for stat scaling.
  double get stageMultiplier {
    switch (this) {
      case BossStage.minion:
        return 0.5;
      case BossStage.midBoss:
        return 0.8;
      case BossStage.gymLeader:
        return 1.0;
    }
  }
}

/// Immutable domain model for a battle boss.
/// Pure Dart — zero Flutter dependency.
class Boss {
  /// Creates a [Boss].
  const Boss({
    required this.name,
    required this.type,
    required this.maxHp,
    required this.currentHp,
    required this.defense,
    required this.stage,
  });

  /// Boss display name.
  final String name;

  /// Boss muscle/element type.
  final MuscleType type;

  /// Maximum hit points.
  final int maxHp;

  /// Current hit points.
  final int currentHp;

  /// Defense value (damage threshold for strength gym).
  final int defense;

  /// Boss stage in the battle lineup.
  final BossStage stage;

  /// Returns a copy with updated fields.
  Boss copyWith({
    String? name,
    MuscleType? type,
    int? maxHp,
    int? currentHp,
    int? defense,
    BossStage? stage,
  }) {
    return Boss(
      name: name ?? this.name,
      type: type ?? this.type,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      defense: defense ?? this.defense,
      stage: stage ?? this.stage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Boss &&
        other.name == name &&
        other.type == type &&
        other.maxHp == maxHp &&
        other.currentHp == currentHp &&
        other.defense == defense &&
        other.stage == stage;
  }

  @override
  int get hashCode => Object.hash(
        name,
        type,
        maxHp,
        currentHp,
        defense,
        stage,
      );

  @override
  String toString() =>
      'Boss(name: $name, type: ${type.name}, '
      'hp: $currentHp/$maxHp, def: $defense, '
      'stage: ${stage.name})';
}
