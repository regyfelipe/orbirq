import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/question.dart';

class QuestionOptionWidget extends StatelessWidget {
  final QuestionOption option;
  final VoidCallback? onTap;

  const QuestionOptionWidget({super.key, required this.option, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;

    if (option.isCorrect == true) {
      // Resposta correta
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
    } else if (option.isCorrect == false) {
      // Resposta incorreta (apenas quando o usuário selecionou uma opção errada)
      borderColor = Colors.grey.withOpacity(0.3);
    } else if (option.isSelected) {
      // Opção selecionada (antes de mostrar resposta)
      backgroundColor = AppColors.buttonColor.withOpacity(0.1);
      borderColor = AppColors.buttonColor;
    } else {
      // Estado normal (não selecionada)
      backgroundColor = Colors.white;
      borderColor = Colors.grey.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Círculo com letra
            Container(
              width: 32,
              height: 50,
              decoration: BoxDecoration(
                color: option.isSelected || option.isCorrect == true
                    ? AppColors.buttonColor
                    : Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  option.letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.md),
            // Texto da opção
            Expanded(
              child: Text(
                option.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            // Ícone de status (apenas quando há resposta e é a opção selecionada ou correta)
            if ((option.isSelected || option.isCorrect == true)) ...[
              SizedBox(width: AppSizes.sm),
              // Icon(
              //   option.isCorrect ? Icons.check_circle : Icons.cancel,
              //   color: option.isCorrect ? Colors.green : Colors.red,
              //   size: 20,
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
