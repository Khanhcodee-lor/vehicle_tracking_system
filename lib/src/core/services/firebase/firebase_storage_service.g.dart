// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseStorageService)
final firebaseStorageServiceProvider = FirebaseStorageServiceProvider._();

final class FirebaseStorageServiceProvider
    extends
        $FunctionalProvider<
          FirebaseStorageService,
          FirebaseStorageService,
          FirebaseStorageService
        >
    with $Provider<FirebaseStorageService> {
  FirebaseStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseStorageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseStorageServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseStorageService create(Ref ref) {
    return firebaseStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseStorageService>(value),
    );
  }
}

String _$firebaseStorageServiceHash() =>
    r'44250ccd963835ef361a218487235124c7e68d7c';
