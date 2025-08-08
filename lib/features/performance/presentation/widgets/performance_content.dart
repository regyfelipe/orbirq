import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_bloc.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_event.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_state.dart';
import 'package:orbirq/features/performance/presentation/pages/performance_page.dart';
import 'package:orbirq/features/performance/presentation/widgets/difficulty_performance_widget.dart';
import 'package:orbirq/features/performance/presentation/widgets/overall_stats_widget.dart';
import 'package:orbirq/features/performance/presentation/widgets/recent_responses_widget.dart';
import 'package:orbirq/features/performance/presentation/widgets/subject_performance_widget.dart';

class PerformanceContent extends StatelessWidget {
  const PerformanceContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) {
        if (state is PerformanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PerformanceError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                BlocBuilder<PerformanceBloc, PerformanceState>(
                  builder: (context, state) {
                    final bloc = context.read<PerformanceBloc>();
                    final userId = state.userId;
                    final token = state.token;
                    
                    return ElevatedButton(
                      onPressed: () {
                        if (userId != null) {
                          bloc.add(
                            LoadPerformanceData(
                              userId: userId,
                              token: token,
                            ),
                          );
                        } else {
                          // If userId is null, try to get it from the PerformancePage
                          final page = context.findAncestorWidgetOfExactType<PerformancePage>();
                          if (page != null) {
                            bloc.add(
                              LoadPerformanceData(
                                userId: page.userId,
                                token: page.token,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Tentar novamente'),
                    );
                  },
                ),
              ],
            ),
          );
        }

        if (state is PerformanceLoaded) {
          final performance = state.performance;
          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<PerformanceBloc>();
              final state = bloc.state;
              final userId = state.userId;
              final token = state.token;

              if (userId != null) {
                bloc.add(
                  RefreshPerformanceData(
                    userId: userId,
                    token: token,
                  ),
                );
              } else {
                // If userId is null, try to get it from the PerformancePage
                final page = context.findAncestorWidgetOfExactType<PerformancePage>();
                if (page != null) {
                  bloc.add(
                    LoadPerformanceData(
                      userId: page.userId,
                      token: page.token,
                    ),
                  );
                }
              }
              // Wait for the refresh to complete
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverallStatsWidget(overall: performance.overall),
                  const SizedBox(height: 24),
                  if (performance.bySubject.isNotEmpty) ...[
                    SubjectPerformanceWidget(subjects: performance.bySubject),
                    const SizedBox(height: 24),
                  ],
                  if (performance.byDifficulty.isNotEmpty) ...[
                    DifficultyPerformanceWidget(difficulties: performance.byDifficulty),
                    const SizedBox(height: 24),
                  ],
                  if (performance.recentResponses.isNotEmpty)
                    RecentResponsesWidget(responses: performance.recentResponses),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum dado de desempenho disponível',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete alguns exercícios para ver suas estatísticas de desempenho aqui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to exercises screen or refresh
                    final userId = context.read<PerformanceBloc>().state.userId;
                    final token = context.read<PerformanceBloc>().state.token;
                    if (userId != null) {
                      context.read<PerformanceBloc>().add(
                            LoadPerformanceData(
                              userId: userId,
                              token: token,
                            ),
                          );
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Atualizar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
