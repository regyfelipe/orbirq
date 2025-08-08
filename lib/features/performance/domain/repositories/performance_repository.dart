import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/features/performance/domain/entities/performance_entity.dart';

abstract class PerformanceRepository {
  /// Fetches performance data for a specific user
  /// 
  /// The [userId] is the ID of the user to fetch performance data for
  /// [token] is optional authentication token
  /// [customPath] allows overriding the default API path for testing purposes
  Future<Either<Failure, PerformanceEntity>> getPerformanceData(
    int userId, {
    String? token,
    String? customPath,
  });
}
