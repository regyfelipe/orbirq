import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/core/constants/app_sizes.dart';

class SimuladoNavigationWidget extends StatelessWidget {
  final int questaoAtual;
  final int totalQuestoes;
  final Map<int, String> respostas;
  final VoidCallback? onAnterior;
  final VoidCallback? onProxima;
  final VoidCallback? onFinalizar;
  final VoidCallback? onPausar;

  const SimuladoNavigationWidget({
    super.key,
    required this.questaoAtual,
    required this.totalQuestoes,
    required this.respostas,
    this.onAnterior,
    this.onProxima,
    this.onFinalizar,
    this.onPausar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radius),
          topRight: Radius.circular(AppSizes.radius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuestoesGrid(),
          const SizedBox(height: AppSizes.lg),
          _buildBotoesNavegacao(),
        ],
      ),
    );
  }

  Widget _buildQuestoesGrid() {
    final questoesPorLinha = 5;
    final linhas = (totalQuestoes / questoesPorLinha).ceil();

    return Column(
      children: List.generate(linhas, (linhaIndex) {
        final inicio = linhaIndex * questoesPorLinha;
        final fim = (inicio + questoesPorLinha).clamp(0, totalQuestoes);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Row(
            children: List.generate(fim - inicio, (index) {
              final questaoIndex = inicio + index;
              final isAtual = questaoIndex == questaoAtual;
              final isRespondida = respostas.containsKey(questaoIndex);

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildQuestaoButton(
                    questaoIndex: questaoIndex,
                    isAtual: isAtual,
                    isRespondida: isRespondida,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildQuestaoButton({
    required int questaoIndex,
    required bool isAtual,
    required bool isRespondida,
  }) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isAtual) {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
      borderColor = AppColors.primary;
    } else if (isRespondida) {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      borderColor = Colors.green.shade300;
    } else {
      backgroundColor = Colors.grey.shade100;
      textColor = Colors.grey.shade600;
      borderColor = Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: () {
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: Text(
            '${questaoIndex + 1}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBotoesNavegacao() {
    final isPrimeiraQuestao = questaoAtual == 0;
    final isUltimaQuestao = questaoAtual == totalQuestoes - 1;
    final todasRespondidas = respostas.length == totalQuestoes;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPausar,
            icon: const Icon(Icons.pause),
            label: const Text('Pausar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: isPrimeiraQuestao ? null : onAnterior,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: isUltimaQuestao && todasRespondidas
                ? onFinalizar
                : onProxima,
            icon: Icon(
              isUltimaQuestao && todasRespondidas
                  ? Icons.check
                  : Icons.arrow_forward,
            ),
            label: Text(
              isUltimaQuestao && todasRespondidas ? 'Finalizar' : 'Próxima',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
