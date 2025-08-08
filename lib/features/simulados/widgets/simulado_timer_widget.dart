import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';

class SimuladoTimerWidget extends StatelessWidget {
  final int tempoRestante;
  final VoidCallback? onTempoEsgotado;

  const SimuladoTimerWidget({
    super.key,
    required this.tempoRestante,
    this.onTempoEsgotado,
  });

  @override
  Widget build(BuildContext context) {
    final minutos = tempoRestante ~/ 60;
    final segundos = tempoRestante % 60;
    final tempoFormatado =
        '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';

    final isTempoBaixo = tempoRestante <= 300;
    final isTempoCritico = tempoRestante <= 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isTempoCritico
            ? Colors.red
            : isTempoBaixo
            ? Colors.orange
            : AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            tempoFormatado,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
