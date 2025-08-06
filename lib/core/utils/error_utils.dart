import 'package:flutter/material.dart';

class ErrorUtils {
  static void showErrorSnackBar(BuildContext context, String message) {
    if (message.isEmpty) return;
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static String getFriendlyErrorMessage(dynamic error) {
    if (error is String) return error;
    
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('connection') || errorStr.contains('internet')) {
      return 'Erro de conexão. Verifique sua internet e tente novamente.';
    } else if (errorStr.contains('timeout')) {
      return 'Tempo de conexão esgotado. Tente novamente mais tarde.';
    } else if (errorStr.contains('email') && errorStr.contains('already in use')) {
      return 'Este e-mail já está em uso.';
    } else if (errorStr.contains('invalid email') || errorStr.contains('user not found')) {
      return 'E-mail ou senha inválidos.';
    } else if (errorStr.contains('invalid password')) {
      return 'Senha incorreta.';
    } else if (errorStr.contains('too many requests')) {
      return 'Muitas tentativas. Tente novamente mais tarde.';
    }
    
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}
