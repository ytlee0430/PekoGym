/// Outcome of a completed battle.
/// Pure Dart — zero Flutter dependency.
class BattleOutcome {
  static bool _listEquals(
    List<String> a,
    List<String> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Creates a [BattleOutcome].
  const BattleOutcome({
    required this.isVictory,
    required this.totalDamageDealt,
    required this.totalSets,
    required this.totalVolume,
    this.expModifier = 1.0,
    this.exhaustionEvents = 0,
    this.counterEvents = 0,
    this.earnedExp = 0,
    this.levelsGained = 0,
    this.newLevel = 0,
    this.unlockedMoveNames = const [],
    this.awardedItems = const [],
    this.coinsEarned = 0,
  });

  /// Creates a victory outcome.
  const BattleOutcome.victory({
    required this.totalDamageDealt,
    required this.totalSets,
    required this.totalVolume,
    this.exhaustionEvents = 0,
    this.counterEvents = 0,
    this.earnedExp = 0,
    this.levelsGained = 0,
    this.newLevel = 0,
    this.unlockedMoveNames = const [],
    this.awardedItems = const [],
    this.coinsEarned = 0,
  })  : isVictory = true,
        expModifier = 1.0;

  /// Creates a defeat outcome.
  const BattleOutcome.defeat({
    required this.totalDamageDealt,
    required this.totalSets,
    required this.totalVolume,
    this.exhaustionEvents = 0,
    this.counterEvents = 0,
    this.earnedExp = 0,
    this.levelsGained = 0,
    this.newLevel = 0,
    this.unlockedMoveNames = const [],
    this.awardedItems = const [],
    this.coinsEarned = 0,
  })  : isVictory = false,
        expModifier = 0.6;

  /// Whether the player won.
  final bool isVictory;

  /// Total damage dealt during the battle.
  final int totalDamageDealt;

  /// Total number of sets completed.
  final int totalSets;

  /// Total volume (weight × reps) lifted.
  final double totalVolume;

  /// EXP modifier (1.0 for victory, 0.6 for defeat).
  final double expModifier;

  /// Number of exhaustion (Miss) events.
  final int exhaustionEvents;

  /// Number of counter events.
  final int counterEvents;

  /// EXP earned from this battle.
  final int earnedExp;

  /// Number of levels gained (0 if none).
  final int levelsGained;

  /// New player level after level-up (0 if none).
  final int newLevel;

  /// Names of newly unlocked moves.
  final List<String> unlockedMoveNames;

  /// Item IDs awarded at battle end.
  final List<String> awardedItems;

  /// Coins earned at battle end.
  final int coinsEarned;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BattleOutcome &&
        other.isVictory == isVictory &&
        other.totalDamageDealt ==
            totalDamageDealt &&
        other.totalSets == totalSets &&
        other.totalVolume == totalVolume &&
        other.expModifier == expModifier &&
        other.exhaustionEvents ==
            exhaustionEvents &&
        other.counterEvents == counterEvents &&
        other.earnedExp == earnedExp &&
        other.levelsGained == levelsGained &&
        other.newLevel == newLevel &&
        _listEquals(
          other.unlockedMoveNames,
          unlockedMoveNames,
        ) &&
        _listEquals(
          other.awardedItems,
          awardedItems,
        ) &&
        other.coinsEarned == coinsEarned;
  }

  @override
  int get hashCode => Object.hash(
        isVictory,
        totalDamageDealt,
        totalSets,
        totalVolume,
        expModifier,
        exhaustionEvents,
        counterEvents,
        earnedExp,
        levelsGained,
        newLevel,
        Object.hashAll(unlockedMoveNames),
        Object.hashAll(awardedItems),
        coinsEarned,
      );

  @override
  String toString() =>
      'BattleOutcome('
      '${isVictory ? "victory" : "defeat"}, '
      'damage: $totalDamageDealt, '
      'sets: $totalSets, '
      'volume: $totalVolume, '
      'exp: ${expModifier}x, '
      'unlocks: $unlockedMoveNames)';
}
