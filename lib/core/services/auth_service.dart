import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_type.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final ApiService _apiService = ApiService();

  String? _token;
  String? _error;
  bool _isLoading = false;
  UserType? _userType;
  String? _userName;
  String? _userId;
  Map<String, dynamic>? _userData;

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
        _userData = json.decode(userJson);
        _userName = _userData?['name'];
        _userId = _userData?['id']?.toString();
      }

      try {
        final response = await _apiService.get('auth/me', token: _token);
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

    try {
      final response = await _apiService.post(
        'login',
        body: {'email': email, 'password': password},
      );

      // Trata response.data, pode ser String (JSON) ou Map já decodificado
      Map<String, dynamic>? data;
      if (response.data is String) {
        data = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        data = response.data;
      } else {
        _error = 'Resposta inesperada do servidor.';
        return false;
      }

      if (response.success && data != null) {
        final token = data['token'];
        final user = data['user'];

        if (token != null && user != null) {
          UserType? userType;
          final userTypeString = user['user_type'] as String?;
          if (userTypeString != null) {
            try {
              userType = UserType.values.firstWhere(
                (e) => e.toString().split('.').last == userTypeString,
              );
            } catch (_) {
              userType = null;
            }
          }

          _userType = userType;
          await _saveSession(token, user);
          return true;
        } else {
          _error = 'Resposta do servidor incompleta.';
          return false;
        }
      } else {
        _error = response.error ?? 'Falha no login. Verifique seus dados.';
        return false;
      }
    } catch (e) {
      _error = 'Erro de conexão. Verifique sua internet e tente novamente.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Resto do código permanece igual (signup, logout, _saveSession, _clearSession)...

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

      final response = await _apiService.post('signup', body: userData);

      if (response.success) {
        _token = response.data?['token'];
        _userData = response.data?['user'] ?? {};
        _userName = _userData?['name'] ?? name;
        _userId = _userData?['id']?.toString();
        _userType = userType;

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

  Future<void> logout() async {
    await _clearSession();
  }

  Future<void> _saveSession(String token, Map<String, dynamic> userData) async {
    _token = token;
    _userData = userData;
    _userName = userData['name'];
    _userId = userData['id']?.toString();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(userData));

    notifyListeners();
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
