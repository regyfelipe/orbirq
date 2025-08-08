import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/theme/Colors.dart';

import '../controllers/questao_controller.dart';
import '../services/questao_service.dart';
import '../widgets/questao_header_widget.dart';
import '../widgets/questao_text_widget.dart';
import '../widgets/questao_options_widget.dart';
import '../widgets/questao_answer_widget.dart';
import '../widgets/questao_navigation_widget.dart';
import '../widgets/questao_stats_widget.dart';
import 'package:orbirq/core/services/logger_service.dart';

class QuestaoScreen extends StatefulWidget {
  const QuestaoScreen({super.key});

  @override
  State<QuestaoScreen> createState() => _QuestaoScreenState();
}

class _QuestaoScreenState extends State<QuestaoScreen> {
  late QuestaoController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = QuestaoController(questions: []);
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      LoggerService.info('Loading questions from database...');
      final questaoService = QuestaoService();
      final questions = await questaoService.getAllQuestions();
      
      if (questions.isEmpty) {
        LoggerService.warning('No questions found in the database');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Nenhuma questão encontrada no banco de dados.';
          });
        }
        return;
      }

      LoggerService.success('Successfully loaded ${questions.length} questions');
      
      if (mounted) {
        setState(() {
          _controller = QuestaoController(questions: questions);
          _isLoading = false;
        });
        
        final questionCount = questions.length > 3 ? 3 : questions.length;
        for (var i = 0; i < questionCount; i++) {
          LoggerService.debug('Question ${i + 1}: ${questions[i].text.substring(0, 30)}...');
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error loading questions', 
        error: e,
        stackTrace: stackTrace,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro ao carregar as questões. Por favor, tente novamente.';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carregando...'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando questões...'),
            ],
          ),
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadQuestions,
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadQuestions,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
