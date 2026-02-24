// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _experiencePointsMeta =
      const VerificationMeta('experiencePoints');
  @override
  late final GeneratedColumn<int> experiencePoints = GeneratedColumn<int>(
      'experience_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _squatFiveRmMeta =
      const VerificationMeta('squatFiveRm');
  @override
  late final GeneratedColumn<double> squatFiveRm = GeneratedColumn<double>(
      'squat_five_rm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _benchPressFiveRmMeta =
      const VerificationMeta('benchPressFiveRm');
  @override
  late final GeneratedColumn<double> benchPressFiveRm = GeneratedColumn<double>(
      'bench_press_five_rm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _deadliftFiveRmMeta =
      const VerificationMeta('deadliftFiveRm');
  @override
  late final GeneratedColumn<double> deadliftFiveRm = GeneratedColumn<double>(
      'deadlift_five_rm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _overheadPressFiveRmMeta =
      const VerificationMeta('overheadPressFiveRm');
  @override
  late final GeneratedColumn<double> overheadPressFiveRm =
      GeneratedColumn<double>('overhead_press_five_rm', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _weeklyFrequencyMeta =
      const VerificationMeta('weeklyFrequency');
  @override
  late final GeneratedColumn<int> weeklyFrequency = GeneratedColumn<int>(
      'weekly_frequency', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _isBeginnerModeMeta =
      const VerificationMeta('isBeginnerMode');
  @override
  late final GeneratedColumn<bool> isBeginnerMode = GeneratedColumn<bool>(
      'is_beginner_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_beginner_mode" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unlockedMoveIdsMeta =
      const VerificationMeta('unlockedMoveIds');
  @override
  late final GeneratedColumn<String> unlockedMoveIds = GeneratedColumn<String>(
      'unlocked_move_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        level,
        experiencePoints,
        squatFiveRm,
        benchPressFiveRm,
        deadliftFiveRm,
        overheadPressFiveRm,
        weeklyFrequency,
        isBeginnerMode,
        unlockedMoveIds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfileEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('experience_points')) {
      context.handle(
          _experiencePointsMeta,
          experiencePoints.isAcceptableOrUnknown(
              data['experience_points']!, _experiencePointsMeta));
    }
    if (data.containsKey('squat_five_rm')) {
      context.handle(
          _squatFiveRmMeta,
          squatFiveRm.isAcceptableOrUnknown(
              data['squat_five_rm']!, _squatFiveRmMeta));
    }
    if (data.containsKey('bench_press_five_rm')) {
      context.handle(
          _benchPressFiveRmMeta,
          benchPressFiveRm.isAcceptableOrUnknown(
              data['bench_press_five_rm']!, _benchPressFiveRmMeta));
    }
    if (data.containsKey('deadlift_five_rm')) {
      context.handle(
          _deadliftFiveRmMeta,
          deadliftFiveRm.isAcceptableOrUnknown(
              data['deadlift_five_rm']!, _deadliftFiveRmMeta));
    }
    if (data.containsKey('overhead_press_five_rm')) {
      context.handle(
          _overheadPressFiveRmMeta,
          overheadPressFiveRm.isAcceptableOrUnknown(
              data['overhead_press_five_rm']!, _overheadPressFiveRmMeta));
    }
    if (data.containsKey('weekly_frequency')) {
      context.handle(
          _weeklyFrequencyMeta,
          weeklyFrequency.isAcceptableOrUnknown(
              data['weekly_frequency']!, _weeklyFrequencyMeta));
    }
    if (data.containsKey('is_beginner_mode')) {
      context.handle(
          _isBeginnerModeMeta,
          isBeginnerMode.isAcceptableOrUnknown(
              data['is_beginner_mode']!, _isBeginnerModeMeta));
    }
    if (data.containsKey('unlocked_move_ids')) {
      context.handle(
          _unlockedMoveIdsMeta,
          unlockedMoveIds.isAcceptableOrUnknown(
              data['unlocked_move_ids']!, _unlockedMoveIdsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      experiencePoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}experience_points'])!,
      squatFiveRm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}squat_five_rm'])!,
      benchPressFiveRm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}bench_press_five_rm'])!,
      deadliftFiveRm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}deadlift_five_rm'])!,
      overheadPressFiveRm: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}overhead_press_five_rm'])!,
      weeklyFrequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_frequency'])!,
      isBeginnerMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_beginner_mode'])!,
      unlockedMoveIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unlocked_move_ids'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfileEntity extends DataClass
    implements Insertable<UserProfileEntity> {
  /// Auto-incremented primary key (always 1 for singleton profile).
  final int id;

  /// Current player level (starts at 1).
  final int level;

  /// Accumulated experience points.
  final int experiencePoints;

  /// Squat 5-rep max in kilograms.
  final double squatFiveRm;

  /// Bench press 5-rep max in kilograms.
  final double benchPressFiveRm;

  /// Deadlift 5-rep max in kilograms.
  final double deadliftFiveRm;

  /// Overhead press 5-rep max in kilograms.
  final double overheadPressFiveRm;

  /// Weekly training frequency in days (1–7).
  final int weeklyFrequency;

  /// Whether the player is in beginner auto-calibration mode.
  final bool isBeginnerMode;

  /// JSON-encoded list of unlocked move IDs (e.g. '["push_up"]').
  final String unlockedMoveIds;
  const UserProfileEntity(
      {required this.id,
      required this.level,
      required this.experiencePoints,
      required this.squatFiveRm,
      required this.benchPressFiveRm,
      required this.deadliftFiveRm,
      required this.overheadPressFiveRm,
      required this.weeklyFrequency,
      required this.isBeginnerMode,
      required this.unlockedMoveIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['experience_points'] = Variable<int>(experiencePoints);
    map['squat_five_rm'] = Variable<double>(squatFiveRm);
    map['bench_press_five_rm'] = Variable<double>(benchPressFiveRm);
    map['deadlift_five_rm'] = Variable<double>(deadliftFiveRm);
    map['overhead_press_five_rm'] = Variable<double>(overheadPressFiveRm);
    map['weekly_frequency'] = Variable<int>(weeklyFrequency);
    map['is_beginner_mode'] = Variable<bool>(isBeginnerMode);
    map['unlocked_move_ids'] = Variable<String>(unlockedMoveIds);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      level: Value(level),
      experiencePoints: Value(experiencePoints),
      squatFiveRm: Value(squatFiveRm),
      benchPressFiveRm: Value(benchPressFiveRm),
      deadliftFiveRm: Value(deadliftFiveRm),
      overheadPressFiveRm: Value(overheadPressFiveRm),
      weeklyFrequency: Value(weeklyFrequency),
      isBeginnerMode: Value(isBeginnerMode),
      unlockedMoveIds: Value(unlockedMoveIds),
    );
  }

  factory UserProfileEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileEntity(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      experiencePoints: serializer.fromJson<int>(json['experiencePoints']),
      squatFiveRm: serializer.fromJson<double>(json['squatFiveRm']),
      benchPressFiveRm: serializer.fromJson<double>(json['benchPressFiveRm']),
      deadliftFiveRm: serializer.fromJson<double>(json['deadliftFiveRm']),
      overheadPressFiveRm:
          serializer.fromJson<double>(json['overheadPressFiveRm']),
      weeklyFrequency: serializer.fromJson<int>(json['weeklyFrequency']),
      isBeginnerMode: serializer.fromJson<bool>(json['isBeginnerMode']),
      unlockedMoveIds: serializer.fromJson<String>(json['unlockedMoveIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'experiencePoints': serializer.toJson<int>(experiencePoints),
      'squatFiveRm': serializer.toJson<double>(squatFiveRm),
      'benchPressFiveRm': serializer.toJson<double>(benchPressFiveRm),
      'deadliftFiveRm': serializer.toJson<double>(deadliftFiveRm),
      'overheadPressFiveRm': serializer.toJson<double>(overheadPressFiveRm),
      'weeklyFrequency': serializer.toJson<int>(weeklyFrequency),
      'isBeginnerMode': serializer.toJson<bool>(isBeginnerMode),
      'unlockedMoveIds': serializer.toJson<String>(unlockedMoveIds),
    };
  }

  UserProfileEntity copyWith(
          {int? id,
          int? level,
          int? experiencePoints,
          double? squatFiveRm,
          double? benchPressFiveRm,
          double? deadliftFiveRm,
          double? overheadPressFiveRm,
          int? weeklyFrequency,
          bool? isBeginnerMode,
          String? unlockedMoveIds}) =>
      UserProfileEntity(
        id: id ?? this.id,
        level: level ?? this.level,
        experiencePoints: experiencePoints ?? this.experiencePoints,
        squatFiveRm: squatFiveRm ?? this.squatFiveRm,
        benchPressFiveRm: benchPressFiveRm ?? this.benchPressFiveRm,
        deadliftFiveRm: deadliftFiveRm ?? this.deadliftFiveRm,
        overheadPressFiveRm: overheadPressFiveRm ?? this.overheadPressFiveRm,
        weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
        isBeginnerMode: isBeginnerMode ?? this.isBeginnerMode,
        unlockedMoveIds: unlockedMoveIds ?? this.unlockedMoveIds,
      );
  UserProfileEntity copyWithCompanion(UserProfilesCompanion data) {
    return UserProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      experiencePoints: data.experiencePoints.present
          ? data.experiencePoints.value
          : this.experiencePoints,
      squatFiveRm:
          data.squatFiveRm.present ? data.squatFiveRm.value : this.squatFiveRm,
      benchPressFiveRm: data.benchPressFiveRm.present
          ? data.benchPressFiveRm.value
          : this.benchPressFiveRm,
      deadliftFiveRm: data.deadliftFiveRm.present
          ? data.deadliftFiveRm.value
          : this.deadliftFiveRm,
      overheadPressFiveRm: data.overheadPressFiveRm.present
          ? data.overheadPressFiveRm.value
          : this.overheadPressFiveRm,
      weeklyFrequency: data.weeklyFrequency.present
          ? data.weeklyFrequency.value
          : this.weeklyFrequency,
      isBeginnerMode: data.isBeginnerMode.present
          ? data.isBeginnerMode.value
          : this.isBeginnerMode,
      unlockedMoveIds: data.unlockedMoveIds.present
          ? data.unlockedMoveIds.value
          : this.unlockedMoveIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntity(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('experiencePoints: $experiencePoints, ')
          ..write('squatFiveRm: $squatFiveRm, ')
          ..write('benchPressFiveRm: $benchPressFiveRm, ')
          ..write('deadliftFiveRm: $deadliftFiveRm, ')
          ..write('overheadPressFiveRm: $overheadPressFiveRm, ')
          ..write('weeklyFrequency: $weeklyFrequency, ')
          ..write('isBeginnerMode: $isBeginnerMode, ')
          ..write('unlockedMoveIds: $unlockedMoveIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      level,
      experiencePoints,
      squatFiveRm,
      benchPressFiveRm,
      deadliftFiveRm,
      overheadPressFiveRm,
      weeklyFrequency,
      isBeginnerMode,
      unlockedMoveIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileEntity &&
          other.id == this.id &&
          other.level == this.level &&
          other.experiencePoints == this.experiencePoints &&
          other.squatFiveRm == this.squatFiveRm &&
          other.benchPressFiveRm == this.benchPressFiveRm &&
          other.deadliftFiveRm == this.deadliftFiveRm &&
          other.overheadPressFiveRm == this.overheadPressFiveRm &&
          other.weeklyFrequency == this.weeklyFrequency &&
          other.isBeginnerMode == this.isBeginnerMode &&
          other.unlockedMoveIds == this.unlockedMoveIds);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfileEntity> {
  final Value<int> id;
  final Value<int> level;
  final Value<int> experiencePoints;
  final Value<double> squatFiveRm;
  final Value<double> benchPressFiveRm;
  final Value<double> deadliftFiveRm;
  final Value<double> overheadPressFiveRm;
  final Value<int> weeklyFrequency;
  final Value<bool> isBeginnerMode;
  final Value<String> unlockedMoveIds;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.experiencePoints = const Value.absent(),
    this.squatFiveRm = const Value.absent(),
    this.benchPressFiveRm = const Value.absent(),
    this.deadliftFiveRm = const Value.absent(),
    this.overheadPressFiveRm = const Value.absent(),
    this.weeklyFrequency = const Value.absent(),
    this.isBeginnerMode = const Value.absent(),
    this.unlockedMoveIds = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.experiencePoints = const Value.absent(),
    this.squatFiveRm = const Value.absent(),
    this.benchPressFiveRm = const Value.absent(),
    this.deadliftFiveRm = const Value.absent(),
    this.overheadPressFiveRm = const Value.absent(),
    this.weeklyFrequency = const Value.absent(),
    this.isBeginnerMode = const Value.absent(),
    this.unlockedMoveIds = const Value.absent(),
  });
  static Insertable<UserProfileEntity> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<int>? experiencePoints,
    Expression<double>? squatFiveRm,
    Expression<double>? benchPressFiveRm,
    Expression<double>? deadliftFiveRm,
    Expression<double>? overheadPressFiveRm,
    Expression<int>? weeklyFrequency,
    Expression<bool>? isBeginnerMode,
    Expression<String>? unlockedMoveIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (experiencePoints != null) 'experience_points': experiencePoints,
      if (squatFiveRm != null) 'squat_five_rm': squatFiveRm,
      if (benchPressFiveRm != null) 'bench_press_five_rm': benchPressFiveRm,
      if (deadliftFiveRm != null) 'deadlift_five_rm': deadliftFiveRm,
      if (overheadPressFiveRm != null)
        'overhead_press_five_rm': overheadPressFiveRm,
      if (weeklyFrequency != null) 'weekly_frequency': weeklyFrequency,
      if (isBeginnerMode != null) 'is_beginner_mode': isBeginnerMode,
      if (unlockedMoveIds != null) 'unlocked_move_ids': unlockedMoveIds,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? id,
      Value<int>? level,
      Value<int>? experiencePoints,
      Value<double>? squatFiveRm,
      Value<double>? benchPressFiveRm,
      Value<double>? deadliftFiveRm,
      Value<double>? overheadPressFiveRm,
      Value<int>? weeklyFrequency,
      Value<bool>? isBeginnerMode,
      Value<String>? unlockedMoveIds}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      squatFiveRm: squatFiveRm ?? this.squatFiveRm,
      benchPressFiveRm: benchPressFiveRm ?? this.benchPressFiveRm,
      deadliftFiveRm: deadliftFiveRm ?? this.deadliftFiveRm,
      overheadPressFiveRm: overheadPressFiveRm ?? this.overheadPressFiveRm,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      isBeginnerMode: isBeginnerMode ?? this.isBeginnerMode,
      unlockedMoveIds: unlockedMoveIds ?? this.unlockedMoveIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (experiencePoints.present) {
      map['experience_points'] = Variable<int>(experiencePoints.value);
    }
    if (squatFiveRm.present) {
      map['squat_five_rm'] = Variable<double>(squatFiveRm.value);
    }
    if (benchPressFiveRm.present) {
      map['bench_press_five_rm'] = Variable<double>(benchPressFiveRm.value);
    }
    if (deadliftFiveRm.present) {
      map['deadlift_five_rm'] = Variable<double>(deadliftFiveRm.value);
    }
    if (overheadPressFiveRm.present) {
      map['overhead_press_five_rm'] =
          Variable<double>(overheadPressFiveRm.value);
    }
    if (weeklyFrequency.present) {
      map['weekly_frequency'] = Variable<int>(weeklyFrequency.value);
    }
    if (isBeginnerMode.present) {
      map['is_beginner_mode'] = Variable<bool>(isBeginnerMode.value);
    }
    if (unlockedMoveIds.present) {
      map['unlocked_move_ids'] = Variable<String>(unlockedMoveIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('experiencePoints: $experiencePoints, ')
          ..write('squatFiveRm: $squatFiveRm, ')
          ..write('benchPressFiveRm: $benchPressFiveRm, ')
          ..write('deadliftFiveRm: $deadliftFiveRm, ')
          ..write('overheadPressFiveRm: $overheadPressFiveRm, ')
          ..write('weeklyFrequency: $weeklyFrequency, ')
          ..write('isBeginnerMode: $isBeginnerMode, ')
          ..write('unlockedMoveIds: $unlockedMoveIds')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userProfiles];
}

typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<int> level,
  Value<int> experiencePoints,
  Value<double> squatFiveRm,
  Value<double> benchPressFiveRm,
  Value<double> deadliftFiveRm,
  Value<double> overheadPressFiveRm,
  Value<int> weeklyFrequency,
  Value<bool> isBeginnerMode,
  Value<String> unlockedMoveIds,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<int> level,
  Value<int> experiencePoints,
  Value<double> squatFiveRm,
  Value<double> benchPressFiveRm,
  Value<double> deadliftFiveRm,
  Value<double> overheadPressFiveRm,
  Value<int> weeklyFrequency,
  Value<bool> isBeginnerMode,
  Value<String> unlockedMoveIds,
});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get experiencePoints => $composableBuilder(
      column: $table.experiencePoints,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get squatFiveRm => $composableBuilder(
      column: $table.squatFiveRm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get benchPressFiveRm => $composableBuilder(
      column: $table.benchPressFiveRm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get deadliftFiveRm => $composableBuilder(
      column: $table.deadliftFiveRm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get overheadPressFiveRm => $composableBuilder(
      column: $table.overheadPressFiveRm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeklyFrequency => $composableBuilder(
      column: $table.weeklyFrequency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBeginnerMode => $composableBuilder(
      column: $table.isBeginnerMode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unlockedMoveIds => $composableBuilder(
      column: $table.unlockedMoveIds,
      builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get experiencePoints => $composableBuilder(
      column: $table.experiencePoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get squatFiveRm => $composableBuilder(
      column: $table.squatFiveRm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get benchPressFiveRm => $composableBuilder(
      column: $table.benchPressFiveRm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get deadliftFiveRm => $composableBuilder(
      column: $table.deadliftFiveRm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get overheadPressFiveRm => $composableBuilder(
      column: $table.overheadPressFiveRm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyFrequency => $composableBuilder(
      column: $table.weeklyFrequency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBeginnerMode => $composableBuilder(
      column: $table.isBeginnerMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unlockedMoveIds => $composableBuilder(
      column: $table.unlockedMoveIds,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get experiencePoints => $composableBuilder(
      column: $table.experiencePoints, builder: (column) => column);

  GeneratedColumn<double> get squatFiveRm => $composableBuilder(
      column: $table.squatFiveRm, builder: (column) => column);

  GeneratedColumn<double> get benchPressFiveRm => $composableBuilder(
      column: $table.benchPressFiveRm, builder: (column) => column);

  GeneratedColumn<double> get deadliftFiveRm => $composableBuilder(
      column: $table.deadliftFiveRm, builder: (column) => column);

  GeneratedColumn<double> get overheadPressFiveRm => $composableBuilder(
      column: $table.overheadPressFiveRm, builder: (column) => column);

  GeneratedColumn<int> get weeklyFrequency => $composableBuilder(
      column: $table.weeklyFrequency, builder: (column) => column);

  GeneratedColumn<bool> get isBeginnerMode => $composableBuilder(
      column: $table.isBeginnerMode, builder: (column) => column);

  GeneratedColumn<String> get unlockedMoveIds => $composableBuilder(
      column: $table.unlockedMoveIds, builder: (column) => column);
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfileEntity,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfileEntity,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileEntity>
    ),
    UserProfileEntity,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> experiencePoints = const Value.absent(),
            Value<double> squatFiveRm = const Value.absent(),
            Value<double> benchPressFiveRm = const Value.absent(),
            Value<double> deadliftFiveRm = const Value.absent(),
            Value<double> overheadPressFiveRm = const Value.absent(),
            Value<int> weeklyFrequency = const Value.absent(),
            Value<bool> isBeginnerMode = const Value.absent(),
            Value<String> unlockedMoveIds = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            level: level,
            experiencePoints: experiencePoints,
            squatFiveRm: squatFiveRm,
            benchPressFiveRm: benchPressFiveRm,
            deadliftFiveRm: deadliftFiveRm,
            overheadPressFiveRm: overheadPressFiveRm,
            weeklyFrequency: weeklyFrequency,
            isBeginnerMode: isBeginnerMode,
            unlockedMoveIds: unlockedMoveIds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> experiencePoints = const Value.absent(),
            Value<double> squatFiveRm = const Value.absent(),
            Value<double> benchPressFiveRm = const Value.absent(),
            Value<double> deadliftFiveRm = const Value.absent(),
            Value<double> overheadPressFiveRm = const Value.absent(),
            Value<int> weeklyFrequency = const Value.absent(),
            Value<bool> isBeginnerMode = const Value.absent(),
            Value<String> unlockedMoveIds = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            level: level,
            experiencePoints: experiencePoints,
            squatFiveRm: squatFiveRm,
            benchPressFiveRm: benchPressFiveRm,
            deadliftFiveRm: deadliftFiveRm,
            overheadPressFiveRm: overheadPressFiveRm,
            weeklyFrequency: weeklyFrequency,
            isBeginnerMode: isBeginnerMode,
            unlockedMoveIds: unlockedMoveIds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfileEntity,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfileEntity,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfileEntity>
    ),
    UserProfileEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
