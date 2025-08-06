import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../features/grupos/controllers/grupo_controller.dart';
import '../../features/grupos/widgets/grupo_card.dart';

class GruposScreen extends StatefulWidget {
  const GruposScreen({super.key});

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final controller = context.read<GrupoController>();
      controller.aplicarFiltros(busca: _searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GrupoController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.navGrupos,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      actions: [
        Consumer<GrupoController>(
          builder: (context, controller, child) {
            return IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => controller.refreshGrupos(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<GrupoController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildGruposList(controller)),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _onSearchChanged(),
        decoration: InputDecoration(
          hintText: 'Buscar grupos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildGruposList(GrupoController controller) {
    if (controller.isLoadingGrupos) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (controller.errorGrupos != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar grupos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorGrupos!,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.refreshGrupos(),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    final grupos = controller.gruposFiltrados;

    if (grupos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum grupo encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou buscar por outro termo',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshGrupos(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.lg),
        itemCount: grupos.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.lg),
        itemBuilder: (context, index) {
          final grupo = grupos[index];
          final isMembro = controller.membros.any(
            (m) => m.grupoId == grupo.id && m.userId == controller.userId,
          );

          return GrupoCard(
            grupo: grupo,
            isMembro: isMembro,
            onTap: () => _onGrupoTap(grupo),
            onEntrar: () => _onEntrarGrupo(controller, grupo),
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Implementar criação de grupo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
        );
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _onGrupoTap(grupo) {
    // TODO: Navegar para detalhes do grupo
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Abrindo: ${grupo.nome}')));
  }

  Future<void> _onEntrarGrupo(GrupoController controller, grupo) async {
    final sucesso = await controller.entrarGrupo(grupo.id);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entrou no grupo: ${grupo.nome}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao entrar no grupo: ${grupo.nome}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
