import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';

class QuestaoNavigationWidget extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onBackToList;

  const QuestaoNavigationWidget({
    super.key,
    this.onPrevious,
    this.onNext,
    required this.onBackToList,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onPrevious,
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryLight),
          label: const Text(
            'Anterior',
            style: TextStyle(color: AppColors.primaryLight),
          ),
        ),
        TextButton.icon(
          onPressed: onBackToList,
          icon: const Icon(Icons.list, color: AppColors.primaryLight),
          label: const Text(
            'Lista',
            style: TextStyle(color: AppColors.primaryLight),
          ),
        ),
        TextButton.icon(
          onPressed: onNext,
          icon: const Icon(Icons.arrow_forward, color: AppColors.primaryLight),
          label: const Text(
            'Próxima',
            style: TextStyle(color: AppColors.primaryLight),
          ),
        ),
      ],
    );
  }
}
