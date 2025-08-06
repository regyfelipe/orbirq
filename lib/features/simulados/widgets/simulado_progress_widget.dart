import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../../core/constants/app_sizes.dart';

class SimuladoProgressWidget extends StatelessWidget {
  final int totalQuestoes;
  final int questoesRespondidas;
  final int acertos;
  final int erros;

  const SimuladoProgressWidget({
    super.key,
    required this.totalQuestoes,
    required this.questoesRespondidas,
    required this.acertos,
    required this.erros,
  });

  @override
  Widget build(BuildContext context) {
    final percentualConcluido = totalQuestoes > 0
        ? questoesRespondidas / totalQuestoes
        : 0.0;
    final questoesNaoRespondidas = totalQuestoes - questoesRespondidas;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de progresso
          LinearProgressIndicator(
            value: percentualConcluido,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
          const SizedBox(height: 12),

          // Estatísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Acertos',
                  value: acertos.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.cancel,
                  label: 'Erros',
                  value: erros.toString(),
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.help_outline,
                  label: 'Não respondidas',
                  value: questoesNaoRespondidas.toString(),
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Texto de progresso
          Text(
            '$questoesRespondidas de $totalQuestoes questões respondidas',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
