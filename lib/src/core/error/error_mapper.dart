import 'package:firebase_auth/firebase_auth.dart';

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

  if (error is FirebaseException) {
    return Failure.serverError(
      error.message ?? 'Firebase error: ${error.code}',
    );
  }

  return Failure.serverError(error.toString());
}
