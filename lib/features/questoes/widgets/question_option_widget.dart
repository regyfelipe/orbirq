import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../../core/constants/app_sizes.dart';
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
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
    } else if (option.isCorrect == false) {
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red;
    } else if (option.isSelected) {
      backgroundColor = AppColors.buttonColor.withOpacity(0.1);
      borderColor = AppColors.buttonColor;
    } else {
      backgroundColor = Colors.white;
      borderColor = Colors.grey.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: option.isCorrect == true
                    ? Colors.green
                    : option.isCorrect == false
                    ? Colors.red
                    : option.isSelected
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
          ],
        ),
      ),
    );
  }
}
