import 'dart:convert';

enum QuestionType {
  simple,
  withText,
  withImage,
}

class Question {
  final int id;
  final String discipline;
  final String subject;
  final int year;
  final String board;
  final String exam;
  final String text;
  final String? supportingText;
  final String? imageUrl;
  final List<QuestionOption> options;
  final String correctAnswer;
  final String? explanation;
  final QuestionType type;

  Question({
    required this.id,
    required this.discipline,
    required this.subject,
    required this.year,
    required this.board,
    required this.exam,
    required this.text,
    this.supportingText,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'discipline': discipline,
      'subject': subject,
      'year': year,
      'board': board,
      'exam': exam,
      'text': text,
      'supportingText': supportingText,
      'imageUrl': imageUrl,
      'options': options.map((o) => o.toMap()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'type': type.toString(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    final options = map['options'] is List 
        ? (map['options'] as List).map((o) {
            if (o is Map<String, dynamic>) {
              return QuestionOption.fromMap(o);
            } else if (o is String) {
              try {
                final optionMap = jsonDecode(o) as Map<String, dynamic>;
                return QuestionOption.fromMap(optionMap);
              } catch (e) {
                return QuestionOption(
                  letter: 'A',
                  text: 'Opção inválida',
                );
              }
            }
            return QuestionOption(
              letter: 'A',
              text: 'Opção inválida',
            );
          }).toList()
        : <QuestionOption>[];

    QuestionType determineQuestionType() {
      if (map['type'] is String) {
        final typeStr = map['type'].toString().toLowerCase();
        if (typeStr.contains('withtext') || (map['supportingText'] != null && map['supportingText'].toString().isNotEmpty)) {
          return QuestionType.withText;
        } else if (typeStr.contains('withimage') || (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty)) {
          return QuestionType.withImage;
        }
      }
      return QuestionType.simple;
    }

    return Question(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? '0') ?? 0,
      discipline: map['discipline']?.toString() ?? 'Desconhecida',
      subject: map['subject']?.toString() ?? 'Desconhecida',
      year: map['year'] is int ? map['year'] : int.tryParse(map['year']?.toString() ?? '0') ?? DateTime.now().year,
      board: map['board']?.toString() ?? '',
      exam: map['exam']?.toString() ?? '',
      text: map['text']?.toString() ?? 'Texto da questão não disponível',
      supportingText: map['supportingText']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      options: options,
      correctAnswer: map['correctAnswer']?.toString() ?? '',
      explanation: map['explanation']?.toString(),
      type: determineQuestionType(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(jsonDecode(source));
}

class QuestionOption {
  final String letter;
  final String text;
  final bool isSelected;
  final bool? isCorrect;

  QuestionOption({
    required this.letter,
    required this.text,
    this.isSelected = false,
    this.isCorrect,
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

  Map<String, dynamic> toMap() {
    return {
      'letter': letter,
      'text': text,
      'isSelected': isSelected,
      'isCorrect': isCorrect,
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    String extractLetter(dynamic value) {
      if (value == null) return 'A';
      
      final str = value.toString().trim().toUpperCase();
      if (str.isEmpty) return 'A';
      
      if (int.tryParse(str) != null) {
        final num = int.parse(str);
        if (num >= 1 && num <= 26) {
          return String.fromCharCode('A'.codeUnitAt(0) + num - 1);
        }
      }
      
      if (str.length == 1 && str.compareTo('A') >= 0 && str.compareTo('Z') <= 0) {
        return str;
      }
      
      return 'A';
    }
    
    String extractText(dynamic value) {
      if (value == null) return '';
      if (value is String) return value.trim();
      if (value is Map) {
        return (value['text'] ?? value['option'] ?? value['description'] ?? '').toString().trim();
      }
      return value.toString().trim();
    }
    
    bool? extractIsCorrect(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) {
        final lower = value.toLowerCase().trim();
        if (lower == 'true' || lower == '1' || lower == 'sim' || lower == 's') return true;
        if (lower == 'false' || lower == '0' || lower == 'não' || lower == 'n') return false;
      }
      return null;
    }
    
    return QuestionOption(
      letter: extractLetter(map['letter'] ?? map['id'] ?? map['key'] ?? 'A'),
      text: extractText(map['text'] ?? map['option'] ?? map['description'] ?? ''),
      isSelected: map['isSelected'] == true || map['selected'] == true,
      isCorrect: extractIsCorrect(map['isCorrect'] ?? map['correct'] ?? map['is_correct']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory QuestionOption.fromJson(String source) =>
      QuestionOption.fromMap(jsonDecode(source));
}
