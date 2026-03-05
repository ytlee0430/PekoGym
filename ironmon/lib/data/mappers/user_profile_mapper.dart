import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ironmon/data/local/app_database.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

/// Converts between [UserProfileEntity] (Drift) and [UserProfile] (domain).
/// Keeps all encoding/decoding logic isolated from other layers.
class UserProfileMapper {
  const UserProfileMapper._();

  /// Converts a Drift [UserProfileEntity] row to domain [UserProfile].
  static UserProfile toDomain(UserProfileEntity entity) {
    return UserProfile(
      id: entity.id,
      level: entity.level,
      experiencePoints: entity.experiencePoints,
      squatFiveRm: entity.squatFiveRm,
      benchPressFiveRm: entity.benchPressFiveRm,
      deadliftFiveRm: entity.deadliftFiveRm,
      overheadPressFiveRm: entity.overheadPressFiveRm,
      weeklyFrequency: entity.weeklyFrequency,
      isBeginnerMode: entity.isBeginnerMode,
      calibrationSessionsCompleted: entity.calibrationSessionsCompleted,
      calibrationTargetSessions: entity.calibrationTargetSessions,
      unlockedMoveIds: _decodeIds(entity.unlockedMoveIds),
      maxPp: entity.maxPp,
      currentPp: entity.currentPp,
      potionCount: entity.potionCount,
      etherCount: entity.etherCount,
      rareCandyCount: entity.rareCandyCount,
      coins: entity.coins,
      exerciseFiveRms: _decodeExerciseFiveRms(entity.exerciseFiveRms),
    );
  }

  /// Converts a domain [UserProfile] to a [UserProfilesCompanion] for
  /// insert/upsert. Forces id = 1 (singleton pattern).
  static UserProfilesCompanion toInsertable(UserProfile profile) {
    return UserProfilesCompanion(
      id: const Value(1),
      level: Value(profile.level),
      experiencePoints: Value(profile.experiencePoints),
      squatFiveRm: Value(profile.squatFiveRm),
      benchPressFiveRm: Value(profile.benchPressFiveRm),
      deadliftFiveRm: Value(profile.deadliftFiveRm),
      overheadPressFiveRm: Value(profile.overheadPressFiveRm),
      weeklyFrequency: Value(profile.weeklyFrequency),
      isBeginnerMode: Value(profile.isBeginnerMode),
      calibrationSessionsCompleted:
          Value(profile.calibrationSessionsCompleted),
      calibrationTargetSessions: Value(profile.calibrationTargetSessions),
      unlockedMoveIds: Value(_encodeIds(profile.unlockedMoveIds)),
      maxPp: Value(profile.maxPp),
      currentPp: Value(profile.currentPp),
      potionCount: Value(profile.potionCount),
      etherCount: Value(profile.etherCount),
      rareCandyCount: Value(profile.rareCandyCount),
      coins: Value(profile.coins),
      exerciseFiveRms: Value(_encodeExerciseFiveRms(profile.exerciseFiveRms)),
    );
  }

  /// Converts a domain [UserProfile] to a [UserProfilesCompanion] for
  /// update (excludes id to avoid primary-key reassignment).
  static UserProfilesCompanion toUpdateCompanion(UserProfile profile) {
    return UserProfilesCompanion(
      level: Value(profile.level),
      experiencePoints: Value(profile.experiencePoints),
      squatFiveRm: Value(profile.squatFiveRm),
      benchPressFiveRm: Value(profile.benchPressFiveRm),
      deadliftFiveRm: Value(profile.deadliftFiveRm),
      overheadPressFiveRm: Value(profile.overheadPressFiveRm),
      weeklyFrequency: Value(profile.weeklyFrequency),
      isBeginnerMode: Value(profile.isBeginnerMode),
      calibrationSessionsCompleted:
          Value(profile.calibrationSessionsCompleted),
      calibrationTargetSessions: Value(profile.calibrationTargetSessions),
      unlockedMoveIds: Value(_encodeIds(profile.unlockedMoveIds)),
      maxPp: Value(profile.maxPp),
      currentPp: Value(profile.currentPp),
      potionCount: Value(profile.potionCount),
      etherCount: Value(profile.etherCount),
      rareCandyCount: Value(profile.rareCandyCount),
      coins: Value(profile.coins),
      exerciseFiveRms: Value(_encodeExerciseFiveRms(profile.exerciseFiveRms)),
    );
  }

  static List<String> _decodeIds(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return [];
      return decoded.whereType<String>().toList();
    } on Object catch (_) {
      return [];
    }
  }

  static String _encodeIds(List<String> ids) => jsonEncode(ids);

  static Map<String, double> _decodeExerciseFiveRms(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map) return {};
      return decoded
          .map((k, v) => MapEntry(k as String, (v as num).toDouble()));
    } on Object catch (_) {
      return {};
    }
  }

  static String _encodeExerciseFiveRms(Map<String, double> map) =>
      jsonEncode(map);
}
