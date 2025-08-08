import 'package:flutter/material.dart';

/// Utility class for performance-related helper methods
class PerformanceUtils {
  /// Parses a dynamic value to an integer
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Parses a dynamic value to a double
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return 0.0;
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Calculates accuracy from correct and total values
  static double calculateAccuracy(int correct, int total) {
    if (total == 0) return 0.0;
    return (correct / total) * 100;
  }

  /// Formats a percentage value with optional decimal places
  static String formatPercentage(double value, {int decimalPlaces = 1}) {
    return '${value.toStringAsFixed(decimalPlaces)}%';
  }

  /// Gets color based on accuracy percentage
  static Color getAccuracyColor(double accuracy) {
    if (accuracy >= 70) return Colors.green;
    if (accuracy >= 40) return Colors.orange;
    return Colors.red;
  }

  /// Gets color for difficulty level
  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return Colors.green;
      case 'médio':
      case 'medio':
        return Colors.orange;
      case 'difícil':
      case 'dificil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
