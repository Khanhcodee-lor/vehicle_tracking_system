// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_analytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseAnalyticsService)
final firebaseAnalyticsServiceProvider = FirebaseAnalyticsServiceProvider._();

final class FirebaseAnalyticsServiceProvider
    extends
        $FunctionalProvider<
          FirebaseAnalyticsService,
          FirebaseAnalyticsService,
          FirebaseAnalyticsService
        >
    with $Provider<FirebaseAnalyticsService> {
  FirebaseAnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAnalyticsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAnalyticsServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseAnalyticsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAnalyticsService create(Ref ref) {
    return firebaseAnalyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAnalyticsService>(value),
    );
  }
}

String _$firebaseAnalyticsServiceHash() =>
    r'715f5c9bea9cba57370563e31827e93a6280820b';
