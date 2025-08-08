import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DifficultyPerformanceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> difficulties;

  const DifficultyPerformanceWidget({
    Key? key,
    required this.difficulties,
  }) : super(key: key);

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return 0.0;
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Process the difficulty data
    final processedDifficulties = difficulties.map((diff) {
      final total = _parseDouble(diff['total'] ?? 0);
      final accuracy = _parseDouble(diff['accuracy'] ?? 0.0);
      
      return {
        ...diff,
        'total': total,
        'accuracy': accuracy,
        'calculated_accuracy': accuracy,
      };
    }).toList()
      ..sort((a, b) {
        final aAccuracy = _parseDouble(a['calculated_accuracy'] ?? 0.0);
        final bAccuracy = _parseDouble(b['calculated_accuracy'] ?? 0.0);
        return bAccuracy.compareTo(aAccuracy);
      });

    // Map difficulty levels to colors
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
                  // Pie Chart
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
                              data['difficulty']?.toString() ?? 'Sem classificação',
                          yValueMapper: (data, _) => 
                              _parseDouble(data['calculated_accuracy'] ?? 0.0),
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
                  // Legend
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: processedDifficulties.map((data) {
                        final difficulty = 
                            data['difficulty']?.toString() ?? 'Sem classificação';
                        final accuracy = _parseDouble(data['calculated_accuracy']);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: difficultyColors[difficulty] ?? Colors.grey,
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
}
