import 'package:equatable/equatable.dart';
import 'package:orbirq/features/performance/domain/entities/performance_entity.dart';

class PerformanceModel extends PerformanceEntity with EquatableMixin {
  const PerformanceModel({
    required super.overall,
    required super.bySubject,
    required super.byDifficulty,
    required super.recentResponses,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔄 Parsing performance data from JSON...');
      
      // Check if the response has a 'data' field
      final data = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
      
      // Safely parse overall data
      final overall = data['overall'] is Map 
          ? Map<String, dynamic>.from(data['overall'] as Map)
          : <String, dynamic>{
              'totalResponses': data['totalResponses'] ?? 0,
              'correctResponses': data['correctResponses'] ?? 0,
              'accuracy': data['accuracy']?.toDouble() ?? 0.0,
              'totalSubjects': data['totalSubjects'] ?? 0,
            };
      
      // Safely parse bySubject
      final bySubject = data['bySubject'] is List
          ? List<Map<String, dynamic>>.from(
              (data['bySubject'] as List).map<Map<String, dynamic>>(
                (item) => item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{},
              ),
            )
          : <Map<String, dynamic>>[];
      
      // Safely parse byDifficulty
      final byDifficulty = data['byDifficulty'] is List
          ? List<Map<String, dynamic>>.from(
              (data['byDifficulty'] as List).map<Map<String, dynamic>>(
                (item) => item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{},
              ),
            )
          : <Map<String, dynamic>>[];
      
      // Safely parse recentResponses
      final recentResponses = data['recentResponses'] is List
          ? List<Map<String, dynamic>>.from(
              (data['recentResponses'] as List).map<Map<String, dynamic>>(
                (item) => item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{},
              ),
            )
          : <Map<String, dynamic>>[];
      
      print('✅ Successfully parsed performance data:');
      print('   - Overall: $overall');
      print('   - Subjects: ${bySubject.length}');
      print('   - Difficulty levels: ${byDifficulty.length}');
      print('   - Recent responses: ${recentResponses.length}');
      
      return PerformanceModel(
        overall: overall,
        bySubject: bySubject,
        byDifficulty: byDifficulty,
        recentResponses: recentResponses,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing PerformanceModel:');
      print('   - Error: $e');
      print('   - Stack trace: $stackTrace');
      print('   - JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'bySubject': bySubject,
      'byDifficulty': byDifficulty,
      'recentResponses': recentResponses,
    };
  }
}
