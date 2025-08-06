import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/core/constants/app_sizes.dart';
import 'package:orbirq/features/simulados/models/simulado.dart';

class SimuladoResultadoWidget extends StatelessWidget {
  final Simulado simulado;
  final SimuladoExecucao execucao;
  final VoidCallback? onVerGabarito;
  final VoidCallback? onNovoSimulado;
  final VoidCallback? onVoltar;

  const SimuladoResultadoWidget({
    super.key,
    required this.simulado,
    required this.execucao,
    this.onVerGabarito,
    this.onNovoSimulado,
    this.onVoltar,
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
          _buildEstatisticas(),
          const SizedBox(height: AppSizes.lg),
          _buildTempoInfo(),
          const SizedBox(height: AppSizes.lg),
          _buildBotoesAcao(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getCorResultado(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIconeResultado(), color: Colors.white, size: 24),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    simulado.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Concluído em ${_formatarData(execucao.dataFim!)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: _getCorResultado().withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radius),
            border: Border.all(color: _getCorResultado().withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                '${execucao.pontuacaoFinal?.toStringAsFixed(1) ?? "0.0"}%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _getCorResultado(),
                ),
              ),
              Text(
                _getMensagemResultado(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getCorResultado(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstatisticas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                titulo: 'Acertos',
                valor: '${execucao.acertosTotal ?? 0}',
                cor: Colors.green,
                icone: Icons.check_circle,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _buildStatCard(
                titulo: 'Erros',
                valor: '${execucao.errosTotal ?? 0}',
                cor: Colors.red,
                icone: Icons.cancel,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _buildStatCard(
                titulo: 'Em branco',
                valor: '${execucao.questoesNaoRespondidas ?? 0}',
                cor: Colors.orange,
                icone: Icons.help_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String titulo,
    required String valor,
    required Color cor,
    required IconData icone,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 24),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          Text(
            titulo,
            style: TextStyle(fontSize: 12, color: cor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildTempoInfo() {
    final tempoTotal = execucao.tempoTotal;
    final tempoUtilizado = tempoTotal - execucao.tempoRestante;
    final tempoRestante = execucao.tempoRestante;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tempo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: _buildTempoCard(
                titulo: 'Utilizado',
                tempo: tempoUtilizado,
                cor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _buildTempoCard(
                titulo: 'Restante',
                tempo: tempoRestante,
                cor: tempoRestante > 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTempoCard({
    required String titulo,
    required int tempo,
    required Color cor,
  }) {
    final minutos = tempo ~/ 60;
    final segundos = tempo % 60;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          Text(
            titulo,
            style: TextStyle(fontSize: 12, color: cor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildBotoesAcao() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onVerGabarito,
            icon: const Icon(Icons.visibility),
            label: const Text('Ver Gabarito'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onNovoSimulado,
                icon: const Icon(Icons.refresh),
                label: const Text('Novo Simulado'),
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
                onPressed: onVoltar,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCorResultado() {
    final pontuacao = execucao.pontuacaoFinal ?? 0;
    if (pontuacao >= 80) return Colors.green;
    if (pontuacao >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getIconeResultado() {
    final pontuacao = execucao.pontuacaoFinal ?? 0;
    if (pontuacao >= 80) return Icons.emoji_events;
    if (pontuacao >= 60) return Icons.thumb_up;
    return Icons.sentiment_dissatisfied;
  }

  String _getMensagemResultado() {
    final pontuacao = execucao.pontuacaoFinal ?? 0;
    if (pontuacao >= 80) return 'Excelente!';
    if (pontuacao >= 60) return 'Bom trabalho!';
    return 'Continue estudando!';
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }
}
