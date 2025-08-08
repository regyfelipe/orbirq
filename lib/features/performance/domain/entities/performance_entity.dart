import 'package:equatable/equatable.dart';

class PerformanceEntity extends Equatable {
  final Map<String, dynamic> overall;
  final List<Map<String, dynamic>> bySubject;
  final List<Map<String, dynamic>> byDifficulty;
  final List<Map<String, dynamic>> recentResponses;

  const PerformanceEntity({
    required this.overall,
    required this.bySubject,
    required this.byDifficulty,
    required this.recentResponses,
  });

  @override
  List<Object?> get props => [overall, bySubject, byDifficulty, recentResponses];
}
