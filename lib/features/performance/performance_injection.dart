import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/core/network/network_info.dart';
import 'package:orbirq/features/performance/data/datasources/performance_remote_data_source.dart';
import 'package:orbirq/features/performance/data/models/performance_model.dart';
import 'package:orbirq/features/performance/data/repositories/performance_repository_impl.dart';
import 'package:orbirq/features/performance/domain/repositories/performance_repository.dart';
import 'package:orbirq/features/performance/domain/usecases/get_performance_data.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_bloc.dart';

final getIt = GetIt.instance;

void initPerformanceFeature() {
  // Register external dependencies first if not already registered
  if (!getIt.isRegistered<http.Client>()) {
    getIt.registerLazySingleton<http.Client>(() => http.Client());
  }
  
  if (!getIt.isRegistered<Connectivity>()) {
    getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  }
  
  if (!getIt.isRegistered<NetworkInfo>()) {
    getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: getIt()),
    );
  }

  // Register data sources if not already registered
  if (!getIt.isRegistered<PerformanceRemoteDataSource>()) {
    getIt.registerLazySingleton<PerformanceRemoteDataSource>(
      () => PerformanceRemoteDataSourceImpl(
        baseUrl: 'http://192.168.18.11:3000',
        client: getIt(),
      ),
    );
  }

  // Register repository if not already registered
  if (!getIt.isRegistered<PerformanceRepository>()) {
    getIt.registerLazySingleton<PerformanceRepository>(
      () => PerformanceRepositoryImpl(
        remoteDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );
  }

  // Register use cases if not already registered
  if (!getIt.isRegistered<GetPerformanceData>()) {
    getIt.registerLazySingleton<GetPerformanceData>(
      () => GetPerformanceData(getIt()),
    );
  }

  // Always register the bloc as it's a factory
  if (getIt.isRegistered<PerformanceBloc>()) {
    getIt.unregister<PerformanceBloc>();
  }
  getIt.registerFactory<PerformanceBloc>(
    () => PerformanceBloc(
      getPerformanceData: getIt(),
    ),
  );
}
