import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:orbirq/core/theme/Colors.dart';

class CustomLinkText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  const CustomLinkText({
    super.key,
    required this.text,
    required this.linkText,
    this.onPressed,
    this.textStyle,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 14),
        children: [
          TextSpan(text: text),
          TextSpan(
            text: linkText,
            style:
                linkStyle ??
                const TextStyle(
                  color: AppColors.linkColor,
                  fontWeight: FontWeight.w600,
                ),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
          ),
        ],
      ),
    );
  }
}
