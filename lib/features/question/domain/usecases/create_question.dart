import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/core/usecase/usecase.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/domain/repositories/question_repository.dart';

class CreateQuestion implements UseCase<Question, Question> {
  final QuestionRepository repository;

  const CreateQuestion(this.repository);

  @override
  Future<Either<Failure, Question>> call(Question question) async {
    return await repository.createQuestion(question);
  }
}
