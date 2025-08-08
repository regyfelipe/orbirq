import 'package:flutter/material.dart';
import '../models/question.dart';
import 'question_option_widget.dart';

class QuestaoOptionsWidget extends StatelessWidget {
  final Question question;
  final int? selectedOptionIndex;
  final bool showAnswer;
  final Function(int) onOptionSelected;

  const QuestaoOptionsWidget({
    super.key,
    required this.question,
    required this.selectedOptionIndex,
    required this.showAnswer,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final optionLetter = option.letter;

        bool? isCorrect;
        if (showAnswer) {
          if (optionLetter == question.correctAnswer) {
            isCorrect = true;
          } else if (index == selectedOptionIndex) {
            isCorrect = false;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: QuestionOptionWidget(
            option: option.copyWith(
              isSelected: selectedOptionIndex == index,
              isCorrect: isCorrect,
            ),
            onTap: showAnswer ? null : () => onOptionSelected(index),
          ),
        );
      }),
    );
  }
}
