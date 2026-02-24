import 'package:drift/drift.dart';

/// UserProfile Drift table — singleton pattern (only one row, id == 1).
/// Stores player's character state, 5RM values, and preferences.
@DataClassName('UserProfileEntity')
class UserProfiles extends Table {
  /// Auto-incremented primary key (always 1 for singleton profile).
  IntColumn get id => integer().autoIncrement()();

  // --- Character Stats ---

  /// Current player level (starts at 1).
  IntColumn get level => integer().withDefault(const Constant(1))();

  /// Accumulated experience points.
  IntColumn get experiencePoints =>
      integer().withDefault(const Constant(0))();

  // --- 5RM Values (kg) ---

  /// Squat 5-rep max in kilograms.
  RealColumn get squatFiveRm =>
      real().withDefault(const Constant(0))();

  /// Bench press 5-rep max in kilograms.
  RealColumn get benchPressFiveRm =>
      real().withDefault(const Constant(0))();

  /// Deadlift 5-rep max in kilograms.
  RealColumn get deadliftFiveRm =>
      real().withDefault(const Constant(0))();

  /// Overhead press 5-rep max in kilograms.
  RealColumn get overheadPressFiveRm =>
      real().withDefault(const Constant(0))();

  // --- Training Preferences ---

  /// Weekly training frequency in days (1–7).
  IntColumn get weeklyFrequency =>
      integer().withDefault(const Constant(3))();

  /// Whether the player is in beginner auto-calibration mode.
  BoolColumn get isBeginnerMode =>
      boolean().withDefault(const Constant(false))();

  // --- Move Progression ---

  /// JSON-encoded list of unlocked move IDs (e.g. '["push_up"]').
  TextColumn get unlockedMoveIds =>
      text().withDefault(const Constant('[]'))();
}
