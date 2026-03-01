import 'package:drift/drift.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/data/mappers/exercise_set_mapper.dart';
import 'package:ironmon/data/mappers/workout_session_mapper.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/domain/training/models/exercise_set.dart';
import 'package:ironmon/domain/training/models/workout_session.dart';

/// Repository for workout session history
/// persistence via Drift.
class WorkoutSessionRepository {
  /// Creates a [WorkoutSessionRepository].
  const WorkoutSessionRepository(this._db);

  final AppDatabase _db;

  /// Saves a workout session with its sets
  /// atomically using a transaction (NFR8).
  Future<Result<WorkoutSession, Exception>>
      saveSession(
    WorkoutSession session,
    List<ExerciseSet> sets, {
    List<int> damages = const [],
  }) async {
    try {
      return await _db.transaction(() async {
        final sessionId = await _db
            .into(_db.workoutSessions)
            .insert(
              WorkoutSessionMapper.toInsertable(
                session,
              ),
            );

        for (var i = 0; i < sets.length; i++) {
          final damage = i < damages.length
              ? damages[i]
              : 0;
          await _db
              .into(_db.exerciseSets)
              .insert(
                ExerciseSetMapper.toInsertable(
                  sets[i],
                  sessionId,
                  damage: damage,
                ),
              );
        }

        final saved = session.copyWith(
          id: sessionId,
        );
        return Success(saved);
      });
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  /// Returns the most recent sessions.
  Future<Result<List<WorkoutSession>, Exception>>
      getRecentSessions(int limit) async {
    try {
      final query = _db.select(
        _db.workoutSessions,
      )
        ..orderBy([
          (t) => OrderingTerm.desc(t.date),
        ])
        ..limit(limit);
      final entities = await query.get();
      final sessions = entities
          .map(WorkoutSessionMapper.toDomain)
          .toList();
      return Success(sessions);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  /// Returns sessions from the last [days] days,
  /// ordered most-recent first.
  Future<Result<List<WorkoutSession>, Exception>>
      getSessionsByDays(int days) async {
    try {
      final cutoff = DateTime.now().subtract(
        Duration(days: days),
      );
      final query = _db.select(
        _db.workoutSessions,
      )
        ..where(
          (t) => t.date.isBiggerThanValue(cutoff),
        )
        ..orderBy([
          (t) => OrderingTerm.desc(t.date),
        ]);
      final entities = await query.get();
      final sessions = entities
          .map(WorkoutSessionMapper.toDomain)
          .toList();
      return Success(sessions);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  /// Returns how many times a specific move was used
  /// across all sessions (FR25).
  Future<Result<int, Exception>>
      getMoveUsageCount(String moveId) async {
    try {
      final query = _db.selectOnly(_db.exerciseSets)
        ..addColumns([_db.exerciseSets.id.count()])
        ..where(
          _db.exerciseSets.moveId.equals(moveId),
        );
      final row = await query.getSingle();
      final count = row.read(
            _db.exerciseSets.id.count(),
          ) ??
          0;
      return Success(count);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  /// Returns the best set (highest weight) for a
  /// specific move (FR25 PR display).
  Future<Result<ExerciseSet?, Exception>>
      getMoveBestSet(String moveId) async {
    try {
      final query = _db.select(_db.exerciseSets)
        ..where(
          (t) => t.moveId.equals(moveId),
        )
        ..orderBy([
          (t) => OrderingTerm.desc(t.weight),
        ])
        ..limit(1);
      final rows = await query.get();
      if (rows.isEmpty) return const Success(null);
      return Success(
        ExerciseSetMapper.toDomain(rows.first),
      );
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  /// Returns a session with its linked sets.
  Future<
      Result<
          (WorkoutSession, List<ExerciseSet>),
          Exception>> getSessionWithSets(
    int sessionId,
  ) async {
    try {
      final sessionQuery = _db.select(
        _db.workoutSessions,
      )
        ..where(
          (t) => t.id.equals(sessionId),
        );
      final entity =
          await sessionQuery.getSingle();
      final session =
          WorkoutSessionMapper.toDomain(entity);

      final setsQuery = _db.select(
        _db.exerciseSets,
      )
        ..where(
          (t) => t.sessionId.equals(sessionId),
        )
        ..orderBy([
          (t) => OrderingTerm.asc(t.setNumber),
        ]);
      final setEntities = await setsQuery.get();
      final sets = setEntities
          .map(ExerciseSetMapper.toDomain)
          .toList();

      return Success((session, sets));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
