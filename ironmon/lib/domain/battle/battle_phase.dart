import 'package:ironmon/domain/battle/models/battle_outcome.dart';

/// Battle phases as a sealed class hierarchy.
/// Exhaustive pattern matching required — no default.
/// Pure Dart — zero Flutter dependency.
sealed class BattlePhase {
  /// Creates a [BattlePhase].
  const BattlePhase();
}

/// Battle not started.
final class Idle extends BattlePhase {
  /// Creates an [Idle] phase.
  const Idle();
}

/// Fighting the Minion (stage 1).
final class Warmup extends BattlePhase {
  /// Creates a [Warmup] phase.
  const Warmup();
}

/// Fighting the Mid-Boss (stage 2).
final class MidBossPhase extends BattlePhase {
  /// Creates a [MidBossPhase].
  const MidBossPhase();
}

/// Fighting the Gym Leader (stage 3).
final class GymLeaderPhase extends BattlePhase {
  /// Creates a [GymLeaderPhase].
  const GymLeaderPhase();
}

/// Battle concluded with outcome.
final class BattleResult extends BattlePhase {
  /// Creates a [BattleResult] phase.
  const BattleResult({required this.outcome});

  /// The battle outcome.
  final BattleOutcome outcome;
}
