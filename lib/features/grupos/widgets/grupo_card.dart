import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/core/constants/app_sizes.dart';
import 'package:orbirq/features/grupos/models/grupo.dart';

class GrupoCard extends StatelessWidget {
  final Grupo grupo;
  final VoidCallback? onTap;
  final VoidCallback? onEntrar;
  final bool isMembro;

  const GrupoCard({
    super.key,
    required this.grupo,
    this.onTap,
    this.onEntrar,
    this.isMembro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSizes.md),
              _buildDescricao(),
              const SizedBox(height: AppSizes.md),
              _buildTags(),
              const SizedBox(height: AppSizes.md),
              _buildStats(),
              const SizedBox(height: AppSizes.md),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.group, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                grupo.nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildTipoChip(),
                  const SizedBox(width: AppSizes.sm),
                  if (grupo.requerAprovacao)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Aprovação',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipoChip() {
    Color color;
    String texto;
    IconData icon;

    switch (grupo.tipo) {
      case GrupoTipo.publico:
        color = Colors.green;
        texto = 'Público';
        icon = Icons.public;
        break;
      case GrupoTipo.privado:
        color = Colors.orange;
        texto = 'Privado';
        icon = Icons.lock;
        break;
      case GrupoTipo.restrito:
        color = Colors.red;
        texto = 'Restrito';
        icon = Icons.security;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescricao() {
    return Text(
      grupo.descricao,
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags() {
    if (grupo.tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSizes.xs,
      runSpacing: AppSizes.xs,
      children: grupo.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.people_outline,
          value: '${grupo.membrosAtivos}',
          label: 'membros',
        ),
        const SizedBox(width: AppSizes.lg),
        _buildStatItem(
          icon: Icons.school_outlined,
          value: '${grupo.disciplinas.length}',
          label: 'disciplinas',
        ),
        const SizedBox(width: AppSizes.lg),
        _buildStatItem(
          icon: Icons.calendar_today_outlined,
          value: _formatarData(grupo.dataCriacao),
          label: 'criado',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('Ver Detalhes'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        if (!isMembro)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onEntrar,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Entrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          )
        else
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEntrar,
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Membro'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays > 0) {
      return '${diferenca.inDays}d';
    } else if (diferenca.inHours > 0) {
      return '${diferenca.inHours}h';
    } else {
      return '${diferenca.inMinutes}m';
    }
  }
}
