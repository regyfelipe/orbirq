import 'package:orbirq/features/question/domain/entities/question.dart';

abstract class QuestionRemoteDataSource {
  Future<Map<String, dynamic>> createQuestion(Question question);
  
  Future<Map<String, dynamic>> updateQuestion(Question question);
  
  Future<Map<String, dynamic>> getQuestion(String id);
  
  Future<List<Map<String, dynamic>>> getQuestions({
    String? discipline,
    String? subject,
    String? topic,
    int? year,
    String? board,
    String? exam,
    int? limit,
    int? offset,
  });
  
  Future<bool> deleteQuestion(String id);
}
