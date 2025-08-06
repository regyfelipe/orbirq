import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/questao_service.dart';

class QuestaoController extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  Question? _currentQuestion;
  int? _selectedOptionIndex;
  bool _showAnswer = false;
  bool _showExplanation = false;
  bool _isBookmarked = false;
  int _timeRemaining = 300;
  bool _timerActive = false;
  final int _totalTime = 300; // 5 minutos

  // Estatísticas
  final Map<int, bool> _answeredQuestions = {}; // questionId -> isCorrect

  // Getters
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

  // Estatísticas
  int get answeredQuestions => _answeredQuestions.length;
  int get correctAnswers =>
      _answeredQuestions.values.where((correct) => correct).length;
  int get incorrectAnswers =>
      _answeredQuestions.values.where((correct) => !correct).length;

  // Mensagens motivacionais
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

  QuestaoController() {
    _loadQuestions();
  }

  void _loadQuestions() {
    _questions = QuestaoService.getSampleQuestions();
    if (_questions.isNotEmpty) {
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
    }
    notifyListeners();
  }

  void loadQuestion(Question question) {
    _currentQuestion = question;
    _resetState();
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

  void checkAnswer() {
    if (_selectedOptionIndex == null) return;

    _showAnswer = true;
    _timerActive = false;

    // Registrar resposta para estatísticas
    if (_currentQuestion != null) {
      _answeredQuestions[_currentQuestion!.id] = isAnswerCorrect;
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
      // Tempo esgotado
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

  String get selectedAnswerLetter {
    if (_currentQuestion == null || _selectedOptionIndex == null) return '';
    return _currentQuestion!.options[_selectedOptionIndex!].letter;
  }

  String get currentQuestionNumber {
    return 'Questão ${_currentQuestionIndex + 1}';
  }

  // Métodos para filtrar questões
  void loadQuestionsByDiscipline(String discipline) {
    _questions = QuestaoService.getQuestionsByDiscipline(discipline);
    if (_questions.isNotEmpty) {
      _currentQuestionIndex = 0;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
    }
    notifyListeners();
  }

  void loadQuestionsBySubject(String subject) {
    _questions = QuestaoService.getQuestionsBySubject(subject);
    if (_questions.isNotEmpty) {
      _currentQuestionIndex = 0;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
    }
    notifyListeners();
  }

  void loadQuestionsByBoard(String board) {
    _questions = QuestaoService.getQuestionsByBoard(board);
    if (_questions.isNotEmpty) {
      _currentQuestionIndex = 0;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
    }
    notifyListeners();
  }

  void loadQuestionsByType(QuestionType type) {
    _questions = QuestaoService.getQuestionsByType(type);
    if (_questions.isNotEmpty) {
      _currentQuestionIndex = 0;
      _currentQuestion = _questions[_currentQuestionIndex];
      _resetState();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timerActive = false;
    super.dispose();
  }
}
