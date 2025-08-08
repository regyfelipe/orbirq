import 'package:equatable/equatable.dart';

class UserResponse extends Equatable {
  final int? id;
  final int userId;
  final String questionId;
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String subject;
  final String? topic;
  final String? difficulty;
  final int? timeSpentSeconds;
  final DateTime createdAt;

  const UserResponse({
    this.id,
    required this.userId,
    required this.questionId,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.subject,
    this.topic,
    this.difficulty,
    this.timeSpentSeconds,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'questionId': questionId,
      'questionText': questionText,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
      'subject': subject,
      'topic': topic,
      'difficulty': difficulty,
      'timeSpentSeconds': timeSpentSeconds,
    };
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      userId: json['user_id'],
      questionId: json['question_id'],
      questionText: json['question_text'],
      userAnswer: json['user_answer'],
      correctAnswer: json['correct_answer'],
      isCorrect: json['is_correct'],
      subject: json['subject'],
      topic: json['topic'],
      difficulty: json['difficulty'],
      timeSpentSeconds: json['time_spent_seconds'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  UserResponse copyWith({
    int? id,
    int? userId,
    String? questionId,
    String? questionText,
    String? userAnswer,
    String? correctAnswer,
    bool? isCorrect,
    String? subject,
    String? topic,
    String? difficulty,
    int? timeSpentSeconds,
    DateTime? createdAt,
  }) {
    return UserResponse(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      userAnswer: userAnswer ?? this.userAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      difficulty: difficulty ?? this.difficulty,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        questionId,
        questionText,
        userAnswer,
        correctAnswer,
        isCorrect,
        subject,
        topic,
        difficulty,
        timeSpentSeconds,
        createdAt,
      ];
}
