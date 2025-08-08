import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/core/usecase/usecase.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/domain/repositories/question_repository.dart';

class GetQuestionsParams {
  final String? discipline;
  final String? subject;
  final String? topic;
  final int? year;
  final String? board;
  final String? exam;
  final int? limit;
  final int? offset;

  GetQuestionsParams({
    this.discipline,
    this.subject,
    this.topic,
    this.year,
    this.board,
    this.exam,
    this.limit,
    this.offset,
  });
}

class GetQuestions implements UseCase<List<Question>, GetQuestionsParams> {
  final QuestionRepository repository;

  GetQuestions(this.repository);

  @override
  Future<Either<Failure, List<Question>>> call(GetQuestionsParams params) async {
    return await repository.getQuestions(
      discipline: params.discipline,
      subject: params.subject,
      topic: params.topic,
      year: params.year,
      board: params.board,
      exam: params.exam,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
