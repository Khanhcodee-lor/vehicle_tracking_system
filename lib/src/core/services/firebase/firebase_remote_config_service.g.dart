// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_remote_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseRemoteConfigService)
final firebaseRemoteConfigServiceProvider =
    FirebaseRemoteConfigServiceProvider._();

final class FirebaseRemoteConfigServiceProvider
    extends
        $FunctionalProvider<
          FirebaseRemoteConfigService,
          FirebaseRemoteConfigService,
          FirebaseRemoteConfigService
        >
    with $Provider<FirebaseRemoteConfigService> {
  FirebaseRemoteConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseRemoteConfigServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseRemoteConfigServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseRemoteConfigService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseRemoteConfigService create(Ref ref) {
    return firebaseRemoteConfigService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseRemoteConfigService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseRemoteConfigService>(value),
    );
  }
}

String _$firebaseRemoteConfigServiceHash() =>
    r'ce1b72fbebe7abbeeafb63d1f6c2bc14329989fb';
