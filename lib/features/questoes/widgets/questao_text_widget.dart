import 'package:flutter/material.dart';
import '../models/question.dart';
import 'questao_supporting_text_widget.dart';
import 'questao_image_widget.dart';

class QuestaoTextWidget extends StatelessWidget {
  final Question question;

  const QuestaoTextWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texto de apoio (se existir)
        if (question.supportingText != null) ...[
          QuestaoSupportingTextWidget(supportingText: question.supportingText!),
        ],

        // Imagem (se existir)
        if (question.imageUrl != null) ...[
          QuestaoImageWidget(imageUrl: question.imageUrl!),
        ],

        // Pergunta principal
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
