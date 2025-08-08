import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/response_service.dart';
import '../models/question.dart';

class QuestaoController extends ChangeNotifier {
  final List<Question> _questions;
  int _currentQuestionIndex = 0;
  Question? _currentQuestion;
  int? _selectedOptionIndex;
  bool _showAnswer = false;
  bool _showExplanation = false;
  bool _isBookmarked = false;
  int _timeRemaining = 300;
  bool _timerActive = false;
  final int _totalTime = 300; 

  final Map<int, bool> _answeredQuestions = {};

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  Question? get currentQuestion => _currentQuestion;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool get showAnswer => _showAnswer;
  bool get showExplanation => _showExplanation;
  bool get isBookmarked => _isBookmarked;
  int get timeRemaining => _timeRemaining;
  bool get timerActive => _timerActive;
  int get totalTime => _totalTime;
  bool get hasNextQuestion => _currentQuestionIndex < _questions.length - 1;
  bool get hasPreviousQuestion => _currentQuestionIndex > 0;
  int get totalQuestions => _questions.length;

  int get answeredQuestions => _answeredQuestions.length;
  int get correctAnswers =>
      _answeredQuestions.values.where((correct) => correct).length;
  int get incorrectAnswers =>
      _answeredQuestions.values.where((correct) => !correct).length;

  final List<String> _mensagensMotivacionais = [
    "Excelente! Continue assim que você vai longe! 🌟",
    "Impressionante! Você está dominando o assunto! 🎯",
    "Que orgulho! Seu esforço está valendo a pena! 🏆",
    "Sensacional! Você está no caminho certo! ⭐",
    "Incrível! Sua dedicação está dando resultados! 🌈",
  ];

  final List<String> _mensagensConstrutivas = [
    "Não desanime! Erros são parte do aprendizado. 🌱",
    "Continue tentando! Cada erro te deixa mais forte. 💪",
    "Persista! O caminho do sucesso passa pela superação. 🎯",
    "Mantenha o foco! Você está progredindo a cada tentativa. 🚀",
    "Não desista! Você está mais perto do acerto. 💫",
  ];

  QuestaoController({List<Question>? questions}) : _questions = questions ?? [] {
    if (_questions.isNotEmpty) {
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
    }
  }

  void loadQuestion(Question question) {
    _currentQuestion = question;
    _resetState();
    startQuestionTimer();
    notifyListeners();
  }

  void _resetState() {
    _selectedOptionIndex = null;
    _showAnswer = false;
    _showExplanation = false;
    _isBookmarked = false;
    _timeRemaining = _totalTime;
    _timerActive = false;
  }

  void nextQuestion() {
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (hasPreviousQuestion) {
      _currentQuestionIndex--;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
      notifyListeners();
    }
  }

  void selectOption(int index) {
    if (_showAnswer) return;

    if (_selectedOptionIndex == index) {
      _selectedOptionIndex = null;
    } else {
      _selectedOptionIndex = index;
    }
    notifyListeners();
  }

  Future<void> checkAnswer() async {
    if (_selectedOptionIndex == null) {
      debugPrint('Nenhuma opção selecionada para verificar a resposta');
      return;
    }

    _showAnswer = true;
    _timerActive = false;

    if (_currentQuestion != null) {
      debugPrint('\n=== TENTATIVA DE SALVAR RESPOSTA ===');
      debugPrint('Questão ID: ${_currentQuestion!.id}');
      debugPrint('Pergunta: ${_currentQuestion!.text}');
      debugPrint('Resposta selecionada: ${_currentQuestion!.options[_selectedOptionIndex!].letter}');
      debugPrint('Resposta correta: ${_currentQuestion!.correctAnswer}');
      debugPrint('Resposta está correta: $isAnswerCorrect');

      _answeredQuestions[_currentQuestion!.id] = isAnswerCorrect;
      debugPrint('✅ Resposta registrada localmente: ${_answeredQuestions[_currentQuestion!.id]}');

      try {
        debugPrint('\n=== TENTANDO SALVAR NO BACKEND ===');
        
        debugPrint('1. Inicializando usuário...');
        try {
          await _initializeUser();
          debugPrint('✅ Usuário inicializado com sucesso');
        } catch (e) {
          debugPrint('❌ Falha ao inicializar usuário: $e');
          throw Exception('Não foi possível autenticar o usuário');
        }
        
        if (_userId == null) {
          debugPrint('❌ ID do usuário não encontrado');
          throw Exception('ID do usuário não encontrado');
        }

        final timeSpent = _getTimeSpent();
        debugPrint('\n2. Dados da resposta:');
        debugPrint('   - ID do usuário: $_userId');
        debugPrint('   - ID da questão: ${_currentQuestion!.id}');
        debugPrint('   - Tempo gasto: $timeSpent segundos');
        debugPrint('   - Matéria: ${_currentQuestion!.subject}');
        debugPrint('   - Disciplina: ${_currentQuestion!.discipline}');
        debugPrint('   - Resposta correta: $isAnswerCorrect');

        debugPrint('\n3. Enviando para o servidor...');
        try {
          final success = await ResponseService.saveResponse(
            questionId: _currentQuestion!.id.toString(),
            questionText: _currentQuestion!.text,
            userAnswer: _currentQuestion!.options[_selectedOptionIndex!].letter,
            correctAnswer: _currentQuestion!.correctAnswer,
            isCorrect: isAnswerCorrect,
            subject: _currentQuestion!.subject,
            topic: _currentQuestion!.discipline,
            timeSpentSeconds: timeSpent,
          );
          
          if (success) {
            debugPrint('✅ Resposta salva com sucesso no banco de dados!');
          } else {
            debugPrint('❌ Falha ao salvar a resposta no banco de dados');
            throw Exception('Falha ao salvar a resposta no servidor');
          }
        } catch (e) {
          debugPrint('❌ ERRO ao enviar para o servidor:');
          debugPrint('   Tipo: ${e.runtimeType}');
          debugPrint('   Mensagem: $e');
          if (e is Error) {
            debugPrint('   Stack trace: ${e.stackTrace}');
          }
          rethrow;
        }
      } catch (e) {
        debugPrint('\n❌ ERRO CRÍTICO ao salvar resposta:');
        debugPrint('   $e');
      } finally {
        debugPrint('\n=== FIM DO PROCESSAMENTO DA RESPOSTA ===\n');
      }
    }

    notifyListeners();
  }

  void toggleExplanation() {
    _showExplanation = !_showExplanation;
    notifyListeners();
  }

  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
    notifyListeners();
  }

  void startTimer() {
    _timerActive = true;
    _timeRemaining = _totalTime;
    notifyListeners();
    _updateTimer();
  }

  void _updateTimer() {
    if (!_timerActive) return;

    if (_timeRemaining > 0) {
      _timeRemaining--;
      notifyListeners();
      Future.delayed(const Duration(seconds: 1), _updateTimer);
    } else {
      _timerActive = false;
      _showAnswer = true;
      notifyListeners();
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String getMensagemAleatoria(bool acertou) {
    final lista = acertou ? _mensagensMotivacionais : _mensagensConstrutivas;
    final random = DateTime.now().millisecondsSinceEpoch % lista.length;
    return lista[random];
  }

  bool get isAnswerCorrect {
    if (_currentQuestion == null || _selectedOptionIndex == null) return false;
    final selectedOption = _currentQuestion!.options[_selectedOptionIndex!];
    return selectedOption.letter == _currentQuestion!.correctAnswer;
  }

  DateTime? _questionStartTime;
  int? _userId;

  Future<void> _initializeUser() async {
    try {
      debugPrint('=== INICIALIZANDO USUÁRIO ===');
      final prefs = await SharedPreferences.getInstance();
      
      _userId = prefs.getInt('userId');
      
      if (_userId == null) {
        final userIdStr = prefs.getString('userId');
        if (userIdStr != null) {
          _userId = int.tryParse(userIdStr);
        }
      }
      
      final token = prefs.getString('token');
      
      debugPrint('ID do usuário: $_userId (tipo: ${_userId?.runtimeType})');
      debugPrint('Token: ${token != null ? 'presente' : 'ausente'}');
      debugPrint('Todas as chaves no SharedPreferences: ${prefs.getKeys().join(', ')}');
      
      if (_userId == null || token == null) {
        debugPrint('❌ Usuário não autenticado corretamente');
        debugPrint('ID do usuário é nulo: ${_userId == null}');
        debugPrint('Token é nulo: ${token == null}');
        throw Exception('Usuário não autenticado. Por favor, faça login novamente.');
      }
      
      debugPrint('✅ Usuário inicializado com sucesso');
    } catch (e, stackTrace) {
      debugPrint('❌ Erro ao inicializar usuário');
      debugPrint('Tipo de erro: ${e.runtimeType}');
      debugPrint('Mensagem: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    } finally {
      debugPrint('=== FIM DA INICIALIZAÇÃO DO USUÁRIO ===\n');
    }
  }

  void startQuestionTimer() {
    _questionStartTime = DateTime.now();
  }
  int? _getTimeSpent() {
    if (_questionStartTime == null) return null;
    return DateTime.now().difference(_questionStartTime!).inSeconds;
  }

  String get selectedAnswerLetter {
    if (_currentQuestion == null || _selectedOptionIndex == null) return '';
    return _currentQuestion!.options[_selectedOptionIndex!].letter;
  }

  String get currentQuestionNumber {
    return 'Questão ${_currentQuestionIndex + 1}';
  }

  void loadQuestionsByDiscipline(String discipline) {
    debugPrint('Filtro por disciplina desativado. Use a filtragem no componente pai.');
  }

  void loadQuestionsBySubject(String subject) {
    debugPrint('Filtro por matéria desativado. Use a filtragem no componente pai.');
  }

  void loadQuestionsByBoard(String board) {

    debugPrint('Filtro por banca desativado. Use a filtragem no componente pai.');
  }

  void loadQuestionsByType(QuestionType type) {

    debugPrint('Filtro por tipo de questão desativado. Use a filtragem no componente pai.');
  }

  @override
  void dispose() {
    _timerActive = false;
    super.dispose();
  }
}
