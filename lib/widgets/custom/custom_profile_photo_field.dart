import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';

class CustomProfilePhotoField extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onPhotoSelected;
  final String? Function(String?)? validator;
  final bool isRequired;

  const CustomProfilePhotoField({
    super.key,
    this.photoPath,
    required this.onPhotoSelected,
    this.validator,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.camera_alt, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              'Foto de perfil${isRequired ? ' *' : ' (opcional)'}',
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
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: onPhotoSelected,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: photoPath != null
                      ? AppColors.buttonColor
                      : Colors.grey,
                  width: 2,
                ),
              ),
              child: photoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(58),
                      child: Image.asset(
                        photoPath!,
                        fit: BoxFit.cover,
                        width: 116,
                        height: 116,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                        const SizedBox(height: 4),
                        Text(
                          'Adicionar foto',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (validator != null && photoPath == null && isRequired)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Center(
              child: Text(
                validator!(photoPath) ?? '',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
