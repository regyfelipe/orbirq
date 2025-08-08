class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error occurred', this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status Code: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(String s, {this.message = 'Network error occurred'});

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({this.message = 'Authentication required'});

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(String s, {this.message = 'Resource not found'});

  @override
  String toString() => 'NotFoundException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ValidationException({required this.message, this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException({this.message = 'Request timed out'});

  @override
  String toString() => 'TimeoutException: $message';
}
