import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:orbirq/core/models/user_type.dart';
import 'package:orbirq/core/services/auth_service.dart';
import 'package:orbirq/features/question/domain/repositories/question_repository.dart';
import 'package:orbirq/features/question/domain/usecases/create_question.dart' show CreateQuestion;
import 'package:orbirq/core/services/api_service.dart';
import 'package:orbirq/core/theme/Colors.dart';
import 'package:orbirq/features/question/presentation/bloc/question_form_bloc.dart';
import 'package:orbirq/features/question/presentation/pages/question_form_page.dart';

// Use alias para evitar conflito:
import '../../models/home_item.dart' as home_item;
import '../../models/user_ultimo_acesso.dart' as user_ultimo_acesso;

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

import '../../widgets/home/ultimo_acesso_card.dart';
import '../../widgets/home/simulado_card.dart';
import '../../widgets/home/analise_desempenho_card.dart';
import '../../widgets/home/animated_section.dart';
import '../../widgets/home/quick_stats_card.dart';
import '../../widgets/home/streak_card.dart';
import '../../widgets/home/quick_actions_card.dart';

import 'package:hugeicons/hugeicons.dart';
import 'dart:convert'; // para base64Decode
import 'package:provider/provider.dart';

import '../../models/user_progress.dart';
import '../../models/user_simulado.dart';
import '../../models/user_analise_desempenho.dart';
import '../../features/performance/presentation/pages/performance_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  late final ApiService _apiService;
  List<user_ultimo_acesso.UserUltimoAcesso> _ultimosAcessos = [];
  UserSimulado? _simuladoNovo;
  UserAnaliseDesempenho? _analiseDesempenho;
  UserProgress? _userProgress;

  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  List<QuickAction> _quickActions = [];

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _initializeAnimations();
    _initializeQuickActions();
    
    // Trigger initial load after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
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

  void _initializeQuickActions() {
    try {
      // Safely get the AuthService instance
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Check if authService is properly initialized
      if (authService.userType == null && 
          authService.userData == null) {
        debugPrint('AuthService not properly initialized');
        _quickActions = [];
        return;
      }
      
      // Check user type from the auth service
      final isTeacher = authService.userType == UserType.professor || 
                       authService.userData?['user_type']?.toString().toLowerCase() == 'professor' ||
                       authService.userData?['userType']?.toString().toLowerCase() == 'professor';
      
      debugPrint('User type: ${authService.userType}');
      debugPrint('User data: ${authService.userData}');
      debugPrint('Is teacher: $isTeacher');
      
      _quickActions = [];
      
      // Only add 'Criar Questão' for teachers
      if (isTeacher) {
        _quickActions.add(
          QuickAction(
            title: 'Criar Questão',
            icon: Icons.add_circle,
            color: Colors.blue,
            onTap: _onNovaQuestao,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error initializing quick actions: $e');
      debugPrint('Stack trace: $stackTrace');
      _quickActions = [];
    }
    
    // Add other quick actions
    _quickActions.addAll([
      QuickAction(
        title: 'Meu Desempenho',
        icon: Icons.bar_chart,
        color: Colors.purple,
        onTap: _onMeuDesempenho,
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
    ]);
  }

  // Converter user_ultimo_acesso.UserUltimoAcesso para home_item.UserUltimoAcesso
  home_item.HomeItem converterParaHomeItem(
    user_ultimo_acesso.UserUltimoAcesso u,
  ) {
    return home_item.HomeItem(
      id: u.id.toString(),
      title: u.titulo,
      subtitle: u.disciplina ?? 'N/A',
      type: home_item.HomeItemType.ultimoAcesso,
      data: {
        'id': u.id,
        'titulo': u.titulo,
        'disciplina': u.disciplina,
        'progresso': u.progresso,
        'dataAcesso': u.dataAcesso?.toIso8601String() ?? DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _loadData({bool showLoading = true}) async {
    if (showLoading && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atualizando dados...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    // Prevent multiple simultaneous loads
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.userData?['id'] ?? 0;

    if (userId == 0) {
      debugPrint('Usuário não autenticado ou ID inválido.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado. Por favor, faça login novamente.')),
        );
      }
      return;
    }

    try {
      debugPrint('Iniciando carregamento de dados do usuário $userId...');
      
      // Carrega os dados em paralelo para melhor desempenho
      final responses = await Future.wait([
        _apiService.fetchUserProgress(userId),
        _apiService.fetchUserUltimosAcessos(userId),
        _apiService.fetchUserSimulados(userId),
        _apiService.fetchUserAnalisesDesempenho(userId),
      ]);

      final progressResponse = responses[0] as ApiResponse<UserProgress>;
      final ultimosResponse = responses[1] as ApiResponse<List<user_ultimo_acesso.UserUltimoAcesso>>;
      final simuladosResponse = responses[2] as ApiResponse<List<UserSimulado>>;
      final analisesResponse = responses[3] as ApiResponse<List<UserAnaliseDesempenho>>;

      if (!mounted) return;

      setState(() {
        // Atualiza o progresso do usuário
        if (progressResponse.success && progressResponse.data != null) {
          _userProgress = progressResponse.data!;
          debugPrint('Progresso carregado: $_userProgress');
        } else {
          debugPrint('Falha ao carregar progresso: ${progressResponse.error}');
        }

        // Atualiza últimos acessos
        if (ultimosResponse.success && ultimosResponse.data != null) {
          _ultimosAcessos = ultimosResponse.data!;
          debugPrint('${_ultimosAcessos.length} últimos acessos carregados');
          
          // Garante que tenha 2 itens para exibição
          while (_ultimosAcessos.length < 2) {
            _ultimosAcessos.add(
              user_ultimo_acesso.UserUltimoAcesso(
                id: -1 * (_ultimosAcessos.length + 1), // IDs negativos para itens mockados
                titulo: 'Sem acesso recente',
                disciplina: 'N/A',
                dataAcesso: DateTime.now().subtract(Duration(days: _ultimosAcessos.length + 1)),
                progresso: 0,
              ),
            );
          }
        } else {
          debugPrint('Falha ao carregar últimos acessos: ${ultimosResponse.error}');
        }

        // Atualiza simulados
        if (simuladosResponse.success && simuladosResponse.data != null) {
          if (simuladosResponse.data!.isNotEmpty) {
            _simuladoNovo = simuladosResponse.data!.firstWhere(
              (s) => s.isNovo,
              orElse: () => simuladosResponse.data!.first,
            );
            debugPrint('Simulado carregado: ${_simuladoNovo?.titulo}');
          } else {
            debugPrint('Nenhum simulado disponível');
          }
        } else {
          debugPrint('Falha ao carregar simulados: ${simuladosResponse.error}');
        }

        // Atualiza análises de desempenho
        if (analisesResponse.success && 
            analisesResponse.data != null && 
            analisesResponse.data!.isNotEmpty) {
          _analiseDesempenho = analisesResponse.data!.first;
          debugPrint('Análise de desempenho carregada: ${_analiseDesempenho?.titulo}');
        } else {
          debugPrint('Nenhuma análise de desempenho disponível: ${analisesResponse.error}');
        }
      });
    } catch (e, stackTrace) {
      debugPrint('Erro ao carregar dados do usuário: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao carregar dados. Verifique sua conexão e tente novamente.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            action: SnackBarAction(
              label: 'Tentar novamente',
              textColor: Colors.white,
              onPressed: () => _loadData(showLoading: false),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  // Getters para facilitar acesso às estatísticas
  int get totalQuestoes => _userProgress?.totalQuestoes ?? 0;
  int get acertos => _userProgress?.acertos ?? 0;
  double get mediaGeral => _userProgress?.mediaGeral ?? 0.0;
  int get diasEstudo => _userProgress?.diasEstudo ?? 0;

  int get diasSequencia => 0; // Ajustar quando backend enviar
  int get recordeSequencia => 0; // Ajustar quando backend enviar
  bool get hojeEstudou => false; // Ajustar quando backend enviar

  // Métodos onTap

  void _onUltimoAcessoTap(user_ultimo_acesso.UserUltimoAcesso ultimoAcesso) {
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
        content: const Text('Iniciando simulado...'),
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
        content: const Text('Abrindo análise de desempenho...'),
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

  void _onNovaQuestao() {
    final createQuestion = CreateQuestion(
      GetIt.I<QuestionRepository>(),
    );
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => QuestionFormBloc(
            createQuestion: createQuestion,
          ),
          child: const QuestionFormPage(),
        ),
      ),
    );
  }

  void _onMeusFavoritos() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Abrindo favoritos...'),
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
        content: const Text('Abrindo histórico...'),
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
        content: const Text('Abrindo configurações...'),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
    );
  }

  void _onMeuDesempenho() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.userData?['id'] ?? 0;
    final token = authService.token;
    
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado. Por favor, faça login novamente.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerformancePage(
          userId: userId,
          token: token,
        ),
      ),
    );
  }

  void _onFavoritos() {
    // TODO: Replace with actual favorites screen navigation
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const FavoritesScreen(),
    //   ),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tela de favoritos em desenvolvimento')),
    );
  }

  Future<void> _handleRefresh() async {
    await _loadData(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final fotoBase64 = authService.userData?['photoUrl'];

    ImageProvider profileImage;

    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
      try {
        final bytes = base64Decode(fotoBase64);
        profileImage = MemoryImage(bytes);
      } catch (_) {
        profileImage = AssetImage(AppStrings.avatar);
      }
    } else {
      profileImage = AssetImage(AppStrings.avatar);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primary,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header animado
              FadeTransition(
                opacity: _headerFadeAnimation,
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            HugeIcons.strokeRoundedMenu02,
                            size: 24,
                            color: const Color(0xFF475569),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Image.asset(AppStrings.logo, height: 28),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image(
                              image: profileImage,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Ações Rápidas
              AnimatedSection(
                title: 'Ações Rápidas',
                animationDelay: 200,
                child: QuickActionsCard(actions: _quickActions),
              ),
              const SizedBox(height: 24),

              // Estatísticas Rápidas
              AnimatedSection(
                title: 'Seu Progresso',
                animationDelay: 100,
                child: QuickStatsCard(
                  totalQuestoes: totalQuestoes,
                  acertos: acertos,
                  mediaGeral: mediaGeral,
                  diasEstudo: diasEstudo,
                ),
              ),
              const SizedBox(height: 24),

              // Sequência de Estudos
              AnimatedSection(
                title: 'Sequência de Estudos',
                animationDelay: 400,
                child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Iniciando sessão de estudo...'),
                    ),
                  ),
                  child: StreakCard(
                    diasSequencia: diasSequencia,
                    recordeSequencia: recordeSequencia,
                    hojeEstudou: hojeEstudou,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Últimos Acessos
              AnimatedSection(
                title: AppStrings.ultimosAcessos,
                onVerTodos: () => _onVerTodosTap('Últimos Acessos'),
                animationDelay: 500,
                child: Row(
                  children: [
                    Expanded(
                      child: _ultimosAcessos.isNotEmpty
                          ? GestureDetector(
                              onTap: () =>
                                  _onUltimoAcessoTap(_ultimosAcessos[0]),
                              child: UltimoAcessoCard(
                                ultimoAcesso: converterParaHomeItem(
                                  _ultimosAcessos[0],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ultimosAcessos.length > 1
                          ? GestureDetector(
                              onTap: () =>
                                  _onUltimoAcessoTap(_ultimosAcessos[1]),
                              child: UltimoAcessoCard(
                                ultimoAcesso: converterParaHomeItem(
                                  _ultimosAcessos[1],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Simulado Novo
              if (_simuladoNovo != null)
                AnimatedSection(
                  title: AppStrings.simuladosNovos,
                  onVerTodos: () => _onVerTodosTap('Simulados'),
                  animationDelay: 600,
                  child: GestureDetector(
                    onTap: _onSimuladoTap,
                    child: SimuladoCard(simulado: _simuladoNovo!),
                  ),
                ),
              const SizedBox(height: 24),

              // Análise de Desempenho
              if (_analiseDesempenho != null)
                AnimatedSection(
                  title: AppStrings.analiseDesempenho,
                  onVerTodos: () => _onVerTodosTap('Análise'),
                  animationDelay: 700,
                  child: GestureDetector(
                    onTap: _onAnaliseTap,
                    child: AnaliseDesempenhoCard(analise: _analiseDesempenho!),
                  ),
                ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    ),);
  }
}
