// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tracking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeTrackingController)
final homeTrackingControllerProvider = HomeTrackingControllerProvider._();

final class HomeTrackingControllerProvider
    extends $NotifierProvider<HomeTrackingController, HomeTrackingState> {
  HomeTrackingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTrackingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTrackingControllerHash();

  @$internal
  @override
  HomeTrackingController create() => HomeTrackingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeTrackingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeTrackingState>(value),
    );
  }
}

String _$homeTrackingControllerHash() =>
    r'ff61da7aad32e6c3537985a7e0357d9a88f4b335';

abstract class _$HomeTrackingController extends $Notifier<HomeTrackingState> {
  HomeTrackingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeTrackingState, HomeTrackingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeTrackingState, HomeTrackingState>,
              HomeTrackingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
