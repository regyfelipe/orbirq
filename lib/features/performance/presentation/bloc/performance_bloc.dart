import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/features/performance/domain/entities/performance_entity.dart';
import 'package:orbirq/features/performance/domain/usecases/get_performance_data.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_event.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_state.dart';

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  final GetPerformanceData getPerformanceData;
  StreamSubscription? _performanceSubscription;

  PerformanceBloc({required this.getPerformanceData}) : super(PerformanceInitial()) {
    on<LoadPerformanceData>(_onLoadPerformanceData);
    on<RefreshPerformanceData>(_onRefreshPerformanceData);
  }

  Future<void> _onLoadPerformanceData(
    LoadPerformanceData event,
    Emitter<PerformanceState> emit,
  ) async {
    print('🔄 [PerformanceBloc] Loading performance data for user ${event.userId}');
    emit(PerformanceLoading());
    
    try {
      final result = await getPerformanceData(
        PerformanceParams(userId: event.userId, token: event.token),
      );
      
      print('✅ [PerformanceBloc] Successfully loaded performance data');
      _handlePerformanceResult(result, emit);
    } catch (e, stackTrace) {
      print('❌ [PerformanceBloc] Error loading performance data:');
      print('   - Error: $e');
      print('   - Stack trace: $stackTrace');
      emit(const PerformanceError(
        message: 'Falha ao carregar os dados de desempenho. Tente novamente mais tarde.',
      ));
    }
  }

  Future<void> _onRefreshPerformanceData(
    RefreshPerformanceData event,
    Emitter<PerformanceState> emit,
  ) async {
    print('🔄 [PerformanceBloc] Refreshing performance data for user ${event.userId}');
    
    if (state is PerformanceLoaded) {
      emit((state as PerformanceLoaded).copyWith(isRefreshing: true));
    } else {
      emit(PerformanceLoading());
    }

    try {
      final result = await getPerformanceData(
        PerformanceParams(userId: event.userId, token: event.token),
      );
      
      print('✅ [PerformanceBloc] Successfully refreshed performance data');
      _handlePerformanceResult(result, emit);
    } catch (e, stackTrace) {
      print('❌ [PerformanceBloc] Error refreshing performance data:');
      print('   - Error: $e');
      print('   - Stack trace: $stackTrace');
      
      // If we were refreshing, go back to the previous state but show an error
      if (state is PerformanceLoaded) {
        emit((state as PerformanceLoaded).copyWith(
          isRefreshing: false,
          errorMessage: 'Falha ao atualizar os dados. Puxe para baixo para tentar novamente.',
        ));
      } else {
        emit(PerformanceError(
          message: 'Falha ao carregar os dados de desempenho. Tente novamente mais tarde.',
        ));
      }
    }
  }

  void _handlePerformanceResult(
    Either<Failure, PerformanceEntity> result,
    Emitter<PerformanceState> emit,
  ) {
    result.fold(
      (failure) {
        print('❌ [PerformanceBloc] Error handling performance result:');
        print('   - Failure type: ${failure.runtimeType}');
        print('   - Message: ${failure.message ?? 'No message'}');
        
        if (failure is NetworkFailure) {
          print('   - Network error');
          emit(const PerformanceError(
            message: 'Sem conexão com a internet. Verifique sua conexão e tente novamente.',
          ));
        } else if (failure is UnauthorizedFailure) {
          print('   - Unauthorized error');
          emit(const PerformanceError(
            message: 'Sessão expirada. Por favor, faça login novamente.',
            isUnauthorized: true,
          ));
        } else if (failure is NotFoundFailure) {
          print('   - Not found error');
          emit(PerformanceError(
            message: failure.message ?? 'Dados de desempenho não encontrados.',
          ));
        } else if (failure is ServerFailure) {
          print('   - Server error (${failure.statusCode ?? 'N/A'})');
          emit(PerformanceError(
            message: 'Erro no servidor. Código: ${failure.statusCode ?? 'N/A'}.',
          ));
        } else if (failure is TimeoutFailure) {
          print('   - Timeout error');
          emit(const PerformanceError(
            message: 'Tempo de conexão esgotado. Tente novamente mais tarde.',
          ));
        } else {
          print('   - Unknown error');
          emit(PerformanceError(
            message: failure.message ?? 'Ocorreu um erro inesperado.',
          ));
        }
      },
      (performance) {
        print('✅ [PerformanceBloc] Successfully handled performance data:');
        print('   - Overall: ${performance.overall}');
        print('   - Subjects: ${performance.bySubject.length}');
        print('   - Difficulties: ${performance.byDifficulty.length}');
        print('   - Recent responses: ${performance.recentResponses.length}');
        
        emit(PerformanceLoaded(performance: performance));
      },
    );
  }

  @override
  Future<void> close() {
    _performanceSubscription?.cancel();
    return super.close();
  }
}
