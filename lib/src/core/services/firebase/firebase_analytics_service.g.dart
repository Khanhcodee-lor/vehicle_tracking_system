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
    r'e6e6f6a82b4336d31068eb64050ffdf2a42568f7';
