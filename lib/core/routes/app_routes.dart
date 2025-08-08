import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/features/questoes/screens/questao_screen.dart';
import 'package:orbirq/features/simulados/screens/simulado_execucao_screen.dart';
import 'package:orbirq/features/simulados/controllers/simulado_controller.dart';
import '../../screens/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password.dart';
import '../../screens/main_screen.dart';

class AppRoutes {
  // Nomes das rotas
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String questions = '/questions';
  static const String main = '/main';
  static const String simuladoExecucao = '/simulado-execucao';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      questions: (context) => const QuestaoScreen(),
      main: (context) => const MainScreen(),
      simuladoExecucao: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        return ChangeNotifierProvider(
          create: (_) => SimuladoController(),
          child: SimuladoExecucaoScreen(
            simuladoId: args?['simuladoId'] ?? '',
            userId: args?['userId'] ?? '',
          ),
        );
      },
    };
  }

  static String get initialRoute => splash;

  static Future<dynamic> pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
}
