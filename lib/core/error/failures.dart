import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    String message = 'Server error occurred',
    String? code,
    this.statusCode,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, statusCode];

  @override
  String toString() => 'ServerFailure(message: $message, code: $code, statusCode: $statusCode)';
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred', String? code})
      : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No internet connection', String? code})
      : super(message: message, code: code);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String message = 'Authentication required', String? code})
      : super(message: message, code: code);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Resource not found', String? code})
      : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    String message = 'Validation failed',
    String? code,
    this.errors,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, errors];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String message = 'Request timed out', String? code})
      : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  final dynamic error;

  const UnknownFailure({
    String message = 'An unknown error occurred',
    String? code,
    this.error,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, error];

  @override
  String toString() => 'UnknownFailure(message: $message, code: $code, error: $error)';
}
