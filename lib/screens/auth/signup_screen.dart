import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/core/services/auth_service.dart';
import 'package:orbirq/widgets/custom/PhotoPickerField.dart';
import 'package:orbirq/widgets/custom/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../core/models/user_type.dart';
import '../../widgets/custom/custom_button.dart';
import '../../widgets/custom/custom_link_text.dart';
import '../../widgets/custom/custom_checkbox_field.dart';
import '../../widgets/custom/custom_dropdown_field.dart';
import '../../widgets/custom/custom_date_picker_field.dart';
import '../../core/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _institutionController = TextEditingController();
  final _registrationNumberController = TextEditingController();

  final _cpfController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  final _miniBioController = TextEditingController();
  final _instagramOrWebsiteController = TextEditingController();
  final _proofDocumentController = TextEditingController();
  final _referralCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserType _selectedUserType = UserType.aluno;
  String? _selectedState;
  String? _selectedTargetExam;
  String? _selectedAreaOfExpertise;
  DateTime? _selectedBirthDate;
  String? _profilePhotoPath;

  bool _termsAccepted = false;
  bool _lgpdAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cpfController.dispose();
    _inviteCodeController.dispose();
    _miniBioController.dispose();
    _instagramOrWebsiteController.dispose();
    _proofDocumentController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      String? base64Image;
      if (_profilePhotoPath != null) {
        final bytes = await File(_profilePhotoPath!).readAsBytes();
        base64Image = base64Encode(bytes);
      }

      final success = await authService.signup(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userType: _selectedUserType,
        cpf: _cpfController.text.isNotEmpty ? _cpfController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        institution: _institutionController.text.isNotEmpty ? _institutionController.text : null,
        registrationNumber: _registrationNumberController.text.isNotEmpty ? _registrationNumberController.text : null,
        course: _selectedTargetExam,
        photoUrl: base64Image,
        miniBio: _selectedUserType == UserType.professor ? _miniBioController.text.trim() : null,
        instagramOrWebsite: _selectedUserType == UserType.professor ? _instagramOrWebsiteController.text.trim() : null,
        proofDocument: _selectedUserType == UserType.professor ? _proofDocumentController.text.trim() : null,
        referralCode: _selectedUserType == UserType.professor ? _referralCodeController.text.trim() : null,
      );
      print('Signup success: $success, error: ${authService.error}');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(AppStrings.signUpSuccess),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
              ),
            ),
          );

          AppRoutes.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authService.error ?? 'Erro desconhecido no cadastro',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro no cadastro: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
          ),
        );
      }
    }
  }
}

  void _handleBackToLogin() {
    AppRoutes.pop(context);
  }

  void _handlePhotoSelection() {
    setState(() {
      _profilePhotoPath = AppStrings.avatar;
    });
  }

  void _handleTermsPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          AppStrings.termsTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Aqui você pode adicionar os termos de uso e política de privacidade completos...',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Fechar',
              style: TextStyle(color: AppColors.buttonColor),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateConfirmPassword(String? value) {
    return Validators.validateConfirmPassword(value, _passwordController.text);
  }

  Widget _buildStudentFields() {
    return Column(
      children: [
        CustomTextField(
          label: AppStrings.cpfLabel,
          controller: _cpfController,
          prefixIcon: const Icon(Icons.badge),
          keyboardType: TextInputType.number,
          validator: Validators.validateCpf,
        ),
        SizedBox(height: AppSizes.lg),

        CustomDatePickerField(
          label: AppStrings.birthDateLabel,
          selectedDate: _selectedBirthDate,
          onDateSelected: (date) {
            setState(() {
              _selectedBirthDate = date;
            });
          },
        ),
        SizedBox(height: AppSizes.lg),

        CustomDropdownField(
          label: AppStrings.stateLabel,
          value: _selectedState,
          items: AppStrings.brazilianStates,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
            });
          },
        ),
        SizedBox(height: AppSizes.lg),

        CustomDropdownField(
          label: AppStrings.targetExamLabel,
          value: _selectedTargetExam,
          items: AppStrings.targetExams,
          onChanged: (value) {
            setState(() {
              _selectedTargetExam = value;
            });
          },
        ),
        SizedBox(height: AppSizes.lg),

        CustomTextField(
          label: AppStrings.inviteCodeLabel,
          controller: _inviteCodeController,
          prefixIcon: const Icon(Icons.card_giftcard),
        ),
        SizedBox(height: AppSizes.lg),
      ],
    );
  }

  Widget _buildTeacherFields() {
    return Column(
      children: [
        TextFormField(
          controller: _miniBioController,
          maxLines: 3,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: 'Mini Bio',
            labelStyle: TextStyle(color: Colors.black54),
            hintText: 'Fale um pouco sobre você',
            hintStyle: TextStyle(color: Colors.black38),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description, color: Colors.black54),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Campo obrigatório' : null,
        ),
        SizedBox(height: AppSizes.lg),

        DropdownButtonFormField<String>(
          value: _selectedAreaOfExpertise,
          decoration: InputDecoration(
            labelText: 'Área de Atuação',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items:
              [
                    'Matemática',
                    'Português',
                    'Física',
                    'Química',
                    'Biologia',
                    'História',
                    'Geografia',
                    'Filosofia',
                    'Sociologia',
                    'Inglês',
                    'Espanhol',
                    'Educação Física',
                    'Artes',
                  ]
                  .map(
                    (area) => DropdownMenuItem(value: area, child: Text(area)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedAreaOfExpertise = value;
            });
          },
          validator: (value) =>
              value == null ? 'Selecione uma área de atuação' : null,
        ),
        SizedBox(height: AppSizes.lg),

        TextFormField(
          controller: _instagramOrWebsiteController,
          decoration: InputDecoration(
            labelText: 'Instagram ou site (opcional)',
            hintText: 'www.exemplo.com ou @usuario',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.link),
          ),
          keyboardType: TextInputType.url,
        ),
        SizedBox(height: AppSizes.lg),

        CustomTextField(
          label: AppStrings.proofDocumentLabel,
          controller: _proofDocumentController,
          prefixIcon: const Icon(Icons.upload_file),
          maxLines: 2,
          hint: AppStrings.proofDocumentHint,
        ),
        SizedBox(height: AppSizes.lg),

        // Código de indicação (opcional)
        CustomTextField(
          label: AppStrings.referralCodeLabel,
          controller: _referralCodeController,
          prefixIcon: const Icon(Icons.person_add),
          hint: AppStrings.referralCodeHint,
        ),
        SizedBox(height: AppSizes.lg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: _handleBackToLogin,
        ),
        title: const Text(AppStrings.signUpTitle),
        backgroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo de conta
                      Text(
                        AppStrings.accountTypeLabel,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.md),

                      DropdownButtonFormField<UserType>(
                        items: UserType.values.map((type) {
                          return DropdownMenuItem<UserType>(
                            value: type,
                            child: Text(type.label),
                          );
                        }).toList(),
                        value: _selectedUserType,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedUserType = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppStrings.accountTypeLabel,
                        ),
                      ),
                      SizedBox(height: AppSizes.xl),

                      // Foto de perfil
                      CustomPhotoPickerField(
                        photoPath: _profilePhotoPath,
                        onPhotoSelected: (path) {
                          setState(() {
                            _profilePhotoPath = path;
                          });
                        },
                        isRequired: _selectedUserType == UserType.professor,
                        validator: (value) => Validators.validateProfilePhoto(
                          value,
                          _selectedUserType == UserType.professor,
                        ),
                      ),

                      SizedBox(height: AppSizes.xl),

                      // Campos comuns
                      CustomTextField(
                        label: AppStrings.fullNameLabel,
                        controller: _fullNameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: Validators.validateFullName,
                      ),
                      SizedBox(height: AppSizes.lg),

                      CustomTextField(
                        label: AppStrings.emailLabel,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        validator: Validators.validateEmail,
                      ),
                      SizedBox(height: AppSizes.lg),

                      CustomTextField(
                        label: AppStrings.passwordLabel,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: Validators.validatePassword,
                      ),
                      SizedBox(height: AppSizes.lg),

                      CustomTextField(
                        label: AppStrings.confirmPasswordLabel,
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      SizedBox(height: AppSizes.xl),

                      // Campos específicos por tipo de usuário
                      if (_selectedUserType == UserType.aluno)
                        _buildStudentFields(),
                      if (_selectedUserType == UserType.professor)
                        _buildTeacherFields(),

                      SizedBox(height: AppSizes.xl),

                      // Termos e LGPD
                      CustomCheckboxField(
                        key: const ValueKey('terms_checkbox'),
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        label: AppStrings.termsText,
                        validator: Validators.validateTerms,
                        onTermsPressed: _handleTermsPressed,
                      ),
                      const SizedBox(height: AppSizes.md),

                      CustomCheckboxField(
                        key: const ValueKey('lgpd_checkbox'),
                        value: _lgpdAccepted,
                        onChanged: (value) {
                          setState(() {
                            _lgpdAccepted = value ?? false;
                          });
                        },
                        label: AppStrings.lgpdText,
                        validator: Validators.validateTerms,
                      ),
                      SizedBox(height: AppSizes.xxl),

                      // Botão de cadastro
                      CustomButton(
                        text: AppStrings.signUpButton,
                        onPressed: _handleSignUp,
                        isLoading: _isLoading,
                        backgroundColor: AppColors.primaryLight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer fixo
            Container(
              width: double.infinity,
              color: AppColors.textPrimary,
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Center(
                child: CustomLinkText(
                  text: 'Já tem conta? ',
                  linkText: AppStrings.clickHere,
                  onPressed: _handleBackToLogin,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
