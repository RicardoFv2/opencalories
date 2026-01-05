// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manual_food_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ManualFoodEntry _$ManualFoodEntryFromJson(Map<String, dynamic> json) {
  return _ManualFoodEntry.fromJson(json);
}

/// @nodoc
mixin _$ManualFoodEntry {
  String get name => throw _privateConstructorUsedError;
  String get portion => throw _privateConstructorUsedError;
  int? get calories => throw _privateConstructorUsedError;
  int? get protein => throw _privateConstructorUsedError;
  int? get carbs => throw _privateConstructorUsedError;
  int? get fat => throw _privateConstructorUsedError;

  /// Serializes this ManualFoodEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManualFoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManualFoodEntryCopyWith<ManualFoodEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManualFoodEntryCopyWith<$Res> {
  factory $ManualFoodEntryCopyWith(
    ManualFoodEntry value,
    $Res Function(ManualFoodEntry) then,
  ) = _$ManualFoodEntryCopyWithImpl<$Res, ManualFoodEntry>;
  @useResult
  $Res call({
    String name,
    String portion,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  });
}

/// @nodoc
class _$ManualFoodEntryCopyWithImpl<$Res, $Val extends ManualFoodEntry>
    implements $ManualFoodEntryCopyWith<$Res> {
  _$ManualFoodEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManualFoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? portion = null,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? carbs = freezed,
    Object? fat = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            portion: null == portion
                ? _value.portion
                : portion // ignore: cast_nullable_to_non_nullable
                      as String,
            calories: freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int?,
            protein: freezed == protein
                ? _value.protein
                : protein // ignore: cast_nullable_to_non_nullable
                      as int?,
            carbs: freezed == carbs
                ? _value.carbs
                : carbs // ignore: cast_nullable_to_non_nullable
                      as int?,
            fat: freezed == fat
                ? _value.fat
                : fat // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManualFoodEntryImplCopyWith<$Res>
    implements $ManualFoodEntryCopyWith<$Res> {
  factory _$$ManualFoodEntryImplCopyWith(
    _$ManualFoodEntryImpl value,
    $Res Function(_$ManualFoodEntryImpl) then,
  ) = __$$ManualFoodEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String portion,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  });
}

/// @nodoc
class __$$ManualFoodEntryImplCopyWithImpl<$Res>
    extends _$ManualFoodEntryCopyWithImpl<$Res, _$ManualFoodEntryImpl>
    implements _$$ManualFoodEntryImplCopyWith<$Res> {
  __$$ManualFoodEntryImplCopyWithImpl(
    _$ManualFoodEntryImpl _value,
    $Res Function(_$ManualFoodEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManualFoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? portion = null,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? carbs = freezed,
    Object? fat = freezed,
  }) {
    return _then(
      _$ManualFoodEntryImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        portion: null == portion
            ? _value.portion
            : portion // ignore: cast_nullable_to_non_nullable
                  as String,
        calories: freezed == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int?,
        protein: freezed == protein
            ? _value.protein
            : protein // ignore: cast_nullable_to_non_nullable
                  as int?,
        carbs: freezed == carbs
            ? _value.carbs
            : carbs // ignore: cast_nullable_to_non_nullable
                  as int?,
        fat: freezed == fat
            ? _value.fat
            : fat // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManualFoodEntryImpl implements _ManualFoodEntry {
  const _$ManualFoodEntryImpl({
    required this.name,
    required this.portion,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  factory _$ManualFoodEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManualFoodEntryImplFromJson(json);

  @override
  final String name;
  @override
  final String portion;
  @override
  final int? calories;
  @override
  final int? protein;
  @override
  final int? carbs;
  @override
  final int? fat;

  @override
  String toString() {
    return 'ManualFoodEntry(name: $name, portion: $portion, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManualFoodEntryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.portion, portion) || other.portion == portion) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fat, fat) || other.fat == fat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, portion, calories, protein, carbs, fat);

  /// Create a copy of ManualFoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManualFoodEntryImplCopyWith<_$ManualFoodEntryImpl> get copyWith =>
      __$$ManualFoodEntryImplCopyWithImpl<_$ManualFoodEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ManualFoodEntryImplToJson(this);
  }
}

abstract class _ManualFoodEntry implements ManualFoodEntry {
  const factory _ManualFoodEntry({
    required final String name,
    required final String portion,
    final int? calories,
    final int? protein,
    final int? carbs,
    final int? fat,
  }) = _$ManualFoodEntryImpl;

  factory _ManualFoodEntry.fromJson(Map<String, dynamic> json) =
      _$ManualFoodEntryImpl.fromJson;

  @override
  String get name;
  @override
  String get portion;
  @override
  int? get calories;
  @override
  int? get protein;
  @override
  int? get carbs;
  @override
  int? get fat;

  /// Create a copy of ManualFoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManualFoodEntryImplCopyWith<_$ManualFoodEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
