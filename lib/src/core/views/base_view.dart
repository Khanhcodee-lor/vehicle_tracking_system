import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

abstract class BaseView extends ConsumerWidget {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle(context),
        child: Scaffold(
          extendBodyBehindAppBar: extendBodyBehindAppBar(),
          backgroundColor: backgroundColor(context) ?? AppColors.background,
          appBar: buildAppBar(context, ref),
          drawer: buildDrawer(context, ref),
          floatingActionButton: buildFloatingActionButton(context, ref),
          bottomNavigationBar: buildBottomNavigationBar(context, ref),
          resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
          body: Stack(
            children: [
              _buildBackground(context),
              _buildResponsiveBody(context, ref),
              if (isLoading(ref)) _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final decoration = bodyDecoration(context);
    if (decoration == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: decoration,
    );
  }

  Widget _buildResponsiveBody(BuildContext context, WidgetRef ref) {
    Widget content = buildBody(context, ref);

    if (useSafeArea()) {
      content = SafeArea(
        top: safeAreaTop(),
        bottom: safeAreaBottom(),
        child: content,
      );
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: enableWebConstraints() ? 600.w : double.infinity,
        ),
        padding: padding(context),
        child: content,
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref);

  Decoration? bodyDecoration(BuildContext context) => null;

  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) => null;
  Widget? buildDrawer(BuildContext context, WidgetRef ref) => null;
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) => null;
  Widget? buildBottomNavigationBar(BuildContext context, WidgetRef ref) => null;

  Color? backgroundColor(BuildContext context) => AppColors.background;

  EdgeInsetsGeometry padding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);

  bool isLoading(WidgetRef ref) => false;

  SystemUiOverlayStyle systemUiOverlayStyle(BuildContext context) {
    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  bool resizeToAvoidBottomInset() => true;
  bool extendBodyBehindAppBar() => false;

  bool useSafeArea() => true;
  bool safeAreaTop() => true;
  bool safeAreaBottom() => true;

  bool enableWebConstraints() => true;
}
