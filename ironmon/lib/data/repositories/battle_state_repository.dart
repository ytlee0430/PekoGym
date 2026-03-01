import 'package:drift/drift.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/mappers/battle_state_mapper.dart';
import 'package:ironmon/domain/battle/models/battle_state.dart';

/// Repository for persisting and loading battle
/// state from Drift.
class BattleStateRepository {
  /// Creates a [BattleStateRepository].
  const BattleStateRepository(this._db);

  final AppDatabase _db;

  /// Saves the current battle state (upsert).
  /// Uses a fixed ID=1 row for single active battle.
  Future<void> saveBattleState(
    BattleState state,
  ) async {
    final map =
        BattleStateMapper.toInsertableMap(state);
    await _db.transaction(() async {
      // Delete any existing row then insert
      await _db.delete(_db.battleStates).go();
      await _db.into(_db.battleStates).insert(
            BattleStatesCompanion.insert(
              phaseJson:
                  map['phaseJson'] as String,
              bossesJson:
                  map['bossesJson'] as String,
              gymTypeValue:
                  map['gymTypeValue'] as String,
              playerMuscleTypeValue:
                  map['playerMuscleTypeValue']
                      as String,
              currentBossIndex: Value(
                map['currentBossIndex'] as int,
              ),
              playerHp: Value(
                map['playerHp'] as int,
              ),
              maxPlayerHp: Value(
                map['maxPlayerHp'] as int,
              ),
              completedSetsJson: Value(
                map['completedSetsJson']
                    as String,
              ),
              damageResultsJson: Value(
                map['damageResultsJson']
                    as String,
              ),
              selectedMoveId: Value(
                map['selectedMoveId'] as String?,
              ),
              totalDamageDealt: Value(
                map['totalDamageDealt'] as int,
              ),
            ),
          );
    });
  }

  /// Loads the active battle state, or null if
  /// none exists.
  Future<BattleState?> loadActiveBattle() async {
    final rows = await _db.select(
      _db.battleStates,
    ).get();
    if (rows.isEmpty) return null;

    final entity = rows.first;
    return BattleStateMapper.fromEntityMap({
      'phaseJson': entity.phaseJson,
      'bossesJson': entity.bossesJson,
      'currentBossIndex': entity.currentBossIndex,
      'playerHp': entity.playerHp,
      'maxPlayerHp': entity.maxPlayerHp,
      'completedSetsJson':
          entity.completedSetsJson,
      'damageResultsJson':
          entity.damageResultsJson,
      'selectedMoveId': entity.selectedMoveId,
      'gymTypeValue': entity.gymTypeValue,
      'playerMuscleTypeValue':
          entity.playerMuscleTypeValue,
      'totalDamageDealt': entity.totalDamageDealt,
    });
  }

  /// Clears any saved battle state.
  Future<void> clearBattleState() async {
    await _db.delete(_db.battleStates).go();
  }
}
