import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:orbirq/core/constants/api_constants.dart';
import 'package:orbirq/models/user_analise_desempenho.dart';
import 'package:orbirq/models/user_progress.dart';
import 'package:orbirq/models/user_simulado.dart';
import 'package:orbirq/models/user_ultimo_acesso.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({required this.success, this.data, this.error, this.statusCode});

  factory ApiResponse.fromResponse(http.Response response) {
    try {
      debugPrint('Resposta bruta do servidor: ${response.body}');
      
      dynamic data;
      if (response.body.isNotEmpty) {
        try {
          data = json.decode(response.body);
        } catch (e) {
          data = response.body;
        }
      }

      String? errorMessage;
      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString() ??
            data['error']?.toString() ??
            data['errors']?.toString();
      }

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
      
      if (!isSuccess) {
        debugPrint('Erro na resposta: ${response.statusCode} - $errorMessage');
        debugPrint('Corpo da resposta: $data');
      }

      return ApiResponse(
        success: isSuccess,
        data: data,
        error: errorMessage,
        statusCode: response.statusCode,
      );
    } catch (e, stackTrace) {
      debugPrint('Erro ao processar resposta: $e');
      debugPrint('Stack trace: $stackTrace');
      return ApiResponse(
        success: false,
        error: 'Falha ao processar a resposta: $e',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  String toString() =>
      'ApiResponse(success: $success, data: $data, error: $error)';
}

class ApiService {
  final String baseUrl;
  final SharedPreferences _prefs;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String _buildUrl(String endpoint) {
    final normalizedEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;
    return '$cleanBaseUrl/$normalizedEndpoint';
  }

  ApiService({required SharedPreferences prefs}) 
      : _prefs = prefs,
        baseUrl = ApiConstants.baseUrl;

  static Future<ApiService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ApiService(prefs: prefs);
  }
  Future<void> _updateAuthHeader() async {
    final token = _prefs.getString(ApiConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      _headers['Authorization'] = 'Bearer $token';
      debugPrint('Token de autenticação adicionado ao cabeçalho');
    } else {
      _headers.remove('Authorization');
      debugPrint('Nenhum token de autenticação encontrado');
    }
    debugPrint('Headers atualizados: $_headers');
  }

  Future<ApiResponse<dynamic>> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      debugPrint('\n=== NOVA REQUISIÇÃO DELETE ===');
      final url = _buildUrl(endpoint);
      debugPrint('URL: $url');
      debugPrint('Requer autenticação: $requiresAuth');
      
      if (requiresAuth) {
        await _updateAuthHeader();
      }

      debugPrint('Headers: $_headers');
      final startTime = DateTime.now();
      debugPrint('Enviando requisição em: $startTime');

      final response = await http.delete(
        Uri.parse(url),
        headers: _headers,
      ).timeout(ApiConstants.timeout);
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      debugPrint('\n=== RESPOSTA RECEBIDA ===');
      debugPrint('URL: $baseUrl/$endpoint');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Tempo de resposta: ${duration.inMilliseconds}ms');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('==========================\n');

      return ApiResponse.fromResponse(response);
    } on SocketException {
      return ApiResponse(success: false, error: 'Sem conexão com a internet');
    } on TimeoutException {
      return ApiResponse(success: false, error: 'Tempo de requisição excedido');
    } catch (e) {
      debugPrint('Erro na requisição DELETE: $e');
      return ApiResponse(success: false, error: 'Erro na requisição: $e');
    }
  }

  Future<ApiResponse<dynamic>> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      debugPrint('\n=== NOVA REQUISIÇÃO GET ===');
      final url = _buildUrl(endpoint);
      debugPrint('URL: $url');
      debugPrint('Requer autenticação: $requiresAuth');
      
      if (requiresAuth) {
        await _updateAuthHeader();
      }

      debugPrint('Headers: $_headers');
      final startTime = DateTime.now();
      debugPrint('Enviando requisição em: $startTime');

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(ApiConstants.timeout);
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      debugPrint('\n=== RESPOSTA RECEBIDA ===');
      debugPrint('URL: $baseUrl/$endpoint');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Tempo de resposta: ${duration.inMilliseconds}ms');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('==========================\n');

      return ApiResponse.fromResponse(response);
    } on SocketException {
      return ApiResponse(success: false, error: 'Sem conexão com a internet');
    } on TimeoutException {
      return ApiResponse(success: false, error: 'Tempo de requisição excedido');
    } catch (e) {
      debugPrint('GET request failed: $e');
      return ApiResponse(
        success: false,
        error: 'Falha ao completar a requisição: $e',
      );
    }
  }

  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      debugPrint('\n=== NOVA REQUISIÇÃO POST ===');
      debugPrint('URL: $url');
      debugPrint('Requer autenticação: $requiresAuth');
      
      if (requiresAuth) {
        await _updateAuthHeader();
      }

      debugPrint('Headers: $_headers');
      debugPrint('Body: $body');
      
      final startTime = DateTime.now();
      debugPrint('Enviando requisição em: $startTime');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          ..._headers,
          'Content-Type': 'application/json', 
        },
        body: body is String ? body : jsonEncode(body),
      ).timeout(ApiConstants.timeout);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      debugPrint('\n=== RESPOSTA RECEBIDA ===');
      debugPrint('URL: $baseUrl/$endpoint');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Tempo de resposta: ${duration.inMilliseconds}ms');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('==========================\n');

      return ApiResponse.fromResponse(response);
    } on SocketException {
      return ApiResponse(success: false, error: 'Sem conexão com a internet');
    } on TimeoutException {
      return ApiResponse(success: false, error: 'Tempo de requisição excedido');
    } catch (e) {
      debugPrint('POST request failed: $e');
      return ApiResponse(
        success: false,
        error: 'Falha ao completar a requisição: $e',
      );
    }
  }

  Future<ApiResponse<dynamic>> put(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    try {
      if (requiresAuth) {
        await _updateAuthHeader();
      }

      final url = _buildUrl(endpoint);
      debugPrint('PUT Request to: $url');
      debugPrint('Headers: $_headers');
      debugPrint('Body: $body');

      final response = await http.put(
        Uri.parse(url),
        headers: _headers,
        body: body is String ? body : jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return ApiResponse.fromResponse(response);
    } on SocketException {
      return ApiResponse(success: false, error: 'Sem conexão com a internet');
    } on TimeoutException {
      return ApiResponse(success: false, error: 'Tempo de requisição excedido');
    } catch (e) {
      debugPrint('PUT request failed: $e');
      return ApiResponse(
        success: false,
        error: 'Falha ao completar a requisição: $e',
      );
    }
  }

  Future<ApiResponse<UserProgress>> getUserProgress(int userId) async {
    final response = await get('${ApiConstants.userProgress}/$userId/progress');
    if (response.success && response.data != null) {
      try {
        final responseData = response.data;
        return ApiResponse(
          success: true,
          data: UserProgress.fromJson(
            responseData is Map<String, dynamic> ? responseData : {}
          ),
        );
      } catch (e) {
        debugPrint('Erro ao converter UserProgress: $e');
      }
    }
    return ApiResponse(
      success: false,
      data: UserProgress(
        totalQuestoes: 0,
        acertos: 0,
        mediaGeral: 0.0,
        diasEstudo: 0,
      ),
    );
  }

  Future<ApiResponse<dynamic>> updateUserProgress(
      int userId, Map<String, dynamic> progressData) async {
    return post(
      '${ApiConstants.userProgress}/$userId/progress', 
      body: progressData,
    );
  }

  Future<ApiResponse<dynamic>> updateUserPhoto(int userId, String base64Image) {
    return post(
      '${ApiConstants.userProgress}/$userId/photo',
      body: {'photo': base64Image},
    );
  }

  Future<ApiResponse<UserProgress>> fetchUserProgress(int userId) async {
    try {
      final endpoint = 'users/users/$userId/progress';
      debugPrint('Fetching user progress from: $baseUrl/$endpoint');
      final response = await get(endpoint);
      
      if (response.statusCode == 200 && response.data != null) {
        try {
          final responseData = response.data;
          debugPrint('Dados de progresso recebidos: $responseData');
          
          final progressData = responseData is Map<String, dynamic> && responseData['data'] != null
              ? responseData['data']
              : responseData;
          
          if (progressData is Map<String, dynamic>) {
            return ApiResponse(
              success: true,
              data: UserProgress.fromJson(progressData),
              statusCode: response.statusCode,
            );
          }
        } catch (e) {
          debugPrint('Erro ao converter UserProgress: $e');
        }
      }
      
      return ApiResponse(
        success: false,
        data: UserProgress(
          totalQuestoes: 0,
          acertos: 0,
          mediaGeral: 0.0,
          diasEstudo: 0,
        ),
        statusCode: response.statusCode,
        error: response.error,
      );
    } catch (e) {
      debugPrint('Exceção em fetchUserProgress: $e');
      return ApiResponse(
        success: false,
        data: UserProgress(
          totalQuestoes: 0,
          acertos: 0,
          mediaGeral: 0.0,
          diasEstudo: 0,
        ),
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<UserUltimoAcesso>>> fetchUserUltimosAcessos(int userId) async {
    try {
      final endpoint = 'users/users/$userId/ultimos-acessos';
      debugPrint('Fetching últimos acessos from: $baseUrl/$endpoint');
      final response = await get(endpoint);
      debugPrint('Resposta de últimos acessos: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        try {
          final responseData = response.data;
          final List list = responseData is List 
              ? responseData 
              : (responseData is Map && responseData['data'] is List 
                  ? responseData['data'] 
                  : []);
          
          return ApiResponse(
            success: true,
            data: list.map((e) => UserUltimoAcesso.fromMap(
              e is Map<String, dynamic> ? e : {}
            )).toList(),
            statusCode: response.statusCode,
          );
        } catch (e) {
          debugPrint('Erro ao converter UserUltimoAcesso: $e');
          return ApiResponse(
            success: false,
            data: [],
            statusCode: response.statusCode,
            error: 'Erro ao processar os dados de últimos acessos',
          );
        }
      }
      
      return ApiResponse(
        success: true,
        data: [],
        statusCode: response.statusCode,
        error: response.error,
      );
    } catch (e) {
      debugPrint('Exceção em fetchUserUltimosAcessos: $e');
      return ApiResponse(
        success: false,
        data: [],
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<UserSimulado>>> fetchUserSimulados(int userId) async {
    try {
      final endpoint = 'users/users/$userId/simulados';
      debugPrint('Fetching simulados from: $baseUrl/$endpoint');
      final response = await get(endpoint);
      debugPrint('Resposta de simulados: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        try {
          final responseData = response.data;
          final List list = responseData is List 
              ? responseData 
              : (responseData is Map && responseData['data'] is List 
                  ? responseData['data'] 
                  : []);
          
          final simulados = list.map((e) {
            final map = e is Map<String, dynamic> ? e : {};
            return UserSimulado(
              id: map['id']?.toString() ?? '0',
              titulo: map['titulo']?.toString() ?? 'Simulado',
              descricao: map['descricao']?.toString() ?? '',
              totalQuestoes: (map['totalQuestoes'] ?? 0) as int,
              tempoMinutos: 180,
              isNovo: map['isNovo'] == true,
            );
          }).toList();
          
          return ApiResponse(
            success: true,
            data: simulados,
            statusCode: response.statusCode,
          );
        } catch (e) {
          debugPrint('Erro ao converter UserSimulado: $e');
          return ApiResponse(
            success: false,
            data: [],
            statusCode: response.statusCode,
            error: 'Erro ao processar os dados de simulados',
          );
        }
      }
      
      return ApiResponse(
        success: true,
        data: [],
        statusCode: response.statusCode,
        error: response.error,
      );
    } catch (e) {
      debugPrint('Exceção em fetchUserSimulados: $e');
      return ApiResponse(
        success: false,
        data: [],
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<UserAnaliseDesempenho>>> fetchUserAnalisesDesempenho(int userId) async {
    try {
      final endpoint = 'users/users/$userId/analises-desempenho';
      debugPrint('Fetching análises de desempenho from: $baseUrl/$endpoint');
      final response = await get(endpoint);
      debugPrint('Resposta de análises de desempenho: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        try {
          final responseData = response.data;
          final List list = responseData is List 
              ? responseData 
              : (responseData is Map && responseData['data'] is List 
                  ? responseData['data'] 
                  : []);
          
          final analises = list.map((e) {
            final map = e is Map<String, dynamic> ? e : {};
            return UserAnaliseDesempenho(
              id: map['id']?.toString() ?? '0',
              titulo: map['titulo']?.toString() ?? 'Análise de Desempenho',
              pontuacaoMedia: (map['pontuacaoMedia'] ?? 0.0).toDouble(),
              totalQuestoes: (map['totalQuestoes'] ?? 0) as int,
              acertos: (map['acertos'] ?? 0) as int,
              disciplina: map['disciplina']?.toString() ?? 'Geral',
            );
          }).toList();
          
          return ApiResponse(
            success: true,
            data: analises,
            statusCode: response.statusCode,
          );
        } catch (e) {
          debugPrint('Erro ao converter UserAnaliseDesempenho: $e');
          return ApiResponse(
            success: false,
            data: [],
            statusCode: response.statusCode,
            error: 'Erro ao processar as análises de desempenho',
          );
        }
      }
      
      return ApiResponse(
        success: true,
        data: [],
        statusCode: response.statusCode,
        error: response.error,
      );
    } catch (e) {
      debugPrint('Exceção em fetchUserAnalisesDesempenho: $e');
      return ApiResponse(
        success: false,
        data: [],
        error: e.toString(),
      );
    }
  }
}
