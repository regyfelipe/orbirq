import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({required this.success, this.data, this.error, this.statusCode});

  factory ApiResponse.fromResponse(http.Response response) {
    try {
      // Cuidado: json.decode pode retornar Map ou List, então forço Map para garantir acesso a 'message'
      final data = json.decode(response.body);

      String? errorMessage;

      // Tenta extrair mensagem de erro em várias possíveis chaves
      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString() ??
            data['error']?.toString() ??
            data['errors']?.toString();
      }

      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        data: data,
        error: errorMessage,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Falha ao analisar a resposta: $e',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  String toString() =>
      'ApiResponse(success: $success, data: $data, error: $error)';
}

class ApiService {
  static const String baseUrl = 'http://192.168.18.11:3000';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<ApiResponse<dynamic>> get(String endpoint, {String? token}) async {
    try {
      final headers = {..._headers};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return ApiResponse.fromResponse(response);
    } on SocketException {
      return ApiResponse(success: false, error: 'Sem conexão com a internet');
    } catch (e) {
      debugPrint('GET request failed: $e');
      return ApiResponse(success: false, error: 'Falha ao completar a requisição');
    }
  }

  Future<ApiResponse<dynamic>> post(
  String endpoint, {
  dynamic body,
  String? token,
}) async {
  try {
    final headers = {..._headers};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    debugPrint('POST $endpoint - headers: $headers - body: $body');

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    return ApiResponse.fromResponse(response);
  } on SocketException {
    return ApiResponse(success: false, error: 'Sem conexão com a internet');
  } catch (e) {
    debugPrint('POST request failed: $e');
    return ApiResponse(success: false, error: 'Falha ao completar a requisição');
  }
}

}
