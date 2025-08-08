class ApiConstants {
  static const String baseUrl = 'http://192.168.18.11:3000';

  static const String login = '/login';
  static const String register = 'auth/signup';
  static const String logout = '/logout';
  static const String userProfile = '/me';
  static const String userProgress = '/users';
  static const String responses = '/responses';
  static const String questions = '/questions';
  static const String performance = '/users';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration timeout = Duration(seconds: 30);

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String userIdKey = 'user_id';
}
