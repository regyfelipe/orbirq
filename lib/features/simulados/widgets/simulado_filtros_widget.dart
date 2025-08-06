import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../../core/constants/app_sizes.dart';

class SimuladoFiltrosWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltrosAplicados;
  final VoidCallback onLimparFiltros;

  const SimuladoFiltrosWidget({
    super.key,
    required this.onFiltrosAplicados,
    required this.onLimparFiltros,
  });

  @override
  State<SimuladoFiltrosWidget> createState() => _SimuladoFiltrosWidgetState();
}

class _SimuladoFiltrosWidgetState extends State<SimuladoFiltrosWidget> {
  bool _showFiltros = false;

  // Filtros
  final List<String> _disciplinasSelecionadas = [];
  String? _bancaSelecionada;
  int? _anoSelecionado;
  String? _nivelDificuldadeSelecionado;
  bool? _isGratuito;
  bool? _isNovo;

  // Opções disponíveis
  final List<String> _disciplinas = [
    'Português',
    'Matemática',
    'Raciocínio Lógico',
    'Direito Constitucional',
    'Direito Administrativo',
    'Direito Penal',
    'Direito Civil',
    'Direito Processual',
    'Direito Tributário',
    'Direito do Trabalho',
    'Direito Previdenciário',
    'Informática',
    'Atualidades',
    'Física',
    'Legislação',
  ];

  final List<String> _bancas = [
    'CESPE',
    'FGV',
    'VUNESP',
    'FEPESE',
    'IADES',
    'Várias',
  ];

  final List<int> _anos = [2025, 2024, 2023, 2022, 2021, 2020];

  final List<String> _niveisDificuldade = ['Fácil', 'Médio', 'Difícil'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFiltrosToggle(),
        if (_showFiltros) _buildFiltrosContent(),
      ],
    );
  }

  Widget _buildFiltrosToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _showFiltros ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _showFiltros = !_showFiltros;
              });
            },
          ),
          const Text(
            'Filtros',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          if (_temFiltrosAtivos)
            TextButton(
              onPressed: _limparFiltros,
              child: const Text(
                'Limpar',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFiltrosContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.md),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDisciplinasFilter(),
          const SizedBox(height: AppSizes.md),
          _buildBancaFilter(),
          const SizedBox(height: AppSizes.md),
          _buildAnoFilter(),
          const SizedBox(height: AppSizes.md),
          _buildNivelDificuldadeFilter(),
          const SizedBox(height: AppSizes.md),
          _buildOpcoesFilter(),
          const SizedBox(height: AppSizes.md),
          _buildBotoesAcao(),
        ],
      ),
    );
  }

  Widget _buildDisciplinasFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Disciplinas',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _disciplinas.map((disciplina) {
            final isSelected = _disciplinasSelecionadas.contains(disciplina);
            return FilterChip(
              label: Text(disciplina),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _disciplinasSelecionadas.add(disciplina);
                  } else {
                    _disciplinasSelecionadas.remove(disciplina);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBancaFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Banca',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _bancaSelecionada,
          decoration: const InputDecoration(
            hintText: 'Selecione a banca',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Todas as bancas'),
            ),
            ..._bancas.map((banca) {
              return DropdownMenuItem<String>(value: banca, child: Text(banca));
            }),
          ],
          onChanged: (value) {
            setState(() {
              _bancaSelecionada = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAnoFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ano',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _anoSelecionado,
          decoration: const InputDecoration(
            hintText: 'Selecione o ano',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text('Todos os anos'),
            ),
            ..._anos.map((ano) {
              return DropdownMenuItem<int>(
                value: ano,
                child: Text(ano.toString()),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _anoSelecionado = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNivelDificuldadeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nível de Dificuldade',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _nivelDificuldadeSelecionado,
          decoration: const InputDecoration(
            hintText: 'Selecione o nível',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Todos os níveis'),
            ),
            ..._niveisDificuldade.map((nivel) {
              return DropdownMenuItem<String>(value: nivel, child: Text(nivel));
            }),
          ],
          onChanged: (value) {
            setState(() {
              _nivelDificuldadeSelecionado = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildOpcoesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opções',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Gratuitos'),
                value: _isGratuito,
                tristate: true,
                onChanged: (value) {
                  setState(() {
                    _isGratuito = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Novos'),
                value: _isNovo,
                tristate: true,
                onChanged: (value) {
                  setState(() {
                    _isNovo = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBotoesAcao() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _limparFiltros,
            child: const Text('Limpar'),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: ElevatedButton(
            onPressed: _aplicarFiltros,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Aplicar'),
          ),
        ),
      ],
    );
  }

  bool get _temFiltrosAtivos {
    return _disciplinasSelecionadas.isNotEmpty ||
        _bancaSelecionada != null ||
        _anoSelecionado != null ||
        _nivelDificuldadeSelecionado != null ||
        _isGratuito != null ||
        _isNovo != null;
  }

  void _aplicarFiltros() {
    final filtros = <String, dynamic>{
      'disciplinas': _disciplinasSelecionadas.isNotEmpty
          ? _disciplinasSelecionadas
          : null,
      'banca': _bancaSelecionada,
      'ano': _anoSelecionado,
      'nivelDificuldade': _nivelDificuldadeSelecionado,
      'isGratuito': _isGratuito,
      'isNovo': _isNovo,
    };

    widget.onFiltrosAplicados(filtros);
    setState(() {
      _showFiltros = false;
    });
  }

  void _limparFiltros() {
    setState(() {
      _disciplinasSelecionadas.clear();
      _bancaSelecionada = null;
      _anoSelecionado = null;
      _nivelDificuldadeSelecionado = null;
      _isGratuito = null;
      _isNovo = null;
    });

    widget.onLimparFiltros();
  }
}
