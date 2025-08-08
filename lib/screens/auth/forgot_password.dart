import 'package:flutter/material.dart';
import 'package:orbirq/core/services/auth_service.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      
    }
  }

  void _handleBackToLogin() {
    AppRoutes.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
  backgroundColor: AppColors.background,
  elevation: 0,
  iconTheme: const IconThemeData(
    color: AppColors.primaryLight,
  ),
),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppStrings.logo,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'OrbirQ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                if (_emailSent)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'E-mail enviado!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Verifique sua caixa de entrada e siga as instruções para recuperar sua senha.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textWhite,
                                minimumSize: const Size(double.infinity, 45),
                              ),
                              child: const Text(
                                'Voltar para login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Digite seu e-mail para receber um link de recuperação de senha',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          'E-mail',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'exemplo@gmail.com',
                            hintStyle: const TextStyle(color: AppColors.textDisabled),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite seu e-mail';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Digite um e-mail válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                authService.isLoading ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              foregroundColor: AppColors.textWhite,
                              disabledBackgroundColor: AppColors.disabled,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: authService.isLoading
                                ? const SizedBox(
                                    width: AppSizes.logoMedium,
                                    height: AppSizes.logoMedium,
                                    child: CircularProgressIndicator(
                                      color: AppColors.textWhite,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Enviar link',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Lembrou sua senha?',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Voltar para login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
