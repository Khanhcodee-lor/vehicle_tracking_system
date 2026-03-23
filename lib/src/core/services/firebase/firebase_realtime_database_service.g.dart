// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_realtime_database_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseRealtimeDatabaseService)
final firebaseRealtimeDatabaseServiceProvider =
    FirebaseRealtimeDatabaseServiceProvider._();

final class FirebaseRealtimeDatabaseServiceProvider
    extends
        $FunctionalProvider<
          FirebaseRealtimeDatabaseService,
          FirebaseRealtimeDatabaseService,
          FirebaseRealtimeDatabaseService
        >
    with $Provider<FirebaseRealtimeDatabaseService> {
  FirebaseRealtimeDatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseRealtimeDatabaseServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseRealtimeDatabaseServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseRealtimeDatabaseService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseRealtimeDatabaseService create(Ref ref) {
    return firebaseRealtimeDatabaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseRealtimeDatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseRealtimeDatabaseService>(
        value,
      ),
    );
  }
}

String _$firebaseRealtimeDatabaseServiceHash() =>
    r'20d612ec399d307e64eb5a5a57f477524c07324a';
