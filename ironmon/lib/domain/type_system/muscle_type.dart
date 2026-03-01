/// Represents the 5 muscle group types in the battle system.
/// Each maps to a Pokémon-style elemental type.
/// Pure Dart — zero Flutter dependency.
enum MuscleType {
  /// Chest — mapped to Fire element.
  chest,

  /// Back — mapped to Water element.
  back,

  /// Legs — mapped to Rock element.
  legs,

  /// Shoulders — mapped to Electric element.
  shoulders,

  /// Arms — mapped to Fighting element.
  arms;

  /// Human-readable display name.
  String get displayName {
    switch (this) {
      case MuscleType.chest:
        return 'Chest';
      case MuscleType.back:
        return 'Back';
      case MuscleType.legs:
        return 'Legs';
      case MuscleType.shoulders:
        return 'Shoulders';
      case MuscleType.arms:
        return 'Arms';
    }
  }

  /// Elemental type name.
  String get elementName {
    switch (this) {
      case MuscleType.chest:
        return 'Fire';
      case MuscleType.back:
        return 'Water';
      case MuscleType.legs:
        return 'Rock';
      case MuscleType.shoulders:
        return 'Electric';
      case MuscleType.arms:
        return 'Fighting';
    }
  }
}
