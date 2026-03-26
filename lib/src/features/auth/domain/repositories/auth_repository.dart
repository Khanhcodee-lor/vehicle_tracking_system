import 'package:vehicle_tracking_system/src/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> signInWithEmail(String email, String password);
  Future<AppUser?> signUpWithEmail(String email, String password);
  Future<void> signOut();

  AppUser? getCurrentUser();
}
