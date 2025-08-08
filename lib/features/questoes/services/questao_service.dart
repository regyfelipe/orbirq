import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../models/question.dart';
import '../../../core/services/logger_service.dart';

class QuestaoService {
  static final QuestaoService _instance = QuestaoService._internal();
  final String _baseUrl = 'http://192.168.18.11:3000';
  late final http.Client _httpClient;

  factory QuestaoService() {
    return _instance;
  }

  QuestaoService._internal() {
    final httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    _httpClient = IOClient(httpClient);
  }
  
  @visibleForTesting
  QuestaoService.testingConstructor(http.Client client) : _httpClient = client;

  void dispose() {
    _httpClient.close();
  }

  Future<List<Question>> getAllQuestions({
    int page = 1,
    int limit = 10,
    String? discipline,
    String? subject,
    int? year,
    String? board,
  }) async {
    try {
      LoggerService.info('🔍 Buscando questões da API...');
      
      final uri = Uri.parse('$_baseUrl/questions/questions').replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          if (discipline != null) 'discipline': discipline,
          if (subject != null) 'subject': subject,
          if (year != null) 'year': year.toString(),
          if (board != null) 'board': board,
        }..removeWhere((key, value) => value == null || value == 'null'),
      );

      LoggerService.info('🌐 URL da requisição: ${uri.toString()}');
      
      final response = await _httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.error('⏰ Timeout ao buscar questões: A requisição demorou mais de 10 segundos');
          throw Exception('Tempo de conexão esgotado. Verifique sua conexão com a internet.');
        },
      );

      LoggerService.info('📥 Resposta recebida - Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          LoggerService.debug('📦 Dados brutos da resposta: $data');
          
          if (data == null) {
            LoggerService.warning('⚠️ A resposta da API está vazia');
            return [];
          }
          
          if (data['data'] == null) {
            LoggerService.warning('⚠️ A resposta não contém o campo "data"');
            LoggerService.debug('Conteúdo da resposta: ${response.body}');
            return [];
          }
          
          final List<dynamic> questionsData = data['data'] is List ? data['data'] : [];
          LoggerService.info('📚 ${questionsData.length} questões recebidas da API');
          
          if (questionsData.isEmpty) {
            LoggerService.warning('ℹ️ Nenhuma questão encontrada com os filtros fornecidos');
            return [];
          }
          
          final List<Question> questions = [];
          int errorCount = 0;
          
          for (var item in questionsData) {
            try {
              if (item['options'] is String) {
                try {
                  item['options'] = jsonDecode(item['options']);
                } catch (e) {
                  LoggerService.warning('⚠️ Erro ao decodificar opções da questão ${item['id']}: $e');
                  item['options'] = [];
                }
              }
              
              final question = Question.fromMap({
                'id': item['id'] ?? 0,
                'discipline': item['discipline'] ?? 'Desconhecida',
                'subject': item['subject'] ?? 'Desconhecida',
                'year': item['year'] ?? DateTime.now().year,
                'board': item['board'] ?? '',
                'exam': item['exam'] ?? '',
                'text': item['text'] ?? 'Texto da questão não disponível',
                'supportingText': item['supportingText'],
                'imageUrl': item['imageUrl'],
                'correctAnswer': item['correctAnswer'] ?? '',
                'explanation': item['explanation'],
                'type': item['type'] ?? 'simple',
                'options': item['options'] ?? [],
              });
              
              questions.add(question);
              LoggerService.debug('✅ Questão carregada: ${item['id']} - ${item['text'].toString().substring(0, item['text'].toString().length > 30 ? 30 : item['text'].toString().length)}...');
            } catch (e, stackTrace) {
              errorCount++;
              LoggerService.error(
                '❌ Erro ao converter questão ${item['id'] ?? 'desconhecida'}', 
                error: e,
                stackTrace: stackTrace,
              );
              LoggerService.debug('Item com erro: $item');
            }
          }

          if (errorCount > 0) {
            LoggerService.warning('⚠️ $errorCount questões não puderam ser carregadas devido a erros');
          }
          
          if (questions.isEmpty) {
            LoggerService.warning('ℹ️ Nenhuma questão pôde ser carregada devido a erros de formatação');
          } else {
            LoggerService.success('✅ ${questions.length} questões carregadas com sucesso');
          }
          
          return questions;
        } catch (e, stackTrace) {
          LoggerService.error(
            '❌ Erro ao processar a resposta da API', 
            error: e,
            stackTrace: stackTrace,
          );
          LoggerService.debug('Conteúdo da resposta: ${response.body}');
          throw Exception('Erro ao processar os dados recebidos do servidor');
        }
      } else {
        final errorMsg = '❌ Erro ao buscar questões: ${response.statusCode} - ${response.body}';
        LoggerService.error(errorMsg);
        
        if (response.statusCode >= 500) {
          throw Exception('Erro no servidor. Por favor, tente novamente mais tarde.');
        } else if (response.statusCode == 404) {
          throw Exception('Endpoint não encontrado. Verifique a URL da API.');
        } else if (response.statusCode == 401) {
          throw Exception('Não autorizado. Por favor, faça login novamente.');
        } else {
          throw Exception('Erro ao buscar questões. Código: ${response.statusCode}');
        }
      }
    } on SocketException catch (e) {
      final errorMsg = '🌐 Erro de conexão: ${e.message}';
      LoggerService.error(errorMsg);
      throw Exception('Não foi possível conectar ao servidor. Verifique sua conexão com a internet.');
    } on TimeoutException catch (e) {
      final errorMsg = '⏰ Timeout ao buscar questões: ${e.message ?? 'A requisição excedeu o tempo limite'}';
      LoggerService.error(errorMsg);
      throw Exception('A conexão com o servidor está lenta. Tente novamente mais tarde.');
    } on FormatException catch (e) {
      final errorMsg = '📄 Erro de formatação na resposta: ${e.message}';
      LoggerService.error(errorMsg);
      throw Exception('Resposta inválida do servidor. Por favor, tente novamente.');
    } on http.ClientException catch (e) {
      final errorMsg = '🔌 Erro de cliente HTTP: ${e.message}';
      LoggerService.error(errorMsg);
      throw Exception('Erro ao se comunicar com o servidor. Verifique sua conexão e tente novamente.');
    } catch (e, stackTrace) {
      LoggerService.error(
        '❌ Erro inesperado ao buscar questões', 
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Ocorreu um erro inesperado. Por favor, tente novamente.');
    }
  }

  Future<Question> getQuestionById(int id) async {
    try {
      LoggerService.info('Buscando questão $id da API...');
      
      final uri = Uri.parse('$_baseUrl/questions/$id');
      LoggerService.debug('URL da requisição: $uri');
      
      final response = await _httpClient.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (data == null || data['data'] == null) {
          throw Exception('Questão não encontrada');
        }
        
        final questionData = data['data'];
        
        if (questionData['options'] is String) {
          questionData['options'] = jsonDecode(questionData['options']);
        }
        
        final questionMap = {
          'id': questionData['id'],
          'discipline': questionData['discipline'] ?? '',
          'subject': questionData['subject'] ?? '',
          'year': questionData['year'],
          'board': questionData['board'] ?? '',
          'exam': questionData['exam'] ?? '',
          'text': questionData['text'] ?? '',
          'supportingText': questionData['supportingText'] ?? '',
          'imageUrl': questionData['imageUrl'],
          'correctAnswer': questionData['correctAnswer'] ?? '',
          'explanation': questionData['explanation'] ?? '',
          'type': questionData['type'] ?? 'simple',
          'options': questionData['options'] ?? [],
        };
        
        final question = Question.fromMap(questionMap);
        LoggerService.info('✅ Questão $id carregada com sucesso');
        return question;
      } else {
        final errorMsg = 'Erro ao buscar questão: ${response.statusCode} - ${response.body}';
        LoggerService.error(errorMsg);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Erro ao buscar questão $id', 
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
  
  Future<List<Question>> getQuestionsByDiscipline(String discipline) async {
    return getAllQuestions(discipline: discipline);
  }

  Future<List<Question>> getQuestionsBySubject(String subject) async {
    return getAllQuestions(subject: subject);
  }

  Future<List<Question>> getQuestionsByBoard(String board) async {
    return getAllQuestions(board: board);
  }

  Future<List<Question>> getQuestionsByYear(int year) async {
    return getAllQuestions(year: year);
  }
}
