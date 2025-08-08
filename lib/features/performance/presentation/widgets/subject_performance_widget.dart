import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubjectPerformanceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  const SubjectPerformanceWidget({
    Key? key,
    required this.subjects,
  }) : super(key: key);

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return 0.0;
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Log the raw input data
    print('📊 Raw subjects data: $subjects');
    
    // Process and sort subjects by accuracy
    final processedSubjects = subjects.map((subject) {
      try {
        print('Processing subject: $subject');
        final total = _parseInt(subject['total_responses']);
        final correct = _parseInt(subject['correct_responses']);
        
        // Ensure accuracy is always a double
        final accuracy = total > 0 ? (correct / total) * 100 : 0.0;
        
        // Create a new map with the processed values
        final result = {
          ...subject,
          'total_responses': total,
          'correct_responses': correct,
          'calculated_accuracy': accuracy.toDouble(), // Explicitly convert to double
          'subject': subject['subject']?.toString() ?? 'Sem matéria',
        };
        
        print('Processed subject data: $result');
        return result;
      } catch (e, stackTrace) {
        print('Error processing subject data: $e');
        print('Stack trace: $stackTrace');
        return {
          'subject': 'Erro',
          'total_responses': 0,
          'correct_responses': 0,
          'calculated_accuracy': 0.0,
        };
      }
    }).toList()
      ..sort((a, b) {
        try {
          final aAccuracy = _parseDouble(a['calculated_accuracy']);
          final bAccuracy = _parseDouble(b['calculated_accuracy']);
          return bAccuracy.compareTo(aAccuracy);
        } catch (e) {
          print('Error sorting subjects: $e');
          return 0;
        }
      });

    // Log the processed data
    print('📈 Processed subjects data:');
    for (var subject in processedSubjects) {
      print('   - Subject: ${subject['subject']}, ' 
            'Accuracy: ${subject['calculated_accuracy']} (${subject['calculated_accuracy'].runtimeType}), '
            'Total: ${subject['total_responses']}, '
            'Correct: ${subject['correct_responses']}');
    }
    
    // Ensure we have data to display
    if (processedSubjects.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Desempenho por Matéria',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Nenhum dado de desempenho disponível.'),
            ],
          ),
        ),
      );
    }
    
    // Group subjects by subject, then by topic
    final subjectGroups = <String, Map<String, List<Map<String, dynamic>>>>{};
    
    for (var subject in processedSubjects) {
      final subjectName = subject['subject']?.toString() ?? 'Sem matéria';
      final topics = subject['topics'] as Map<String, dynamic>? ?? {};
      
      if (!subjectGroups.containsKey(subjectName)) {
        subjectGroups[subjectName] = {};
      }
      
      // Process each topic for this subject
      topics.forEach((topicName, topicData) {
        if (topicData is Map<String, dynamic>) {
          final topicDisplayName = topicName == 'Sem tópico' ? 'Geral' : topicName;
          
          if (!subjectGroups[subjectName]!.containsKey(topicDisplayName)) {
            subjectGroups[subjectName]![topicDisplayName] = [];
          }
          
          // Add the topic data to the group
          subjectGroups[subjectName]![topicDisplayName]!.add({
            'topic': topicDisplayName,
            'total_responses': topicData['total_responses'] ?? 0,
            'correct_responses': topicData['correct_responses'] ?? 0,
            'accuracy': topicData['accuracy']?.toDouble() ?? 0.0,
          });
        }
      });
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Desempenho por Matéria e Assunto',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.analytics_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildSubjectList(context, subjectGroups),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  // Build subject list with topics
  List<Widget> _buildSubjectList(BuildContext context, Map<String, Map<String, List<Map<String, dynamic>>>> subjectGroups) {
    return subjectGroups.entries.expand((subjectEntry) {
      final subjectName = subjectEntry.key;
      final topics = subjectEntry.value;
      
      return [
        // Subject header
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.subject_rounded,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                subjectName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),
        ..._buildTopicList(topics),
        const SizedBox(height: 12),
      ];
    }).toList();
  }

  // Build topic list with performance data
  List<Widget> _buildTopicList(Map<String, List<Map<String, dynamic>>> topics) {
    return topics.entries.expand((topicEntry) {
      final topicName = topicEntry.key;
      final topicItems = topicEntry.value;
      
      return topicItems.map((topicData) {
        final accuracy = _parseDouble(topicData['accuracy']);
        final total = _parseInt(topicData['total_responses']);
        final correct = _parseInt(topicData['correct_responses']);
        
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topic and accuracy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            topicName,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getAccuracyColor(accuracy).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${accuracy.toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getAccuracyColor(accuracy),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: accuracy / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getAccuracyColor(accuracy),
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$correct de $total respostas',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${accuracy.toStringAsFixed(1)}% de acerto',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _getAccuracyColor(accuracy),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList();
    }).toList();
  }



  // Helper method to get color based on accuracy percentage
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 50) return Colors.orange;
    return Colors.red;
  }
}
