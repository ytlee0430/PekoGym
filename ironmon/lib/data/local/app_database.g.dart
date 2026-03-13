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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL CHECK (id = 1)',
      defaultValue: const Constant(1));
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
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('male'));
  static const VerificationMeta _bodyWeightKgMeta =
      const VerificationMeta('bodyWeightKg');
  @override
  late final GeneratedColumn<double> bodyWeightKg = GeneratedColumn<double>(
      'body_weight_kg', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(70));
  static const VerificationMeta _squatFiveRmMeta =
      const VerificationMeta('squatFiveRm');
  @override
  late final GeneratedColumn<double> squatFiveRm = GeneratedColumn<double>(
      'squat_five_rm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _benchPressFiveRmMeta =
      const VerificationMeta('benchPressFiveRm');
  @override
  late final GeneratedColumn<double> benchPressFiveRm = GeneratedColumn<double>(
      'bench_press_five_rm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deadliftFiveRmMeta =
      const VerificationMeta('deadliftFiveRm');
  @override
  late final GeneratedColumn<double> deadliftFiveRm = GeneratedColumn<double>(
      'deadlift_five_rm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _overheadPressFiveRmMeta =
      const VerificationMeta('overheadPressFiveRm');
  @override
  late final GeneratedColumn<double> overheadPressFiveRm =
      GeneratedColumn<double>('overhead_press_five_rm', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
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
  static const VerificationMeta _calibrationSessionsCompletedMeta =
      const VerificationMeta('calibrationSessionsCompleted');
  @override
  late final GeneratedColumn<int> calibrationSessionsCompleted =
      GeneratedColumn<int>('calibration_sessions_completed', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _calibrationTargetSessionsMeta =
      const VerificationMeta('calibrationTargetSessions');
  @override
  late final GeneratedColumn<int> calibrationTargetSessions =
      GeneratedColumn<int>('calibration_target_sessions', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(5));
  static const VerificationMeta _unlockedMoveIdsMeta =
      const VerificationMeta('unlockedMoveIds');
  @override
  late final GeneratedColumn<String> unlockedMoveIds = GeneratedColumn<String>(
      'unlocked_move_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _maxPpMeta = const VerificationMeta('maxPp');
  @override
  late final GeneratedColumn<int> maxPp = GeneratedColumn<int>(
      'max_pp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(110));
  static const VerificationMeta _currentPpMeta =
      const VerificationMeta('currentPp');
  @override
  late final GeneratedColumn<int> currentPp = GeneratedColumn<int>(
      'current_pp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(110));
  static const VerificationMeta _potionCountMeta =
      const VerificationMeta('potionCount');
  @override
  late final GeneratedColumn<int> potionCount = GeneratedColumn<int>(
      'potion_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _etherCountMeta =
      const VerificationMeta('etherCount');
  @override
  late final GeneratedColumn<int> etherCount = GeneratedColumn<int>(
      'ether_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _rareCandyCountMeta =
      const VerificationMeta('rareCandyCount');
  @override
  late final GeneratedColumn<int> rareCandyCount = GeneratedColumn<int>(
      'rare_candy_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
      'coins', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _exerciseFiveRmsMeta =
      const VerificationMeta('exerciseFiveRms');
  @override
  late final GeneratedColumn<String> exerciseFiveRms = GeneratedColumn<String>(
      'exercise_five_rms', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        level,
        experiencePoints,
        gender,
        bodyWeightKg,
        squatFiveRm,
        benchPressFiveRm,
        deadliftFiveRm,
        overheadPressFiveRm,
        weeklyFrequency,
        isBeginnerMode,
        calibrationSessionsCompleted,
        calibrationTargetSessions,
        unlockedMoveIds,
        maxPp,
        currentPp,
        potionCount,
        etherCount,
        rareCandyCount,
        coins,
        exerciseFiveRms
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
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('body_weight_kg')) {
      context.handle(
          _bodyWeightKgMeta,
          bodyWeightKg.isAcceptableOrUnknown(
              data['body_weight_kg']!, _bodyWeightKgMeta));
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
    if (data.containsKey('calibration_sessions_completed')) {
      context.handle(
          _calibrationSessionsCompletedMeta,
          calibrationSessionsCompleted.isAcceptableOrUnknown(
              data['calibration_sessions_completed']!,
              _calibrationSessionsCompletedMeta));
    }
    if (data.containsKey('calibration_target_sessions')) {
      context.handle(
          _calibrationTargetSessionsMeta,
          calibrationTargetSessions.isAcceptableOrUnknown(
              data['calibration_target_sessions']!,
              _calibrationTargetSessionsMeta));
    }
    if (data.containsKey('unlocked_move_ids')) {
      context.handle(
          _unlockedMoveIdsMeta,
          unlockedMoveIds.isAcceptableOrUnknown(
              data['unlocked_move_ids']!, _unlockedMoveIdsMeta));
    }
    if (data.containsKey('max_pp')) {
      context.handle(
          _maxPpMeta, maxPp.isAcceptableOrUnknown(data['max_pp']!, _maxPpMeta));
    }
    if (data.containsKey('current_pp')) {
      context.handle(_currentPpMeta,
          currentPp.isAcceptableOrUnknown(data['current_pp']!, _currentPpMeta));
    }
    if (data.containsKey('potion_count')) {
      context.handle(
          _potionCountMeta,
          potionCount.isAcceptableOrUnknown(
              data['potion_count']!, _potionCountMeta));
    }
    if (data.containsKey('ether_count')) {
      context.handle(
          _etherCountMeta,
          etherCount.isAcceptableOrUnknown(
              data['ether_count']!, _etherCountMeta));
    }
    if (data.containsKey('rare_candy_count')) {
      context.handle(
          _rareCandyCountMeta,
          rareCandyCount.isAcceptableOrUnknown(
              data['rare_candy_count']!, _rareCandyCountMeta));
    }
    if (data.containsKey('coins')) {
      context.handle(
          _coinsMeta, coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta));
    }
    if (data.containsKey('exercise_five_rms')) {
      context.handle(
          _exerciseFiveRmsMeta,
          exerciseFiveRms.isAcceptableOrUnknown(
              data['exercise_five_rms']!, _exerciseFiveRmsMeta));
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
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      bodyWeightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}body_weight_kg'])!,
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
      calibrationSessionsCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}calibration_sessions_completed'])!,
      calibrationTargetSessions: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}calibration_target_sessions'])!,
      unlockedMoveIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unlocked_move_ids'])!,
      maxPp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_pp'])!,
      currentPp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_pp'])!,
      potionCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}potion_count'])!,
      etherCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ether_count'])!,
      rareCandyCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rare_candy_count'])!,
      coins: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}coins'])!,
      exerciseFiveRms: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}exercise_five_rms'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfileEntity extends DataClass
    implements Insertable<UserProfileEntity> {
  /// Singleton primary key. [primaryKey] getter declares this as the
  /// table-level PK; customConstraint enforces the singleton CHECK (id = 1).
  final int id;

  /// Current player level (starts at 1).
  final int level;

  /// Accumulated experience points.
  final int experiencePoints;

  /// Player gender ('male' or 'female').
  final String gender;

  /// Player body weight in kilograms.
  final double bodyWeightKg;

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

  /// Number of sessions completed during beginner calibration.
  final int calibrationSessionsCompleted;

  /// Target number of calibration sessions (default 5).
  final int calibrationTargetSessions;

  /// JSON-encoded list of unlocked move IDs (e.g. '["push_up"]').
  final String unlockedMoveIds;

  /// Maximum PP (stamina). Derived: 100 + level * 10.
  final int maxPp;

  /// Current PP (stamina). Deducted when moves are used.
  final int currentPp;

  /// Number of Potions held.
  final int potionCount;

  /// Number of Ethers held.
  final int etherCount;

  /// Number of Rare Candies held.
  final int rareCandyCount;

  /// In-game currency balance.
  final int coins;

  /// JSON-encoded map of per-exercise 5RM overrides keyed by move ID.
  final String exerciseFiveRms;
  const UserProfileEntity(
      {required this.id,
      required this.level,
      required this.experiencePoints,
      required this.gender,
      required this.bodyWeightKg,
      required this.squatFiveRm,
      required this.benchPressFiveRm,
      required this.deadliftFiveRm,
      required this.overheadPressFiveRm,
      required this.weeklyFrequency,
      required this.isBeginnerMode,
      required this.calibrationSessionsCompleted,
      required this.calibrationTargetSessions,
      required this.unlockedMoveIds,
      required this.maxPp,
      required this.currentPp,
      required this.potionCount,
      required this.etherCount,
      required this.rareCandyCount,
      required this.coins,
      required this.exerciseFiveRms});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['experience_points'] = Variable<int>(experiencePoints);
    map['gender'] = Variable<String>(gender);
    map['body_weight_kg'] = Variable<double>(bodyWeightKg);
    map['squat_five_rm'] = Variable<double>(squatFiveRm);
    map['bench_press_five_rm'] = Variable<double>(benchPressFiveRm);
    map['deadlift_five_rm'] = Variable<double>(deadliftFiveRm);
    map['overhead_press_five_rm'] = Variable<double>(overheadPressFiveRm);
    map['weekly_frequency'] = Variable<int>(weeklyFrequency);
    map['is_beginner_mode'] = Variable<bool>(isBeginnerMode);
    map['calibration_sessions_completed'] =
        Variable<int>(calibrationSessionsCompleted);
    map['calibration_target_sessions'] =
        Variable<int>(calibrationTargetSessions);
    map['unlocked_move_ids'] = Variable<String>(unlockedMoveIds);
    map['max_pp'] = Variable<int>(maxPp);
    map['current_pp'] = Variable<int>(currentPp);
    map['potion_count'] = Variable<int>(potionCount);
    map['ether_count'] = Variable<int>(etherCount);
    map['rare_candy_count'] = Variable<int>(rareCandyCount);
    map['coins'] = Variable<int>(coins);
    map['exercise_five_rms'] = Variable<String>(exerciseFiveRms);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      level: Value(level),
      experiencePoints: Value(experiencePoints),
      gender: Value(gender),
      bodyWeightKg: Value(bodyWeightKg),
      squatFiveRm: Value(squatFiveRm),
      benchPressFiveRm: Value(benchPressFiveRm),
      deadliftFiveRm: Value(deadliftFiveRm),
      overheadPressFiveRm: Value(overheadPressFiveRm),
      weeklyFrequency: Value(weeklyFrequency),
      isBeginnerMode: Value(isBeginnerMode),
      calibrationSessionsCompleted: Value(calibrationSessionsCompleted),
      calibrationTargetSessions: Value(calibrationTargetSessions),
      unlockedMoveIds: Value(unlockedMoveIds),
      maxPp: Value(maxPp),
      currentPp: Value(currentPp),
      potionCount: Value(potionCount),
      etherCount: Value(etherCount),
      rareCandyCount: Value(rareCandyCount),
      coins: Value(coins),
      exerciseFiveRms: Value(exerciseFiveRms),
    );
  }

  factory UserProfileEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileEntity(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      experiencePoints: serializer.fromJson<int>(json['experiencePoints']),
      gender: serializer.fromJson<String>(json['gender']),
      bodyWeightKg: serializer.fromJson<double>(json['bodyWeightKg']),
      squatFiveRm: serializer.fromJson<double>(json['squatFiveRm']),
      benchPressFiveRm: serializer.fromJson<double>(json['benchPressFiveRm']),
      deadliftFiveRm: serializer.fromJson<double>(json['deadliftFiveRm']),
      overheadPressFiveRm:
          serializer.fromJson<double>(json['overheadPressFiveRm']),
      weeklyFrequency: serializer.fromJson<int>(json['weeklyFrequency']),
      isBeginnerMode: serializer.fromJson<bool>(json['isBeginnerMode']),
      calibrationSessionsCompleted:
          serializer.fromJson<int>(json['calibrationSessionsCompleted']),
      calibrationTargetSessions:
          serializer.fromJson<int>(json['calibrationTargetSessions']),
      unlockedMoveIds: serializer.fromJson<String>(json['unlockedMoveIds']),
      maxPp: serializer.fromJson<int>(json['maxPp']),
      currentPp: serializer.fromJson<int>(json['currentPp']),
      potionCount: serializer.fromJson<int>(json['potionCount']),
      etherCount: serializer.fromJson<int>(json['etherCount']),
      rareCandyCount: serializer.fromJson<int>(json['rareCandyCount']),
      coins: serializer.fromJson<int>(json['coins']),
      exerciseFiveRms: serializer.fromJson<String>(json['exerciseFiveRms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'experiencePoints': serializer.toJson<int>(experiencePoints),
      'gender': serializer.toJson<String>(gender),
      'bodyWeightKg': serializer.toJson<double>(bodyWeightKg),
      'squatFiveRm': serializer.toJson<double>(squatFiveRm),
      'benchPressFiveRm': serializer.toJson<double>(benchPressFiveRm),
      'deadliftFiveRm': serializer.toJson<double>(deadliftFiveRm),
      'overheadPressFiveRm': serializer.toJson<double>(overheadPressFiveRm),
      'weeklyFrequency': serializer.toJson<int>(weeklyFrequency),
      'isBeginnerMode': serializer.toJson<bool>(isBeginnerMode),
      'calibrationSessionsCompleted':
          serializer.toJson<int>(calibrationSessionsCompleted),
      'calibrationTargetSessions':
          serializer.toJson<int>(calibrationTargetSessions),
      'unlockedMoveIds': serializer.toJson<String>(unlockedMoveIds),
      'maxPp': serializer.toJson<int>(maxPp),
      'currentPp': serializer.toJson<int>(currentPp),
      'potionCount': serializer.toJson<int>(potionCount),
      'etherCount': serializer.toJson<int>(etherCount),
      'rareCandyCount': serializer.toJson<int>(rareCandyCount),
      'coins': serializer.toJson<int>(coins),
      'exerciseFiveRms': serializer.toJson<String>(exerciseFiveRms),
    };
  }

  UserProfileEntity copyWith(
          {int? id,
          int? level,
          int? experiencePoints,
          String? gender,
          double? bodyWeightKg,
          double? squatFiveRm,
          double? benchPressFiveRm,
          double? deadliftFiveRm,
          double? overheadPressFiveRm,
          int? weeklyFrequency,
          bool? isBeginnerMode,
          int? calibrationSessionsCompleted,
          int? calibrationTargetSessions,
          String? unlockedMoveIds,
          int? maxPp,
          int? currentPp,
          int? potionCount,
          int? etherCount,
          int? rareCandyCount,
          int? coins,
          String? exerciseFiveRms}) =>
      UserProfileEntity(
        id: id ?? this.id,
        level: level ?? this.level,
        experiencePoints: experiencePoints ?? this.experiencePoints,
        gender: gender ?? this.gender,
        bodyWeightKg: bodyWeightKg ?? this.bodyWeightKg,
        squatFiveRm: squatFiveRm ?? this.squatFiveRm,
        benchPressFiveRm: benchPressFiveRm ?? this.benchPressFiveRm,
        deadliftFiveRm: deadliftFiveRm ?? this.deadliftFiveRm,
        overheadPressFiveRm: overheadPressFiveRm ?? this.overheadPressFiveRm,
        weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
        isBeginnerMode: isBeginnerMode ?? this.isBeginnerMode,
        calibrationSessionsCompleted:
            calibrationSessionsCompleted ?? this.calibrationSessionsCompleted,
        calibrationTargetSessions:
            calibrationTargetSessions ?? this.calibrationTargetSessions,
        unlockedMoveIds: unlockedMoveIds ?? this.unlockedMoveIds,
        maxPp: maxPp ?? this.maxPp,
        currentPp: currentPp ?? this.currentPp,
        potionCount: potionCount ?? this.potionCount,
        etherCount: etherCount ?? this.etherCount,
        rareCandyCount: rareCandyCount ?? this.rareCandyCount,
        coins: coins ?? this.coins,
        exerciseFiveRms: exerciseFiveRms ?? this.exerciseFiveRms,
      );
  UserProfileEntity copyWithCompanion(UserProfilesCompanion data) {
    return UserProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      experiencePoints: data.experiencePoints.present
          ? data.experiencePoints.value
          : this.experiencePoints,
      gender: data.gender.present ? data.gender.value : this.gender,
      bodyWeightKg: data.bodyWeightKg.present
          ? data.bodyWeightKg.value
          : this.bodyWeightKg,
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
      calibrationSessionsCompleted: data.calibrationSessionsCompleted.present
          ? data.calibrationSessionsCompleted.value
          : this.calibrationSessionsCompleted,
      calibrationTargetSessions: data.calibrationTargetSessions.present
          ? data.calibrationTargetSessions.value
          : this.calibrationTargetSessions,
      unlockedMoveIds: data.unlockedMoveIds.present
          ? data.unlockedMoveIds.value
          : this.unlockedMoveIds,
      maxPp: data.maxPp.present ? data.maxPp.value : this.maxPp,
      currentPp: data.currentPp.present ? data.currentPp.value : this.currentPp,
      potionCount:
          data.potionCount.present ? data.potionCount.value : this.potionCount,
      etherCount:
          data.etherCount.present ? data.etherCount.value : this.etherCount,
      rareCandyCount: data.rareCandyCount.present
          ? data.rareCandyCount.value
          : this.rareCandyCount,
      coins: data.coins.present ? data.coins.value : this.coins,
      exerciseFiveRms: data.exerciseFiveRms.present
          ? data.exerciseFiveRms.value
          : this.exerciseFiveRms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntity(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('experiencePoints: $experiencePoints, ')
          ..write('gender: $gender, ')
          ..write('bodyWeightKg: $bodyWeightKg, ')
          ..write('squatFiveRm: $squatFiveRm, ')
          ..write('benchPressFiveRm: $benchPressFiveRm, ')
          ..write('deadliftFiveRm: $deadliftFiveRm, ')
          ..write('overheadPressFiveRm: $overheadPressFiveRm, ')
          ..write('weeklyFrequency: $weeklyFrequency, ')
          ..write('isBeginnerMode: $isBeginnerMode, ')
          ..write(
              'calibrationSessionsCompleted: $calibrationSessionsCompleted, ')
          ..write('calibrationTargetSessions: $calibrationTargetSessions, ')
          ..write('unlockedMoveIds: $unlockedMoveIds, ')
          ..write('maxPp: $maxPp, ')
          ..write('currentPp: $currentPp, ')
          ..write('potionCount: $potionCount, ')
          ..write('etherCount: $etherCount, ')
          ..write('rareCandyCount: $rareCandyCount, ')
          ..write('coins: $coins, ')
          ..write('exerciseFiveRms: $exerciseFiveRms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        level,
        experiencePoints,
        gender,
        bodyWeightKg,
        squatFiveRm,
        benchPressFiveRm,
        deadliftFiveRm,
        overheadPressFiveRm,
        weeklyFrequency,
        isBeginnerMode,
        calibrationSessionsCompleted,
        calibrationTargetSessions,
        unlockedMoveIds,
        maxPp,
        currentPp,
        potionCount,
        etherCount,
        rareCandyCount,
        coins,
        exerciseFiveRms
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileEntity &&
          other.id == this.id &&
          other.level == this.level &&
          other.experiencePoints == this.experiencePoints &&
          other.gender == this.gender &&
          other.bodyWeightKg == this.bodyWeightKg &&
          other.squatFiveRm == this.squatFiveRm &&
          other.benchPressFiveRm == this.benchPressFiveRm &&
          other.deadliftFiveRm == this.deadliftFiveRm &&
          other.overheadPressFiveRm == this.overheadPressFiveRm &&
          other.weeklyFrequency == this.weeklyFrequency &&
          other.isBeginnerMode == this.isBeginnerMode &&
          other.calibrationSessionsCompleted ==
              this.calibrationSessionsCompleted &&
          other.calibrationTargetSessions == this.calibrationTargetSessions &&
          other.unlockedMoveIds == this.unlockedMoveIds &&
          other.maxPp == this.maxPp &&
          other.currentPp == this.currentPp &&
          other.potionCount == this.potionCount &&
          other.etherCount == this.etherCount &&
          other.rareCandyCount == this.rareCandyCount &&
          other.coins == this.coins &&
          other.exerciseFiveRms == this.exerciseFiveRms);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfileEntity> {
  final Value<int> id;
  final Value<int> level;
  final Value<int> experiencePoints;
  final Value<String> gender;
  final Value<double> bodyWeightKg;
  final Value<double> squatFiveRm;
  final Value<double> benchPressFiveRm;
  final Value<double> deadliftFiveRm;
  final Value<double> overheadPressFiveRm;
  final Value<int> weeklyFrequency;
  final Value<bool> isBeginnerMode;
  final Value<int> calibrationSessionsCompleted;
  final Value<int> calibrationTargetSessions;
  final Value<String> unlockedMoveIds;
  final Value<int> maxPp;
  final Value<int> currentPp;
  final Value<int> potionCount;
  final Value<int> etherCount;
  final Value<int> rareCandyCount;
  final Value<int> coins;
  final Value<String> exerciseFiveRms;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.experiencePoints = const Value.absent(),
    this.gender = const Value.absent(),
    this.bodyWeightKg = const Value.absent(),
    this.squatFiveRm = const Value.absent(),
    this.benchPressFiveRm = const Value.absent(),
    this.deadliftFiveRm = const Value.absent(),
    this.overheadPressFiveRm = const Value.absent(),
    this.weeklyFrequency = const Value.absent(),
    this.isBeginnerMode = const Value.absent(),
    this.calibrationSessionsCompleted = const Value.absent(),
    this.calibrationTargetSessions = const Value.absent(),
    this.unlockedMoveIds = const Value.absent(),
    this.maxPp = const Value.absent(),
    this.currentPp = const Value.absent(),
    this.potionCount = const Value.absent(),
    this.etherCount = const Value.absent(),
    this.rareCandyCount = const Value.absent(),
    this.coins = const Value.absent(),
    this.exerciseFiveRms = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.experiencePoints = const Value.absent(),
    this.gender = const Value.absent(),
    this.bodyWeightKg = const Value.absent(),
    this.squatFiveRm = const Value.absent(),
    this.benchPressFiveRm = const Value.absent(),
    this.deadliftFiveRm = const Value.absent(),
    this.overheadPressFiveRm = const Value.absent(),
    this.weeklyFrequency = const Value.absent(),
    this.isBeginnerMode = const Value.absent(),
    this.calibrationSessionsCompleted = const Value.absent(),
    this.calibrationTargetSessions = const Value.absent(),
    this.unlockedMoveIds = const Value.absent(),
    this.maxPp = const Value.absent(),
    this.currentPp = const Value.absent(),
    this.potionCount = const Value.absent(),
    this.etherCount = const Value.absent(),
    this.rareCandyCount = const Value.absent(),
    this.coins = const Value.absent(),
    this.exerciseFiveRms = const Value.absent(),
  });
  static Insertable<UserProfileEntity> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<int>? experiencePoints,
    Expression<String>? gender,
    Expression<double>? bodyWeightKg,
    Expression<double>? squatFiveRm,
    Expression<double>? benchPressFiveRm,
    Expression<double>? deadliftFiveRm,
    Expression<double>? overheadPressFiveRm,
    Expression<int>? weeklyFrequency,
    Expression<bool>? isBeginnerMode,
    Expression<int>? calibrationSessionsCompleted,
    Expression<int>? calibrationTargetSessions,
    Expression<String>? unlockedMoveIds,
    Expression<int>? maxPp,
    Expression<int>? currentPp,
    Expression<int>? potionCount,
    Expression<int>? etherCount,
    Expression<int>? rareCandyCount,
    Expression<int>? coins,
    Expression<String>? exerciseFiveRms,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (experiencePoints != null) 'experience_points': experiencePoints,
      if (gender != null) 'gender': gender,
      if (bodyWeightKg != null) 'body_weight_kg': bodyWeightKg,
      if (squatFiveRm != null) 'squat_five_rm': squatFiveRm,
      if (benchPressFiveRm != null) 'bench_press_five_rm': benchPressFiveRm,
      if (deadliftFiveRm != null) 'deadlift_five_rm': deadliftFiveRm,
      if (overheadPressFiveRm != null)
        'overhead_press_five_rm': overheadPressFiveRm,
      if (weeklyFrequency != null) 'weekly_frequency': weeklyFrequency,
      if (isBeginnerMode != null) 'is_beginner_mode': isBeginnerMode,
      if (calibrationSessionsCompleted != null)
        'calibration_sessions_completed': calibrationSessionsCompleted,
      if (calibrationTargetSessions != null)
        'calibration_target_sessions': calibrationTargetSessions,
      if (unlockedMoveIds != null) 'unlocked_move_ids': unlockedMoveIds,
      if (maxPp != null) 'max_pp': maxPp,
      if (currentPp != null) 'current_pp': currentPp,
      if (potionCount != null) 'potion_count': potionCount,
      if (etherCount != null) 'ether_count': etherCount,
      if (rareCandyCount != null) 'rare_candy_count': rareCandyCount,
      if (coins != null) 'coins': coins,
      if (exerciseFiveRms != null) 'exercise_five_rms': exerciseFiveRms,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? id,
      Value<int>? level,
      Value<int>? experiencePoints,
      Value<String>? gender,
      Value<double>? bodyWeightKg,
      Value<double>? squatFiveRm,
      Value<double>? benchPressFiveRm,
      Value<double>? deadliftFiveRm,
      Value<double>? overheadPressFiveRm,
      Value<int>? weeklyFrequency,
      Value<bool>? isBeginnerMode,
      Value<int>? calibrationSessionsCompleted,
      Value<int>? calibrationTargetSessions,
      Value<String>? unlockedMoveIds,
      Value<int>? maxPp,
      Value<int>? currentPp,
      Value<int>? potionCount,
      Value<int>? etherCount,
      Value<int>? rareCandyCount,
      Value<int>? coins,
      Value<String>? exerciseFiveRms}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      gender: gender ?? this.gender,
      bodyWeightKg: bodyWeightKg ?? this.bodyWeightKg,
      squatFiveRm: squatFiveRm ?? this.squatFiveRm,
      benchPressFiveRm: benchPressFiveRm ?? this.benchPressFiveRm,
      deadliftFiveRm: deadliftFiveRm ?? this.deadliftFiveRm,
      overheadPressFiveRm: overheadPressFiveRm ?? this.overheadPressFiveRm,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      isBeginnerMode: isBeginnerMode ?? this.isBeginnerMode,
      calibrationSessionsCompleted:
          calibrationSessionsCompleted ?? this.calibrationSessionsCompleted,
      calibrationTargetSessions:
          calibrationTargetSessions ?? this.calibrationTargetSessions,
      unlockedMoveIds: unlockedMoveIds ?? this.unlockedMoveIds,
      maxPp: maxPp ?? this.maxPp,
      currentPp: currentPp ?? this.currentPp,
      potionCount: potionCount ?? this.potionCount,
      etherCount: etherCount ?? this.etherCount,
      rareCandyCount: rareCandyCount ?? this.rareCandyCount,
      coins: coins ?? this.coins,
      exerciseFiveRms: exerciseFiveRms ?? this.exerciseFiveRms,
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
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (bodyWeightKg.present) {
      map['body_weight_kg'] = Variable<double>(bodyWeightKg.value);
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
    if (calibrationSessionsCompleted.present) {
      map['calibration_sessions_completed'] =
          Variable<int>(calibrationSessionsCompleted.value);
    }
    if (calibrationTargetSessions.present) {
      map['calibration_target_sessions'] =
          Variable<int>(calibrationTargetSessions.value);
    }
    if (unlockedMoveIds.present) {
      map['unlocked_move_ids'] = Variable<String>(unlockedMoveIds.value);
    }
    if (maxPp.present) {
      map['max_pp'] = Variable<int>(maxPp.value);
    }
    if (currentPp.present) {
      map['current_pp'] = Variable<int>(currentPp.value);
    }
    if (potionCount.present) {
      map['potion_count'] = Variable<int>(potionCount.value);
    }
    if (etherCount.present) {
      map['ether_count'] = Variable<int>(etherCount.value);
    }
    if (rareCandyCount.present) {
      map['rare_candy_count'] = Variable<int>(rareCandyCount.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (exerciseFiveRms.present) {
      map['exercise_five_rms'] = Variable<String>(exerciseFiveRms.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('experiencePoints: $experiencePoints, ')
          ..write('gender: $gender, ')
          ..write('bodyWeightKg: $bodyWeightKg, ')
          ..write('squatFiveRm: $squatFiveRm, ')
          ..write('benchPressFiveRm: $benchPressFiveRm, ')
          ..write('deadliftFiveRm: $deadliftFiveRm, ')
          ..write('overheadPressFiveRm: $overheadPressFiveRm, ')
          ..write('weeklyFrequency: $weeklyFrequency, ')
          ..write('isBeginnerMode: $isBeginnerMode, ')
          ..write(
              'calibrationSessionsCompleted: $calibrationSessionsCompleted, ')
          ..write('calibrationTargetSessions: $calibrationTargetSessions, ')
          ..write('unlockedMoveIds: $unlockedMoveIds, ')
          ..write('maxPp: $maxPp, ')
          ..write('currentPp: $currentPp, ')
          ..write('potionCount: $potionCount, ')
          ..write('etherCount: $etherCount, ')
          ..write('rareCandyCount: $rareCandyCount, ')
          ..write('coins: $coins, ')
          ..write('exerciseFiveRms: $exerciseFiveRms')
          ..write(')'))
        .toString();
  }
}

class $BattleStatesTable extends BattleStates
    with TableInfo<$BattleStatesTable, BattleStateEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BattleStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _phaseJsonMeta =
      const VerificationMeta('phaseJson');
  @override
  late final GeneratedColumn<String> phaseJson = GeneratedColumn<String>(
      'phase_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bossesJsonMeta =
      const VerificationMeta('bossesJson');
  @override
  late final GeneratedColumn<String> bossesJson = GeneratedColumn<String>(
      'bosses_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentBossIndexMeta =
      const VerificationMeta('currentBossIndex');
  @override
  late final GeneratedColumn<int> currentBossIndex = GeneratedColumn<int>(
      'current_boss_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _playerHpMeta =
      const VerificationMeta('playerHp');
  @override
  late final GeneratedColumn<int> playerHp = GeneratedColumn<int>(
      'player_hp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _maxPlayerHpMeta =
      const VerificationMeta('maxPlayerHp');
  @override
  late final GeneratedColumn<int> maxPlayerHp = GeneratedColumn<int>(
      'max_player_hp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _completedSetsJsonMeta =
      const VerificationMeta('completedSetsJson');
  @override
  late final GeneratedColumn<String> completedSetsJson =
      GeneratedColumn<String>('completed_sets_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _damageResultsJsonMeta =
      const VerificationMeta('damageResultsJson');
  @override
  late final GeneratedColumn<String> damageResultsJson =
      GeneratedColumn<String>('damage_results_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _selectedMoveIdMeta =
      const VerificationMeta('selectedMoveId');
  @override
  late final GeneratedColumn<String> selectedMoveId = GeneratedColumn<String>(
      'selected_move_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gymTypeValueMeta =
      const VerificationMeta('gymTypeValue');
  @override
  late final GeneratedColumn<String> gymTypeValue = GeneratedColumn<String>(
      'gym_type_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playerMuscleTypeValueMeta =
      const VerificationMeta('playerMuscleTypeValue');
  @override
  late final GeneratedColumn<String> playerMuscleTypeValue =
      GeneratedColumn<String>('player_muscle_type_value', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalDamageDealtMeta =
      const VerificationMeta('totalDamageDealt');
  @override
  late final GeneratedColumn<int> totalDamageDealt = GeneratedColumn<int>(
      'total_damage_dealt', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phaseJson,
        bossesJson,
        currentBossIndex,
        playerHp,
        maxPlayerHp,
        completedSetsJson,
        damageResultsJson,
        selectedMoveId,
        gymTypeValue,
        playerMuscleTypeValue,
        totalDamageDealt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'battle_states';
  @override
  VerificationContext validateIntegrity(Insertable<BattleStateEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phase_json')) {
      context.handle(_phaseJsonMeta,
          phaseJson.isAcceptableOrUnknown(data['phase_json']!, _phaseJsonMeta));
    } else if (isInserting) {
      context.missing(_phaseJsonMeta);
    }
    if (data.containsKey('bosses_json')) {
      context.handle(
          _bossesJsonMeta,
          bossesJson.isAcceptableOrUnknown(
              data['bosses_json']!, _bossesJsonMeta));
    } else if (isInserting) {
      context.missing(_bossesJsonMeta);
    }
    if (data.containsKey('current_boss_index')) {
      context.handle(
          _currentBossIndexMeta,
          currentBossIndex.isAcceptableOrUnknown(
              data['current_boss_index']!, _currentBossIndexMeta));
    }
    if (data.containsKey('player_hp')) {
      context.handle(_playerHpMeta,
          playerHp.isAcceptableOrUnknown(data['player_hp']!, _playerHpMeta));
    }
    if (data.containsKey('max_player_hp')) {
      context.handle(
          _maxPlayerHpMeta,
          maxPlayerHp.isAcceptableOrUnknown(
              data['max_player_hp']!, _maxPlayerHpMeta));
    }
    if (data.containsKey('completed_sets_json')) {
      context.handle(
          _completedSetsJsonMeta,
          completedSetsJson.isAcceptableOrUnknown(
              data['completed_sets_json']!, _completedSetsJsonMeta));
    }
    if (data.containsKey('damage_results_json')) {
      context.handle(
          _damageResultsJsonMeta,
          damageResultsJson.isAcceptableOrUnknown(
              data['damage_results_json']!, _damageResultsJsonMeta));
    }
    if (data.containsKey('selected_move_id')) {
      context.handle(
          _selectedMoveIdMeta,
          selectedMoveId.isAcceptableOrUnknown(
              data['selected_move_id']!, _selectedMoveIdMeta));
    }
    if (data.containsKey('gym_type_value')) {
      context.handle(
          _gymTypeValueMeta,
          gymTypeValue.isAcceptableOrUnknown(
              data['gym_type_value']!, _gymTypeValueMeta));
    } else if (isInserting) {
      context.missing(_gymTypeValueMeta);
    }
    if (data.containsKey('player_muscle_type_value')) {
      context.handle(
          _playerMuscleTypeValueMeta,
          playerMuscleTypeValue.isAcceptableOrUnknown(
              data['player_muscle_type_value']!, _playerMuscleTypeValueMeta));
    } else if (isInserting) {
      context.missing(_playerMuscleTypeValueMeta);
    }
    if (data.containsKey('total_damage_dealt')) {
      context.handle(
          _totalDamageDealtMeta,
          totalDamageDealt.isAcceptableOrUnknown(
              data['total_damage_dealt']!, _totalDamageDealtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BattleStateEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BattleStateEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      phaseJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phase_json'])!,
      bossesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bosses_json'])!,
      currentBossIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_boss_index'])!,
      playerHp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}player_hp'])!,
      maxPlayerHp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_player_hp'])!,
      completedSetsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completed_sets_json'])!,
      damageResultsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}damage_results_json'])!,
      selectedMoveId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}selected_move_id']),
      gymTypeValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gym_type_value'])!,
      playerMuscleTypeValue: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}player_muscle_type_value'])!,
      totalDamageDealt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_damage_dealt'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BattleStatesTable createAlias(String alias) {
    return $BattleStatesTable(attachedDatabase, alias);
  }
}

class BattleStateEntity extends DataClass
    implements Insertable<BattleStateEntity> {
  /// Auto-increment primary key.
  final int id;

  /// Serialized BattlePhase as JSON.
  final String phaseJson;

  /// Serialized boss list as JSON.
  final String bossesJson;

  /// Index of current boss (0-2).
  final int currentBossIndex;

  /// Current player HP.
  final int playerHp;

  /// Maximum player HP.
  final int maxPlayerHp;

  /// Serialized completed sets as JSON.
  final String completedSetsJson;

  /// Serialized damage results as JSON.
  final String damageResultsJson;

  /// Currently selected move ID.
  final String? selectedMoveId;

  /// Gym type value string.
  final String gymTypeValue;

  /// Player muscle type value string.
  final String playerMuscleTypeValue;

  /// Total damage dealt.
  final int totalDamageDealt;

  /// Row creation timestamp.
  final DateTime createdAt;

  /// Last update timestamp.
  final DateTime updatedAt;
  const BattleStateEntity(
      {required this.id,
      required this.phaseJson,
      required this.bossesJson,
      required this.currentBossIndex,
      required this.playerHp,
      required this.maxPlayerHp,
      required this.completedSetsJson,
      required this.damageResultsJson,
      this.selectedMoveId,
      required this.gymTypeValue,
      required this.playerMuscleTypeValue,
      required this.totalDamageDealt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phase_json'] = Variable<String>(phaseJson);
    map['bosses_json'] = Variable<String>(bossesJson);
    map['current_boss_index'] = Variable<int>(currentBossIndex);
    map['player_hp'] = Variable<int>(playerHp);
    map['max_player_hp'] = Variable<int>(maxPlayerHp);
    map['completed_sets_json'] = Variable<String>(completedSetsJson);
    map['damage_results_json'] = Variable<String>(damageResultsJson);
    if (!nullToAbsent || selectedMoveId != null) {
      map['selected_move_id'] = Variable<String>(selectedMoveId);
    }
    map['gym_type_value'] = Variable<String>(gymTypeValue);
    map['player_muscle_type_value'] = Variable<String>(playerMuscleTypeValue);
    map['total_damage_dealt'] = Variable<int>(totalDamageDealt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BattleStatesCompanion toCompanion(bool nullToAbsent) {
    return BattleStatesCompanion(
      id: Value(id),
      phaseJson: Value(phaseJson),
      bossesJson: Value(bossesJson),
      currentBossIndex: Value(currentBossIndex),
      playerHp: Value(playerHp),
      maxPlayerHp: Value(maxPlayerHp),
      completedSetsJson: Value(completedSetsJson),
      damageResultsJson: Value(damageResultsJson),
      selectedMoveId: selectedMoveId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedMoveId),
      gymTypeValue: Value(gymTypeValue),
      playerMuscleTypeValue: Value(playerMuscleTypeValue),
      totalDamageDealt: Value(totalDamageDealt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BattleStateEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BattleStateEntity(
      id: serializer.fromJson<int>(json['id']),
      phaseJson: serializer.fromJson<String>(json['phaseJson']),
      bossesJson: serializer.fromJson<String>(json['bossesJson']),
      currentBossIndex: serializer.fromJson<int>(json['currentBossIndex']),
      playerHp: serializer.fromJson<int>(json['playerHp']),
      maxPlayerHp: serializer.fromJson<int>(json['maxPlayerHp']),
      completedSetsJson: serializer.fromJson<String>(json['completedSetsJson']),
      damageResultsJson: serializer.fromJson<String>(json['damageResultsJson']),
      selectedMoveId: serializer.fromJson<String?>(json['selectedMoveId']),
      gymTypeValue: serializer.fromJson<String>(json['gymTypeValue']),
      playerMuscleTypeValue:
          serializer.fromJson<String>(json['playerMuscleTypeValue']),
      totalDamageDealt: serializer.fromJson<int>(json['totalDamageDealt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phaseJson': serializer.toJson<String>(phaseJson),
      'bossesJson': serializer.toJson<String>(bossesJson),
      'currentBossIndex': serializer.toJson<int>(currentBossIndex),
      'playerHp': serializer.toJson<int>(playerHp),
      'maxPlayerHp': serializer.toJson<int>(maxPlayerHp),
      'completedSetsJson': serializer.toJson<String>(completedSetsJson),
      'damageResultsJson': serializer.toJson<String>(damageResultsJson),
      'selectedMoveId': serializer.toJson<String?>(selectedMoveId),
      'gymTypeValue': serializer.toJson<String>(gymTypeValue),
      'playerMuscleTypeValue': serializer.toJson<String>(playerMuscleTypeValue),
      'totalDamageDealt': serializer.toJson<int>(totalDamageDealt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BattleStateEntity copyWith(
          {int? id,
          String? phaseJson,
          String? bossesJson,
          int? currentBossIndex,
          int? playerHp,
          int? maxPlayerHp,
          String? completedSetsJson,
          String? damageResultsJson,
          Value<String?> selectedMoveId = const Value.absent(),
          String? gymTypeValue,
          String? playerMuscleTypeValue,
          int? totalDamageDealt,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BattleStateEntity(
        id: id ?? this.id,
        phaseJson: phaseJson ?? this.phaseJson,
        bossesJson: bossesJson ?? this.bossesJson,
        currentBossIndex: currentBossIndex ?? this.currentBossIndex,
        playerHp: playerHp ?? this.playerHp,
        maxPlayerHp: maxPlayerHp ?? this.maxPlayerHp,
        completedSetsJson: completedSetsJson ?? this.completedSetsJson,
        damageResultsJson: damageResultsJson ?? this.damageResultsJson,
        selectedMoveId:
            selectedMoveId.present ? selectedMoveId.value : this.selectedMoveId,
        gymTypeValue: gymTypeValue ?? this.gymTypeValue,
        playerMuscleTypeValue:
            playerMuscleTypeValue ?? this.playerMuscleTypeValue,
        totalDamageDealt: totalDamageDealt ?? this.totalDamageDealt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BattleStateEntity copyWithCompanion(BattleStatesCompanion data) {
    return BattleStateEntity(
      id: data.id.present ? data.id.value : this.id,
      phaseJson: data.phaseJson.present ? data.phaseJson.value : this.phaseJson,
      bossesJson:
          data.bossesJson.present ? data.bossesJson.value : this.bossesJson,
      currentBossIndex: data.currentBossIndex.present
          ? data.currentBossIndex.value
          : this.currentBossIndex,
      playerHp: data.playerHp.present ? data.playerHp.value : this.playerHp,
      maxPlayerHp:
          data.maxPlayerHp.present ? data.maxPlayerHp.value : this.maxPlayerHp,
      completedSetsJson: data.completedSetsJson.present
          ? data.completedSetsJson.value
          : this.completedSetsJson,
      damageResultsJson: data.damageResultsJson.present
          ? data.damageResultsJson.value
          : this.damageResultsJson,
      selectedMoveId: data.selectedMoveId.present
          ? data.selectedMoveId.value
          : this.selectedMoveId,
      gymTypeValue: data.gymTypeValue.present
          ? data.gymTypeValue.value
          : this.gymTypeValue,
      playerMuscleTypeValue: data.playerMuscleTypeValue.present
          ? data.playerMuscleTypeValue.value
          : this.playerMuscleTypeValue,
      totalDamageDealt: data.totalDamageDealt.present
          ? data.totalDamageDealt.value
          : this.totalDamageDealt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BattleStateEntity(')
          ..write('id: $id, ')
          ..write('phaseJson: $phaseJson, ')
          ..write('bossesJson: $bossesJson, ')
          ..write('currentBossIndex: $currentBossIndex, ')
          ..write('playerHp: $playerHp, ')
          ..write('maxPlayerHp: $maxPlayerHp, ')
          ..write('completedSetsJson: $completedSetsJson, ')
          ..write('damageResultsJson: $damageResultsJson, ')
          ..write('selectedMoveId: $selectedMoveId, ')
          ..write('gymTypeValue: $gymTypeValue, ')
          ..write('playerMuscleTypeValue: $playerMuscleTypeValue, ')
          ..write('totalDamageDealt: $totalDamageDealt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      phaseJson,
      bossesJson,
      currentBossIndex,
      playerHp,
      maxPlayerHp,
      completedSetsJson,
      damageResultsJson,
      selectedMoveId,
      gymTypeValue,
      playerMuscleTypeValue,
      totalDamageDealt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleStateEntity &&
          other.id == this.id &&
          other.phaseJson == this.phaseJson &&
          other.bossesJson == this.bossesJson &&
          other.currentBossIndex == this.currentBossIndex &&
          other.playerHp == this.playerHp &&
          other.maxPlayerHp == this.maxPlayerHp &&
          other.completedSetsJson == this.completedSetsJson &&
          other.damageResultsJson == this.damageResultsJson &&
          other.selectedMoveId == this.selectedMoveId &&
          other.gymTypeValue == this.gymTypeValue &&
          other.playerMuscleTypeValue == this.playerMuscleTypeValue &&
          other.totalDamageDealt == this.totalDamageDealt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BattleStatesCompanion extends UpdateCompanion<BattleStateEntity> {
  final Value<int> id;
  final Value<String> phaseJson;
  final Value<String> bossesJson;
  final Value<int> currentBossIndex;
  final Value<int> playerHp;
  final Value<int> maxPlayerHp;
  final Value<String> completedSetsJson;
  final Value<String> damageResultsJson;
  final Value<String?> selectedMoveId;
  final Value<String> gymTypeValue;
  final Value<String> playerMuscleTypeValue;
  final Value<int> totalDamageDealt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BattleStatesCompanion({
    this.id = const Value.absent(),
    this.phaseJson = const Value.absent(),
    this.bossesJson = const Value.absent(),
    this.currentBossIndex = const Value.absent(),
    this.playerHp = const Value.absent(),
    this.maxPlayerHp = const Value.absent(),
    this.completedSetsJson = const Value.absent(),
    this.damageResultsJson = const Value.absent(),
    this.selectedMoveId = const Value.absent(),
    this.gymTypeValue = const Value.absent(),
    this.playerMuscleTypeValue = const Value.absent(),
    this.totalDamageDealt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BattleStatesCompanion.insert({
    this.id = const Value.absent(),
    required String phaseJson,
    required String bossesJson,
    this.currentBossIndex = const Value.absent(),
    this.playerHp = const Value.absent(),
    this.maxPlayerHp = const Value.absent(),
    this.completedSetsJson = const Value.absent(),
    this.damageResultsJson = const Value.absent(),
    this.selectedMoveId = const Value.absent(),
    required String gymTypeValue,
    required String playerMuscleTypeValue,
    this.totalDamageDealt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : phaseJson = Value(phaseJson),
        bossesJson = Value(bossesJson),
        gymTypeValue = Value(gymTypeValue),
        playerMuscleTypeValue = Value(playerMuscleTypeValue);
  static Insertable<BattleStateEntity> custom({
    Expression<int>? id,
    Expression<String>? phaseJson,
    Expression<String>? bossesJson,
    Expression<int>? currentBossIndex,
    Expression<int>? playerHp,
    Expression<int>? maxPlayerHp,
    Expression<String>? completedSetsJson,
    Expression<String>? damageResultsJson,
    Expression<String>? selectedMoveId,
    Expression<String>? gymTypeValue,
    Expression<String>? playerMuscleTypeValue,
    Expression<int>? totalDamageDealt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phaseJson != null) 'phase_json': phaseJson,
      if (bossesJson != null) 'bosses_json': bossesJson,
      if (currentBossIndex != null) 'current_boss_index': currentBossIndex,
      if (playerHp != null) 'player_hp': playerHp,
      if (maxPlayerHp != null) 'max_player_hp': maxPlayerHp,
      if (completedSetsJson != null) 'completed_sets_json': completedSetsJson,
      if (damageResultsJson != null) 'damage_results_json': damageResultsJson,
      if (selectedMoveId != null) 'selected_move_id': selectedMoveId,
      if (gymTypeValue != null) 'gym_type_value': gymTypeValue,
      if (playerMuscleTypeValue != null)
        'player_muscle_type_value': playerMuscleTypeValue,
      if (totalDamageDealt != null) 'total_damage_dealt': totalDamageDealt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BattleStatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? phaseJson,
      Value<String>? bossesJson,
      Value<int>? currentBossIndex,
      Value<int>? playerHp,
      Value<int>? maxPlayerHp,
      Value<String>? completedSetsJson,
      Value<String>? damageResultsJson,
      Value<String?>? selectedMoveId,
      Value<String>? gymTypeValue,
      Value<String>? playerMuscleTypeValue,
      Value<int>? totalDamageDealt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return BattleStatesCompanion(
      id: id ?? this.id,
      phaseJson: phaseJson ?? this.phaseJson,
      bossesJson: bossesJson ?? this.bossesJson,
      currentBossIndex: currentBossIndex ?? this.currentBossIndex,
      playerHp: playerHp ?? this.playerHp,
      maxPlayerHp: maxPlayerHp ?? this.maxPlayerHp,
      completedSetsJson: completedSetsJson ?? this.completedSetsJson,
      damageResultsJson: damageResultsJson ?? this.damageResultsJson,
      selectedMoveId: selectedMoveId ?? this.selectedMoveId,
      gymTypeValue: gymTypeValue ?? this.gymTypeValue,
      playerMuscleTypeValue:
          playerMuscleTypeValue ?? this.playerMuscleTypeValue,
      totalDamageDealt: totalDamageDealt ?? this.totalDamageDealt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phaseJson.present) {
      map['phase_json'] = Variable<String>(phaseJson.value);
    }
    if (bossesJson.present) {
      map['bosses_json'] = Variable<String>(bossesJson.value);
    }
    if (currentBossIndex.present) {
      map['current_boss_index'] = Variable<int>(currentBossIndex.value);
    }
    if (playerHp.present) {
      map['player_hp'] = Variable<int>(playerHp.value);
    }
    if (maxPlayerHp.present) {
      map['max_player_hp'] = Variable<int>(maxPlayerHp.value);
    }
    if (completedSetsJson.present) {
      map['completed_sets_json'] = Variable<String>(completedSetsJson.value);
    }
    if (damageResultsJson.present) {
      map['damage_results_json'] = Variable<String>(damageResultsJson.value);
    }
    if (selectedMoveId.present) {
      map['selected_move_id'] = Variable<String>(selectedMoveId.value);
    }
    if (gymTypeValue.present) {
      map['gym_type_value'] = Variable<String>(gymTypeValue.value);
    }
    if (playerMuscleTypeValue.present) {
      map['player_muscle_type_value'] =
          Variable<String>(playerMuscleTypeValue.value);
    }
    if (totalDamageDealt.present) {
      map['total_damage_dealt'] = Variable<int>(totalDamageDealt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BattleStatesCompanion(')
          ..write('id: $id, ')
          ..write('phaseJson: $phaseJson, ')
          ..write('bossesJson: $bossesJson, ')
          ..write('currentBossIndex: $currentBossIndex, ')
          ..write('playerHp: $playerHp, ')
          ..write('maxPlayerHp: $maxPlayerHp, ')
          ..write('completedSetsJson: $completedSetsJson, ')
          ..write('damageResultsJson: $damageResultsJson, ')
          ..write('selectedMoveId: $selectedMoveId, ')
          ..write('gymTypeValue: $gymTypeValue, ')
          ..write('playerMuscleTypeValue: $playerMuscleTypeValue, ')
          ..write('totalDamageDealt: $totalDamageDealt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _gymTypeMeta =
      const VerificationMeta('gymType');
  @override
  late final GeneratedColumn<String> gymType = GeneratedColumn<String>(
      'gym_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _muscleTypeMeta =
      const VerificationMeta('muscleType');
  @override
  late final GeneratedColumn<String> muscleType = GeneratedColumn<String>(
      'muscle_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalVolumeMeta =
      const VerificationMeta('totalVolume');
  @override
  late final GeneratedColumn<double> totalVolume = GeneratedColumn<double>(
      'total_volume', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalDamageMeta =
      const VerificationMeta('totalDamage');
  @override
  late final GeneratedColumn<int> totalDamage = GeneratedColumn<int>(
      'total_damage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalSetsMeta =
      const VerificationMeta('totalSets');
  @override
  late final GeneratedColumn<int> totalSets = GeneratedColumn<int>(
      'total_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isVictoryMeta =
      const VerificationMeta('isVictory');
  @override
  late final GeneratedColumn<bool> isVictory = GeneratedColumn<bool>(
      'is_victory', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_victory" IN (0, 1))'));
  static const VerificationMeta _expEarnedMeta =
      const VerificationMeta('expEarned');
  @override
  late final GeneratedColumn<int> expEarned = GeneratedColumn<int>(
      'exp_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        gymType,
        muscleType,
        totalVolume,
        totalDamage,
        totalSets,
        isVictory,
        expEarned,
        durationSeconds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutSessionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('gym_type')) {
      context.handle(_gymTypeMeta,
          gymType.isAcceptableOrUnknown(data['gym_type']!, _gymTypeMeta));
    } else if (isInserting) {
      context.missing(_gymTypeMeta);
    }
    if (data.containsKey('muscle_type')) {
      context.handle(
          _muscleTypeMeta,
          muscleType.isAcceptableOrUnknown(
              data['muscle_type']!, _muscleTypeMeta));
    } else if (isInserting) {
      context.missing(_muscleTypeMeta);
    }
    if (data.containsKey('total_volume')) {
      context.handle(
          _totalVolumeMeta,
          totalVolume.isAcceptableOrUnknown(
              data['total_volume']!, _totalVolumeMeta));
    } else if (isInserting) {
      context.missing(_totalVolumeMeta);
    }
    if (data.containsKey('total_damage')) {
      context.handle(
          _totalDamageMeta,
          totalDamage.isAcceptableOrUnknown(
              data['total_damage']!, _totalDamageMeta));
    } else if (isInserting) {
      context.missing(_totalDamageMeta);
    }
    if (data.containsKey('total_sets')) {
      context.handle(_totalSetsMeta,
          totalSets.isAcceptableOrUnknown(data['total_sets']!, _totalSetsMeta));
    } else if (isInserting) {
      context.missing(_totalSetsMeta);
    }
    if (data.containsKey('is_victory')) {
      context.handle(_isVictoryMeta,
          isVictory.isAcceptableOrUnknown(data['is_victory']!, _isVictoryMeta));
    } else if (isInserting) {
      context.missing(_isVictoryMeta);
    }
    if (data.containsKey('exp_earned')) {
      context.handle(_expEarnedMeta,
          expEarned.isAcceptableOrUnknown(data['exp_earned']!, _expEarnedMeta));
    } else if (isInserting) {
      context.missing(_expEarnedMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      gymType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gym_type'])!,
      muscleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}muscle_type'])!,
      totalVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_volume'])!,
      totalDamage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_damage'])!,
      totalSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_sets'])!,
      isVictory: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_victory'])!,
      expEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exp_earned'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSessionEntity extends DataClass
    implements Insertable<WorkoutSessionEntity> {
  /// Auto-increment primary key.
  final int id;

  /// Session date/time.
  final DateTime date;

  /// Gym type value string.
  final String gymType;

  /// Player muscle type value string.
  final String muscleType;

  /// Total volume (weight × reps) in kg.
  final double totalVolume;

  /// Total damage dealt.
  final int totalDamage;

  /// Total sets completed.
  final int totalSets;

  /// Whether the player won.
  final bool isVictory;

  /// EXP earned from this session.
  final int expEarned;

  /// Session duration in seconds (optional).
  final int? durationSeconds;
  const WorkoutSessionEntity(
      {required this.id,
      required this.date,
      required this.gymType,
      required this.muscleType,
      required this.totalVolume,
      required this.totalDamage,
      required this.totalSets,
      required this.isVictory,
      required this.expEarned,
      this.durationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['gym_type'] = Variable<String>(gymType);
    map['muscle_type'] = Variable<String>(muscleType);
    map['total_volume'] = Variable<double>(totalVolume);
    map['total_damage'] = Variable<int>(totalDamage);
    map['total_sets'] = Variable<int>(totalSets);
    map['is_victory'] = Variable<bool>(isVictory);
    map['exp_earned'] = Variable<int>(expEarned);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      date: Value(date),
      gymType: Value(gymType),
      muscleType: Value(muscleType),
      totalVolume: Value(totalVolume),
      totalDamage: Value(totalDamage),
      totalSets: Value(totalSets),
      isVictory: Value(isVictory),
      expEarned: Value(expEarned),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
    );
  }

  factory WorkoutSessionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionEntity(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      gymType: serializer.fromJson<String>(json['gymType']),
      muscleType: serializer.fromJson<String>(json['muscleType']),
      totalVolume: serializer.fromJson<double>(json['totalVolume']),
      totalDamage: serializer.fromJson<int>(json['totalDamage']),
      totalSets: serializer.fromJson<int>(json['totalSets']),
      isVictory: serializer.fromJson<bool>(json['isVictory']),
      expEarned: serializer.fromJson<int>(json['expEarned']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'gymType': serializer.toJson<String>(gymType),
      'muscleType': serializer.toJson<String>(muscleType),
      'totalVolume': serializer.toJson<double>(totalVolume),
      'totalDamage': serializer.toJson<int>(totalDamage),
      'totalSets': serializer.toJson<int>(totalSets),
      'isVictory': serializer.toJson<bool>(isVictory),
      'expEarned': serializer.toJson<int>(expEarned),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
    };
  }

  WorkoutSessionEntity copyWith(
          {int? id,
          DateTime? date,
          String? gymType,
          String? muscleType,
          double? totalVolume,
          int? totalDamage,
          int? totalSets,
          bool? isVictory,
          int? expEarned,
          Value<int?> durationSeconds = const Value.absent()}) =>
      WorkoutSessionEntity(
        id: id ?? this.id,
        date: date ?? this.date,
        gymType: gymType ?? this.gymType,
        muscleType: muscleType ?? this.muscleType,
        totalVolume: totalVolume ?? this.totalVolume,
        totalDamage: totalDamage ?? this.totalDamage,
        totalSets: totalSets ?? this.totalSets,
        isVictory: isVictory ?? this.isVictory,
        expEarned: expEarned ?? this.expEarned,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
      );
  WorkoutSessionEntity copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSessionEntity(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      gymType: data.gymType.present ? data.gymType.value : this.gymType,
      muscleType:
          data.muscleType.present ? data.muscleType.value : this.muscleType,
      totalVolume:
          data.totalVolume.present ? data.totalVolume.value : this.totalVolume,
      totalDamage:
          data.totalDamage.present ? data.totalDamage.value : this.totalDamage,
      totalSets: data.totalSets.present ? data.totalSets.value : this.totalSets,
      isVictory: data.isVictory.present ? data.isVictory.value : this.isVictory,
      expEarned: data.expEarned.present ? data.expEarned.value : this.expEarned,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionEntity(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('gymType: $gymType, ')
          ..write('muscleType: $muscleType, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('totalDamage: $totalDamage, ')
          ..write('totalSets: $totalSets, ')
          ..write('isVictory: $isVictory, ')
          ..write('expEarned: $expEarned, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, gymType, muscleType, totalVolume,
      totalDamage, totalSets, isVictory, expEarned, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionEntity &&
          other.id == this.id &&
          other.date == this.date &&
          other.gymType == this.gymType &&
          other.muscleType == this.muscleType &&
          other.totalVolume == this.totalVolume &&
          other.totalDamage == this.totalDamage &&
          other.totalSets == this.totalSets &&
          other.isVictory == this.isVictory &&
          other.expEarned == this.expEarned &&
          other.durationSeconds == this.durationSeconds);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSessionEntity> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> gymType;
  final Value<String> muscleType;
  final Value<double> totalVolume;
  final Value<int> totalDamage;
  final Value<int> totalSets;
  final Value<bool> isVictory;
  final Value<int> expEarned;
  final Value<int?> durationSeconds;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.gymType = const Value.absent(),
    this.muscleType = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.totalDamage = const Value.absent(),
    this.totalSets = const Value.absent(),
    this.isVictory = const Value.absent(),
    this.expEarned = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String gymType,
    required String muscleType,
    required double totalVolume,
    required int totalDamage,
    required int totalSets,
    required bool isVictory,
    required int expEarned,
    this.durationSeconds = const Value.absent(),
  })  : date = Value(date),
        gymType = Value(gymType),
        muscleType = Value(muscleType),
        totalVolume = Value(totalVolume),
        totalDamage = Value(totalDamage),
        totalSets = Value(totalSets),
        isVictory = Value(isVictory),
        expEarned = Value(expEarned);
  static Insertable<WorkoutSessionEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? gymType,
    Expression<String>? muscleType,
    Expression<double>? totalVolume,
    Expression<int>? totalDamage,
    Expression<int>? totalSets,
    Expression<bool>? isVictory,
    Expression<int>? expEarned,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (gymType != null) 'gym_type': gymType,
      if (muscleType != null) 'muscle_type': muscleType,
      if (totalVolume != null) 'total_volume': totalVolume,
      if (totalDamage != null) 'total_damage': totalDamage,
      if (totalSets != null) 'total_sets': totalSets,
      if (isVictory != null) 'is_victory': isVictory,
      if (expEarned != null) 'exp_earned': expEarned,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? gymType,
      Value<String>? muscleType,
      Value<double>? totalVolume,
      Value<int>? totalDamage,
      Value<int>? totalSets,
      Value<bool>? isVictory,
      Value<int>? expEarned,
      Value<int?>? durationSeconds}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      gymType: gymType ?? this.gymType,
      muscleType: muscleType ?? this.muscleType,
      totalVolume: totalVolume ?? this.totalVolume,
      totalDamage: totalDamage ?? this.totalDamage,
      totalSets: totalSets ?? this.totalSets,
      isVictory: isVictory ?? this.isVictory,
      expEarned: expEarned ?? this.expEarned,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (gymType.present) {
      map['gym_type'] = Variable<String>(gymType.value);
    }
    if (muscleType.present) {
      map['muscle_type'] = Variable<String>(muscleType.value);
    }
    if (totalVolume.present) {
      map['total_volume'] = Variable<double>(totalVolume.value);
    }
    if (totalDamage.present) {
      map['total_damage'] = Variable<int>(totalDamage.value);
    }
    if (totalSets.present) {
      map['total_sets'] = Variable<int>(totalSets.value);
    }
    if (isVictory.present) {
      map['is_victory'] = Variable<bool>(isVictory.value);
    }
    if (expEarned.present) {
      map['exp_earned'] = Variable<int>(expEarned.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('gymType: $gymType, ')
          ..write('muscleType: $muscleType, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('totalDamage: $totalDamage, ')
          ..write('totalSets: $totalSets, ')
          ..write('isVictory: $isVictory, ')
          ..write('expEarned: $expEarned, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $ExerciseSetsTable extends ExerciseSets
    with TableInfo<$ExerciseSetsTable, ExerciseSetEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_sessions (id)'));
  static const VerificationMeta _moveIdMeta = const VerificationMeta('moveId');
  @override
  late final GeneratedColumn<String> moveId = GeneratedColumn<String>(
      'move_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setNumberMeta =
      const VerificationMeta('setNumber');
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
      'set_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<int> rpe = GeneratedColumn<int>(
      'rpe', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _damageMeta = const VerificationMeta('damage');
  @override
  late final GeneratedColumn<int> damage = GeneratedColumn<int>(
      'damage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, moveId, setNumber, weight, reps, rpe, damage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_sets';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseSetEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('move_id')) {
      context.handle(_moveIdMeta,
          moveId.isAcceptableOrUnknown(data['move_id']!, _moveIdMeta));
    } else if (isInserting) {
      context.missing(_moveIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(_setNumberMeta,
          setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta));
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
          _rpeMeta, rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta));
    } else if (isInserting) {
      context.missing(_rpeMeta);
    }
    if (data.containsKey('damage')) {
      context.handle(_damageMeta,
          damage.isAcceptableOrUnknown(data['damage']!, _damageMeta));
    } else if (isInserting) {
      context.missing(_damageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseSetEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseSetEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      moveId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}move_id'])!,
      setNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_number'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      rpe: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rpe'])!,
      damage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}damage'])!,
    );
  }

  @override
  $ExerciseSetsTable createAlias(String alias) {
    return $ExerciseSetsTable(attachedDatabase, alias);
  }
}

class ExerciseSetEntity extends DataClass
    implements Insertable<ExerciseSetEntity> {
  /// Auto-increment primary key.
  final int id;

  /// Foreign key to WorkoutSessions.
  final int sessionId;

  /// Move ID used for this set.
  final String moveId;

  /// Set number within the session.
  final int setNumber;

  /// Weight lifted in kg.
  final double weight;

  /// Number of reps completed.
  final int reps;

  /// Rate of perceived exertion (1-10).
  final int rpe;

  /// Damage dealt by this set.
  final int damage;
  const ExerciseSetEntity(
      {required this.id,
      required this.sessionId,
      required this.moveId,
      required this.setNumber,
      required this.weight,
      required this.reps,
      required this.rpe,
      required this.damage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['move_id'] = Variable<String>(moveId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight'] = Variable<double>(weight);
    map['reps'] = Variable<int>(reps);
    map['rpe'] = Variable<int>(rpe);
    map['damage'] = Variable<int>(damage);
    return map;
  }

  ExerciseSetsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseSetsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      moveId: Value(moveId),
      setNumber: Value(setNumber),
      weight: Value(weight),
      reps: Value(reps),
      rpe: Value(rpe),
      damage: Value(damage),
    );
  }

  factory ExerciseSetEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseSetEntity(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      moveId: serializer.fromJson<String>(json['moveId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<int>(json['rpe']),
      damage: serializer.fromJson<int>(json['damage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'moveId': serializer.toJson<String>(moveId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double>(weight),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<int>(rpe),
      'damage': serializer.toJson<int>(damage),
    };
  }

  ExerciseSetEntity copyWith(
          {int? id,
          int? sessionId,
          String? moveId,
          int? setNumber,
          double? weight,
          int? reps,
          int? rpe,
          int? damage}) =>
      ExerciseSetEntity(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        moveId: moveId ?? this.moveId,
        setNumber: setNumber ?? this.setNumber,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        rpe: rpe ?? this.rpe,
        damage: damage ?? this.damage,
      );
  ExerciseSetEntity copyWithCompanion(ExerciseSetsCompanion data) {
    return ExerciseSetEntity(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      moveId: data.moveId.present ? data.moveId.value : this.moveId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      damage: data.damage.present ? data.damage.value : this.damage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSetEntity(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('moveId: $moveId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('damage: $damage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, moveId, setNumber, weight, reps, rpe, damage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseSetEntity &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.moveId == this.moveId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.damage == this.damage);
}

class ExerciseSetsCompanion extends UpdateCompanion<ExerciseSetEntity> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> moveId;
  final Value<int> setNumber;
  final Value<double> weight;
  final Value<int> reps;
  final Value<int> rpe;
  final Value<int> damage;
  const ExerciseSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.moveId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.damage = const Value.absent(),
  });
  ExerciseSetsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String moveId,
    required int setNumber,
    required double weight,
    required int reps,
    required int rpe,
    required int damage,
  })  : sessionId = Value(sessionId),
        moveId = Value(moveId),
        setNumber = Value(setNumber),
        weight = Value(weight),
        reps = Value(reps),
        rpe = Value(rpe),
        damage = Value(damage);
  static Insertable<ExerciseSetEntity> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? moveId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<int>? rpe,
    Expression<int>? damage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (moveId != null) 'move_id': moveId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (damage != null) 'damage': damage,
    });
  }

  ExerciseSetsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<String>? moveId,
      Value<int>? setNumber,
      Value<double>? weight,
      Value<int>? reps,
      Value<int>? rpe,
      Value<int>? damage}) {
    return ExerciseSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      moveId: moveId ?? this.moveId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      damage: damage ?? this.damage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (moveId.present) {
      map['move_id'] = Variable<String>(moveId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<int>(rpe.value);
    }
    if (damage.present) {
      map['damage'] = Variable<int>(damage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('moveId: $moveId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('damage: $damage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $BattleStatesTable battleStates = $BattleStatesTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  late final $ExerciseSetsTable exerciseSets = $ExerciseSetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userProfiles, battleStates, workoutSessions, exerciseSets];
}

typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<int> level,
  Value<int> experiencePoints,
  Value<String> gender,
  Value<double> bodyWeightKg,
  Value<double> squatFiveRm,
  Value<double> benchPressFiveRm,
  Value<double> deadliftFiveRm,
  Value<double> overheadPressFiveRm,
  Value<int> weeklyFrequency,
  Value<bool> isBeginnerMode,
  Value<int> calibrationSessionsCompleted,
  Value<int> calibrationTargetSessions,
  Value<String> unlockedMoveIds,
  Value<int> maxPp,
  Value<int> currentPp,
  Value<int> potionCount,
  Value<int> etherCount,
  Value<int> rareCandyCount,
  Value<int> coins,
  Value<String> exerciseFiveRms,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<int> level,
  Value<int> experiencePoints,
  Value<String> gender,
  Value<double> bodyWeightKg,
  Value<double> squatFiveRm,
  Value<double> benchPressFiveRm,
  Value<double> deadliftFiveRm,
  Value<double> overheadPressFiveRm,
  Value<int> weeklyFrequency,
  Value<bool> isBeginnerMode,
  Value<int> calibrationSessionsCompleted,
  Value<int> calibrationTargetSessions,
  Value<String> unlockedMoveIds,
  Value<int> maxPp,
  Value<int> currentPp,
  Value<int> potionCount,
  Value<int> etherCount,
  Value<int> rareCandyCount,
  Value<int> coins,
  Value<String> exerciseFiveRms,
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

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bodyWeightKg => $composableBuilder(
      column: $table.bodyWeightKg, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<int> get calibrationSessionsCompleted => $composableBuilder(
      column: $table.calibrationSessionsCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calibrationTargetSessions => $composableBuilder(
      column: $table.calibrationTargetSessions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unlockedMoveIds => $composableBuilder(
      column: $table.unlockedMoveIds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxPp => $composableBuilder(
      column: $table.maxPp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentPp => $composableBuilder(
      column: $table.currentPp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get potionCount => $composableBuilder(
      column: $table.potionCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get etherCount => $composableBuilder(
      column: $table.etherCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rareCandyCount => $composableBuilder(
      column: $table.rareCandyCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get coins => $composableBuilder(
      column: $table.coins, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseFiveRms => $composableBuilder(
      column: $table.exerciseFiveRms,
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

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bodyWeightKg => $composableBuilder(
      column: $table.bodyWeightKg,
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

  ColumnOrderings<int> get calibrationSessionsCompleted => $composableBuilder(
      column: $table.calibrationSessionsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calibrationTargetSessions => $composableBuilder(
      column: $table.calibrationTargetSessions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unlockedMoveIds => $composableBuilder(
      column: $table.unlockedMoveIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxPp => $composableBuilder(
      column: $table.maxPp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentPp => $composableBuilder(
      column: $table.currentPp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get potionCount => $composableBuilder(
      column: $table.potionCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get etherCount => $composableBuilder(
      column: $table.etherCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rareCandyCount => $composableBuilder(
      column: $table.rareCandyCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get coins => $composableBuilder(
      column: $table.coins, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseFiveRms => $composableBuilder(
      column: $table.exerciseFiveRms,
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

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get bodyWeightKg => $composableBuilder(
      column: $table.bodyWeightKg, builder: (column) => column);

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

  GeneratedColumn<int> get calibrationSessionsCompleted => $composableBuilder(
      column: $table.calibrationSessionsCompleted, builder: (column) => column);

  GeneratedColumn<int> get calibrationTargetSessions => $composableBuilder(
      column: $table.calibrationTargetSessions, builder: (column) => column);

  GeneratedColumn<String> get unlockedMoveIds => $composableBuilder(
      column: $table.unlockedMoveIds, builder: (column) => column);

  GeneratedColumn<int> get maxPp =>
      $composableBuilder(column: $table.maxPp, builder: (column) => column);

  GeneratedColumn<int> get currentPp =>
      $composableBuilder(column: $table.currentPp, builder: (column) => column);

  GeneratedColumn<int> get potionCount => $composableBuilder(
      column: $table.potionCount, builder: (column) => column);

  GeneratedColumn<int> get etherCount => $composableBuilder(
      column: $table.etherCount, builder: (column) => column);

  GeneratedColumn<int> get rareCandyCount => $composableBuilder(
      column: $table.rareCandyCount, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<String> get exerciseFiveRms => $composableBuilder(
      column: $table.exerciseFiveRms, builder: (column) => column);
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
            Value<String> gender = const Value.absent(),
            Value<double> bodyWeightKg = const Value.absent(),
            Value<double> squatFiveRm = const Value.absent(),
            Value<double> benchPressFiveRm = const Value.absent(),
            Value<double> deadliftFiveRm = const Value.absent(),
            Value<double> overheadPressFiveRm = const Value.absent(),
            Value<int> weeklyFrequency = const Value.absent(),
            Value<bool> isBeginnerMode = const Value.absent(),
            Value<int> calibrationSessionsCompleted = const Value.absent(),
            Value<int> calibrationTargetSessions = const Value.absent(),
            Value<String> unlockedMoveIds = const Value.absent(),
            Value<int> maxPp = const Value.absent(),
            Value<int> currentPp = const Value.absent(),
            Value<int> potionCount = const Value.absent(),
            Value<int> etherCount = const Value.absent(),
            Value<int> rareCandyCount = const Value.absent(),
            Value<int> coins = const Value.absent(),
            Value<String> exerciseFiveRms = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            level: level,
            experiencePoints: experiencePoints,
            gender: gender,
            bodyWeightKg: bodyWeightKg,
            squatFiveRm: squatFiveRm,
            benchPressFiveRm: benchPressFiveRm,
            deadliftFiveRm: deadliftFiveRm,
            overheadPressFiveRm: overheadPressFiveRm,
            weeklyFrequency: weeklyFrequency,
            isBeginnerMode: isBeginnerMode,
            calibrationSessionsCompleted: calibrationSessionsCompleted,
            calibrationTargetSessions: calibrationTargetSessions,
            unlockedMoveIds: unlockedMoveIds,
            maxPp: maxPp,
            currentPp: currentPp,
            potionCount: potionCount,
            etherCount: etherCount,
            rareCandyCount: rareCandyCount,
            coins: coins,
            exerciseFiveRms: exerciseFiveRms,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> experiencePoints = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<double> bodyWeightKg = const Value.absent(),
            Value<double> squatFiveRm = const Value.absent(),
            Value<double> benchPressFiveRm = const Value.absent(),
            Value<double> deadliftFiveRm = const Value.absent(),
            Value<double> overheadPressFiveRm = const Value.absent(),
            Value<int> weeklyFrequency = const Value.absent(),
            Value<bool> isBeginnerMode = const Value.absent(),
            Value<int> calibrationSessionsCompleted = const Value.absent(),
            Value<int> calibrationTargetSessions = const Value.absent(),
            Value<String> unlockedMoveIds = const Value.absent(),
            Value<int> maxPp = const Value.absent(),
            Value<int> currentPp = const Value.absent(),
            Value<int> potionCount = const Value.absent(),
            Value<int> etherCount = const Value.absent(),
            Value<int> rareCandyCount = const Value.absent(),
            Value<int> coins = const Value.absent(),
            Value<String> exerciseFiveRms = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            level: level,
            experiencePoints: experiencePoints,
            gender: gender,
            bodyWeightKg: bodyWeightKg,
            squatFiveRm: squatFiveRm,
            benchPressFiveRm: benchPressFiveRm,
            deadliftFiveRm: deadliftFiveRm,
            overheadPressFiveRm: overheadPressFiveRm,
            weeklyFrequency: weeklyFrequency,
            isBeginnerMode: isBeginnerMode,
            calibrationSessionsCompleted: calibrationSessionsCompleted,
            calibrationTargetSessions: calibrationTargetSessions,
            unlockedMoveIds: unlockedMoveIds,
            maxPp: maxPp,
            currentPp: currentPp,
            potionCount: potionCount,
            etherCount: etherCount,
            rareCandyCount: rareCandyCount,
            coins: coins,
            exerciseFiveRms: exerciseFiveRms,
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
typedef $$BattleStatesTableCreateCompanionBuilder = BattleStatesCompanion
    Function({
  Value<int> id,
  required String phaseJson,
  required String bossesJson,
  Value<int> currentBossIndex,
  Value<int> playerHp,
  Value<int> maxPlayerHp,
  Value<String> completedSetsJson,
  Value<String> damageResultsJson,
  Value<String?> selectedMoveId,
  required String gymTypeValue,
  required String playerMuscleTypeValue,
  Value<int> totalDamageDealt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$BattleStatesTableUpdateCompanionBuilder = BattleStatesCompanion
    Function({
  Value<int> id,
  Value<String> phaseJson,
  Value<String> bossesJson,
  Value<int> currentBossIndex,
  Value<int> playerHp,
  Value<int> maxPlayerHp,
  Value<String> completedSetsJson,
  Value<String> damageResultsJson,
  Value<String?> selectedMoveId,
  Value<String> gymTypeValue,
  Value<String> playerMuscleTypeValue,
  Value<int> totalDamageDealt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$BattleStatesTableFilterComposer
    extends Composer<_$AppDatabase, $BattleStatesTable> {
  $$BattleStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phaseJson => $composableBuilder(
      column: $table.phaseJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bossesJson => $composableBuilder(
      column: $table.bossesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentBossIndex => $composableBuilder(
      column: $table.currentBossIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playerHp => $composableBuilder(
      column: $table.playerHp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxPlayerHp => $composableBuilder(
      column: $table.maxPlayerHp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedSetsJson => $composableBuilder(
      column: $table.completedSetsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get damageResultsJson => $composableBuilder(
      column: $table.damageResultsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedMoveId => $composableBuilder(
      column: $table.selectedMoveId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gymTypeValue => $composableBuilder(
      column: $table.gymTypeValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerMuscleTypeValue => $composableBuilder(
      column: $table.playerMuscleTypeValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDamageDealt => $composableBuilder(
      column: $table.totalDamageDealt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BattleStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $BattleStatesTable> {
  $$BattleStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phaseJson => $composableBuilder(
      column: $table.phaseJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bossesJson => $composableBuilder(
      column: $table.bossesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentBossIndex => $composableBuilder(
      column: $table.currentBossIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playerHp => $composableBuilder(
      column: $table.playerHp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxPlayerHp => $composableBuilder(
      column: $table.maxPlayerHp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedSetsJson => $composableBuilder(
      column: $table.completedSetsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get damageResultsJson => $composableBuilder(
      column: $table.damageResultsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedMoveId => $composableBuilder(
      column: $table.selectedMoveId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gymTypeValue => $composableBuilder(
      column: $table.gymTypeValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerMuscleTypeValue => $composableBuilder(
      column: $table.playerMuscleTypeValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDamageDealt => $composableBuilder(
      column: $table.totalDamageDealt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BattleStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BattleStatesTable> {
  $$BattleStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phaseJson =>
      $composableBuilder(column: $table.phaseJson, builder: (column) => column);

  GeneratedColumn<String> get bossesJson => $composableBuilder(
      column: $table.bossesJson, builder: (column) => column);

  GeneratedColumn<int> get currentBossIndex => $composableBuilder(
      column: $table.currentBossIndex, builder: (column) => column);

  GeneratedColumn<int> get playerHp =>
      $composableBuilder(column: $table.playerHp, builder: (column) => column);

  GeneratedColumn<int> get maxPlayerHp => $composableBuilder(
      column: $table.maxPlayerHp, builder: (column) => column);

  GeneratedColumn<String> get completedSetsJson => $composableBuilder(
      column: $table.completedSetsJson, builder: (column) => column);

  GeneratedColumn<String> get damageResultsJson => $composableBuilder(
      column: $table.damageResultsJson, builder: (column) => column);

  GeneratedColumn<String> get selectedMoveId => $composableBuilder(
      column: $table.selectedMoveId, builder: (column) => column);

  GeneratedColumn<String> get gymTypeValue => $composableBuilder(
      column: $table.gymTypeValue, builder: (column) => column);

  GeneratedColumn<String> get playerMuscleTypeValue => $composableBuilder(
      column: $table.playerMuscleTypeValue, builder: (column) => column);

  GeneratedColumn<int> get totalDamageDealt => $composableBuilder(
      column: $table.totalDamageDealt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BattleStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BattleStatesTable,
    BattleStateEntity,
    $$BattleStatesTableFilterComposer,
    $$BattleStatesTableOrderingComposer,
    $$BattleStatesTableAnnotationComposer,
    $$BattleStatesTableCreateCompanionBuilder,
    $$BattleStatesTableUpdateCompanionBuilder,
    (
      BattleStateEntity,
      BaseReferences<_$AppDatabase, $BattleStatesTable, BattleStateEntity>
    ),
    BattleStateEntity,
    PrefetchHooks Function()> {
  $$BattleStatesTableTableManager(_$AppDatabase db, $BattleStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BattleStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BattleStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BattleStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> phaseJson = const Value.absent(),
            Value<String> bossesJson = const Value.absent(),
            Value<int> currentBossIndex = const Value.absent(),
            Value<int> playerHp = const Value.absent(),
            Value<int> maxPlayerHp = const Value.absent(),
            Value<String> completedSetsJson = const Value.absent(),
            Value<String> damageResultsJson = const Value.absent(),
            Value<String?> selectedMoveId = const Value.absent(),
            Value<String> gymTypeValue = const Value.absent(),
            Value<String> playerMuscleTypeValue = const Value.absent(),
            Value<int> totalDamageDealt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BattleStatesCompanion(
            id: id,
            phaseJson: phaseJson,
            bossesJson: bossesJson,
            currentBossIndex: currentBossIndex,
            playerHp: playerHp,
            maxPlayerHp: maxPlayerHp,
            completedSetsJson: completedSetsJson,
            damageResultsJson: damageResultsJson,
            selectedMoveId: selectedMoveId,
            gymTypeValue: gymTypeValue,
            playerMuscleTypeValue: playerMuscleTypeValue,
            totalDamageDealt: totalDamageDealt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String phaseJson,
            required String bossesJson,
            Value<int> currentBossIndex = const Value.absent(),
            Value<int> playerHp = const Value.absent(),
            Value<int> maxPlayerHp = const Value.absent(),
            Value<String> completedSetsJson = const Value.absent(),
            Value<String> damageResultsJson = const Value.absent(),
            Value<String?> selectedMoveId = const Value.absent(),
            required String gymTypeValue,
            required String playerMuscleTypeValue,
            Value<int> totalDamageDealt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BattleStatesCompanion.insert(
            id: id,
            phaseJson: phaseJson,
            bossesJson: bossesJson,
            currentBossIndex: currentBossIndex,
            playerHp: playerHp,
            maxPlayerHp: maxPlayerHp,
            completedSetsJson: completedSetsJson,
            damageResultsJson: damageResultsJson,
            selectedMoveId: selectedMoveId,
            gymTypeValue: gymTypeValue,
            playerMuscleTypeValue: playerMuscleTypeValue,
            totalDamageDealt: totalDamageDealt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BattleStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BattleStatesTable,
    BattleStateEntity,
    $$BattleStatesTableFilterComposer,
    $$BattleStatesTableOrderingComposer,
    $$BattleStatesTableAnnotationComposer,
    $$BattleStatesTableCreateCompanionBuilder,
    $$BattleStatesTableUpdateCompanionBuilder,
    (
      BattleStateEntity,
      BaseReferences<_$AppDatabase, $BattleStatesTable, BattleStateEntity>
    ),
    BattleStateEntity,
    PrefetchHooks Function()>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required String gymType,
  required String muscleType,
  required double totalVolume,
  required int totalDamage,
  required int totalSets,
  required bool isVictory,
  required int expEarned,
  Value<int?> durationSeconds,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> gymType,
  Value<String> muscleType,
  Value<double> totalVolume,
  Value<int> totalDamage,
  Value<int> totalSets,
  Value<bool> isVictory,
  Value<int> expEarned,
  Value<int?> durationSeconds,
});

final class $$WorkoutSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutSessionsTable, WorkoutSessionEntity> {
  $$WorkoutSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseSetsTable, List<ExerciseSetEntity>>
      _exerciseSetsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.exerciseSets,
              aliasName: $_aliasNameGenerator(
                  db.workoutSessions.id, db.exerciseSets.sessionId));

  $$ExerciseSetsTableProcessedTableManager get exerciseSetsRefs {
    final manager = $$ExerciseSetsTableTableManager($_db, $_db.exerciseSets)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exerciseSetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gymType => $composableBuilder(
      column: $table.gymType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get muscleType => $composableBuilder(
      column: $table.muscleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalVolume => $composableBuilder(
      column: $table.totalVolume, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDamage => $composableBuilder(
      column: $table.totalDamage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalSets => $composableBuilder(
      column: $table.totalSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVictory => $composableBuilder(
      column: $table.isVictory, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expEarned => $composableBuilder(
      column: $table.expEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  Expression<bool> exerciseSetsRefs(
      Expression<bool> Function($$ExerciseSetsTableFilterComposer f) f) {
    final $$ExerciseSetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exerciseSets,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseSetsTableFilterComposer(
              $db: $db,
              $table: $db.exerciseSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gymType => $composableBuilder(
      column: $table.gymType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get muscleType => $composableBuilder(
      column: $table.muscleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalVolume => $composableBuilder(
      column: $table.totalVolume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDamage => $composableBuilder(
      column: $table.totalDamage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalSets => $composableBuilder(
      column: $table.totalSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVictory => $composableBuilder(
      column: $table.isVictory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expEarned => $composableBuilder(
      column: $table.expEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get gymType =>
      $composableBuilder(column: $table.gymType, builder: (column) => column);

  GeneratedColumn<String> get muscleType => $composableBuilder(
      column: $table.muscleType, builder: (column) => column);

  GeneratedColumn<double> get totalVolume => $composableBuilder(
      column: $table.totalVolume, builder: (column) => column);

  GeneratedColumn<int> get totalDamage => $composableBuilder(
      column: $table.totalDamage, builder: (column) => column);

  GeneratedColumn<int> get totalSets =>
      $composableBuilder(column: $table.totalSets, builder: (column) => column);

  GeneratedColumn<bool> get isVictory =>
      $composableBuilder(column: $table.isVictory, builder: (column) => column);

  GeneratedColumn<int> get expEarned =>
      $composableBuilder(column: $table.expEarned, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  Expression<T> exerciseSetsRefs<T extends Object>(
      Expression<T> Function($$ExerciseSetsTableAnnotationComposer a) f) {
    final $$ExerciseSetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.exerciseSets,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseSetsTableAnnotationComposer(
              $db: $db,
              $table: $db.exerciseSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSessionEntity,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSessionEntity, $$WorkoutSessionsTableReferences),
    WorkoutSessionEntity,
    PrefetchHooks Function({bool exerciseSetsRefs})> {
  $$WorkoutSessionsTableTableManager(
      _$AppDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> gymType = const Value.absent(),
            Value<String> muscleType = const Value.absent(),
            Value<double> totalVolume = const Value.absent(),
            Value<int> totalDamage = const Value.absent(),
            Value<int> totalSets = const Value.absent(),
            Value<bool> isVictory = const Value.absent(),
            Value<int> expEarned = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            date: date,
            gymType: gymType,
            muscleType: muscleType,
            totalVolume: totalVolume,
            totalDamage: totalDamage,
            totalSets: totalSets,
            isVictory: isVictory,
            expEarned: expEarned,
            durationSeconds: durationSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String gymType,
            required String muscleType,
            required double totalVolume,
            required int totalDamage,
            required int totalSets,
            required bool isVictory,
            required int expEarned,
            Value<int?> durationSeconds = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            date: date,
            gymType: gymType,
            muscleType: muscleType,
            totalVolume: totalVolume,
            totalDamage: totalDamage,
            totalSets: totalSets,
            isVictory: isVictory,
            expEarned: expEarned,
            durationSeconds: durationSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({exerciseSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exerciseSetsRefs) db.exerciseSets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exerciseSetsRefs)
                    await $_getPrefetchedData<WorkoutSessionEntity,
                            $WorkoutSessionsTable, ExerciseSetEntity>(
                        currentTable: table,
                        referencedTable: $$WorkoutSessionsTableReferences
                            ._exerciseSetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutSessionsTableReferences(db, table, p0)
                                .exerciseSetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSessionEntity,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSessionEntity, $$WorkoutSessionsTableReferences),
    WorkoutSessionEntity,
    PrefetchHooks Function({bool exerciseSetsRefs})>;
typedef $$ExerciseSetsTableCreateCompanionBuilder = ExerciseSetsCompanion
    Function({
  Value<int> id,
  required int sessionId,
  required String moveId,
  required int setNumber,
  required double weight,
  required int reps,
  required int rpe,
  required int damage,
});
typedef $$ExerciseSetsTableUpdateCompanionBuilder = ExerciseSetsCompanion
    Function({
  Value<int> id,
  Value<int> sessionId,
  Value<String> moveId,
  Value<int> setNumber,
  Value<double> weight,
  Value<int> reps,
  Value<int> rpe,
  Value<int> damage,
});

final class $$ExerciseSetsTableReferences extends BaseReferences<_$AppDatabase,
    $ExerciseSetsTable, ExerciseSetEntity> {
  $$ExerciseSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias($_aliasNameGenerator(
          db.exerciseSets.sessionId, db.workoutSessions.id));

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$WorkoutSessionsTableTableManager($_db, $_db.workoutSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExerciseSetsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moveId => $composableBuilder(
      column: $table.moveId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get damage => $composableBuilder(
      column: $table.damage, builder: (column) => ColumnFilters(column));

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moveId => $composableBuilder(
      column: $table.moveId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get damage => $composableBuilder(
      column: $table.damage, builder: (column) => ColumnOrderings(column));

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moveId =>
      $composableBuilder(column: $table.moveId, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get damage =>
      $composableBuilder(column: $table.damage, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseSetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseSetsTable,
    ExerciseSetEntity,
    $$ExerciseSetsTableFilterComposer,
    $$ExerciseSetsTableOrderingComposer,
    $$ExerciseSetsTableAnnotationComposer,
    $$ExerciseSetsTableCreateCompanionBuilder,
    $$ExerciseSetsTableUpdateCompanionBuilder,
    (ExerciseSetEntity, $$ExerciseSetsTableReferences),
    ExerciseSetEntity,
    PrefetchHooks Function({bool sessionId})> {
  $$ExerciseSetsTableTableManager(_$AppDatabase db, $ExerciseSetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<String> moveId = const Value.absent(),
            Value<int> setNumber = const Value.absent(),
            Value<double> weight = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> rpe = const Value.absent(),
            Value<int> damage = const Value.absent(),
          }) =>
              ExerciseSetsCompanion(
            id: id,
            sessionId: sessionId,
            moveId: moveId,
            setNumber: setNumber,
            weight: weight,
            reps: reps,
            rpe: rpe,
            damage: damage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required String moveId,
            required int setNumber,
            required double weight,
            required int reps,
            required int rpe,
            required int damage,
          }) =>
              ExerciseSetsCompanion.insert(
            id: id,
            sessionId: sessionId,
            moveId: moveId,
            setNumber: setNumber,
            weight: weight,
            reps: reps,
            rpe: rpe,
            damage: damage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExerciseSetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$ExerciseSetsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$ExerciseSetsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExerciseSetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseSetsTable,
    ExerciseSetEntity,
    $$ExerciseSetsTableFilterComposer,
    $$ExerciseSetsTableOrderingComposer,
    $$ExerciseSetsTableAnnotationComposer,
    $$ExerciseSetsTableCreateCompanionBuilder,
    $$ExerciseSetsTableUpdateCompanionBuilder,
    (ExerciseSetEntity, $$ExerciseSetsTableReferences),
    ExerciseSetEntity,
    PrefetchHooks Function({bool sessionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$BattleStatesTableTableManager get battleStates =>
      $$BattleStatesTableTableManager(_db, _db.battleStates);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$ExerciseSetsTableTableManager get exerciseSets =>
      $$ExerciseSetsTableTableManager(_db, _db.exerciseSets);
}
