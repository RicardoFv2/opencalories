// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FoodAnalysis _$FoodAnalysisFromJson(Map<String, dynamic> json) {
  return _FoodAnalysis.fromJson(json);
}

/// @nodoc
mixin _$FoodAnalysis {
  List<FoodItem> get items =>
      throw _privateConstructorUsedError; // Confidence score (0-100) representing AI certainty
  @JsonKey(name: 'conf')
  int get confidence => throw _privateConstructorUsedError;

  /// Serializes this FoodAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodAnalysisCopyWith<FoodAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodAnalysisCopyWith<$Res> {
  factory $FoodAnalysisCopyWith(
    FoodAnalysis value,
    $Res Function(FoodAnalysis) then,
  ) = _$FoodAnalysisCopyWithImpl<$Res, FoodAnalysis>;
  @useResult
  $Res call({List<FoodItem> items, @JsonKey(name: 'conf') int confidence});
}

/// @nodoc
class _$FoodAnalysisCopyWithImpl<$Res, $Val extends FoodAnalysis>
    implements $FoodAnalysisCopyWith<$Res> {
  _$FoodAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null, Object? confidence = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<FoodItem>,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FoodAnalysisImplCopyWith<$Res>
    implements $FoodAnalysisCopyWith<$Res> {
  factory _$$FoodAnalysisImplCopyWith(
    _$FoodAnalysisImpl value,
    $Res Function(_$FoodAnalysisImpl) then,
  ) = __$$FoodAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FoodItem> items, @JsonKey(name: 'conf') int confidence});
}

/// @nodoc
class __$$FoodAnalysisImplCopyWithImpl<$Res>
    extends _$FoodAnalysisCopyWithImpl<$Res, _$FoodAnalysisImpl>
    implements _$$FoodAnalysisImplCopyWith<$Res> {
  __$$FoodAnalysisImplCopyWithImpl(
    _$FoodAnalysisImpl _value,
    $Res Function(_$FoodAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null, Object? confidence = null}) {
    return _then(
      _$FoodAnalysisImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<FoodItem>,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodAnalysisImpl implements _FoodAnalysis {
  const _$FoodAnalysisImpl({
    required final List<FoodItem> items,
    @JsonKey(name: 'conf') this.confidence = 0,
  }) : _items = items;

  factory _$FoodAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodAnalysisImplFromJson(json);

  final List<FoodItem> _items;
  @override
  List<FoodItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  // Confidence score (0-100) representing AI certainty
  @override
  @JsonKey(name: 'conf')
  final int confidence;

  @override
  String toString() {
    return 'FoodAnalysis(items: $items, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodAnalysisImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    confidence,
  );

  /// Create a copy of FoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodAnalysisImplCopyWith<_$FoodAnalysisImpl> get copyWith =>
      __$$FoodAnalysisImplCopyWithImpl<_$FoodAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodAnalysisImplToJson(this);
  }
}

abstract class _FoodAnalysis implements FoodAnalysis {
  const factory _FoodAnalysis({
    required final List<FoodItem> items,
    @JsonKey(name: 'conf') final int confidence,
  }) = _$FoodAnalysisImpl;

  factory _FoodAnalysis.fromJson(Map<String, dynamic> json) =
      _$FoodAnalysisImpl.fromJson;

  @override
  List<FoodItem> get items; // Confidence score (0-100) representing AI certainty
  @override
  @JsonKey(name: 'conf')
  int get confidence;

  /// Create a copy of FoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodAnalysisImplCopyWith<_$FoodAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  @JsonKey(name: 'n')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'cal')
  int get calories => throw _privateConstructorUsedError;
  @JsonKey(name: 'p')
  int get protein => throw _privateConstructorUsedError;
  @JsonKey(name: 'c')
  int get carbs => throw _privateConstructorUsedError;
  @JsonKey(name: 'f')
  int get fat => throw _privateConstructorUsedError;
  @JsonKey(name: 'q')
  String get portionEstimate => throw _privateConstructorUsedError;

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'n') String name,
    @JsonKey(name: 'cal') int calories,
    @JsonKey(name: 'p') int protein,
    @JsonKey(name: 'c') int carbs,
    @JsonKey(name: 'f') int fat,
    @JsonKey(name: 'q') String portionEstimate,
  });
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fat = null,
    Object? portionEstimate = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            calories: null == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int,
            protein: null == protein
                ? _value.protein
                : protein // ignore: cast_nullable_to_non_nullable
                      as int,
            carbs: null == carbs
                ? _value.carbs
                : carbs // ignore: cast_nullable_to_non_nullable
                      as int,
            fat: null == fat
                ? _value.fat
                : fat // ignore: cast_nullable_to_non_nullable
                      as int,
            portionEstimate: null == portionEstimate
                ? _value.portionEstimate
                : portionEstimate // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
    _$FoodItemImpl value,
    $Res Function(_$FoodItemImpl) then,
  ) = __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'n') String name,
    @JsonKey(name: 'cal') int calories,
    @JsonKey(name: 'p') int protein,
    @JsonKey(name: 'c') int carbs,
    @JsonKey(name: 'f') int fat,
    @JsonKey(name: 'q') String portionEstimate,
  });
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
    _$FoodItemImpl _value,
    $Res Function(_$FoodItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fat = null,
    Object? portionEstimate = null,
  }) {
    return _then(
      _$FoodItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        calories: null == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int,
        protein: null == protein
            ? _value.protein
            : protein // ignore: cast_nullable_to_non_nullable
                  as int,
        carbs: null == carbs
            ? _value.carbs
            : carbs // ignore: cast_nullable_to_non_nullable
                  as int,
        fat: null == fat
            ? _value.fat
            : fat // ignore: cast_nullable_to_non_nullable
                  as int,
        portionEstimate: null == portionEstimate
            ? _value.portionEstimate
            : portionEstimate // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl implements _FoodItem {
  const _$FoodItemImpl({
    @JsonKey(name: 'n') required this.name,
    @JsonKey(name: 'cal') required this.calories,
    @JsonKey(name: 'p') required this.protein,
    @JsonKey(name: 'c') required this.carbs,
    @JsonKey(name: 'f') required this.fat,
    @JsonKey(name: 'q') required this.portionEstimate,
  });

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  @JsonKey(name: 'n')
  final String name;
  @override
  @JsonKey(name: 'cal')
  final int calories;
  @override
  @JsonKey(name: 'p')
  final int protein;
  @override
  @JsonKey(name: 'c')
  final int carbs;
  @override
  @JsonKey(name: 'f')
  final int fat;
  @override
  @JsonKey(name: 'q')
  final String portionEstimate;

  @override
  String toString() {
    return 'FoodItem(name: $name, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, portionEstimate: $portionEstimate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.portionEstimate, portionEstimate) ||
                other.portionEstimate == portionEstimate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    calories,
    protein,
    carbs,
    fat,
    portionEstimate,
  );

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(this);
  }
}

abstract class _FoodItem implements FoodItem {
  const factory _FoodItem({
    @JsonKey(name: 'n') required final String name,
    @JsonKey(name: 'cal') required final int calories,
    @JsonKey(name: 'p') required final int protein,
    @JsonKey(name: 'c') required final int carbs,
    @JsonKey(name: 'f') required final int fat,
    @JsonKey(name: 'q') required final String portionEstimate,
  }) = _$FoodItemImpl;

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  @JsonKey(name: 'n')
  String get name;
  @override
  @JsonKey(name: 'cal')
  int get calories;
  @override
  @JsonKey(name: 'p')
  int get protein;
  @override
  @JsonKey(name: 'c')
  int get carbs;
  @override
  @JsonKey(name: 'f')
  int get fat;
  @override
  @JsonKey(name: 'q')
  String get portionEstimate;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
