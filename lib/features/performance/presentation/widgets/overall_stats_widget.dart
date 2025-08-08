import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:orbirq/features/performance/data/models/chart_data_model.dart';

class OverallStatsWidget extends StatelessWidget {
  final Map<String, dynamic> overall;

  const OverallStatsWidget({
    Key? key,
    required this.overall,
  }) : super(key: key);

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final total = _parseInt(overall['totalResponses'] ?? 0);
    final correct = _parseInt(overall['correctResponses'] ?? 0);
    final incorrect = total - correct;
    final streak = _parseInt(overall['currentStreak'] ?? 0);
    final bestStreak = _parseInt(overall['bestStreak'] ?? 0);

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
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: TextStyle(fontSize: 12),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatItem(
                        context,
                        'Total',
                        total.toString(),
                        Icons.numbers_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildStatItem(
                        context,
                        'Acertos',
                        '$correct (${total > 0 ? ((correct / total) * 100).toStringAsFixed(1) : 0}%)',
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildStatItem(
                        context,
                        'Erros',
                        '$incorrect (${total > 0 ? ((incorrect / total) * 100).toStringAsFixed(1) : 0}%)',
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      if (streak > 0) ...[
                        const SizedBox(height: 12),
                        _buildStatItem(
                          context,
                          'Sequência Atual',
                          '$streak dia${streak != 1 ? 's' : ''}',
                          Icons.local_fire_department_rounded,
                          color: Colors.orange,
                        ),
                      ],
                      if (bestStreak > 0) ...[
                        const SizedBox(height: 12),
                        _buildStatItem(
                          context,
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
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
