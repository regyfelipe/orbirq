import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestaoAnswerWidget extends StatelessWidget {
  final Question question;
  final String selectedAnswerLetter;
  final bool isAnswerCorrect;
  final String mensagem;
  final bool showExplanation;
  final VoidCallback onToggleExplanation;

  const QuestaoAnswerWidget({
    super.key,
    required this.question,
    required this.selectedAnswerLetter,
    required this.isAnswerCorrect,
    required this.mensagem,
    required this.showExplanation,
    required this.onToggleExplanation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAnswerCorrect
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAnswerCorrect ? Colors.green : Colors.orange,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isAnswerCorrect ? Icons.celebration : Icons.psychology,
                    color: isAnswerCorrect ? Colors.green : Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mensagem,
                      style: TextStyle(
                        color: isAnswerCorrect ? Colors.green : Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAnswerCorrect
                        ? Colors.green.withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isAnswerCorrect ? Icons.check_circle : Icons.info,
                      color: isAnswerCorrect ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sua resposta: $selectedAnswerLetter',
                            style: TextStyle(
                              color: isAnswerCorrect
                                  ? Colors.green
                                  : Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Resposta correta: ${question.correctAnswer}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onToggleExplanation,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isAnswerCorrect
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                showExplanation ? Icons.remove : Icons.add,
                color: isAnswerCorrect ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                'Ver explicação',
                style: TextStyle(
                  color: isAnswerCorrect ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ),
        if (showExplanation)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAnswerCorrect
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explicação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.explanation ?? 'Explicação não disponível.',
                  style: const TextStyle(color: Colors.black87, height: 1.5),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
