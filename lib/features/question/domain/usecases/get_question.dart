import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/core/usecase/usecase.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/domain/repositories/question_repository.dart';

class GetQuestion implements UseCase<Question, String> {
  final QuestionRepository repository;

  GetQuestion(this.repository);

  @override
  Future<Either<Failure, Question>> call(String id) async {
    return await repository.getQuestion(id);
  }
}
