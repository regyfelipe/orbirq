import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/features/questoes/screens/questao_screen.dart';
import 'home/home_screen.dart';
import 'simulados/simulados_screen.dart';
import 'grupos/grupos_screen.dart';
import 'perfil/perfil_screen.dart';
import '../widgets/navigation/custom_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const QuestaoScreen(),
    const SimuladosScreen(),
    const GruposScreen(),
    const PerfilScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
