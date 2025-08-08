import 'package:equatable/equatable.dart';

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadPerformanceData extends PerformanceEvent {
  final int userId;
  final String? token;

  const LoadPerformanceData({required this.userId, this.token});

  @override
  List<Object?> get props => [userId, token];
}

class RefreshPerformanceData extends PerformanceEvent {
  final int userId;
  final String? token;

  const RefreshPerformanceData({required this.userId, this.token});

  @override
  List<Object?> get props => [userId, token];
}
