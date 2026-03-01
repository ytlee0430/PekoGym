import 'package:drift/drift.dart';

/// UserProfile Drift table — singleton pattern (only one row, id == 1).
/// Stores player's character state, 5RM values, and preferences.
@DataClassName('UserProfileEntity')
class UserProfiles extends Table {
  /// Singleton primary key. [primaryKey] getter declares this as the
  /// table-level PK; customConstraint enforces the singleton CHECK (id = 1).
  IntColumn get id => integer()
      .withDefault(const Constant(1))
      .customConstraint('NOT NULL CHECK (id = 1)')();

  @override
  Set<Column> get primaryKey => {id};

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

  // --- Calibration Progress (Story 1.3) ---

  /// Number of sessions completed during beginner calibration.
  IntColumn get calibrationSessionsCompleted =>
      integer().withDefault(const Constant(0))();

  /// Target number of calibration sessions (default 5).
  IntColumn get calibrationTargetSessions =>
      integer().withDefault(const Constant(5))();

  // --- Move Progression ---

  /// JSON-encoded list of unlocked move IDs (e.g. '["push_up"]').
  TextColumn get unlockedMoveIds =>
      text().withDefault(const Constant('[]'))();

  // --- PP (Stamina) System (Story 6.1) ---

  /// Maximum PP (stamina). Derived: 100 + level * 10.
  IntColumn get maxPp =>
      integer().withDefault(const Constant(110))();

  /// Current PP (stamina). Deducted when moves are used.
  IntColumn get currentPp =>
      integer().withDefault(const Constant(110))();

  // --- Inventory (Story 6.2) ---

  /// Number of Potions held.
  IntColumn get potionCount =>
      integer().withDefault(const Constant(0))();

  /// Number of Ethers held.
  IntColumn get etherCount =>
      integer().withDefault(const Constant(0))();

  /// Number of Rare Candies held.
  IntColumn get rareCandyCount =>
      integer().withDefault(const Constant(0))();

  /// In-game currency balance.
  IntColumn get coins =>
      integer().withDefault(const Constant(0))();
}
