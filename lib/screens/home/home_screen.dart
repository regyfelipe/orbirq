import 'package:flutter/material.dart';
import 'package:orbirq/core/theme/Colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/home_item.dart';
import '../../widgets/home/ultimo_acesso_card.dart';
import '../../widgets/home/simulado_card.dart';
import '../../widgets/home/analise_desempenho_card.dart';
import '../../widgets/home/animated_section.dart';
import '../../widgets/home/quick_stats_card.dart';
import '../../widgets/home/streak_card.dart';
import '../../widgets/home/quick_actions_card.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late List<UltimoAcesso> _ultimosAcessos;
  late Simulado _simuladoNovo;
  late AnaliseDesempenho _analiseDesempenho;
  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  // Dados para os novos cards
  late Map<String, dynamic> _userStats;
  late Map<String, dynamic> _dailyChallenge;
  late Map<String, dynamic> _streakData;
  late List<QuickAction> _quickActions;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  void _loadData() {
    // Dados simulados para demonstração
    _ultimosAcessos = [
      UltimoAcesso(
        id: '1',
        titulo: 'Direito Constitucional',
        disciplina: 'Direito',
        dataAcesso: DateTime.now().subtract(const Duration(hours: 2)),
        progresso: 75,
      ),
      UltimoAcesso(
        id: '2',
        titulo: 'Matemática Básica',
        disciplina: 'Matemática',
        dataAcesso: DateTime.now().subtract(const Duration(days: 1)),
        progresso: 45,
      ),
    ];

    _simuladoNovo = Simulado(
      id: '1',
      titulo: 'Simulado Completo PMCE 2024',
      descricao:
          'Teste seus conhecimentos com questões atualizadas do último concurso da Polícia Militar do Ceará.',
      totalQuestoes: 100,
      tempoMinutos: 180,
      isNovo: true,
    );

    _analiseDesempenho = AnaliseDesempenho(
      id: '1',
      titulo: 'Desempenho Geral',
      pontuacaoMedia: 7.8,
      totalQuestoes: 250,
      acertos: 195,
      disciplina: 'Todas as disciplinas',
    );

    // Dados para estatísticas rápidas
    _userStats = {
      'totalQuestoes': 1250,
      'acertos': 987,
      'mediaGeral': 8.2,
      'diasEstudo': 45,
    };

    // Dados para desafio diário
    _dailyChallenge = {
      'titulo': 'Desafio do Dia',
      'descricao': '10 questões de Direito Administrativo',
      'questoes': 10,
      'tempoMinutos': 15,
      'pontos': 50,
      'isCompleted': false,
    };

    // Dados para sequência de estudos
    _streakData = {
      'diasSequencia': 7,
      'recordeSequencia': 12,
      'hojeEstudou': false,
    };

    // Ações rápidas
    _quickActions = [
      QuickAction(
        title: 'Nova Questão',
        icon: Icons.add_circle,
        color: Colors.blue,
        onTap: _onNovaQuestao,
      ),
      QuickAction(
        title: 'Meus Favoritos',
        icon: Icons.favorite,
        color: Colors.red,
        onTap: _onMeusFavoritos,
      ),
      QuickAction(
        title: 'Histórico',
        icon: Icons.history,
        color: Colors.green,
        onTap: _onHistorico,
      ),
      QuickAction(
        title: 'Configurações',
        icon: Icons.settings,
        color: Colors.grey,
        onTap: _onConfiguracoes,
      ),
    ];
  }

  void _onUltimoAcessoTap(UltimoAcesso ultimoAcesso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continuando: ${ultimoAcesso.titulo}'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onSimuladoTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando simulado...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onAnaliseTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo análise de desempenho...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onVerTodosTap(String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ver todos: $section'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onDailyChallengeTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando desafio diário...'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onStreakTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando sessão de estudo...'),
        backgroundColor: Colors.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onNovaQuestao() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando para nova questão...'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onMeusFavoritos() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo favoritos...'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onHistorico() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo histórico...'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onConfiguracoes() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo configurações...'),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header animado
              FadeTransition(
                opacity: _headerFadeAnimation,
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: _buildHeader(),
                ),
              ),
              const SizedBox(height: 32),

              // Seção: Estatísticas Rápidas
              AnimatedSection(
                title: 'Seu Progresso',
                animationDelay: 100,
                child: QuickStatsCard(
                  totalQuestoes: _userStats['totalQuestoes'],
                  acertos: _userStats['acertos'],
                  mediaGeral: _userStats['mediaGeral'],
                  diasEstudo: _userStats['diasEstudo'],
                ),
              ),
              
              const SizedBox(height: 24),

              // Seção: Sequência de Estudos
              AnimatedSection(
                title: 'Sequência de Estudos',
                animationDelay: 400,
                child: GestureDetector(
                  onTap: _onStreakTap,
                  child: StreakCard(
                    diasSequencia: _streakData['diasSequencia'],
                    recordeSequencia: _streakData['recordeSequencia'],
                    hojeEstudou: _streakData['hojeEstudou'],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Seção: Últimos Acessos
              AnimatedSection(
                title: AppStrings.ultimosAcessos,
                onVerTodos: () => _onVerTodosTap('Últimos Acessos'),
                animationDelay: 500,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onUltimoAcessoTap(_ultimosAcessos[0]),
                        child: UltimoAcessoCard(
                          ultimoAcesso: _ultimosAcessos[0],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onUltimoAcessoTap(_ultimosAcessos[1]),
                        child: UltimoAcessoCard(
                          ultimoAcesso: _ultimosAcessos[1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Seção: Simulados Novos
              AnimatedSection(
                title: AppStrings.simuladosNovos,
                onVerTodos: () => _onVerTodosTap('Simulados'),
                animationDelay: 600,
                child: GestureDetector(
                  onTap: _onSimuladoTap,
                  child: SimuladoCard(simulado: _simuladoNovo),
                ),
              ),
              const SizedBox(height: 24),

              // Seção: Análise de Desempenho
              AnimatedSection(
                title: AppStrings.analiseDesempenho,
                onVerTodos: () => _onVerTodosTap('Análise'),
                animationDelay: 700,
                child: GestureDetector(
                  onTap: _onAnaliseTap,
                  child: AnaliseDesempenhoCard(analise: _analiseDesempenho),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Icon(
              HugeIcons.strokeRoundedMenu02,
              size: 24,
              color: const Color(0xFF475569),
            ),
          ),
          Expanded(
            child: Center(child: Image.asset(AppStrings.logo, height: 28)),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppStrings.avatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
