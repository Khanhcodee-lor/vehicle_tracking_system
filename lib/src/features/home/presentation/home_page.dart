import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routers/app_router.dart';
import '../domain/entities/location_point.dart';
import 'controllers/home_tracking_controller.dart';
import 'controllers/home_tracking_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final MapController _mapController = MapController();

  static const String _vehicleName = 'Xe cua toi';
  static const String _primaryMapUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String _fallbackMapUrl =
      'https://tile.openstreetmap.de/{z}/{x}/{y}.png';
  static const List<double> _zoomPresets = [14.2, 15.8, 17.2];

  bool _hasAutoCenteredOnVehicle = false;
  bool _hasTileLoadIssue = false;
  bool _isMapFullscreen = false;
  int _tileLayerVersion = 0;
  int _activeZoomPresetIndex = 1;

  String _displayName(User? user) {
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'Nguoi dung';
  }

  String _avatarLabel(User? user) {
    final name = _displayName(user).trim();
    if (name.isEmpty) return 'ND';

    final words = name.split(RegExp(r'\s+')).where((item) => item.isNotEmpty);
    final items = words.toList();
    if (items.length >= 2) {
      return '${items.first[0]}${items.last[0]}'.toUpperCase();
    }

    if (name.length == 1) return name.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  LatLng _toLatLng(LocationPoint location) {
    return LatLng(location.latitude, location.longitude);
  }

  void _centerOnVehicle(HomeTrackingState trackingState) {
    if (!trackingState.hasVehicleLocation) return;
    _mapController.move(_toLatLng(trackingState.vehicleLocation), 15.8);
  }

  Future<void> _centerOnCurrentLocation() async {
    final controller = ref.read(homeTrackingControllerProvider.notifier);
    await controller.refreshCurrentUserLocation();

    final trackingState = ref.read(homeTrackingControllerProvider);
    if (!trackingState.hasUserLocation) return;

    _mapController.move(_toLatLng(trackingState.currentLocation), 15.5);
  }

  void _scheduleAutoCenter(HomeTrackingState trackingState) {
    if (!trackingState.hasVehicleLocation || _hasAutoCenteredOnVehicle) {
      return;
    }

    _hasAutoCenteredOnVehicle = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.move(_toLatLng(trackingState.vehicleLocation), 15.8);
    });
  }

  void _toggleMapFullscreen() {
    setState(() {
      _isMapFullscreen = !_isMapFullscreen;
    });
  }

  void _showMapMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _reloadMapTiles() {
    setState(() {
      _hasTileLoadIssue = false;
      _tileLayerVersion++;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final camera = _mapController.camera;
      _mapController.move(camera.center, camera.zoom);
    });
  }

  void _applyZoomPreset(int presetIndex) {
    final camera = _mapController.camera;
    _mapController.move(camera.center, _zoomPresets[presetIndex]);
    setState(() {
      _activeZoomPresetIndex = presetIndex;
    });
  }

  void _syncZoomPreset(double zoom) {
    var nearestIndex = 0;
    var smallestDelta = double.infinity;

    for (var i = 0; i < _zoomPresets.length; i++) {
      final delta = (zoom - _zoomPresets[i]).abs();
      if (delta < smallestDelta) {
        smallestDelta = delta;
        nearestIndex = i;
      }
    }

    if (nearestIndex == _activeZoomPresetIndex) return;
    setState(() {
      _activeZoomPresetIndex = nearestIndex;
    });
  }

  Future<void> _openDirectionsToVehicle(HomeTrackingState trackingState) async {
    if (!trackingState.hasVehicleLocation) {
      _showMapMessage('Chua co vi tri xe de chi duong');
      return;
    }

    var currentState = trackingState;
    if (!currentState.hasUserLocation) {
      await ref
          .read(homeTrackingControllerProvider.notifier)
          .refreshCurrentUserLocation();
      currentState = ref.read(homeTrackingControllerProvider);
    }

    final vehicle = currentState.vehicleLocation;
    final destination = '${vehicle.latitude},${vehicle.longitude}';

    final candidates = <Uri>[
      if (currentState.hasUserLocation)
        Uri.parse('google.navigation:q=$destination&mode=d'),
      if (currentState.hasUserLocation)
        Uri.https('www.google.com', '/maps/dir/', {
          'api': '1',
          'origin':
              '${currentState.currentLocation.latitude},${currentState.currentLocation.longitude}',
          'destination': destination,
          'travelmode': 'driving',
        }),
      Uri.parse('geo:$destination?q=$destination($_vehicleName)'),
      Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': destination,
      }),
    ];

    for (final uri in candidates) {
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) continue;

      final launched = await launchUrl(
        uri,
        mode: uri.scheme.startsWith('http')
            ? LaunchMode.externalApplication
            : LaunchMode.externalNonBrowserApplication,
      );

      if (launched) return;
    }

    _showMapMessage('Khong mo duoc ung dung chi duong');
  }

  Future<void> _showVehicleDetailsSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final trackingState = ref.watch(homeTrackingControllerProvider);

            return Container(
              margin: EdgeInsets.all(12.r),
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4DCE8),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        Container(
                          width: 52.r,
                          height: 52.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Icon(
                            Icons.local_shipping_rounded,
                            color: AppColors.primary,
                            size: 28.r,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _vehicleName,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Cap nhat luc ${trackingState.vehicleUpdatedAt}, theo doi thoi gian thuc',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: _VehicleMetricCard(
                            label: 'Trang thai',
                            value: trackingState.vehicleStatus,
                            valueColor: AppColors.success,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _VehicleMetricCard(
                            label: 'Toc do',
                            value: trackingState.vehicleSpeed,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: const [
                        Expanded(
                          child: _VehicleMetricCard(
                            label: 'Nhien lieu',
                            value: '74%',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _VehicleMetricCard(
                            label: 'Nhiet do',
                            value: '32 C',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            color: AppColors.primary,
                            size: 22.r,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vi tri xe',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  trackingState.vehicleAddress,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.my_location_rounded,
                            color: AppColors.primary,
                            size: 22.r,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vi tri cua ban',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  trackingState.userAddress,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final trackingState = ref.watch(homeTrackingControllerProvider);

    _scheduleAutoCenter(trackingState);

    final initialCenter = trackingState.hasVehicleLocation
        ? _toLatLng(trackingState.vehicleLocation)
        : (trackingState.hasUserLocation
              ? _toLatLng(trackingState.currentLocation)
              : LatLng(
                  HomeTrackingState.defaultMapCenter.latitude,
                  HomeTrackingState.defaultMapCenter.longitude,
                ));

    final routePoints = trackingState.routePoints
        .map(_toLatLng)
        .toList(growable: false);
    final bottomToolbarBottom = _isMapFullscreen ? 16.h : 24.h;
    final tileIssueBottom = bottomToolbarBottom + 76.h;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _isMapFullscreen
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 78.h,
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              elevation: 0,
              titleSpacing: 16.w,
              title: GestureDetector(
                onTap: () => AppRouter.pushNamed(AppRouter.profile),
                child: Row(
                  children: [
                    user != null &&
                            user.photoURL != null &&
                            user.photoURL!.isNotEmpty
                        ? CircleAvatar(
                            radius: 23.r,
                            backgroundImage: NetworkImage(user.photoURL!),
                          )
                        : Container(
                            width: 46.r,
                            height: 46.r,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _avatarLabel(user),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _displayName(user),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                _AppBarActionButton(
                  icon: Icons.notifications_none_rounded,
                  hasBadge: true,
                  onTap: () {},
                ),
                SizedBox(width: 16.w),
              ],
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: const Color(0xFFF3EFE8),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: 15.4,
                  minZoom: 4,
                  maxZoom: 18.5,
                  onPositionChanged: (camera, hasGesture) {
                    _syncZoomPreset(camera.zoom);
                  },
                ),
                children: [
                  TileLayer(
                    key: ValueKey('tile-layer-$_tileLayerVersion'),
                    urlTemplate: _primaryMapUrl,
                    fallbackUrl: _fallbackMapUrl,
                    retinaMode: false,
                    userAgentPackageName: 'com.example.vehicle_tracking_system',
                    tileProvider: NetworkTileProvider(silenceExceptions: true),
                    panBuffer: 2,
                    keepBuffer: 4,
                    tileDisplay: const TileDisplay.instantaneous(),
                    errorTileCallback: (tile, error, stackTrace) {
                      if (!mounted || _hasTileLoadIssue) return;
                      setState(() {
                        _hasTileLoadIssue = true;
                      });
                    },
                  ),
                  if (routePoints.length >= 2)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4,
                          color: AppColors.primary.withValues(alpha: 0.18),
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      if (trackingState.hasUserLocation)
                        Marker(
                          point: _toLatLng(trackingState.currentLocation),
                          width: 22.w,
                          height: 22.h,
                          child: const _UserLocationMarker(),
                        ),
                      if (trackingState.hasVehicleLocation)
                        Marker(
                          point: _toLatLng(trackingState.vehicleLocation),
                          width: 110.w,
                          height: 126.h,
                          alignment: Alignment.topCenter,
                          child: const _VehicleMarker(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: _isMapFullscreen ? 0 : 0.015),
                      Colors.transparent,
                      Colors.white.withValues(alpha: _isMapFullscreen ? 0 : 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_hasTileLoadIssue && !_isMapFullscreen)
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: tileIssueBottom,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(999.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      'Ket noi ban do dang cham, dang thu tai lai tile',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: bottomToolbarBottom,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BottomMapButton(
                      icon: Icons.alt_route_rounded,
                      label: 'Duong di',
                      accentColor: AppColors.primary,
                      onTap: () {
                        unawaited(_openDirectionsToVehicle(trackingState));
                      },
                    ),
                    SizedBox(width: 10.w),
                    _BottomMapButton(
                      icon: Icons.refresh_rounded,
                      label: 'Tai lai',
                      accentColor: const Color(0xFF0F172A),
                      onTap: _reloadMapTiles,
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.97),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 34.r,
                            height: 34.r,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.zoom_in_map_rounded,
                              color: AppColors.primary,
                              size: 18.r,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Row(
                            children: List.generate(_zoomPresets.length, (index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: _ZoomPresetButton(
                                  label: 'x${index + 1}',
                                  isActive: _activeZoomPresetIndex == index,
                                  onTap: () => _applyZoomPreset(index),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!_isMapFullscreen)
            Positioned(
              top: 16.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.04),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: AppColors.textSecondary,
                            size: 22.r,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Tim xe, tai xe hoac dia chi',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _MapActionButton(icon: Icons.tune_rounded, onTap: () {}),
                ],
              ),
            ),
          Positioned(
            top: _isMapFullscreen ? 16.h : 84.h,
            right: 16.w,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _MapActionButton(
                    icon: Icons.my_location_rounded,
                    onTap: () {
                      unawaited(_centerOnCurrentLocation());
                    },
                  ),
                  SizedBox(height: 10.h),
                  _MapActionButton(
                    icon: Icons.local_shipping_rounded,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    onTap: () => _centerOnVehicle(trackingState),
                  ),
                  SizedBox(height: 10.h),
                  _MapActionButton(
                    icon: Icons.visibility_rounded,
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    onTap: _showVehicleDetailsSheet,
                  ),
                  SizedBox(height: 10.h),
                  _MapActionButton(
                    icon: _isMapFullscreen
                        ? Icons.close_fullscreen_rounded
                        : Icons.open_in_full_rounded,
                    onTap: _toggleMapFullscreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomMapButton extends StatelessWidget {
  const _BottomMapButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Ink(
          width: 92.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(icon, size: 18.r, color: accentColor),
              ),
              SizedBox(height: 6.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoomPresetButton extends StatelessWidget {
  const _ZoomPresetButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Ink(
          width: 44.w,
          height: 40.h,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  )
                : null,
            color: isActive ? null : const Color(0xFFF7FAFF),
            borderRadius: BorderRadius.circular(16.r),
            border: isActive
                ? null
                : Border.all(color: const Color(0xFFE7EEF8)),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 11.5.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarActionButton extends StatelessWidget {
  const _AppBarActionButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Ink(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFE8EEF7)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Icon(icon, size: 22.r, color: AppColors.textPrimary),
            ),
            if (hasBadge)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  const _MapActionButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.foregroundColor = AppColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Ink(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: foregroundColor, size: 22.r),
        ),
      ),
    );
  }
}

class _VehicleMetricCard extends StatelessWidget {
  const _VehicleMetricCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleMarker extends StatelessWidget {
  const _VehicleMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            'Xe cua toi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.local_shipping_rounded,
            color: Colors.white,
            size: 28.r,
          ),
        ),
        Container(
          width: 4.r,
          height: 18.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
      ],
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.15),
      ),
      padding: EdgeInsets.all(4.r),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          border: Border.all(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
