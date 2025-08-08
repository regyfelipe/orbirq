import 'package:equatable/equatable.dart';
import 'package:orbirq/features/performance/domain/entities/performance_entity.dart';

/// Estados possíveis para o gerenciamento de estado do módulo de desempenho
abstract class PerformanceState extends Equatable {
  /// O ID do usuário associado aos dados de desempenho
  final int? userId;
  
  /// Token de autenticação do usuário
  final String? token;
  
  const PerformanceState({this.userId, this.token});

  @override
  List<Object?> get props => [userId, token];
}

/// Estado inicial, antes de qualquer carregamento
class PerformanceInitial extends PerformanceState {
  const PerformanceInitial({super.userId, super.token});
}

/// Estado de carregamento dos dados de desempenho
class PerformanceLoading extends PerformanceState {
  const PerformanceLoading({super.userId, super.token});
}

/// Estado quando os dados de desempenho foram carregados com sucesso
class PerformanceLoaded extends PerformanceState {
  /// Dados de desempenho do usuário
  final PerformanceEntity performance;
  
  /// Indica se está ocorrendo uma atualização dos dados
  final bool isRefreshing;
  
  /// Mensagem de erro, se houver
  final String? errorMessage;

  const PerformanceLoaded({
    required this.performance,
    this.isRefreshing = false,
    this.errorMessage,
    super.userId,
    super.token,
  });

  /// Cria uma cópia deste estado com os campos fornecidos substituindo os atuais
  PerformanceLoaded copyWith({
    PerformanceEntity? performance,
    bool? isRefreshing,
    int? userId,
    String? token,
    String? errorMessage,
  }) {
    return PerformanceLoaded(
      performance: performance ?? this.performance,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
      userId: userId ?? this.userId,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [performance, isRefreshing, errorMessage, userId, token];
}

/// Estado de erro ao carregar os dados de desempenho
class PerformanceError extends PerformanceState {
  /// Mensagem de erro a ser exibida ao usuário
  final String message;
  
  /// Indica se o erro é devido a uma autenticação inválida
  final bool isUnauthorized;
  
  /// Indica se o erro ocorreu durante uma atualização
  final bool isRefreshing;

  const PerformanceError({
    required this.message,
    this.isUnauthorized = false,
    this.isRefreshing = false,
    super.userId,
    super.token,
  });
  
  /// Cria uma cópia deste estado de erro com os campos fornecidos substituindo os atuais
  PerformanceError copyWith({
    String? message,
    bool? isUnauthorized,
    bool? isRefreshing,
    int? userId,
    String? token,
  }) {
    return PerformanceError(
      message: message ?? this.message,
      isUnauthorized: isUnauthorized ?? this.isUnauthorized,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      userId: userId ?? this.userId,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [message, isUnauthorized, isRefreshing, userId, token];
}
