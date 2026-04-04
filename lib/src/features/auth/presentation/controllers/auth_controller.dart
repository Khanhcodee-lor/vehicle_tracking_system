import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/error_mapper.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    // Check initial user state
    final user = _repository.getCurrentUser();
    if (user != null) {
      return AuthState.authenticated(user);
    } else {
      return const AuthState.unauthenticated();
    }
  }

  Future<void> _authenticate(Future<AppUser?> Function() action) async {
    state = const AuthState.loading();
    try {
      final user = await action();
      state = user != null
          ? AuthState.authenticated(user)
          : const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(mapExceptionToFailure(e).message);
    }
  }

  Future<void> signInWithGoogle() =>
      _authenticate(() => _repository.signInWithGoogle());

  Future<void> signInWithEmail(String email, String password) =>
      _authenticate(() => _repository.signInWithEmail(email, password));

  Future<void> signUpWithEmail(String email, String password) =>
      _authenticate(() => _repository.signUpWithEmail(email, password));

  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _repository.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(mapExceptionToFailure(e).message);
    }
  }
}
