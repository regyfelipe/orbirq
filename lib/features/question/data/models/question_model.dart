import 'package:orbirq/features/question/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required String id,
    required String discipline,
    required String subject,
    required String topic,
    required int year,
    required String board,
    required String exam,
    required String text,
    String supportingText = '',
    String? imageUrl,
    required String correctAnswer,
    required String explanation,
    required String type,
    required List<QuestionOption> options,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          discipline: discipline,
          subject: subject,
          topic: topic,
          year: year,
          board: board,
          exam: exam,
          text: text,
          supportingText: supportingText,
          imageUrl: imageUrl,
          correctAnswer: correctAnswer,
          explanation: explanation,
          type: type,
          options: options,
          createdBy: createdBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
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

  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      discipline: question.discipline,
      subject: question.subject,
      topic: question.topic,
      year: question.year,
      board: question.board,
      exam: question.exam,
      text: question.text,
      supportingText: question.supportingText,
      imageUrl: question.imageUrl,
      correctAnswer: question.correctAnswer,
      explanation: question.explanation,
      type: question.type,
      options: question.options,
      createdBy: question.createdBy,
      createdAt: question.createdAt,
      updatedAt: question.updatedAt,
    );
  }

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
}
