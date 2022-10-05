// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'beacon_broadcasting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BeaconBroadcastingStateTearOff {
  const _$BeaconBroadcastingStateTearOff();

  _BeaconBroadcastingState call(
      {bool broadcastReady = false, bool isBroadcasting = false}) {
    return _BeaconBroadcastingState(
      broadcastReady: broadcastReady,
      isBroadcasting: isBroadcasting,
    );
  }
}

/// @nodoc
const $BeaconBroadcastingState = _$BeaconBroadcastingStateTearOff();

/// @nodoc
mixin _$BeaconBroadcastingState {
  bool get broadcastReady => throw _privateConstructorUsedError;
  bool get isBroadcasting => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BeaconBroadcastingStateCopyWith<BeaconBroadcastingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeaconBroadcastingStateCopyWith<$Res> {
  factory $BeaconBroadcastingStateCopyWith(BeaconBroadcastingState value,
          $Res Function(BeaconBroadcastingState) then) =
      _$BeaconBroadcastingStateCopyWithImpl<$Res>;
  $Res call({bool broadcastReady, bool isBroadcasting});
}

/// @nodoc
class _$BeaconBroadcastingStateCopyWithImpl<$Res>
    implements $BeaconBroadcastingStateCopyWith<$Res> {
  _$BeaconBroadcastingStateCopyWithImpl(this._value, this._then);

  final BeaconBroadcastingState _value;
  // ignore: unused_field
  final $Res Function(BeaconBroadcastingState) _then;

  @override
  $Res call({
    Object? broadcastReady = freezed,
    Object? isBroadcasting = freezed,
  }) {
    return _then(_value.copyWith(
      broadcastReady: broadcastReady == freezed
          ? _value.broadcastReady
          : broadcastReady // ignore: cast_nullable_to_non_nullable
              as bool,
      isBroadcasting: isBroadcasting == freezed
          ? _value.isBroadcasting
          : isBroadcasting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$BeaconBroadcastingStateCopyWith<$Res>
    implements $BeaconBroadcastingStateCopyWith<$Res> {
  factory _$BeaconBroadcastingStateCopyWith(_BeaconBroadcastingState value,
          $Res Function(_BeaconBroadcastingState) then) =
      __$BeaconBroadcastingStateCopyWithImpl<$Res>;
  @override
  $Res call({bool broadcastReady, bool isBroadcasting});
}

/// @nodoc
class __$BeaconBroadcastingStateCopyWithImpl<$Res>
    extends _$BeaconBroadcastingStateCopyWithImpl<$Res>
    implements _$BeaconBroadcastingStateCopyWith<$Res> {
  __$BeaconBroadcastingStateCopyWithImpl(_BeaconBroadcastingState _value,
      $Res Function(_BeaconBroadcastingState) _then)
      : super(_value, (v) => _then(v as _BeaconBroadcastingState));

  @override
  _BeaconBroadcastingState get _value =>
      super._value as _BeaconBroadcastingState;

  @override
  $Res call({
    Object? broadcastReady = freezed,
    Object? isBroadcasting = freezed,
  }) {
    return _then(_BeaconBroadcastingState(
      broadcastReady: broadcastReady == freezed
          ? _value.broadcastReady
          : broadcastReady // ignore: cast_nullable_to_non_nullable
              as bool,
      isBroadcasting: isBroadcasting == freezed
          ? _value.isBroadcasting
          : isBroadcasting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_BeaconBroadcastingState implements _BeaconBroadcastingState {
  _$_BeaconBroadcastingState(
      {this.broadcastReady = false, this.isBroadcasting = false});

  @JsonKey()
  @override
  final bool broadcastReady;
  @JsonKey()
  @override
  final bool isBroadcasting;

  @override
  String toString() {
    return 'BeaconBroadcastingState(broadcastReady: $broadcastReady, isBroadcasting: $isBroadcasting)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BeaconBroadcastingState &&
            const DeepCollectionEquality()
                .equals(other.broadcastReady, broadcastReady) &&
            const DeepCollectionEquality()
                .equals(other.isBroadcasting, isBroadcasting));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(broadcastReady),
      const DeepCollectionEquality().hash(isBroadcasting));

  @JsonKey(ignore: true)
  @override
  _$BeaconBroadcastingStateCopyWith<_BeaconBroadcastingState> get copyWith =>
      __$BeaconBroadcastingStateCopyWithImpl<_BeaconBroadcastingState>(
          this, _$identity);
}

abstract class _BeaconBroadcastingState implements BeaconBroadcastingState {
  factory _BeaconBroadcastingState({bool broadcastReady, bool isBroadcasting}) =
      _$_BeaconBroadcastingState;

  @override
  bool get broadcastReady;
  @override
  bool get isBroadcasting;
  @override
  @JsonKey(ignore: true)
  _$BeaconBroadcastingStateCopyWith<_BeaconBroadcastingState> get copyWith =>
      throw _privateConstructorUsedError;
}
