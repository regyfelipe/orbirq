class Question {
  final String id;
  final String discipline;
  final String subject;
  final String topic;
  final int year;
  final String board;
  final String exam;
  final String text;
  final String supportingText;
  final String? imageUrl;
  final String correctAnswer;
  final String explanation;
  final String type;
  final List<QuestionOption> options;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Question({
    required this.id,
    required this.discipline,
    required this.subject,
    required this.topic,
    required this.year,
    required this.board,
    required this.exam,
    required this.text,
    this.supportingText = '',
    this.imageUrl,
    required this.correctAnswer,
    required this.explanation,
    required this.type,
    required this.options,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discipline': discipline,
      'subject': subject,
      'topic': topic,
      'year': year,
      'board': board,
      'exam': exam,
      'text': text,
      'supportingText': supportingText,
      'imageUrl': imageUrl,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'type': type,
      'options': options.map((e) => e.toJson()).toList(),
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      discipline: json['discipline'] as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      year: json['year'] as int,
      board: json['board'] as String,
      exam: json['exam'] as String,
      text: json['text'] as String,
      supportingText: json['supportingText'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
      type: json['type'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}

class QuestionOption {
  final String letter;
  final String text;

  QuestionOption({
    required this.letter,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'letter': letter,
      'text': text,
    };
  }

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      letter: json['letter'] as String,
      text: json['text'] as String,
    );
  }
}
