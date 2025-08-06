import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:orbirq/core/theme/Colors.dart';

class CustomCheckboxField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final String? Function(bool?)? validator;
  final VoidCallback? onTermsPressed;

  const CustomCheckboxField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.validator,
    this.onTermsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.buttonColor,
                checkColor: AppColors.textPrimary,
                side: const BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: label.split('Termos de Uso')[0]),
                      if (label.contains('Termos de Uso'))
                        TextSpan(
                          text: 'Termos de Uso e Política de Privacidade',
                          style: const TextStyle(
                            color: AppColors.buttonColor,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onTermsPressed,
                        ),
                      if (label.contains('LGPD'))
                        TextSpan(text: label.split('LGPD')[1]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (validator != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 32),
            child: Text(
              validator!(value) ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
