import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is Failure) {
    return error;
  }

  if (error is AppException) {
    if (error is NetworkException) {
      return Failure.networkError(error.message);
    }
    if (error is CacheException) {
      return Failure.cacheError(error.message);
    }
    return Failure.serverError(error.message);
  }

  if (error is FirebaseAuthException) {
    return Failure.serverError(
      error.message ?? 'Firebase auth error: ${error.code}',
    );
  }

  if (error is PlatformException) {
    if (_isGoogleShaConfigError(error)) {
      return const Failure.serverError(
        'Google Sign-In chua duoc cau hinh dung cho Android. Hay them SHA-1/SHA-256 vao Firebase va tai lai google-services.json.',
      );
    }

    return Failure.serverError(
      error.message ?? 'Platform error: ${error.code}',
    );
  }

  if (error is FirebaseException) {
    return Failure.serverError(
      error.message ?? 'Firebase error: ${error.code}',
    );
  }

  return Failure.serverError(error.toString());
}

bool _isGoogleShaConfigError(PlatformException error) {
  final message = (error.message ?? '').toLowerCase();
  final details = (error.details?.toString() ?? '').toLowerCase();

  return error.code == 'sign_in_failed' &&
      (message.contains('apiexception: 10') ||
          details.contains('apiexception: 10'));
}
