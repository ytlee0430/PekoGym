/// Type of gym that determines boss stat distribution.
/// Pure Dart — zero Flutter dependency.
enum GymType {
  /// High defense, low HP — rewards heavy singles.
  strength,

  /// Low defense, high HP — rewards volume.
  physique;

  /// Human-readable display name.
  String get displayName {
    switch (this) {
      case GymType.strength:
        return 'Strength';
      case GymType.physique:
        return 'Physique';
    }
  }

  /// Description for UI display.
  String get description {
    switch (this) {
      case GymType.strength:
        return 'High defense, low HP';
      case GymType.physique:
        return 'Low defense, high HP';
    }
  }

  /// HP multiplier applied to base HP.
  double get hpMultiplier {
    switch (this) {
      case GymType.strength:
        return 0.5;
      case GymType.physique:
        return 2.0;
    }
  }

  /// Defense multiplier applied to base defense.
  double get defenseMultiplier {
    switch (this) {
      case GymType.strength:
        return 2.0;
      case GymType.physique:
        return 0.5;
    }
  }
}
