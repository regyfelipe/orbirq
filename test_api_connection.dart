import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<void> main() async {
  print('🔍 Testando conexão com a API...');
  
  // Configura o cliente HTTP para aceitar certificados autoassinados (apenas para desenvolvimento)
  final httpClient = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  
  final client = IOClient(httpClient);
  
  try {
    // Testar endpoint de ping
    print('\n🔄 Testando endpoint /ping...');
    final pingResponse = await client.get(
      Uri.parse('http://192.168.18.11:3000/ping'),
      headers: {'Accept': 'application/json'},
    );
    
    print('✅ Status: ${pingResponse.statusCode}');
    print('📄 Resposta: ${pingResponse.body}');
    
    // Testar endpoint de questões
    print('\n🔄 Testando endpoint /api/questions...');
    final questionsResponse = await client.get(
      Uri.parse('http://192.168.18.11:3000/api/questions?limit=1'),
      headers: {'Accept': 'application/json'},
    );
    
    print('✅ Status: ${questionsResponse.statusCode}');
    print('📄 Resposta: ${questionsResponse.body}');
    
  } catch (e) {
    print('❌ Erro ao testar a API: $e');
  } finally {
    client.close();
    httpClient.close(force: true);
  }
}
