import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/exceptions.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/core/network/network_info.dart';
import 'package:orbirq/features/performance/data/datasources/performance_remote_data_source.dart';
import 'package:orbirq/features/performance/domain/entities/performance_entity.dart';
import 'package:orbirq/features/performance/domain/repositories/performance_repository.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final PerformanceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PerformanceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PerformanceEntity>> getPerformanceData(
    int userId, {
    String? token,
    String? customPath,
  }) async {
    print('🔄 [PerformanceRepositoryImpl] Getting performance data for user $userId');
    
    // Check network connection
    final isConnected = await networkInfo.isConnected;
    print('📶 Network connection status: $isConnected');
    
    if (!isConnected) {
      print('❌ No internet connection available');
      return Left(NetworkFailure());
    }

    try {
      print('📡 Fetching performance data from remote data source...');
      final remotePerformance = await remoteDataSource.getPerformanceData(
        userId, 
        token: token,
      );
      
      print('✅ Successfully fetched performance data:');
      print('   - Overall: ${remotePerformance.overall}');
      print('   - Subjects: ${remotePerformance.bySubject.length}');
      print('   - Difficulties: ${remotePerformance.byDifficulty.length}');
      print('   - Recent responses: ${remotePerformance.recentResponses.length}');
      
      return Right(remotePerformance);
    } on UnauthorizedException {
      print('🔒 Unauthorized: Invalid or expired token');
      return Left(UnauthorizedFailure());
    } on NotFoundException catch (e) {
      print('🔍 Not found: ${e.message}');
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      print('⚠️ Server error (${e.statusCode}): ${e.message}');
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on TimeoutException {
      print('⏱️ Request timed out');
      return Left(TimeoutFailure());
    } on FormatException catch (e) {
      print('❌ Format error: ${e.message}');
      print('   - Source: ${e.source}');
      print('   - Offset: ${e.offset}');
      return Left(ValidationFailure(
        message: 'Invalid data format: ${e.message}',
      ));
    } catch (e, stackTrace) {
      print('❌ Unexpected error in getPerformanceData:');
      print('   - Error: $e');
      print('   - Stack trace: $stackTrace');
      return Left(UnknownFailure(
        message: 'An unexpected error occurred: $e',
      ));
    }
  }
}
