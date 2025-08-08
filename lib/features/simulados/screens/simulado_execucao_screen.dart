import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../controllers/simulado_controller.dart';
import '../widgets/simulado_timer_widget.dart';
import '../widgets/simulado_progress_widget.dart';
import '../widgets/simulado_questao_widget.dart';
import '../widgets/simulado_navigation_widget.dart';
import '../widgets/simulado_resultado_widget.dart';

class SimuladoExecucaoScreen extends StatefulWidget {
  final String simuladoId;
  final String userId;

  const SimuladoExecucaoScreen({
    super.key,
    required this.simuladoId,
    required this.userId,
  });

  @override
  State<SimuladoExecucaoScreen> createState() => _SimuladoExecucaoScreenState();
}

class _SimuladoExecucaoScreenState extends State<SimuladoExecucaoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _iniciarSimulado();
    });
  }

  Future<void> _iniciarSimulado() async {
    final controller = context.read<SimuladoController>();
    final sucesso = await controller.iniciarSimulado(
      widget.simuladoId,
      widget.userId,
    );

    if (!sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorExecucao ?? 'Erro ao iniciar simulado'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SimuladoController>(
      builder: (context, controller, child) {
        if (controller.isLoadingExecucao) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'Carregando simulado...',
                    style: TextStyle(fontSize: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.errorExecucao != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Erro'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Erro no simulado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorExecucao!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.simuladoConcluido) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Resultado'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: SimuladoResultadoWidget(
                simulado: controller.simuladoAtual!,
                execucao: controller.execucaoAtual!,
                onVerGabarito: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade em desenvolvimento'),
                    ),
                  );
                },
                onNovoSimulado: () {
                  controller.limparExecucaoAtual();
                  Navigator.pop(context);
                },
                onVoltar: () {
                  controller.limparExecucaoAtual();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }

        if (controller.execucaoAtual == null ||
            controller.simuladoAtual == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Nenhum simulado em execução')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(controller),
          body: _buildBody(controller),
          floatingActionButton: _buildFloatingActionButton(controller),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(SimuladoController controller) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.simuladoAtual!.titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Questão ${controller.execucaoAtual!.questaoAtual + 1} de ${controller.totalQuestoes}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        if (controller.temExecucaoAtiva)
          SimuladoTimerWidget(
            tempoRestante: controller.execucaoAtual!.tempoRestante,
            onTempoEsgotado: () {
              controller.finalizarSimulado();
            },
          ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'pause':
                controller.pausarSimulado();
                break;
              case 'resume':
                controller.retomarSimulado();
                break;
              case 'finish':
                _showConfirmarFinalizarDialog(controller);
                break;
              case 'exit':
                _showConfirmarSairDialog(controller);
                break;
            }
          },
          itemBuilder: (context) => [
            if (controller.temExecucaoAtiva)
              const PopupMenuItem(
                value: 'pause',
                child: Row(
                  children: [
                    Icon(Icons.pause),
                    SizedBox(width: 8),
                    Text('Pausar'),
                  ],
                ),
              ),
            if (controller.temExecucaoPausada)
              const PopupMenuItem(
                value: 'resume',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text('Retomar'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'finish',
              child: Row(
                children: [
                  Icon(Icons.stop),
                  SizedBox(width: 8),
                  Text('Finalizar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'exit',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8),
                  Text('Sair'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(SimuladoController controller) {
    if (controller.questoes.isEmpty) {
      return const Center(child: Text('Nenhuma questão disponível'));
    }

    final questaoAtual =
        controller.questoes[controller.execucaoAtual!.questaoAtual];

    return Column(
      children: [
        SimuladoProgressWidget(
          totalQuestoes: controller.totalQuestoes,
          questoesRespondidas: controller.questoesRespondidas,
          acertos: controller.acertos,
          erros: controller.erros,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: SimuladoQuestaoWidget(
              questao: questaoAtual,
              questaoIndex: controller.execucaoAtual!.questaoAtual,
              totalQuestoes: controller.totalQuestoes,
              respostaSelecionada: controller.obterRespostaQuestao(
                controller.execucaoAtual!.questaoAtual,
              ),
              onRespostaSelecionada: (resposta) {
                controller.responderQuestao(
                  controller.execucaoAtual!.questaoAtual,
                  resposta,
                );
              },
            ),
          ),
        ),
        SimuladoNavigationWidget(
          questaoAtual: controller.execucaoAtual!.questaoAtual,
          totalQuestoes: controller.totalQuestoes,
          respostas: controller.execucaoAtual!.respostas,
          onAnterior: controller.questaoAnterior,
          onProxima: controller.proximaQuestao,
          onFinalizar: () => _showConfirmarFinalizarDialog(controller),
          onPausar: controller.pausarSimulado,
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton(SimuladoController controller) {
    if (controller.temExecucaoPausada) {
      return FloatingActionButton.extended(
        onPressed: controller.retomarSimulado,
        backgroundColor: Colors.green,
        label: const Text('Retomar', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.play_arrow, color: Colors.white),
      );
    }

    return null;
  }

  void _showConfirmarFinalizarDialog(SimuladoController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Simulado'),
        content: const Text(
          'Tem certeza que deseja finalizar o simulado? '
          'Você não poderá voltar atrás.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.finalizarSimulado();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  void _showConfirmarSairDialog(SimuladoController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do Simulado'),
        content: const Text(
          'Tem certeza que deseja sair? '
          'Seu progresso será perdido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.limparExecucaoAtual();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
