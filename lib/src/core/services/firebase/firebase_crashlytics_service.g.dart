// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_crashlytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseCrashlyticsService)
final firebaseCrashlyticsServiceProvider =
    FirebaseCrashlyticsServiceProvider._();

final class FirebaseCrashlyticsServiceProvider
    extends
        $FunctionalProvider<
          FirebaseCrashlyticsService,
          FirebaseCrashlyticsService,
          FirebaseCrashlyticsService
        >
    with $Provider<FirebaseCrashlyticsService> {
  FirebaseCrashlyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseCrashlyticsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseCrashlyticsServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseCrashlyticsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseCrashlyticsService create(Ref ref) {
    return firebaseCrashlyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseCrashlyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseCrashlyticsService>(value),
    );
  }
}

String _$firebaseCrashlyticsServiceHash() =>
    r'b7a1398fbfd10798c48c1c73e5f3ea3e5008a731';
