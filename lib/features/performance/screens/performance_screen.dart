import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/services/response_service.dart';
import 'package:orbirq/core/services/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Model for chart data
class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, {this.color = Colors.blue});
}

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  // Helper methods to safely parse values
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return 0.0;
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  Map<String, dynamic>? _performanceData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPerformanceData();
  }

  Future<void> _loadPerformanceData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final authService = Provider.of<AuthService>(context, listen: false);

      // Log authentication state for debugging
      print('Auth State - isAuthenticated: ${authService.isAuthenticated}');
      print('Auth State - User ID: ${authService.userId}');
      print('Auth State - Token: ${authService.token?.substring(0, 10)}...');

      if (!authService.isAuthenticated) {
        throw Exception('Usuário não autenticado. Faça login novamente.');
      }

      if (authService.userId == null || authService.userId!.isEmpty) {
        throw Exception(
          'ID de usuário não encontrado. Tente fazer login novamente.',
        );
      }

      final userId = int.tryParse(authService.userId!);
      if (userId == null) {
        throw Exception('ID de usuário inválido: ${authService.userId}');
      }

      print('Buscando dados de desempenho para o usuário: $userId');
      final data = await ResponseService.getUserPerformance(
        userId,
        token: authService.token,
      );

      if (mounted) {
        setState(() {
          _performanceData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erro ao carregar dados de desempenho: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (!authService.isAuthenticated) {
          return const Scaffold(
            body: Center(
              child: Text('Por favor, faça login para ver seu desempenho'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Desempenho'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _isLoading ? null : _loadPerformanceData,
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPerformanceData,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_performanceData == null) {
      return const Center(child: Text('Nenhum dado de desempenho disponível'));
    }

    final overall = _performanceData!['overall'];
    final bySubject = List<Map<String, dynamic>>.from(
      _performanceData!['bySubject'] ?? [],
    );
    final byDifficulty = List<Map<String, dynamic>>.from(
      _performanceData!['byDifficulty'] ?? [],
    );
    final recentResponses = List<Map<String, dynamic>>.from(
      _performanceData!['recentResponses'] ?? [],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallStats(overall),
          const SizedBox(height: 24),
          if (bySubject.isNotEmpty) _buildSubjectPerformance(bySubject),
          const SizedBox(height: 24),
          if (byDifficulty.isNotEmpty)
            _buildDifficultyPerformance(byDifficulty),
          const SizedBox(height: 24),
          if (recentResponses.isNotEmpty)
            _buildRecentResponses(recentResponses),
        ],
      ),
    );
  }

  Widget _buildOverallStats(Map<String, dynamic>? stats) {
    if (stats == null) return const SizedBox();

    // Convert values safely
    final total = _parseInt(stats['totalResponses'] ?? 0);
    final correct = _parseInt(stats['correctResponses'] ?? 0);
    // Accuracy is calculated from correct/total to ensure consistency
    final incorrect = total - correct;
    final streak = _parseInt(stats['currentStreak'] ?? 0);
    final bestStreak = _parseInt(stats['bestStreak'] ?? 0);

    // Prepare chart data
    final chartData = [
      ChartData('Acertos', correct.toDouble(), color: Colors.green),
      ChartData('Erros', incorrect.toDouble(), color: Colors.red),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Visão Geral',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.insights_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Chart and Stats Row
            Row(
              children: [
                // Donut Chart
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      series: <DoughnutSeries<ChartData, String>>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (data, _) => data.label,
                          yValueMapper: (data, _) => data.value,
                          pointColorMapper: (data, _) => data.color,
                          radius: '70%',
                          innerRadius: '60%',
                          dataLabelMapper: (data, _) => '${data.value.toInt()}',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatItem(
                        'Total',
                        total.toString(),
                        Icons.numbers_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildStatItem(
                        'Acertos',
                        '$correct (${total > 0 ? ((correct / total) * 100).toStringAsFixed(1) : 0}%)',
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildStatItem(
                        'Erros',
                        '$incorrect (${total > 0 ? ((incorrect / total) * 100).toStringAsFixed(1) : 0}%)',
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      if (streak > 0) ...[
                        const SizedBox(height: 12),
                        _buildStatItem(
                          'Sequência Atual',
                          '$streak dia${streak != 1 ? 's' : ''}',
                          Icons.local_fire_department_rounded,
                          color: Colors.orange,
                        ),
                      ],
                      if (bestStreak > 0) ...[
                        const SizedBox(height: 12),
                        _buildStatItem(
                          'Melhor Sequência',
                          '$bestStreak dia${bestStreak != 1 ? 's' : ''}',
                          Icons.emoji_events_rounded,
                          color: Colors.amber,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSubjectPerformance(List<Map<String, dynamic>> subjects) {
    if (subjects.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate accuracy for each subject and create a new list with the calculated value
    final processedSubjects = subjects.map((subject) {
      final total = _parseInt(subject['total_responses']);
      final correct = _parseInt(subject['correct_responses']);
      final accuracy = total > 0 ? (correct / total) * 100 : 0.0;
      
      return {
        ...subject,
        'total_responses': total,
        'correct_responses': correct,
        'calculated_accuracy': accuracy,
      };
    }).toList()
      ..sort((a, b) {
        final aAccuracy = _parseDouble(a['calculated_accuracy'] ?? 0.0);
        final bAccuracy = _parseDouble(b['calculated_accuracy'] ?? 0.0);
        return bAccuracy.compareTo(aAccuracy);
      });

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Desempenho por Matéria',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.school_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: processedSubjects.length * 60.0,
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: NumericAxis(
                  isVisible: true,
                  minimum: 0,
                  maximum: 100,
                  interval: 25,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: CategoryAxis(
                  isVisible: true,
                  labelAlignment: LabelAlignment.end,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                series: <BarSeries<Map<String, dynamic>, String>>[
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: processedSubjects,
                    xValueMapper: (data, _) => data['subject']?.toString() ?? 'Sem matéria',
                    yValueMapper: (data, _) => _parseDouble(data['calculated_accuracy'] ?? 0.0),
                    width: 0.7,
                    spacing: 0.2,
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.auto,
                      labelPosition: ChartDataLabelPosition.outside,
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    dataLabelMapper: (data, _) {
                      final accuracy = _parseDouble(data['calculated_accuracy'] ?? 0.0);
                      return '${accuracy.toStringAsFixed(1)}%';
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDifficultyPerformance(List<Map<String, dynamic>> difficulties) {
    if (difficulties.isEmpty) {
      return const SizedBox.shrink();
    }

    // Processa os dados para garantir que todos os valores numéricos estejam corretos
    final processedDifficulties = difficulties.map((diff) {
      final total = _parseInt(diff['total'] ?? 0);
      final accuracy = _parseDouble(diff['accuracy'] ?? 0.0);
      
      return {
        ...diff,
        'total': total,
        'accuracy': accuracy,
        'calculated_accuracy': accuracy, // Mantendo para compatibilidade
      };
    }).toList()
      ..sort((a, b) {
        final aAccuracy = _parseDouble(a['calculated_accuracy'] ?? 0.0);
        final bAccuracy = _parseDouble(b['calculated_accuracy'] ?? 0.0);
        return bAccuracy.compareTo(aAccuracy);
      });

    // Mapear níveis de dificuldade para cores
    final difficultyColors = {
      'Fácil': Colors.green,
      'Médio': Colors.orange,
      'Difícil': Colors.red,
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Desempenho por Dificuldade',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.analytics_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // Gráfico de pizza
                  Expanded(
                    flex: 2,
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      legend: const Legend(
                        isVisible: false,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <PieSeries<Map<String, dynamic>, String>>[
                        PieSeries<Map<String, dynamic>, String>(
                          dataSource: processedDifficulties,
                          xValueMapper: (data, _) =>
                              data['difficulty']?.toString() ??
                              'Sem classificação',
                          yValueMapper: (data, _) => _parseDouble(data['calculated_accuracy'] ?? 0.0),
                          pointColorMapper: (data, _) {
                            final difficulty = data['difficulty']?.toString() ?? '';
                            return difficultyColors[difficulty] ?? Colors.grey;
                          },
                          dataLabelMapper: (data, _) {
                            final difficulty = data['difficulty']?.toString() ?? 'N/A';
                            final accuracy = _parseDouble(data['calculated_accuracy'] ?? 0.0);
                            return '${difficulty}\n${accuracy.toStringAsFixed(1)}%';
                          },
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          radius: '80%',
                          explode: true,
                          explodeAll: false,
                          explodeIndex: 1,
                        ),
                      ],
                    ),
                  ),
                  // Legenda
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: processedDifficulties.map((data) {
                        final difficulty =
                            data['difficulty']?.toString() ??
                            'Sem classificação';
                        final accuracy = _parseDouble(data['calculated_accuracy']);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      difficultyColors[difficulty] ??
                                      Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  difficulty,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${accuracy.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecentResponses(List<Map<String, dynamic>> responses) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Respostas Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...responses
                .take(5)
                .map((response) => _buildResponseItem(response)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseItem(Map<String, dynamic> response) {
    final isCorrect = response['is_correct'] == true || 
                      response['is_correct'] == 'true' || 
                      response['is_correct'] == 1;
    final date = DateTime.tryParse(response['created_at']?.toString() ?? '');

    return ListTile(
      leading: Icon(
        isCorrect ? Icons.check_circle : Icons.cancel,
        color: isCorrect ? Colors.green : Colors.red,
      ),
      title: Text(
        response['question_text']?.toString().substring(0, 50) ?? 'Questão',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${response['subject'] ?? 'Sem matéria'} • ${date != null ? '${date.day}/${date.month}/${date.year}' : ''}',
      ),
      trailing: Text(
        isCorrect ? 'Acertou' : 'Errou',
        style: TextStyle(
          color: isCorrect ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
