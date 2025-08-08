import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:orbirq/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Nome do logger para esta classe
const String _logTag = 'ResponseService';

class ResponseService {
  static const String _baseUrl = 'http://192.168.18.11:3000';
  static const String _responsesEndpoint = '/responses/responses';
  // Note: The performance endpoint is in the responses route, not user route

  /// Gets authentication headers with JWT token
  static Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Try both possible token keys for compatibility
      final token = prefs.getString('auth_token') ?? prefs.getString('token');
      
      developer.log('Token from SharedPreferences: ${token != null ? 'present' : 'missing'}', 
          name: _logTag);
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      developer.log('Error getting auth headers: $e', 
          name: _logTag, 
          error: e);
      rethrow;
    }
  }

  /// Saves the user's response to a question
  /// Returns true if the response is saved successfully
  static Future<bool> saveResponse({
    required String questionId,
    required String questionText,
    required String userAnswer,
    required String correctAnswer,
    required bool isCorrect,
    required String subject,
    String? topic,
    String? difficulty,
    int? timeSpentSeconds,
  }) async {
    final stopwatch = Stopwatch()..start();
    const String methodName = 'saveResponse';
    
    try {
      developer.log('\n🔄 === INÍCIO DO SALVAMENTO DA RESPOSTA ===', 
          name: '$_logTag.$methodName');
      
      final headers = await _getAuthHeaders();
      
      final prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('userId');
      
      if (userId == null) {
        final userIdStr = prefs.getString('userIdStr');
        if (userIdStr != null && userIdStr.isNotEmpty) {
          userId = int.tryParse(userIdStr);
          if (userId != null) {
            await prefs.setInt('userId', userId);
          }
        }
      }
      
      if (userId == null) {
        final userDataStr = prefs.getString('user_data');
        if (userDataStr != null && userDataStr.isNotEmpty) {
          try {
            final userData = json.decode(userDataStr);
            final dynamic idValue = userData['id'];
            
            if (idValue is int) {
              userId = idValue;
            } else if (idValue is String) {
              userId = int.tryParse(idValue);
            } else if (idValue != null) {
              userId = int.tryParse(idValue.toString());
            }
            
            if (userId != null) {
              await prefs.setInt('userId', userId);
              await prefs.setString('userIdStr', userId.toString());
            }
          } catch (e) {
            developer.log('Error decoding user_data: $e', name: _logTag);
          }
        }
      }

      developer.log('🔍 Authentication data:', name: '$_logTag.$methodName');
      developer.log('   - User ID: $userId (type: ${userId?.runtimeType})', 
          name: '$_logTag.$methodName');
      
      final keys = prefs.getKeys();
      developer.log('   - Available SharedPreferences keys: ${keys.join(', ')}', 
          name: '$_logTag.$methodName');

      if (userId == null) {
        final errorMsg = 'User ID not found. User may not be logged in.';
        developer.log('❌ $errorMsg', name: '$_logTag.$methodName');
        throw Exception(errorMsg);
      }

      final requestBody = {
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
        'timestamp': DateTime.now().toIso8601String(),
      };

      developer.log('🌐 Enviando requisição para: $_baseUrl$_responsesEndpoint', 
          name: '$_logTag.$methodName');
      developer.log('📦 Corpo da requisição: $requestBody', 
          name: '$_logTag.$methodName');

      http.Response response;
      try {
        developer.log('🌐 Iniciando requisição HTTP...', name: '$_logTag.$methodName');
        final uri = Uri.parse('$_baseUrl$_responsesEndpoint');
        developer.log('🔗 URL: $uri', name: '$_logTag.$methodName');
        
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(requestBody),
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            final errorMsg = '⏱️ Timeout ao salvar resposta';
            developer.log(errorMsg, 
                name: '$_logTag.$methodName', 
                level: 900);
            throw TimeoutException('Tempo limite excedido ao salvar resposta');
          },
        );
        developer.log('✅ Resposta HTTP recebida', name: '$_logTag.$methodName');
      } catch (e, stackTrace) {
        developer.log('❌ Erro na requisição HTTP', 
            name: '$_logTag.$methodName',
            error: e,
            stackTrace: stackTrace);
        rethrow;
      }

      final responseTime = stopwatch.elapsedMilliseconds;
      developer.log('✅ Resposta recebida em ${responseTime}ms', 
          name: '$_logTag.$methodName');
      developer.log('📥 Status: ${response.statusCode}', 
          name: '$_logTag.$methodName');
      developer.log('📄 Corpo da resposta: ${response.body}', 
          name: '$_logTag.$methodName',
          level: response.statusCode >= 400 ? 1000 : 0);

      if (response.statusCode == 200 || response.statusCode == 201) {
        developer.log('✔️ Resposta salva com sucesso!', 
            name: '$_logTag.$methodName');
        return true;
      } else {
        final errorMsg = 'Falha ao salvar resposta: ${response.statusCode}\n'
            'Resposta: ${response.body}';
        developer.log('❌ $errorMsg', 
            name: '$_logTag.$methodName', 
            error: errorMsg);
        throw http.ClientException(
          'Erro ${response.statusCode}: ${response.body}',
          Uri.parse('$_baseUrl$_responsesEndpoint'),
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      developer.log('⏱️ Timeout ao salvar resposta', 
          name: '$_logTag.$methodName',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    } on http.ClientException catch (e, stackTrace) {
      developer.log('🌐 Erro de conexão', 
          name: '$_logTag.$methodName',
          error: e,
          stackTrace: stackTrace);
      throw Exception('Erro de conexão: ${e.message}');
    } on FormatException catch (e, stackTrace) {
      developer.log('📝 Erro de formatação', 
          name: '$_logTag.$methodName',
          error: e,
          stackTrace: stackTrace);
      throw Exception('Erro ao processar a resposta do servidor');
    } on Exception catch (e, stackTrace) {
      developer.log('❌ Erro ao salvar resposta', 
          name: '$_logTag.$methodName',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    } finally {
      stopwatch.stop();
      developer.log('⏱️ Tempo total: ${stopwatch.elapsedMilliseconds}ms', 
          name: '$_logTag.$methodName');
    }
  }

  static Future<Map<String, dynamic>> getUserPerformance(int userId, {String? token}) async {
    try {
      var authToken = token;
      if (authToken == null) {
        final prefs = await SharedPreferences.getInstance();
        authToken = prefs.getString('token');
      }

      if (authToken == null) {
        throw Exception('Usuário não autenticado');
      }

      final url = '$_baseUrl/responses/users/$userId/performance';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data is Map<String, dynamic>) {
          if (data['data'] != null) {
            return _sanitizePerformanceData(data['data']);
          }
          return _sanitizePerformanceData(data);
        }
        
        throw Exception('Formato de resposta inválido do servidor');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?.toString() ?? 'Falha ao buscar dados de desempenho');
      }
    } catch (e) {
      rethrow;
    }
  }
  

  static dynamic _sanitizePerformanceData(dynamic data) {
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      
      data.forEach((key, value) {
        if (value is num) {
          sanitized[key] = value;
        } else if (value == null) {
          sanitized[key] = 0.0;
        } else if (value is String) {
          if (key.toString().toLowerCase().contains('accuracy') || 
              key.toString().toLowerCase().contains('percent') ||
              key.toString().toLowerCase().contains('progress') ||
              key.toString().toLowerCase().contains('value')) {
            sanitized[key] = num.tryParse(value)?.toDouble() ?? 0.0;
          } else {
            sanitized[key] = value;
          }
        } else if (value is Map) {
          sanitized[key] = _sanitizePerformanceData(Map<String, dynamic>.from(value));
        } else if (value is List) {
          sanitized[key] = value.map((item) => _sanitizePerformanceData(item)).toList();
        } else {
          sanitized[key] = value;
        }
      });
      
      return sanitized;
    } else if (data is List) {
      return data.map((item) => _sanitizePerformanceData(item)).toList();
    } else if (data is String && (data == 'true' || data == 'false')) {
      return data == 'true';
    } else if (data is String) {
      return num.tryParse(data) ?? data;
    }
    
    return data;
  }

  static Future<Map<String, dynamic>> getProgressBySubject(int userId, String subject) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/responses/users/$userId/progress?subject=$subject'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return _sanitizePerformanceData(data['data'] ?? data);
        }
        return {'subject': subject, 'progress': 0.0};
      } else {
        throw Exception('Falha ao carregar progresso para $subject');
      }
    } catch (e) {
      return {'subject': subject, 'progress': 0.0};
    }
  }

  static Future<List<UserResponse>> getRecentResponses(int userId, {int limit = 10}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$_responsesEndpoint/user/$userId?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = (responseData is Map && responseData['data'] != null)
            ? responseData['data']
            : (responseData is List ? responseData : []);

        return data.map((json) => UserResponse.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']?.toString() ?? 'Falha ao buscar respostas recentes');
      }
    } catch (e) {
      rethrow;
    }
  }

  static double getSafeProgress(Map<String, dynamic> data, String key) {
    try {
      if (data[key] == null) return 0.0;
      
      final value = data[key] is num 
          ? data[key].toDouble() 
          : double.tryParse(data[key].toString()) ?? 0.0;
          
      if (value.isNaN || !value.isFinite) return 0.0;
      return value.clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }
}
