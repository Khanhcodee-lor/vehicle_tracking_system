// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_tracking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeTrackingState {

 LocationPoint get currentLocation; bool get hasUserLocation; bool get hasVehicleLocation; LocationPoint get vehicleLocation; List<LocationPoint> get routePoints; String get vehicleStatus; String get vehicleSpeed; String get vehicleUpdatedAt; String get vehicleAddress; String get userAddress;
/// Create a copy of HomeTrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeTrackingStateCopyWith<HomeTrackingState> get copyWith => _$HomeTrackingStateCopyWithImpl<HomeTrackingState>(this as HomeTrackingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeTrackingState&&(identical(other.currentLocation, currentLocation) || other.currentLocation == currentLocation)&&(identical(other.hasUserLocation, hasUserLocation) || other.hasUserLocation == hasUserLocation)&&(identical(other.hasVehicleLocation, hasVehicleLocation) || other.hasVehicleLocation == hasVehicleLocation)&&(identical(other.vehicleLocation, vehicleLocation) || other.vehicleLocation == vehicleLocation)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.vehicleStatus, vehicleStatus) || other.vehicleStatus == vehicleStatus)&&(identical(other.vehicleSpeed, vehicleSpeed) || other.vehicleSpeed == vehicleSpeed)&&(identical(other.vehicleUpdatedAt, vehicleUpdatedAt) || other.vehicleUpdatedAt == vehicleUpdatedAt)&&(identical(other.vehicleAddress, vehicleAddress) || other.vehicleAddress == vehicleAddress)&&(identical(other.userAddress, userAddress) || other.userAddress == userAddress));
}


@override
int get hashCode => Object.hash(runtimeType,currentLocation,hasUserLocation,hasVehicleLocation,vehicleLocation,const DeepCollectionEquality().hash(routePoints),vehicleStatus,vehicleSpeed,vehicleUpdatedAt,vehicleAddress,userAddress);

@override
String toString() {
  return 'HomeTrackingState(currentLocation: $currentLocation, hasUserLocation: $hasUserLocation, hasVehicleLocation: $hasVehicleLocation, vehicleLocation: $vehicleLocation, routePoints: $routePoints, vehicleStatus: $vehicleStatus, vehicleSpeed: $vehicleSpeed, vehicleUpdatedAt: $vehicleUpdatedAt, vehicleAddress: $vehicleAddress, userAddress: $userAddress)';
}


}

/// @nodoc
abstract mixin class $HomeTrackingStateCopyWith<$Res>  {
  factory $HomeTrackingStateCopyWith(HomeTrackingState value, $Res Function(HomeTrackingState) _then) = _$HomeTrackingStateCopyWithImpl;
@useResult
$Res call({
 LocationPoint currentLocation, bool hasUserLocation, bool hasVehicleLocation, LocationPoint vehicleLocation, List<LocationPoint> routePoints, String vehicleStatus, String vehicleSpeed, String vehicleUpdatedAt, String vehicleAddress, String userAddress
});




}
/// @nodoc
class _$HomeTrackingStateCopyWithImpl<$Res>
    implements $HomeTrackingStateCopyWith<$Res> {
  _$HomeTrackingStateCopyWithImpl(this._self, this._then);

  final HomeTrackingState _self;
  final $Res Function(HomeTrackingState) _then;

/// Create a copy of HomeTrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentLocation = null,Object? hasUserLocation = null,Object? hasVehicleLocation = null,Object? vehicleLocation = null,Object? routePoints = null,Object? vehicleStatus = null,Object? vehicleSpeed = null,Object? vehicleUpdatedAt = null,Object? vehicleAddress = null,Object? userAddress = null,}) {
  return _then(_self.copyWith(
currentLocation: null == currentLocation ? _self.currentLocation : currentLocation // ignore: cast_nullable_to_non_nullable
as LocationPoint,hasUserLocation: null == hasUserLocation ? _self.hasUserLocation : hasUserLocation // ignore: cast_nullable_to_non_nullable
as bool,hasVehicleLocation: null == hasVehicleLocation ? _self.hasVehicleLocation : hasVehicleLocation // ignore: cast_nullable_to_non_nullable
as bool,vehicleLocation: null == vehicleLocation ? _self.vehicleLocation : vehicleLocation // ignore: cast_nullable_to_non_nullable
as LocationPoint,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<LocationPoint>,vehicleStatus: null == vehicleStatus ? _self.vehicleStatus : vehicleStatus // ignore: cast_nullable_to_non_nullable
as String,vehicleSpeed: null == vehicleSpeed ? _self.vehicleSpeed : vehicleSpeed // ignore: cast_nullable_to_non_nullable
as String,vehicleUpdatedAt: null == vehicleUpdatedAt ? _self.vehicleUpdatedAt : vehicleUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,vehicleAddress: null == vehicleAddress ? _self.vehicleAddress : vehicleAddress // ignore: cast_nullable_to_non_nullable
as String,userAddress: null == userAddress ? _self.userAddress : userAddress // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeTrackingState].
extension HomeTrackingStatePatterns on HomeTrackingState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeTrackingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeTrackingState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeTrackingState value)  $default,){
final _that = this;
switch (_that) {
case _HomeTrackingState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeTrackingState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeTrackingState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationPoint currentLocation,  bool hasUserLocation,  bool hasVehicleLocation,  LocationPoint vehicleLocation,  List<LocationPoint> routePoints,  String vehicleStatus,  String vehicleSpeed,  String vehicleUpdatedAt,  String vehicleAddress,  String userAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeTrackingState() when $default != null:
return $default(_that.currentLocation,_that.hasUserLocation,_that.hasVehicleLocation,_that.vehicleLocation,_that.routePoints,_that.vehicleStatus,_that.vehicleSpeed,_that.vehicleUpdatedAt,_that.vehicleAddress,_that.userAddress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationPoint currentLocation,  bool hasUserLocation,  bool hasVehicleLocation,  LocationPoint vehicleLocation,  List<LocationPoint> routePoints,  String vehicleStatus,  String vehicleSpeed,  String vehicleUpdatedAt,  String vehicleAddress,  String userAddress)  $default,) {final _that = this;
switch (_that) {
case _HomeTrackingState():
return $default(_that.currentLocation,_that.hasUserLocation,_that.hasVehicleLocation,_that.vehicleLocation,_that.routePoints,_that.vehicleStatus,_that.vehicleSpeed,_that.vehicleUpdatedAt,_that.vehicleAddress,_that.userAddress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationPoint currentLocation,  bool hasUserLocation,  bool hasVehicleLocation,  LocationPoint vehicleLocation,  List<LocationPoint> routePoints,  String vehicleStatus,  String vehicleSpeed,  String vehicleUpdatedAt,  String vehicleAddress,  String userAddress)?  $default,) {final _that = this;
switch (_that) {
case _HomeTrackingState() when $default != null:
return $default(_that.currentLocation,_that.hasUserLocation,_that.hasVehicleLocation,_that.vehicleLocation,_that.routePoints,_that.vehicleStatus,_that.vehicleSpeed,_that.vehicleUpdatedAt,_that.vehicleAddress,_that.userAddress);case _:
  return null;

}
}

}

/// @nodoc


class _HomeTrackingState extends HomeTrackingState {
  const _HomeTrackingState({this.currentLocation = const LocationPoint(latitude: 16.047079, longitude: 108.206230), this.hasUserLocation = false, this.hasVehicleLocation = false, this.vehicleLocation = const LocationPoint(latitude: 16.047079, longitude: 108.206230), final  List<LocationPoint> routePoints = const <LocationPoint>[], this.vehicleStatus = 'Dang cho du lieu', this.vehicleSpeed = '-- km/h', this.vehicleUpdatedAt = 'Dang cho du lieu', this.vehicleAddress = 'Dang cho du lieu vi tri xe...', this.userAddress = 'Dang lay dia chi cua ban...'}): _routePoints = routePoints,super._();
  

@override@JsonKey() final  LocationPoint currentLocation;
@override@JsonKey() final  bool hasUserLocation;
@override@JsonKey() final  bool hasVehicleLocation;
@override@JsonKey() final  LocationPoint vehicleLocation;
 final  List<LocationPoint> _routePoints;
@override@JsonKey() List<LocationPoint> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override@JsonKey() final  String vehicleStatus;
@override@JsonKey() final  String vehicleSpeed;
@override@JsonKey() final  String vehicleUpdatedAt;
@override@JsonKey() final  String vehicleAddress;
@override@JsonKey() final  String userAddress;

/// Create a copy of HomeTrackingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeTrackingStateCopyWith<_HomeTrackingState> get copyWith => __$HomeTrackingStateCopyWithImpl<_HomeTrackingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeTrackingState&&(identical(other.currentLocation, currentLocation) || other.currentLocation == currentLocation)&&(identical(other.hasUserLocation, hasUserLocation) || other.hasUserLocation == hasUserLocation)&&(identical(other.hasVehicleLocation, hasVehicleLocation) || other.hasVehicleLocation == hasVehicleLocation)&&(identical(other.vehicleLocation, vehicleLocation) || other.vehicleLocation == vehicleLocation)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.vehicleStatus, vehicleStatus) || other.vehicleStatus == vehicleStatus)&&(identical(other.vehicleSpeed, vehicleSpeed) || other.vehicleSpeed == vehicleSpeed)&&(identical(other.vehicleUpdatedAt, vehicleUpdatedAt) || other.vehicleUpdatedAt == vehicleUpdatedAt)&&(identical(other.vehicleAddress, vehicleAddress) || other.vehicleAddress == vehicleAddress)&&(identical(other.userAddress, userAddress) || other.userAddress == userAddress));
}


@override
int get hashCode => Object.hash(runtimeType,currentLocation,hasUserLocation,hasVehicleLocation,vehicleLocation,const DeepCollectionEquality().hash(_routePoints),vehicleStatus,vehicleSpeed,vehicleUpdatedAt,vehicleAddress,userAddress);

@override
String toString() {
  return 'HomeTrackingState(currentLocation: $currentLocation, hasUserLocation: $hasUserLocation, hasVehicleLocation: $hasVehicleLocation, vehicleLocation: $vehicleLocation, routePoints: $routePoints, vehicleStatus: $vehicleStatus, vehicleSpeed: $vehicleSpeed, vehicleUpdatedAt: $vehicleUpdatedAt, vehicleAddress: $vehicleAddress, userAddress: $userAddress)';
}


}

/// @nodoc
abstract mixin class _$HomeTrackingStateCopyWith<$Res> implements $HomeTrackingStateCopyWith<$Res> {
  factory _$HomeTrackingStateCopyWith(_HomeTrackingState value, $Res Function(_HomeTrackingState) _then) = __$HomeTrackingStateCopyWithImpl;
@override @useResult
$Res call({
 LocationPoint currentLocation, bool hasUserLocation, bool hasVehicleLocation, LocationPoint vehicleLocation, List<LocationPoint> routePoints, String vehicleStatus, String vehicleSpeed, String vehicleUpdatedAt, String vehicleAddress, String userAddress
});




}
/// @nodoc
class __$HomeTrackingStateCopyWithImpl<$Res>
    implements _$HomeTrackingStateCopyWith<$Res> {
  __$HomeTrackingStateCopyWithImpl(this._self, this._then);

  final _HomeTrackingState _self;
  final $Res Function(_HomeTrackingState) _then;

/// Create a copy of HomeTrackingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentLocation = null,Object? hasUserLocation = null,Object? hasVehicleLocation = null,Object? vehicleLocation = null,Object? routePoints = null,Object? vehicleStatus = null,Object? vehicleSpeed = null,Object? vehicleUpdatedAt = null,Object? vehicleAddress = null,Object? userAddress = null,}) {
  return _then(_HomeTrackingState(
currentLocation: null == currentLocation ? _self.currentLocation : currentLocation // ignore: cast_nullable_to_non_nullable
as LocationPoint,hasUserLocation: null == hasUserLocation ? _self.hasUserLocation : hasUserLocation // ignore: cast_nullable_to_non_nullable
as bool,hasVehicleLocation: null == hasVehicleLocation ? _self.hasVehicleLocation : hasVehicleLocation // ignore: cast_nullable_to_non_nullable
as bool,vehicleLocation: null == vehicleLocation ? _self.vehicleLocation : vehicleLocation // ignore: cast_nullable_to_non_nullable
as LocationPoint,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<LocationPoint>,vehicleStatus: null == vehicleStatus ? _self.vehicleStatus : vehicleStatus // ignore: cast_nullable_to_non_nullable
as String,vehicleSpeed: null == vehicleSpeed ? _self.vehicleSpeed : vehicleSpeed // ignore: cast_nullable_to_non_nullable
as String,vehicleUpdatedAt: null == vehicleUpdatedAt ? _self.vehicleUpdatedAt : vehicleUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,vehicleAddress: null == vehicleAddress ? _self.vehicleAddress : vehicleAddress // ignore: cast_nullable_to_non_nullable
as String,userAddress: null == userAddress ? _self.userAddress : userAddress // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
