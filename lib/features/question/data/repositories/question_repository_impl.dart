import 'package:dartz/dartz.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/features/question/data/datasources/question_remote_data_source.dart';
import 'package:orbirq/features/question/data/models/question_model.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDataSource remoteDataSource;

  QuestionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Question>> createQuestion(Question question) async {
    try {
      final questionModel = QuestionModel.fromEntity(question);
      final result = await remoteDataSource.createQuestion(questionModel);
      return Right(QuestionModel.fromJson(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteQuestion(String id) async {
    try {
      final result = await remoteDataSource.deleteQuestion(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Question>> getQuestion(String id) async {
    try {
      final result = await remoteDataSource.getQuestion(id);
      return Right(QuestionModel.fromJson(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions({
    String? discipline,
    String? subject,
    String? topic,
    int? year,
    String? board,
    String? exam,
    int? limit,
    int? offset,
  }) async {
    try {
      final result = await remoteDataSource.getQuestions(
        discipline: discipline,
        subject: subject,
        topic: topic,
        year: year,
        board: board,
        exam: exam,
        limit: limit,
        offset: offset,
      );
      return Right(result.map((e) => QuestionModel.fromJson(e)).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Question>> updateQuestion(Question question) async {
    try {
      final questionModel = QuestionModel.fromEntity(question);
      final result = await remoteDataSource.updateQuestion(questionModel);
      return Right(QuestionModel.fromJson(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
