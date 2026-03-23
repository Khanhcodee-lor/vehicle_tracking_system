/// Base failure cho tầng domain/data.
sealed class Failure {
  final String message;

  const Failure(this.message);

  const factory Failure.serverError([String message]) = ServerFailure;
  const factory Failure.networkError([String message]) = NetworkFailure;
  const factory Failure.cacheError([String message]) = CacheFailure;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure']);
}
