import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/Colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/error_utils.dart';
import '../../core/widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    debugPrint('\n=== TENTATIVA DE LOGIN INICIADA ===');
    
    if (!_formKey.currentState!.validate()) {
      debugPrint('Validação do formulário falhou');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    debugPrint('Email: $email');
    debugPrint('Senha: ${password.isNotEmpty ? '******' : 'vazia'}');
    
    setState(() => _isLoading = true);

    try {
      debugPrint('Iniciando processo de autenticação...');
      final authService = Provider.of<AuthService>(context, listen: false);
      
      debugPrint('Chamando authService.login()...');
      final success = await authService.login(email, password);
      
      debugPrint('\n=== RESULTADO DO LOGIN ===');
      debugPrint('Sucesso: $success');
      debugPrint('Erro: ${authService.error}');
      debugPrint('Tipo de usuário: ${authService.userType}');
      debugPrint('Nome do usuário: ${authService.userName}');
      debugPrint('ID do usuário: ${authService.userId}');
      debugPrint('Dados do usuário: ${authService.userData}');
      
      if (!mounted) {
        debugPrint('Widget não está mais montado, abortando...');
        return;
      }

      if (success) {
        debugPrint('Login bem-sucedido, verificando tipo de usuário...');
        if (authService.userType != null) {
          debugPrint('Navegando para a tela principal...');
          AppRoutes.pushNamedAndRemoveUntil(context, AppRoutes.main);
        } else {
          debugPrint('Tipo de usuário não definido');
          ErrorUtils.showErrorSnackBar(
            context,
            'Erro ao carregar informações do usuário',
          );
        }
      } else if (authService.error != null) {
        debugPrint('Erro durante o login: ${authService.error}');
        ErrorUtils.showErrorSnackBar(context, authService.error!);
      } else {
        debugPrint('Login falhou sem mensagem de erro específica');
        ErrorUtils.showErrorSnackBar(context, 'Falha no login. Tente novamente.');
      }
  } catch (e, stackTrace) {
    debugPrint('\n=== ERRO DURANTE O LOGIN ===');
    debugPrint('Tipo: ${e.runtimeType}');
    debugPrint('Mensagem: $e');
    debugPrint('Stack trace: $stackTrace');
    
    if (mounted) {
      final errorMessage = ErrorUtils.getFriendlyErrorMessage(e);
      debugPrint('Mensagem amigável: $errorMessage');
      
      ErrorUtils.showErrorSnackBar(
        context,
        errorMessage,
      );
    }
  } finally {
    debugPrint('Finalizando processo de login...');
    if (mounted) {
      setState(() => _isLoading = false);
    }
    debugPrint('=== FIM DO PROCESSO DE LOGIN ===\n');
  }
}



  void _handleForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.forgotPassword);
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login com Google em desenvolvimento'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

 

  void _handleSignUp() {
    Navigator.pushNamed(context, AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: 'Entrando...',
      child: Scaffold(
      backgroundColor: AppColors.background,
      // appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppStrings.logo,
                            width: 150,
                            height: 150,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text(
                                  'LOGO',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            hintStyle: const TextStyle(
                              color: AppColors.textDisabled,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            // suffixIcon: const Icon(Icons.visibility,
                            //     color: AppColors.textDisabled),
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
                        const SizedBox(height: 16),
                        const Text(
                          'Senha',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: '••••••••••',
                            hintStyle: const TextStyle(
                              color: AppColors.textDisabled,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite sua senha';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _handleForgotPassword();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              foregroundColor: AppColors.textWhite,
                              disabledBackgroundColor: AppColors.disabled,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.textWhite,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.divider,
                                  thickness: 0.3,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  'ou',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.divider,
                                  thickness: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                            label: const Text(
                              'Fazer login com o Google',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(
                                color: AppColors.divider,
                                width: 0.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Não tem uma conta?',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _handleSignUp();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Cadastre-se!',
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
        ),
      ),
    );
  }
}
