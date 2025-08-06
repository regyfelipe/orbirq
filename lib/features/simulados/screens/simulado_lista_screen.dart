import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/simulado_controller.dart';
import '../widgets/simulado_card.dart';
import '../widgets/simulado_filtros_widget.dart';

class SimuladoListaScreen extends StatefulWidget {
  const SimuladoListaScreen({super.key});

  @override
  State<SimuladoListaScreen> createState() => _SimuladoListaScreenState();
}

class _SimuladoListaScreenState extends State<SimuladoListaScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final controller = context.read<SimuladoController>();
      controller.aplicarFiltros(busca: _searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.navSimulados,
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
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            context.read<SimuladoController>().refreshSimulados();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<SimuladoController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            _buildSearchBar(),
            _buildFiltros(),
            Expanded(child: _buildSimuladosList(controller)),
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
        decoration: InputDecoration(
          hintText: 'Buscar simulado...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
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

  Widget _buildFiltros() {
    return Consumer<SimuladoController>(
      builder: (context, controller, child) {
        return SimuladoFiltrosWidget(
          onFiltrosAplicados: (filtros) {
            controller.aplicarFiltros(
              disciplinas: filtros['disciplinas'],
              banca: filtros['banca'],
              ano: filtros['ano'],
              nivelDificuldade: filtros['nivelDificuldade'],
              isGratuito: filtros['isGratuito'],
              isNovo: filtros['isNovo'],
            );
          },
          onLimparFiltros: () {
            controller.limparFiltros();
          },
        );
      },
    );
  }

  Widget _buildSimuladosList(SimuladoController controller) {
    if (controller.isLoadingSimulados) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (controller.errorSimulados != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar simulados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorSimulados!,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.refreshSimulados(),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    final simulados = controller.simuladosFiltrados;

    if (simulados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum simulado encontrado',
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
      onRefresh: () => controller.refreshSimulados(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.lg),
        itemCount: simulados.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.lg),
        itemBuilder: (context, index) {
          final simulado = simulados[index];
          return SimuladoCard(
            simulado: simulado,
            onTap: () => _onSimuladoTap(simulado),
          );
        },
      ),
    );
  }

  void _onSimuladoTap(simulado) {
    // Navegar para a tela de detalhes do simulado
    Navigator.pushNamed(context, '/simulado-detalhes', arguments: simulado);
  }
}
