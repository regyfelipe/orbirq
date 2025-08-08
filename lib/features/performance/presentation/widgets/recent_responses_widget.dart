import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecentResponsesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> responses;

  const RecentResponsesWidget({
    Key? key,
    required this.responses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Respostas Recentes',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.history_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...responses
                .take(5)
                .map((response) => _buildResponseItem(context, response))
                .toList(),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildResponseItem(
      BuildContext context, Map<String, dynamic> response) {
    final isCorrect = response['is_correct'] == true ||
        response['is_correct'] == 'true' ||
        response['is_correct'] == 1;
    final date = DateTime.tryParse(response['created_at']?.toString() ?? '');
    final subject = response['subject']?.toString() ?? 'Sem matéria';
    final questionText = response['question_text']?.toString() ?? 'Questão';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionText.length > 50
                      ? '${questionText.substring(0, 50)}...'
                      : questionText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isCorrect ? 'Acertou' : 'Errou',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (date != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
