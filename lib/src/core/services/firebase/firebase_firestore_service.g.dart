// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_firestore_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseFirestoreService)
final firebaseFirestoreServiceProvider = FirebaseFirestoreServiceProvider._();

final class FirebaseFirestoreServiceProvider
    extends
        $FunctionalProvider<
          FirebaseFirestoreService,
          FirebaseFirestoreService,
          FirebaseFirestoreService
        >
    with $Provider<FirebaseFirestoreService> {
  FirebaseFirestoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseFirestoreServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseFirestoreServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestoreService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestoreService create(Ref ref) {
    return firebaseFirestoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestoreService>(value),
    );
  }
}

String _$firebaseFirestoreServiceHash() =>
    r'7cc14bb34dc2d5adaefdb18f1ff05b1445c766dd';
