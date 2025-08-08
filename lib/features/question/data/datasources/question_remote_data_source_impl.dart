import 'package:orbirq/core/error/exceptions.dart';
import 'package:orbirq/features/question/data/datasources/question_remote_data_source.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/data/models/question_model.dart';
import 'package:orbirq/core/services/api_service.dart';

class QuestionRemoteDataSourceImpl implements QuestionRemoteDataSource {
  final ApiService apiService;
  
  QuestionRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Map<String, dynamic>> createQuestion(Question question) async {
    try {
      final questionModel = QuestionModel.fromEntity(question);
      final response = await apiService.post(
        'questions',
        body: questionModel.toJson(),
      );

      if (!response.success || response.data == null) {
        throw ServerException(
          message: response.error ?? 'Failed to create question',
          statusCode: response.statusCode ?? 500,
        );
      }

      return response.data! as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<bool> deleteQuestion(String id) async {
    try {
      final response = await apiService.delete('questions/$id');
      
      if (!response.success) {
        throw ServerException(
          message: response.error ?? 'Failed to delete question',
          statusCode: response.statusCode ?? 500,
        );
      }

      return true;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getQuestion(String id) async {
    try {
      final response = await apiService.get('questions/$id');
      
      if (!response.success || response.data == null) {
        throw ServerException(
          message: response.error ?? 'Question not found',
          statusCode: response.statusCode ?? 404,
        );
      }

      return response.data! as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getQuestions({
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
      final queryParams = <String, dynamic>{};
      if (discipline != null) queryParams['discipline'] = discipline;
      if (subject != null) queryParams['subject'] = subject;
      if (topic != null) queryParams['topic'] = topic;
      if (year != null) queryParams['year'] = year.toString();
      if (board != null) queryParams['board'] = board;
      if (exam != null) queryParams['exam'] = exam;
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = 'questions${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await apiService.get(endpoint);
      
      if (!response.success || response.data == null) {
        throw ServerException(
          message: response.error ?? 'Failed to fetch questions',
          statusCode: response.statusCode ?? 500,
        );
      }

      return List<Map<String, dynamic>>.from(response.data as List);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateQuestion(Question question) async {
    try {
      final questionModel = QuestionModel.fromEntity(question);
      final response = await apiService.put(
        'questions/${question.id}',
        body: questionModel.toJson(),
      );

      if (!response.success || response.data == null) {
        throw ServerException(
          message: response.error ?? 'Failed to update question',
          statusCode: response.statusCode ?? 500,
        );
      }

      return response.data! as Map<String, dynamic>;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}
