import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/core/constants/app_sizes.dart';
import 'package:orbirq/features/questoes/models/question.dart';

class SimuladoQuestaoWidget extends StatelessWidget {
  final Question questao;
  final int questaoIndex;
  final int totalQuestoes;
  final String? respostaSelecionada;
  final Function(String) onRespostaSelecionada;

  const SimuladoQuestaoWidget({
    super.key,
    required this.questao,
    required this.questaoIndex,
    required this.totalQuestoes,
    this.respostaSelecionada,
    required this.onRespostaSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.lg),
          _buildEnunciado(),
          if (questao.imageUrl != null) ...[
            const SizedBox(height: AppSizes.md),
            _buildImagem(),
          ],
          const SizedBox(height: AppSizes.lg),
          _buildOpcoes(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Questão ${questaoIndex + 1} de $totalQuestoes',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getDisciplinaColor(questao.discipline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            questao.discipline,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnunciado() {
    return Text(
      questao.text,
      style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
    );
  }

  Widget _buildImagem() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Image.network(
          questao.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOpcoes() {
    return Column(
      children: questao.options.map((opcao) => _buildOpcao(opcao)).toList(),
    );
  }

  Widget _buildOpcao(QuestionOption opcao) {
    final isSelecionada = respostaSelecionada == opcao.letter;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InkWell(
        onTap: () => onRespostaSelecionada(opcao.letter),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: isSelecionada
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppSizes.radius),
            border: Border.all(
              color: isSelecionada ? AppColors.primary : Colors.grey.shade300,
              width: isSelecionada ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelecionada ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelecionada
                        ? AppColors.primary
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelecionada
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  opcao.text,
                  style: TextStyle(
                    fontSize: 15,
                    color: isSelecionada ? AppColors.primary : Colors.black87,
                    fontWeight: isSelecionada
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDisciplinaColor(String disciplina) {
    switch (disciplina.toLowerCase()) {
      case 'matemática':
      case 'matematica':
        return Colors.blue;
      case 'português':
      case 'portugues':
        return Colors.green;
      case 'história':
      case 'historia':
        return Colors.orange;
      case 'geografia':
        return Colors.purple;
      case 'física':
      case 'fisica':
        return Colors.red;
      case 'química':
      case 'quimica':
        return Colors.teal;
      case 'biologia':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }
}
