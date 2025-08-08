import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/core/usecases/usecase.dart';
import 'package:orbirq/features/performance/domain/entities/performance_entity.dart';
import 'package:orbirq/features/performance/domain/repositories/performance_repository.dart';

class GetPerformanceData implements UseCase<PerformanceEntity, PerformanceParams> {
  final PerformanceRepository repository;

  GetPerformanceData(this.repository);

  @override
  Future<Either<Failure, PerformanceEntity>> call(PerformanceParams params) async {
    return await repository.getPerformanceData(
      params.userId,
      token: params.token,
    );
  }
}

class PerformanceParams {
  final int userId;
  final String? token;

  PerformanceParams({
    required this.userId,
    this.token,
  });
}
