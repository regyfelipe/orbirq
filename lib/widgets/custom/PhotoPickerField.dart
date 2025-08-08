import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbirq/core/theme/Colors.dart';

class CustomPhotoPickerField extends StatefulWidget {
  final String? photoPath;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Function(String?) onPhotoSelected;

  const CustomPhotoPickerField({
    super.key,
    this.photoPath,
    required this.onPhotoSelected,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<CustomPhotoPickerField> createState() => _CustomPhotoPickerFieldState();
}

class _CustomPhotoPickerFieldState extends State<CustomPhotoPickerField> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.photoPath != null) {
      _imageFile = File(widget.photoPath!);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onPhotoSelected(pickedFile.path);
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancelar'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  String? _validate() {
    if (widget.isRequired && (_imageFile == null && widget.photoPath == null)) {
      return 'Selecione uma foto';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = (_imageFile != null || widget.photoPath != null)
        ? AppColors.buttonColor
        : Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.camera_alt, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              'Foto de perfil${widget.isRequired ? ' *' : ' (opcional)'}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.isRequired)
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
            onTap: _showPickerOptions,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: (_imageFile != null)
    ? ClipRRect(
        borderRadius: BorderRadius.circular(58),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          width: 116,
          height: 116,
        ),
      )
    : (widget.photoPath != null && widget.photoPath!.startsWith('http'))
        ? ClipRRect(
            borderRadius: BorderRadius.circular(58),
            child: Image.network(
              widget.photoPath!,
              fit: BoxFit.cover,
              width: 116,
              height: 116,
            ),
          )
        : (widget.photoPath != null)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(58),
                child: Image.file(
                  File(widget.photoPath!),
                  fit: BoxFit.cover,
                  width: 116,
                  height: 116,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                  SizedBox(height: 4),
                  Text(
                    'Adicionar foto',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

            ),
          ),
        ),
        if (widget.validator != null && _validate() != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Center(
              child: Text(
                widget.validator!(widget.photoPath ?? '') ?? '',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
