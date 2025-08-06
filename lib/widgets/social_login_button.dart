import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onPressed;

  const SocialLoginButton({super.key, required this.iconPath, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        // color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.1),
          //   blurRadius: 4,
          //   offset: const Offset(0, 2),
          // ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(iconPath, width: 50, height: 50),
      ),
    );
  }
}
