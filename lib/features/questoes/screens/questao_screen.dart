import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../controllers/questao_controller.dart';
import '../widgets/questao_header_widget.dart';
import '../widgets/questao_text_widget.dart';
import '../widgets/questao_options_widget.dart';
import '../widgets/questao_answer_widget.dart';
import '../widgets/questao_navigation_widget.dart';
import '../widgets/questao_stats_widget.dart';

class QuestaoScreen extends StatefulWidget {
  const QuestaoScreen({super.key});

  @override
  State<QuestaoScreen> createState() => _QuestaoScreenState();
}

class _QuestaoScreenState extends State<QuestaoScreen> {
  late QuestaoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuestaoController();
    _loadQuestion();
  }

  void _loadQuestion() {
    // O controller já carrega as questões automaticamente
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryLight,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Consumer<QuestaoController>(
        builder: (context, controller, child) {
          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.currentQuestionNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${controller.currentQuestionIndex + 1} de ${controller.totalQuestions}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              if (controller.timerActive)
                Text(
                  controller.formatTime(controller.timeRemaining),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                )
              else
                TextButton.icon(
                  onPressed: controller.startTimer,
                  icon: const Icon(Icons.timer, color: Colors.white, size: 18),
                  label: const Text(
                    'Iniciar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              IconButton(
                icon: Icon(
                  controller.isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: controller.toggleBookmark,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<QuestaoController>(
      builder: (context, controller, child) {
        if (controller.currentQuestion == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestaoHeaderWidget(question: controller.currentQuestion!),
                const SizedBox(height: 20),
                if (controller.answeredQuestions > 0) ...[
                  QuestaoStatsWidget(
                    totalQuestions: controller.totalQuestions,
                    answeredQuestions: controller.answeredQuestions,
                    correctAnswers: controller.correctAnswers,
                    incorrectAnswers: controller.incorrectAnswers,
                  ),
                  const SizedBox(height: 20),
                ],
                QuestaoTextWidget(question: controller.currentQuestion!),
                const SizedBox(height: 20),
                QuestaoOptionsWidget(
                  question: controller.currentQuestion!,
                  selectedOptionIndex: controller.selectedOptionIndex,
                  showAnswer: controller.showAnswer,
                  onOptionSelected: controller.selectOption,
                ),
                if (controller.showAnswer) ...[
                  const SizedBox(height: 20),
                  QuestaoAnswerWidget(
                    question: controller.currentQuestion!,
                    selectedAnswerLetter: controller.selectedAnswerLetter,
                    isAnswerCorrect: controller.isAnswerCorrect,
                    mensagem: controller.getMensagemAleatoria(
                      controller.isAnswerCorrect,
                    ),
                    showExplanation: controller.showExplanation,
                    onToggleExplanation: controller.toggleExplanation,
                  ),
                ],
                const SizedBox(height: 20),
                QuestaoNavigationWidget(
                  onPrevious: controller.hasPreviousQuestion
                      ? controller.previousQuestion
                      : null,
                  onNext: controller.hasNextQuestion
                      ? controller.nextQuestion
                      : null,
                  onBackToList: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    return Consumer<QuestaoController>(
      builder: (context, controller, child) {
        if (!controller.showAnswer && controller.selectedOptionIndex != null) {
          return FloatingActionButton.extended(
            onPressed: controller.checkAnswer,
            backgroundColor: AppColors.primaryLight,
            label: const Text(
              'Resolver',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
