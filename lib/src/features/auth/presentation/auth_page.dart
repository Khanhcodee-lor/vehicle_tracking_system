import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/base_view.dart';
import 'controllers/auth_controller.dart';
import 'controllers/auth_state.dart';

class AuthPage extends BaseView {
  const AuthPage({super.key});

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (message) => _showError(context, message),
        orElse: () {},
      );
    });

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: Lottie.asset(AppAssets.vehicleLogin, fit: BoxFit.contain),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chao mung ban!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1F24),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dang nhap de theo doi phuong tien cua ban',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: authState.maybeWhen(
              loading: () => null,
              orElse: () => () => ref
                  .read(authControllerProvider.notifier)
                  .signInWithGoogle(),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            icon: SvgPicture.asset(AppAssets.googleIcon, height: 24),
            label: const Text(
              'Dang nhap voi Google',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool isLoading(WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return authState.maybeWhen(loading: () => true, orElse: () => false);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
