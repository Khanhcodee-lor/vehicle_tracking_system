// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_performance_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebasePerformanceService)
final firebasePerformanceServiceProvider =
    FirebasePerformanceServiceProvider._();

final class FirebasePerformanceServiceProvider
    extends
        $FunctionalProvider<
          FirebasePerformanceService,
          FirebasePerformanceService,
          FirebasePerformanceService
        >
    with $Provider<FirebasePerformanceService> {
  FirebasePerformanceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebasePerformanceServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebasePerformanceServiceHash();

  @$internal
  @override
  $ProviderElement<FirebasePerformanceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebasePerformanceService create(Ref ref) {
    return firebasePerformanceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebasePerformanceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebasePerformanceService>(value),
    );
  }
}

String _$firebasePerformanceServiceHash() =>
    r'3e32d77723a5bf39e66c586c4446beeba126ce36';
