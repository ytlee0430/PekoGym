import 'dart:math';

import 'package:ironmon/domain/training/models/user_profile.dart';

/// Immutable result of a level-up check.
class LevelUpResult {
  /// Creates a [LevelUpResult].
  const LevelUpResult({
    required this.previousLevel,
    required this.newLevel,
    required this.remainingExp,
    required this.levelsGained,
    required this.hpIncrease,
  });

  /// Level before EXP was applied.
  final int previousLevel;

  /// Level after EXP was applied.
  final int newLevel;

  /// Total EXP after level-up processing.
  final int remainingExp;

  /// Number of levels gained.
  final int levelsGained;

  /// Total HP increase from leveling.
  final int hpIncrease;

  /// Whether any levels were gained.
  bool get didLevelUp => levelsGained > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelUpResult &&
        other.previousLevel == previousLevel &&
        other.newLevel == newLevel &&
        other.remainingExp == remainingExp &&
        other.levelsGained == levelsGained &&
        other.hpIncrease == hpIncrease;
  }

  @override
  int get hashCode => Object.hash(
        previousLevel,
        newLevel,
        remainingExp,
        levelsGained,
        hpIncrease,
      );

  @override
  String toString() =>
      'LevelUpResult(Lv.$previousLevel → '
      'Lv.$newLevel, +$hpIncrease HP, '
      'exp: $remainingExp)';
}

/// Calculates level progression from EXP.
/// Pure Dart — zero Flutter dependency.
class LevelSystem {
  /// Creates a [LevelSystem].
  const LevelSystem();

  /// Returns total EXP needed to reach [level].
  ///
  /// Level 1: 0, Level 2: 150, Level 3: 350,
  /// Level 4: 600, etc.
  int expForLevel(int level) {
    if (level <= 1) return 0;
    return level * 100 + (level - 1) * 50;
  }

  /// Returns EXP needed from current level to
  /// the next level.
  int expToNextLevel(int currentLevel) {
    return expForLevel(currentLevel + 1) -
        expForLevel(currentLevel);
  }

  /// Returns EXP progress within current level.
  /// (total EXP - EXP threshold of current level)
  int expInCurrentLevel(
    int totalExp,
    int currentLevel,
  ) {
    return max(0, totalExp - expForLevel(currentLevel));
  }

  /// Checks if the player should level up after
  /// earning [earnedExp].
  /// Supports multi-level ups.
  LevelUpResult checkLevelUp(
    UserProfile profile,
    int earnedExp,
  ) {
    var totalExp =
        profile.experiencePoints + earnedExp;
    var level = profile.level;
    var levelsGained = 0;

    while (totalExp >= expForLevel(level + 1)) {
      level++;
      levelsGained++;
    }

    return LevelUpResult(
      previousLevel: profile.level,
      newLevel: level,
      remainingExp: totalExp,
      levelsGained: levelsGained,
      hpIncrease: levelsGained * 5,
    );
  }
}
