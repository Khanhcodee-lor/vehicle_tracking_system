import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';

class LoggerUtils {
  static void d(String message) {
    dev.log('DEBUG: $message', name: 'APP');
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    dev.log(
      'ERROR: $message',
      name: 'APP',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void i(String message) {
    dev.log('INFO: $message', name: 'APP');
  }

  static void firebaseError(
    String context,
    Object error,
    StackTrace stackTrace,
  ) {
    final String message = _firebaseMessage(error);
    e('[$context] $message', error, stackTrace);
  }

  static String _firebaseMessage(Object error) {
    if (error is FirebaseAuthException) {
      return 'FirebaseAuthException(code: ${error.code}, message: ${error.message ?? 'Unknown auth error'})';
    }

    if (error is FirebaseException) {
      return 'FirebaseException(plugin: ${error.plugin}, code: ${error.code}, message: ${error.message ?? 'Unknown firebase error'})';
    }

    return error.toString();
  }
}
