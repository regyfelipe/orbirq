import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../core/constants/app_sizes.dart';

class StreakCard extends StatelessWidget {
  final int diasSequencia;
  final int recordeSequencia;
  final bool hojeEstudou;
  final VoidCallback? onTap;

  const StreakCard({
    super.key,
    required this.diasSequencia,
    required this.recordeSequencia,
    this.hojeEstudou = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRecorde = diasSequencia == recordeSequencia && diasSequencia > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department_outlined,
                    color: Color(0xFF8B5CF6), size: 24),
                const SizedBox(width: AppSizes.sm),
                const Expanded(
                  child: Text(
                    'Sequência de Estudos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (isRecorde)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'RECORDE!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
        
                _buildInfoBlock(
                  label: 'Dias Seguidos',
                  value: '$diasSequencia',
                  isMain: true,
                ),
                const SizedBox(width: AppSizes.md),
                _buildInfoBlock(
                  label: 'Recorde',
                  value: '$recordeSequencia',
                  isMain: false,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Icon(
                  hojeEstudou ? Icons.check_circle : Icons.schedule,
                  size: 16,
                  color: hojeEstudou ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hojeEstudou
                        ? 'Parabéns! Você já estudou hoje!'
                        : 'Estude hoje para manter a sequência!',
                    style: TextStyle(
                      fontSize: 12,
                      color: hojeEstudou ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (!hojeEstudou) ...[
              const SizedBox(height: AppSizes.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                  ),
                  child: const Text(
                    'Estudar Agora',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock({
    required String value,
    required String label,
    required bool isMain,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isMain ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
