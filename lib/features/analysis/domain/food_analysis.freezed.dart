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
  $Res call({List<FoodItem> items, int confidence});
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
  $Res call({List<FoodItem> items, int confidence});
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
    this.confidence = 0,
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
  @JsonKey()
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
    final int confidence,
  }) = _$FoodAnalysisImpl;

  factory _FoodAnalysis.fromJson(Map<String, dynamic> json) =
      _$FoodAnalysisImpl.fromJson;

  @override
  List<FoodItem> get items; // Confidence score (0-100) representing AI certainty
  @override
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
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_translations')
  Map<String, String>? get nameTranslations =>
      throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  int get protein => throw _privateConstructorUsedError;
  int get carbs => throw _privateConstructorUsedError;
  int get fat => throw _privateConstructorUsedError;
  @JsonKey(name: 'portion_estimate')
  String get portionEstimate => throw _privateConstructorUsedError;
  @JsonKey(name: 'portion_translations')
  Map<String, String>? get portionTranslations =>
      throw _privateConstructorUsedError;

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
    String name,
    @JsonKey(name: 'name_translations') Map<String, String>? nameTranslations,
    int calories,
    int protein,
    int carbs,
    int fat,
    @JsonKey(name: 'portion_estimate') String portionEstimate,
    @JsonKey(name: 'portion_translations')
    Map<String, String>? portionTranslations,
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
    Object? nameTranslations = freezed,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fat = null,
    Object? portionEstimate = null,
    Object? portionTranslations = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nameTranslations: freezed == nameTranslations
                ? _value.nameTranslations
                : nameTranslations // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
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
            portionTranslations: freezed == portionTranslations
                ? _value.portionTranslations
                : portionTranslations // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
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
    String name,
    @JsonKey(name: 'name_translations') Map<String, String>? nameTranslations,
    int calories,
    int protein,
    int carbs,
    int fat,
    @JsonKey(name: 'portion_estimate') String portionEstimate,
    @JsonKey(name: 'portion_translations')
    Map<String, String>? portionTranslations,
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
    Object? nameTranslations = freezed,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fat = null,
    Object? portionEstimate = null,
    Object? portionTranslations = freezed,
  }) {
    return _then(
      _$FoodItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nameTranslations: freezed == nameTranslations
            ? _value._nameTranslations
            : nameTranslations // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
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
        portionTranslations: freezed == portionTranslations
            ? _value._portionTranslations
            : portionTranslations // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl implements _FoodItem {
  const _$FoodItemImpl({
    required this.name,
    @JsonKey(name: 'name_translations')
    final Map<String, String>? nameTranslations,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    @JsonKey(name: 'portion_estimate') required this.portionEstimate,
    @JsonKey(name: 'portion_translations')
    final Map<String, String>? portionTranslations,
  }) : _nameTranslations = nameTranslations,
       _portionTranslations = portionTranslations;

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  final String name;
  final Map<String, String>? _nameTranslations;
  @override
  @JsonKey(name: 'name_translations')
  Map<String, String>? get nameTranslations {
    final value = _nameTranslations;
    if (value == null) return null;
    if (_nameTranslations is EqualUnmodifiableMapView) return _nameTranslations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int calories;
  @override
  final int protein;
  @override
  final int carbs;
  @override
  final int fat;
  @override
  @JsonKey(name: 'portion_estimate')
  final String portionEstimate;
  final Map<String, String>? _portionTranslations;
  @override
  @JsonKey(name: 'portion_translations')
  Map<String, String>? get portionTranslations {
    final value = _portionTranslations;
    if (value == null) return null;
    if (_portionTranslations is EqualUnmodifiableMapView)
      return _portionTranslations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FoodItem(name: $name, nameTranslations: $nameTranslations, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, portionEstimate: $portionEstimate, portionTranslations: $portionTranslations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._nameTranslations,
              _nameTranslations,
            ) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.portionEstimate, portionEstimate) ||
                other.portionEstimate == portionEstimate) &&
            const DeepCollectionEquality().equals(
              other._portionTranslations,
              _portionTranslations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_nameTranslations),
    calories,
    protein,
    carbs,
    fat,
    portionEstimate,
    const DeepCollectionEquality().hash(_portionTranslations),
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
    required final String name,
    @JsonKey(name: 'name_translations')
    final Map<String, String>? nameTranslations,
    required final int calories,
    required final int protein,
    required final int carbs,
    required final int fat,
    @JsonKey(name: 'portion_estimate') required final String portionEstimate,
    @JsonKey(name: 'portion_translations')
    final Map<String, String>? portionTranslations,
  }) = _$FoodItemImpl;

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'name_translations')
  Map<String, String>? get nameTranslations;
  @override
  int get calories;
  @override
  int get protein;
  @override
  int get carbs;
  @override
  int get fat;
  @override
  @JsonKey(name: 'portion_estimate')
  String get portionEstimate;
  @override
  @JsonKey(name: 'portion_translations')
  Map<String, String>? get portionTranslations;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
