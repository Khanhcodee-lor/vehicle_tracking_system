import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routers/app_router.dart';
import '../../../core/services/firebase/firebase_auth_service.dart';
import '../../../core/widgets/base_view.dart';
import 'controllers/auth_controller.dart';
import 'controllers/auth_state.dart';

class AuthPage extends BaseView {
  const AuthPage({super.key});

  @override
  EdgeInsetsGeometry padding(BuildContext context) => EdgeInsets.zero;

  @override
  Decoration? bodyDecoration(BuildContext context) {
    return const BoxDecoration(color: AppColors.surface);
  }

  @override
  bool isLoading(WidgetRef ref) {
    return ref
        .watch(authControllerProvider)
        .maybeWhen(loading: () => true, orElse: () => false);
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    _listenToAuthErrors(context, ref);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeroIllustration(),
              SizedBox(height: 56.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  'Chào mừng bạn!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.w),
                child: Text(
                  'Theo dõi và quản lý phương tiện của bạn một cách an toàn, thông minh và dễ dàng.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 48.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: _buildGoogleLoginButton(context, ref),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: _buildTermsAndPrivacy(context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: _buildSupportHint(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return SizedBox(
      width: double.infinity,
      height: 280.h,
      child: Center(
        child: Lottie.asset(
          AppAssets.vehicleLogin,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }

  void _listenToAuthErrors(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) => AppRouter.pushNamedAndRemoveUntil(AppRouter.home),
        error: (message) => _showError(context, message),
        orElse: () {},
      );
    });
  }

  Widget _buildGoogleLoginButton(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(firebaseAuthServiceProvider);
    final isLoading = ref
        .watch(authControllerProvider)
        .maybeWhen(loading: () => true, orElse: () => false);
    final isSupported = authService.isGoogleSignInSupported;

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading || !isSupported
            ? null
            : () =>
                  ref.read(authControllerProvider.notifier).signInWithGoogle(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.textSecondary,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
            side: BorderSide(
              color: AppColors.textSecondary.withValues(alpha: 0.15),
            ),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.googleIcon, width: 24.w, height: 24.w),
            SizedBox(width: 12.w),
            Text(
              'Tiếp tục với Google',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacy(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'Bằng việc tiếp tục, bạn đồng ý với\n'),
            TextSpan(
              text: 'Điều khoản dịch vụ',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' và '),
            TextSpan(
              text: 'Chính sách bảo mật',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' của chúng tôi.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHint(BuildContext context, WidgetRef ref) {
    final isSupported = ref
        .watch(firebaseAuthServiceProvider)
        .isGoogleSignInSupported;
    if (isSupported) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Text(
        'Thiết bị hoặc môi trường hiện tại không hỗ trợ Google Sign-In.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.warning, fontSize: 13.sp),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      ),
    );
  }
}
