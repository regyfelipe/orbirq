import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../core/constants/app_sizes.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool isRequired;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
  filled: true,
  fillColor: Colors.white.withOpacity(0.1),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.radius),
    borderSide: const BorderSide(color: Colors.black, width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.radius),
    borderSide: const BorderSide(color: Colors.black, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.radius),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.radius),
    borderSide: const BorderSide(color: Colors.red, width: 2),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  ),
),

          dropdownColor: AppColors.textPrimary,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: AppColors.buttonColor)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
