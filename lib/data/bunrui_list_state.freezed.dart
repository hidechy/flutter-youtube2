// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bunrui_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BunruiListStateTearOff {
  const _$BunruiListStateTearOff();

  _BunruiListState call(
      {required List<Video> youtubeList,
      required List<String> specialList,
      required List<String> selectedList}) {
    return _BunruiListState(
      youtubeList: youtubeList,
      specialList: specialList,
      selectedList: selectedList,
    );
  }
}

/// @nodoc
const $BunruiListState = _$BunruiListStateTearOff();

/// @nodoc
mixin _$BunruiListState {
  List<Video> get youtubeList => throw _privateConstructorUsedError;
  List<String> get specialList => throw _privateConstructorUsedError;
  List<String> get selectedList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BunruiListStateCopyWith<BunruiListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BunruiListStateCopyWith<$Res> {
  factory $BunruiListStateCopyWith(
          BunruiListState value, $Res Function(BunruiListState) then) =
      _$BunruiListStateCopyWithImpl<$Res>;
  $Res call(
      {List<Video> youtubeList,
      List<String> specialList,
      List<String> selectedList});
}

/// @nodoc
class _$BunruiListStateCopyWithImpl<$Res>
    implements $BunruiListStateCopyWith<$Res> {
  _$BunruiListStateCopyWithImpl(this._value, this._then);

  final BunruiListState _value;
  // ignore: unused_field
  final $Res Function(BunruiListState) _then;

  @override
  $Res call({
    Object? youtubeList = freezed,
    Object? specialList = freezed,
    Object? selectedList = freezed,
  }) {
    return _then(_value.copyWith(
      youtubeList: youtubeList == freezed
          ? _value.youtubeList
          : youtubeList // ignore: cast_nullable_to_non_nullable
              as List<Video>,
      specialList: specialList == freezed
          ? _value.specialList
          : specialList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedList: selectedList == freezed
          ? _value.selectedList
          : selectedList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$BunruiListStateCopyWith<$Res>
    implements $BunruiListStateCopyWith<$Res> {
  factory _$BunruiListStateCopyWith(
          _BunruiListState value, $Res Function(_BunruiListState) then) =
      __$BunruiListStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<Video> youtubeList,
      List<String> specialList,
      List<String> selectedList});
}

/// @nodoc
class __$BunruiListStateCopyWithImpl<$Res>
    extends _$BunruiListStateCopyWithImpl<$Res>
    implements _$BunruiListStateCopyWith<$Res> {
  __$BunruiListStateCopyWithImpl(
      _BunruiListState _value, $Res Function(_BunruiListState) _then)
      : super(_value, (v) => _then(v as _BunruiListState));

  @override
  _BunruiListState get _value => super._value as _BunruiListState;

  @override
  $Res call({
    Object? youtubeList = freezed,
    Object? specialList = freezed,
    Object? selectedList = freezed,
  }) {
    return _then(_BunruiListState(
      youtubeList: youtubeList == freezed
          ? _value.youtubeList
          : youtubeList // ignore: cast_nullable_to_non_nullable
              as List<Video>,
      specialList: specialList == freezed
          ? _value.specialList
          : specialList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedList: selectedList == freezed
          ? _value.selectedList
          : selectedList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$_BunruiListState implements _BunruiListState {
  const _$_BunruiListState(
      {required this.youtubeList,
      required this.specialList,
      required this.selectedList});

  @override
  final List<Video> youtubeList;
  @override
  final List<String> specialList;
  @override
  final List<String> selectedList;

  @override
  String toString() {
    return 'BunruiListState(youtubeList: $youtubeList, specialList: $specialList, selectedList: $selectedList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BunruiListState &&
            const DeepCollectionEquality()
                .equals(other.youtubeList, youtubeList) &&
            const DeepCollectionEquality()
                .equals(other.specialList, specialList) &&
            const DeepCollectionEquality()
                .equals(other.selectedList, selectedList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(youtubeList),
      const DeepCollectionEquality().hash(specialList),
      const DeepCollectionEquality().hash(selectedList));

  @JsonKey(ignore: true)
  @override
  _$BunruiListStateCopyWith<_BunruiListState> get copyWith =>
      __$BunruiListStateCopyWithImpl<_BunruiListState>(this, _$identity);
}

abstract class _BunruiListState implements BunruiListState {
  const factory _BunruiListState(
      {required List<Video> youtubeList,
      required List<String> specialList,
      required List<String> selectedList}) = _$_BunruiListState;

  @override
  List<Video> get youtubeList;
  @override
  List<String> get specialList;
  @override
  List<String> get selectedList;
  @override
  @JsonKey(ignore: true)
  _$BunruiListStateCopyWith<_BunruiListState> get copyWith =>
      throw _privateConstructorUsedError;
}
