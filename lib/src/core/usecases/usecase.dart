import 'package:vehicle_tracking_system/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// Marker dùng cho use case không cần tham số đầu vào.
class NoParams {
  const NoParams();
}

/// Base cho use case có tham số và có kết quả.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Base cho use case không tham số và có kết quả.
abstract interface class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Base cho use case có tham số và không trả dữ liệu.
abstract interface class VoidUseCase<Params> {
  Future<void> call(Params params);
}

/// Base cho use case không tham số và không trả dữ liệu.
abstract interface class VoidUseCaseNoParams {
  Future<void> call();
}
