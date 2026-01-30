// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
mixin _$MealsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealsTable get meals => attachedDatabase.meals;
  $FoodItemsTable get foodItems => attachedDatabase.foodItems;
}

class $MealsTable extends Meals with TableInfo<$MealsTable, MealEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCaloriesMeta = const VerificationMeta(
    'totalCalories',
  );
  @override
  late final GeneratedColumn<int> totalCalories = GeneratedColumn<int>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isManualEntryMeta = const VerificationMeta(
    'isManualEntry',
  );
  @override
  late final GeneratedColumn<bool> isManualEntry = GeneratedColumn<bool>(
    'is_manual_entry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual_entry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<int> confidence = GeneratedColumn<int>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    imagePath,
    totalCalories,
    isManualEntry,
    confidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('total_calories')) {
      context.handle(
        _totalCaloriesMeta,
        totalCalories.isAcceptableOrUnknown(
          data['total_calories']!,
          _totalCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCaloriesMeta);
    }
    if (data.containsKey('is_manual_entry')) {
      context.handle(
        _isManualEntryMeta,
        isManualEntry.isAcceptableOrUnknown(
          data['is_manual_entry']!,
          _isManualEntryMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      totalCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_calories'],
      )!,
      isManualEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual_entry'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class MealEntity extends DataClass implements Insertable<MealEntity> {
  final int id;
  final DateTime createdAt;
  final String? imagePath;
  final int totalCalories;
  final bool isManualEntry;
  final int confidence;
  const MealEntity({
    required this.id,
    required this.createdAt,
    this.imagePath,
    required this.totalCalories,
    required this.isManualEntry,
    required this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['total_calories'] = Variable<int>(totalCalories);
    map['is_manual_entry'] = Variable<bool>(isManualEntry);
    map['confidence'] = Variable<int>(confidence);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      totalCalories: Value(totalCalories),
      isManualEntry: Value(isManualEntry),
      confidence: Value(confidence),
    );
  }

  factory MealEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      totalCalories: serializer.fromJson<int>(json['totalCalories']),
      isManualEntry: serializer.fromJson<bool>(json['isManualEntry']),
      confidence: serializer.fromJson<int>(json['confidence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'imagePath': serializer.toJson<String?>(imagePath),
      'totalCalories': serializer.toJson<int>(totalCalories),
      'isManualEntry': serializer.toJson<bool>(isManualEntry),
      'confidence': serializer.toJson<int>(confidence),
    };
  }

  MealEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<String?> imagePath = const Value.absent(),
    int? totalCalories,
    bool? isManualEntry,
    int? confidence,
  }) => MealEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    totalCalories: totalCalories ?? this.totalCalories,
    isManualEntry: isManualEntry ?? this.isManualEntry,
    confidence: confidence ?? this.confidence,
  );
  MealEntity copyWithCompanion(MealsCompanion data) {
    return MealEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      isManualEntry: data.isManualEntry.present
          ? data.isManualEntry.value
          : this.isManualEntry,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('imagePath: $imagePath, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('isManualEntry: $isManualEntry, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    imagePath,
    totalCalories,
    isManualEntry,
    confidence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.imagePath == this.imagePath &&
          other.totalCalories == this.totalCalories &&
          other.isManualEntry == this.isManualEntry &&
          other.confidence == this.confidence);
}

class MealsCompanion extends UpdateCompanion<MealEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String?> imagePath;
  final Value<int> totalCalories;
  final Value<bool> isManualEntry;
  final Value<int> confidence;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.isManualEntry = const Value.absent(),
    this.confidence = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    this.imagePath = const Value.absent(),
    required int totalCalories,
    this.isManualEntry = const Value.absent(),
    this.confidence = const Value.absent(),
  }) : createdAt = Value(createdAt),
       totalCalories = Value(totalCalories);
  static Insertable<MealEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? imagePath,
    Expression<int>? totalCalories,
    Expression<bool>? isManualEntry,
    Expression<int>? confidence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (imagePath != null) 'image_path': imagePath,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (isManualEntry != null) 'is_manual_entry': isManualEntry,
      if (confidence != null) 'confidence': confidence,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String?>? imagePath,
    Value<int>? totalCalories,
    Value<bool>? isManualEntry,
    Value<int>? confidence,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      imagePath: imagePath ?? this.imagePath,
      totalCalories: totalCalories ?? this.totalCalories,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<int>(totalCalories.value);
    }
    if (isManualEntry.present) {
      map['is_manual_entry'] = Variable<bool>(isManualEntry.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<int>(confidence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('imagePath: $imagePath, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('isManualEntry: $isManualEntry, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItemEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>?, String>
  nameTranslations =
      GeneratedColumn<String>(
        'name_translations',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, String>?>(
        $FoodItemsTable.$converternameTranslations,
      );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<int> protein = GeneratedColumn<int>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<int> carbs = GeneratedColumn<int>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<int> fat = GeneratedColumn<int>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portionEstimateMeta = const VerificationMeta(
    'portionEstimate',
  );
  @override
  late final GeneratedColumn<String> portionEstimate = GeneratedColumn<String>(
    'portion_estimate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>?, String>
  portionTranslations =
      GeneratedColumn<String>(
        'portion_translations',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, String>?>(
        $FoodItemsTable.$converterportionTranslations,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mealId,
    name,
    nameTranslations,
    calories,
    protein,
    carbs,
    fat,
    portionEstimate,
    portionTranslations,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItemEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('portion_estimate')) {
      context.handle(
        _portionEstimateMeta,
        portionEstimate.isAcceptableOrUnknown(
          data['portion_estimate']!,
          _portionEstimateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItemEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItemEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameTranslations: $FoodItemsTable.$converternameTranslations.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}name_translations'],
        ),
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fat'],
      )!,
      portionEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_estimate'],
      )!,
      portionTranslations: $FoodItemsTable.$converterportionTranslations
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}portion_translations'],
            ),
          ),
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, String>?, String?>
  $converternameTranslations = const TranslationMapConverter();
  static TypeConverter<Map<String, String>?, String?>
  $converterportionTranslations = const TranslationMapConverter();
}

class FoodItemEntity extends DataClass implements Insertable<FoodItemEntity> {
  final int id;
  final int mealId;
  final String name;
  final Map<String, String>? nameTranslations;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String portionEstimate;
  final Map<String, String>? portionTranslations;
  const FoodItemEntity({
    required this.id,
    required this.mealId,
    required this.name,
    this.nameTranslations,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.portionEstimate,
    this.portionTranslations,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameTranslations != null) {
      map['name_translations'] = Variable<String>(
        $FoodItemsTable.$converternameTranslations.toSql(nameTranslations),
      );
    }
    map['calories'] = Variable<int>(calories);
    map['protein'] = Variable<int>(protein);
    map['carbs'] = Variable<int>(carbs);
    map['fat'] = Variable<int>(fat);
    map['portion_estimate'] = Variable<String>(portionEstimate);
    if (!nullToAbsent || portionTranslations != null) {
      map['portion_translations'] = Variable<String>(
        $FoodItemsTable.$converterportionTranslations.toSql(
          portionTranslations,
        ),
      );
    }
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      mealId: Value(mealId),
      name: Value(name),
      nameTranslations: nameTranslations == null && nullToAbsent
          ? const Value.absent()
          : Value(nameTranslations),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      portionEstimate: Value(portionEstimate),
      portionTranslations: portionTranslations == null && nullToAbsent
          ? const Value.absent()
          : Value(portionTranslations),
    );
  }

  factory FoodItemEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItemEntity(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      name: serializer.fromJson<String>(json['name']),
      nameTranslations: serializer.fromJson<Map<String, String>?>(
        json['nameTranslations'],
      ),
      calories: serializer.fromJson<int>(json['calories']),
      protein: serializer.fromJson<int>(json['protein']),
      carbs: serializer.fromJson<int>(json['carbs']),
      fat: serializer.fromJson<int>(json['fat']),
      portionEstimate: serializer.fromJson<String>(json['portionEstimate']),
      portionTranslations: serializer.fromJson<Map<String, String>?>(
        json['portionTranslations'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'name': serializer.toJson<String>(name),
      'nameTranslations': serializer.toJson<Map<String, String>?>(
        nameTranslations,
      ),
      'calories': serializer.toJson<int>(calories),
      'protein': serializer.toJson<int>(protein),
      'carbs': serializer.toJson<int>(carbs),
      'fat': serializer.toJson<int>(fat),
      'portionEstimate': serializer.toJson<String>(portionEstimate),
      'portionTranslations': serializer.toJson<Map<String, String>?>(
        portionTranslations,
      ),
    };
  }

  FoodItemEntity copyWith({
    int? id,
    int? mealId,
    String? name,
    Value<Map<String, String>?> nameTranslations = const Value.absent(),
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    String? portionEstimate,
    Value<Map<String, String>?> portionTranslations = const Value.absent(),
  }) => FoodItemEntity(
    id: id ?? this.id,
    mealId: mealId ?? this.mealId,
    name: name ?? this.name,
    nameTranslations: nameTranslations.present
        ? nameTranslations.value
        : this.nameTranslations,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    portionEstimate: portionEstimate ?? this.portionEstimate,
    portionTranslations: portionTranslations.present
        ? portionTranslations.value
        : this.portionTranslations,
  );
  FoodItemEntity copyWithCompanion(FoodItemsCompanion data) {
    return FoodItemEntity(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      name: data.name.present ? data.name.value : this.name,
      nameTranslations: data.nameTranslations.present
          ? data.nameTranslations.value
          : this.nameTranslations,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      portionEstimate: data.portionEstimate.present
          ? data.portionEstimate.value
          : this.portionEstimate,
      portionTranslations: data.portionTranslations.present
          ? data.portionTranslations.value
          : this.portionTranslations,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemEntity(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('name: $name, ')
          ..write('nameTranslations: $nameTranslations, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('portionEstimate: $portionEstimate, ')
          ..write('portionTranslations: $portionTranslations')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mealId,
    name,
    nameTranslations,
    calories,
    protein,
    carbs,
    fat,
    portionEstimate,
    portionTranslations,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItemEntity &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.name == this.name &&
          other.nameTranslations == this.nameTranslations &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.portionEstimate == this.portionEstimate &&
          other.portionTranslations == this.portionTranslations);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItemEntity> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<String> name;
  final Value<Map<String, String>?> nameTranslations;
  final Value<int> calories;
  final Value<int> protein;
  final Value<int> carbs;
  final Value<int> fat;
  final Value<String> portionEstimate;
  final Value<Map<String, String>?> portionTranslations;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameTranslations = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.portionEstimate = const Value.absent(),
    this.portionTranslations = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required String name,
    this.nameTranslations = const Value.absent(),
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    this.portionEstimate = const Value.absent(),
    this.portionTranslations = const Value.absent(),
  }) : mealId = Value(mealId),
       name = Value(name),
       calories = Value(calories),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat);
  static Insertable<FoodItemEntity> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<String>? name,
    Expression<String>? nameTranslations,
    Expression<int>? calories,
    Expression<int>? protein,
    Expression<int>? carbs,
    Expression<int>? fat,
    Expression<String>? portionEstimate,
    Expression<String>? portionTranslations,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (name != null) 'name': name,
      if (nameTranslations != null) 'name_translations': nameTranslations,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (portionEstimate != null) 'portion_estimate': portionEstimate,
      if (portionTranslations != null)
        'portion_translations': portionTranslations,
    });
  }

  FoodItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealId,
    Value<String>? name,
    Value<Map<String, String>?>? nameTranslations,
    Value<int>? calories,
    Value<int>? protein,
    Value<int>? carbs,
    Value<int>? fat,
    Value<String>? portionEstimate,
    Value<Map<String, String>?>? portionTranslations,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      name: name ?? this.name,
      nameTranslations: nameTranslations ?? this.nameTranslations,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      portionEstimate: portionEstimate ?? this.portionEstimate,
      portionTranslations: portionTranslations ?? this.portionTranslations,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameTranslations.present) {
      map['name_translations'] = Variable<String>(
        $FoodItemsTable.$converternameTranslations.toSql(
          nameTranslations.value,
        ),
      );
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<int>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<int>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<int>(fat.value);
    }
    if (portionEstimate.present) {
      map['portion_estimate'] = Variable<String>(portionEstimate.value);
    }
    if (portionTranslations.present) {
      map['portion_translations'] = Variable<String>(
        $FoodItemsTable.$converterportionTranslations.toSql(
          portionTranslations.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('name: $name, ')
          ..write('nameTranslations: $nameTranslations, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('portionEstimate: $portionEstimate, ')
          ..write('portionTranslations: $portionTranslations')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final MealsDao mealsDao = MealsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [meals, foodItems];
}

typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      Value<String?> imagePath,
      required int totalCalories,
      Value<bool> isManualEntry,
      Value<int> confidence,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String?> imagePath,
      Value<int> totalCalories,
      Value<bool> isManualEntry,
      Value<int> confidence,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, MealEntity> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoodItemsTable, List<FoodItemEntity>>
  _foodItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.foodItems,
    aliasName: $_aliasNameGenerator(db.meals.id, db.foodItems.mealId),
  );

  $$FoodItemsTableProcessedTableManager get foodItemsRefs {
    final manager = $$FoodItemsTableTableManager(
      $_db,
      $_db.foodItems,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> foodItemsRefs(
    Expression<bool> Function($$FoodItemsTableFilterComposer f) f,
  ) {
    final $$FoodItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableFilterComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => column,
  );

  GeneratedColumn<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  Expression<T> foodItemsRefs<T extends Object>(
    Expression<T> Function($$FoodItemsTableAnnotationComposer a) f,
  ) {
    final $$FoodItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          MealEntity,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (MealEntity, $$MealsTableReferences),
          MealEntity,
          PrefetchHooks Function({bool foodItemsRefs})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> totalCalories = const Value.absent(),
                Value<bool> isManualEntry = const Value.absent(),
                Value<int> confidence = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                createdAt: createdAt,
                imagePath: imagePath,
                totalCalories: totalCalories,
                isManualEntry: isManualEntry,
                confidence: confidence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                Value<String?> imagePath = const Value.absent(),
                required int totalCalories,
                Value<bool> isManualEntry = const Value.absent(),
                Value<int> confidence = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                createdAt: createdAt,
                imagePath: imagePath,
                totalCalories: totalCalories,
                isManualEntry: isManualEntry,
                confidence: confidence,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({foodItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (foodItemsRefs) db.foodItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (foodItemsRefs)
                    await $_getPrefetchedData<
                      MealEntity,
                      $MealsTable,
                      FoodItemEntity
                    >(
                      currentTable: table,
                      referencedTable: $$MealsTableReferences
                          ._foodItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MealsTableReferences(db, table, p0).foodItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mealId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      MealEntity,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (MealEntity, $$MealsTableReferences),
      MealEntity,
      PrefetchHooks Function({bool foodItemsRefs})
    >;
typedef $$FoodItemsTableCreateCompanionBuilder =
    FoodItemsCompanion Function({
      Value<int> id,
      required int mealId,
      required String name,
      Value<Map<String, String>?> nameTranslations,
      required int calories,
      required int protein,
      required int carbs,
      required int fat,
      Value<String> portionEstimate,
      Value<Map<String, String>?> portionTranslations,
    });
typedef $$FoodItemsTableUpdateCompanionBuilder =
    FoodItemsCompanion Function({
      Value<int> id,
      Value<int> mealId,
      Value<String> name,
      Value<Map<String, String>?> nameTranslations,
      Value<int> calories,
      Value<int> protein,
      Value<int> carbs,
      Value<int> fat,
      Value<String> portionEstimate,
      Value<Map<String, String>?> portionTranslations,
    });

final class $$FoodItemsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItemEntity> {
  $$FoodItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
    $_aliasNameGenerator(db.foodItems.mealId, db.meals.id),
  );

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>?,
    Map<String, String>,
    String
  >
  get nameTranslations => $composableBuilder(
    column: $table.nameTranslations,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionEstimate => $composableBuilder(
    column: $table.portionEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>?,
    Map<String, String>,
    String
  >
  get portionTranslations => $composableBuilder(
    column: $table.portionTranslations,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTranslations => $composableBuilder(
    column: $table.nameTranslations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionEstimate => $composableBuilder(
    column: $table.portionEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionTranslations => $composableBuilder(
    column: $table.portionTranslations,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>?, String>
  get nameTranslations => $composableBuilder(
    column: $table.nameTranslations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<int> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<int> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<String> get portionEstimate => $composableBuilder(
    column: $table.portionEstimate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, String>?, String>
  get portionTranslations => $composableBuilder(
    column: $table.portionTranslations,
    builder: (column) => column,
  );

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemsTable,
          FoodItemEntity,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (FoodItemEntity, $$FoodItemsTableReferences),
          FoodItemEntity,
          PrefetchHooks Function({bool mealId})
        > {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Map<String, String>?> nameTranslations =
                    const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> protein = const Value.absent(),
                Value<int> carbs = const Value.absent(),
                Value<int> fat = const Value.absent(),
                Value<String> portionEstimate = const Value.absent(),
                Value<Map<String, String>?> portionTranslations =
                    const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                mealId: mealId,
                name: name,
                nameTranslations: nameTranslations,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                portionEstimate: portionEstimate,
                portionTranslations: portionTranslations,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealId,
                required String name,
                Value<Map<String, String>?> nameTranslations =
                    const Value.absent(),
                required int calories,
                required int protein,
                required int carbs,
                required int fat,
                Value<String> portionEstimate = const Value.absent(),
                Value<Map<String, String>?> portionTranslations =
                    const Value.absent(),
              }) => FoodItemsCompanion.insert(
                id: id,
                mealId: mealId,
                name: name,
                nameTranslations: nameTranslations,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                portionEstimate: portionEstimate,
                portionTranslations: portionTranslations,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (mealId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealId,
                                referencedTable: $$FoodItemsTableReferences
                                    ._mealIdTable(db),
                                referencedColumn: $$FoodItemsTableReferences
                                    ._mealIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemsTable,
      FoodItemEntity,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (FoodItemEntity, $$FoodItemsTableReferences),
      FoodItemEntity,
      PrefetchHooks Function({bool mealId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'4db1c5efe1a73afafa926c6e91d12e49a68b1abc';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
String _$mealsDaoHash() => r'713ba2bc54023a06d1d2bf3e39cf3387846e0543';

/// See also [mealsDao].
@ProviderFor(mealsDao)
final mealsDaoProvider = AutoDisposeProvider<MealsDao>.internal(
  mealsDao,
  name: r'mealsDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealsDaoRef = AutoDisposeProviderRef<MealsDao>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
