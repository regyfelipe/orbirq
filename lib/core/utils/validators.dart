import '../constants/app_strings.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordMinLength;
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }

    if (value != password) {
      return AppStrings.passwordsNotMatch;
    }

    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fullNameRequired;
    }

    if (value.trim().split(' ').length < 2) {
      return 'Digite seu nome completo';
    }

    return null;
  }

  static String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return null; // CPF é opcional
    }

    // Remove caracteres não numéricos
    final cpf = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) {
      return AppStrings.invalidCpf;
    }

    // Validação básica de CPF
    if (cpf == '00000000000' ||
        cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999') {
      return AppStrings.invalidCpf;
    }

    return null;
  }

  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateTerms(bool? value) {
    if (value != true) {
      return AppStrings.termsRequired;
    }
    return null;
  }

  static String? validateProfilePhoto(String? value, bool isRequired) {
    if (isRequired && (value == null || value.isEmpty)) {
      return AppStrings.profilePhotoRequired;
    }
    return null;
  }

  static String? validateMiniBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.miniBioRequired;
    }

    if (value.trim().length < 10) {
      return 'A mini bio deve ter pelo menos 10 caracteres';
    }

    return null;
  }

  static String? validateAreaOfExpertise(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.areaOfExpertiseRequired;
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL é opcional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }

    return null;
  }

  static String formatCpf(String cpf) {
    // Remove caracteres não numéricos
    final numbers = cpf.replaceAll(RegExp(r'[^\d]'), '');

    // Aplica máscara
    if (numbers.length <= 3) {
      return numbers;
    } else if (numbers.length <= 6) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3)}';
    } else if (numbers.length <= 9) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6)}';
    } else {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9, 11)}';
    }
  }
}
