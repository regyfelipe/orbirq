import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_type.dart';
import 'api_service.dart';
import '../constants/api_constants.dart';

class AuthService with ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final ApiService _apiService;

  AuthService({required ApiService apiService}) : _apiService = apiService;

  String? _token;
  String? _error;
  bool _isLoading = false;
  UserType? _userType;
  String? _userName;
  String? _userId;
  Map<String, dynamic>? _userData;
  String? get token => _token;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserType? get userType => _userType;
  String? get userName => _userName;
  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);

    if (_token != null) {
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final Map<String, dynamic> loadedUserData = json.decode(userJson);
        
        _userData = {
          ...loadedUserData,
          'progress': loadedUserData['progress'] ?? [],
          'ultimoAcesso': loadedUserData['ultimoAcesso'] ?? [],
          'simulados': loadedUserData['simulados'] ?? [],
          'analiseDesempenho': loadedUserData['analiseDesempenho'] ?? [],
        };
        
        _userName = _userData?['name'] as String?;
        _userId = _userData?['id']?.toString();
        
        final userTypeStr = _userData?['user_type'] as String?;
        if (userTypeStr != null) {
          _userType = UserType.values.firstWhere(
            (e) => e.name == userTypeStr.toLowerCase(),
            orElse: () => UserType.aluno,
          );
          debugPrint('Tipo de usuário carregado: ${_userType?.name}');
        }
        
        debugPrint('Dados do usuário carregados: $_userData');
      }

      try {
        final response = await _apiService.get('auth/me');
        if (!response.success) {
          await _clearSession();
        }
      } catch (e) {
        await _clearSession();
      }
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    debugPrint('\n=== INÍCIO DO LOGIN ===');
    debugPrint('Email: $email');
    debugPrint('Senha: ${password.isNotEmpty ? '******' : 'vazia'}');

    try {
      debugPrint('Enviando requisição de login para o servidor...');
      final response = await _apiService.post(
        'auth/login',
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );
      
      debugPrint('\n=== RESPOSTA DA API ===');
      debugPrint('Status: ${response.success ? 'SUCESSO' : 'ERRO'}');
      debugPrint('Código: ${response.statusCode}');
      debugPrint('Tipo de dados: ${response.data.runtimeType}');
      debugPrint('Dados: ${response.data}');
      debugPrint('Erro: ${response.error}');

      if (!response.success) {
        _error = response.error ?? 'Falha no login. Verifique suas credenciais.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      Map<String, dynamic>? data;
      if (response.data is Map<String, dynamic>) {
        data = response.data as Map<String, dynamic>;
        debugPrint('Dados extraídos do Map: $data');
      } else if (response.data is String) {
        debugPrint('Resposta é uma String, tentando converter para JSON...');
        try {
          data = json.decode(response.data) as Map<String, dynamic>;
          debugPrint('Dados convertidos: $data');
        } catch (e) {
          debugPrint('Erro ao decodificar JSON: $e');
          _error = 'Erro ao processar a resposta do servidor.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        debugPrint('Formato de resposta inesperado: ${response.data.runtimeType}');
        _error = 'Resposta inesperada do servidor: ${response.data}';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint('\n=== PROCESSANDO DADOS DO USUÁRIO ===');
      debugPrint('Estrutura dos dados recebidos: ${data.keys.join(', ')}');
      
      if (data['token'] == null) {
        debugPrint('Token não encontrado na resposta');
        _error = 'Resposta do servidor inválida: token não encontrado';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final token = data['token'] as String;
      debugPrint('Token recebido: ***${token.length > 6 ? token.substring(token.length - 6) : '***'}');
      
      final user = data['user'] as Map<String, dynamic>? ?? data;
      debugPrint('Dados do usuário: $user');

      if (user.isEmpty) {
        debugPrint('Dados do usuário não encontrados na resposta');
        _error = 'Dados do usuário não encontrados na resposta do servidor';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      UserType? userType;
      final userTypeString = user['user_type']?.toString();
      debugPrint('Tipo de usuário recebido: $userTypeString');
      
      if (userTypeString != null) {
        try {
          userType = UserType.values.firstWhere(
            (e) => e.name == userTypeString.toLowerCase(),
            orElse: () => UserType.aluno,
          );
          debugPrint('Tipo de usuário processado: ${userType.name}');
        } catch (e) {
          debugPrint('Erro ao processar tipo de usuário: $e');
          userType = UserType.aluno;
        }
      } else {
        debugPrint('Tipo de usuário não especificado, usando valor padrão (aluno)');
        userType = UserType.aluno;
      }

      try {
        debugPrint('Salvando sessão do usuário...');
        await _saveSession(token, user);
        _userType = userType;
        _isLoading = false;
        debugPrint('Sessão salva com sucesso!');
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Erro ao salvar sessão: $e');
        _error = 'Erro ao salvar os dados da sessão';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Erro durante o login: $e');
      _error = 'Erro de conexão. Verifique sua internet e tente novamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? institution,
    String? registrationNumber,
    String? course,
    String? cpf,
    String? phone,
    String? photoUrl,
    String? miniBio,
    String? instagramOrWebsite,
    String? proofDocument,
    String? referralCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = {
        'name': name,
        'email': email,
        'password': password,
        'userType': userType.toString().split('.').last,
        'institution': institution,
        'registrationNumber': registrationNumber,
        'course': course,
        'cpf': cpf,
        'phone': phone,
        'photoUrl': photoUrl,
        'miniBio': miniBio,
        'instagramOrWebsite': instagramOrWebsite,
        'proofDocument': proofDocument,
        'referralCode': referralCode,
      };

      final response = await _apiService.post(ApiConstants.register, body: userData);

      if (response.success) {
        _token = response.data?['token'] as String?;
        _userData = {
          ...?response.data?['user'] as Map<String, dynamic>?,
          'progress': [],
          'ultimoAcesso': [],
          'simulados': [],
          'analiseDesempenho': [],
        };
        _userName = _userData?['name'] as String? ?? name;
        _userId = _userData?['id']?.toString();
        _userType = userType;
        
        debugPrint('Usuário cadastrado com sucesso: $_userData');

        final prefs = await SharedPreferences.getInstance();
        if (_token != null) await prefs.setString(_tokenKey, _token!);
        await prefs.setString(_userKey, json.encode(_userData));

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.error ?? 'Falha no cadastro.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveSession(String token, Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('auth_token', token);
      await prefs.setString('token', token); 
      debugPrint('✅ Token saved successfully in SharedPreferences');
      
      final userId = userData['id'];
      if (userId != null) {
        if (userId is int) {
          await prefs.setInt('userId', userId);
          await prefs.setString('userIdStr', userId.toString());
        } else if (userId is String) {
          final parsedId = int.tryParse(userId);
          if (parsedId != null) {
            await prefs.setInt('userId', parsedId);
          }
          await prefs.setString('userIdStr', userId);
        }
        debugPrint('✅ User ID saved: $userId');
      } else {
        debugPrint('⚠️ User ID not found in data: $userData');
      }
      
      final userDataWithDefaults = {
        ...userData,
        'progress': userData['progress'] ?? [],
        'ultimoAcesso': userData['ultimoAcesso'] ?? [],
        'simulados': userData['simulados'] ?? [],
        'analiseDesempenho': userData['analiseDesempenho'] ?? [],
      };
      
      await prefs.setString('user_data', json.encode(userDataWithDefaults));
      debugPrint('✅ User data saved successfully');
      
      _token = token;
      _userData = userDataWithDefaults;
      _userName = _userData?['name'] as String?;
      _userId = userId?.toString();
      
      final userTypeStr = userData['user_type']?.toString().toLowerCase();
      if (userTypeStr != null) {
        _userType = UserType.values.firstWhere(
          (e) => e.name == userTypeStr,
          orElse: () => UserType.aluno,
        );
      }
      
      notifyListeners();
      
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving session: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
  
  Future<void> logout() async {
    try {
      await _clearSession();
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ Error during logout: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _clearSession() async {
    _token = null;
    _userData = null;
    _userName = null;
    _userId = null;
    _userType = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);

    notifyListeners();
  }
}
