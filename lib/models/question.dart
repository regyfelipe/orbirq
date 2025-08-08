class Question {
  final int id;
  final String discipline;
  final String subject;
  final int year;
  final String board;
  final String exam;
  final String text;
  final List<QuestionOption> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.discipline,
    required this.subject,
    required this.year,
    required this.board,
    required this.exam,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}

class QuestionOption {
  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrect;

  QuestionOption({
    required this.letter,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
  });

  QuestionOption copyWith({
    String? letter,
    String? text,
    bool? isSelected,
    bool? isCorrect,
  }) {
    return QuestionOption(
      letter: letter ?? this.letter,
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
