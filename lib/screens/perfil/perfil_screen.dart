import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/auth_service.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final nomeUsuario = authService.userName ?? 'Usuário';
    final emailUsuario = authService.userData?['email'] ?? 'email@exemplo.com';
    final fotoUrl = authService.userData?['photoUrl'] ??
        "https://i.pravatar.cc/150?img=12";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.navPerfil,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.lg),

            // Avatar com borda e sombra
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: NetworkImage(fotoUrl),
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Nome destacado
            Text(
              nomeUsuario,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 6),

            // Email menor, com ícone e cor suave
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  emailUsuario,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.xl),

            // Cards com informações extras (exemplo: usuário, tipo, etc)
            Card(
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
              ),
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.badge_outlined, color: AppColors.primary),
                title: const Text(
                  'Tipo de usuário',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  authService.userType?.name ?? 'Desconhecido',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // Botão editar perfil estilizado com ícone
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar perfil clicado')),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text(
                  'Editar Perfil',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // Botão logout com estilo mais moderno e ícone
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppStrings.loginRoute,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text(
                  'Sair',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
