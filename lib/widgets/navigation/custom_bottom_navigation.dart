import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import 'package:hugeicons/hugeicons.dart';


class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: HugeIcons.strokeRoundedHome02,
                activeIcon: HugeIcons.strokeRoundedHome02,
                label: AppStrings.navHome,
                index: 0,
              ),
              _buildNavItem(
                icon: HugeIcons.strokeRoundedQuiz01,
                activeIcon: HugeIcons.strokeRoundedQuiz01,
                label: AppStrings.navQuestoes,
                index: 1,
              ),
              _buildNavItem(
                icon: HugeIcons.strokeRoundedAssignments,
                activeIcon: HugeIcons.strokeRoundedAssignments,
                label: AppStrings.navSimulados,
                index: 2,
              ),
              _buildNavItem(
                icon: HugeIcons.strokeRoundedGroup01,
                activeIcon: HugeIcons.strokeRoundedGroup01,
                label: AppStrings.navGrupos,
                index: 3,
              ),
              _buildNavItem(
                icon: HugeIcons.strokeRoundedProfile,
                activeIcon: HugeIcons.strokeRoundedProfile,
                label: AppStrings.navPerfil,
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : Colors.grey[600],
              size: 24,
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : Colors.grey[600],
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
