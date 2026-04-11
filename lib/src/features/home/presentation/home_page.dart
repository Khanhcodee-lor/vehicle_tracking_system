import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
              user != null && user.photoURL != null && user.photoURL!.isNotEmpty
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
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.22),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 15.4,
                minZoom: 4,
                maxZoom: 18.5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  retinaMode: RetinaMode.isHighDensity(context),
                  userAgentPackageName: 'com.example.vehicle_tracking_system',
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
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.04),
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
            top: 84.h,
            right: 16.w,
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
              ],
            ),
          ),
        ],
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
