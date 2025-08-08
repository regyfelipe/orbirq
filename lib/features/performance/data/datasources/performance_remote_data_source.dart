import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:orbirq/core/error/exceptions.dart';
import 'package:orbirq/features/performance/data/models/performance_model.dart';

abstract class PerformanceRemoteDataSource {
  Future<PerformanceModel> getPerformanceData(int userId, {String? token});
}

class PerformanceRemoteDataSourceImpl implements PerformanceRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  PerformanceRemoteDataSourceImpl({
    required this.baseUrl,
    required this.client,
  });

  /// Fetches performance data for a specific user
  /// 
  /// The [userId] is the ID of the user to fetch performance data for
  /// [token] is optional authentication token
  @override
  Future<PerformanceModel> getPerformanceData(
    int userId, {
    String? token,
  }) async {
    // Try different endpoint variations until we find the correct one
    final endpointVariations = [
      'responses/users/$userId/performance',  // Correct path with /responses prefix
      'api/responses/users/$userId/performance',  // With API prefix
      'api/users/$userId/performance',      // Fallback patterns
      'users/$userId/performance',
    ];
    
    Exception? lastError;
    
    // Try each endpoint variation until one works
    for (final endpoint in endpointVariations) {
      try {
        final url = Uri.parse('$baseUrl/$endpoint');
        print('🌐 Trying endpoint: $url');
        
        final response = await client.get(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
        
        print('📥 Response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          print('✅ Successfully connected to endpoint: $endpoint');
          try {
            final responseData = json.decode(utf8.decode(response.bodyBytes));
            return PerformanceModel.fromJson(responseData);
          } catch (e) {
            print('❌ Error parsing response: $e');
            lastError = FormatException('Failed to parse response: $e');
          }
        } else {
          print('⚠️ Endpoint $endpoint returned status: ${response.statusCode}');
          print('Response body: ${response.body}');
          lastError = ServerException(
            message: 'Server returned ${response.statusCode}: ${response.body}',
            statusCode: response.statusCode,
          );
        }
      } on SocketException catch (e) {
        print('🌐 Network error with endpoint $endpoint: $e');
        lastError = NetworkException('No internet connection');
      } on FormatException catch (e) {
        print('📄 Format error with endpoint $endpoint: $e');
        lastError = FormatException('Invalid data format from server');
      } catch (e) {
        print('⚠️ Unexpected error with endpoint $endpoint: $e');
        lastError = e as Exception;
      }
    }
    
    // If we get here, all endpoint variations failed
    throw lastError ?? NotFoundException('Could not find a valid performance endpoint');
  }
}
