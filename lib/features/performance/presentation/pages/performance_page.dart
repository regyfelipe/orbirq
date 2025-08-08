import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:orbirq/features/performance/domain/usecases/get_performance_data.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_bloc.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_event.dart';
import 'package:orbirq/features/performance/presentation/bloc/performance_state.dart';
import 'package:orbirq/features/performance/presentation/widgets/performance_content.dart';

class PerformancePage extends StatelessWidget {
  final int userId;
  final String? token;

  const PerformancePage({
    Key? key,
    required this.userId,
    this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🔄 [PerformancePage] Building with userId: $userId, token: ${token != null ? 'present' : 'null'}');
    
    return BlocProvider(
      create: (context) {
        // Get the required dependencies from GetIt
        try {
          final getPerformanceData = GetIt.instance<GetPerformanceData>();
          print('✅ [PerformancePage] Successfully got GetPerformanceData from GetIt');
          
          final bloc = PerformanceBloc(
            getPerformanceData: getPerformanceData,
          );
          
          print('🚀 [PerformancePage] Dispatching LoadPerformanceData for user $userId');
          bloc.add(LoadPerformanceData(userId: userId, token: token));
          
          return bloc;
        } catch (e, stackTrace) {
          print('❌ [PerformancePage] Error creating PerformanceBloc:');
          print('   - Error: $e');
          print('   - Stack trace: $stackTrace');
          rethrow;
        }
      },
      child: const PerformanceView(),
    );
  }
}

class PerformanceView extends StatelessWidget {
  const PerformanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Desempenho'),
        actions: [
          BlocBuilder<PerformanceBloc, PerformanceState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state is PerformanceLoading
                    ? null
                    : () {
                        final bloc = context.read<PerformanceBloc>();
                        final currentState = bloc.state;
                        final userId = currentState.userId;
                        final token = currentState.token;
                        
                        if (userId != null) {
                          bloc.add(
                            RefreshPerformanceData(
                              userId: userId,
                              token: token,
                            ),
                          );
                        } else {
                          // If we don't have a userId, try to load the initial data
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
              );
            },
          ),
        ],
      ),
      body: const PerformanceContent(),
    );
  }
}
