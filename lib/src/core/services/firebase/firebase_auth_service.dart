import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../ulits/logger_ulits.dart';

part 'firebase_auth_service.g.dart';

// Lớp trung tâm quản lý user

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  bool get isGoogleSignInSupported {
    if (kIsWeb) return true;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  // email/ password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, st) {
      LoggerUtils.firebaseError('FirebaseAuthService.signInWithEmail', e, st);
      rethrow;
    }
  }

  // google
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (!isGoogleSignInSupported) {
        throw UnsupportedError(
          'Google Sign-In hiện chỉ hỗ trợ Android, iOS, macOS và Web.',
        );
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google Sign-In cancelled');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e, st) {
      LoggerUtils.firebaseError('FirebaseAuthService.signInWithGoogle', e, st);
      rethrow;
    }
  }

  // tạo user mới trên Firebase
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, st) {
      LoggerUtils.firebaseError('FirebaseAuthService.signUpWithEmail', e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  // quên mật khẩu
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

@riverpod
FirebaseAuthService firebaseAuthService(Ref ref) {
  return FirebaseAuthService();
}
/*
Service inject được ở mọi nơi
Không cần new FirebaseAuthService()
ref.read(firebaseAuthServiceProvider);
 */
