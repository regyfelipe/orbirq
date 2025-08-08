import 'package:flutter/foundation.dart';

class LoggerService {
  LoggerService._();
  static bool enabled = kDebugMode;

  static void info(String message) {
    if (enabled) {
      print('ℹ️ $message');
    }
  }

  static void warning(String message) {
    if (enabled) {
      print('⚠️ $message');
    }
  }

  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (enabled) {
      final buffer = StringBuffer('❌ $message');
      if (error != null) {
        buffer.write('\nError: $error');
      }
      if (stackTrace != null) {
        buffer.write('\n$stackTrace');
      }
      print(buffer);
    }
  }

  static void debug(String message) {
    if (enabled) {
      print('🐛 $message');
    }
  }

  static void success(String message) {
    if (enabled) {
      print('✅ $message');
    }
  }
}
