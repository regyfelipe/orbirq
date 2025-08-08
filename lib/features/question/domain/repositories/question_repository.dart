import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';

abstract class QuestionRepository {
  Future<Either<Failure, Question>> createQuestion(Question question);
  
  Future<Either<Failure, Question>> updateQuestion(Question question);
  
  Future<Either<Failure, Question>> getQuestion(String id);
  
  Future<Either<Failure, List<Question>>> getQuestions({
    String? discipline,
    String? subject,
    String? topic,
    int? year,
    String? board,
    String? exam,
    int? limit,
    int? offset,
  });
  
  Future<Either<Failure, bool>> deleteQuestion(String id);
}
