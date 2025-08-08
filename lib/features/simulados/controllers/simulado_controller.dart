import 'dart:async';
import 'package:flutter/material.dart';
import '../models/simulado.dart';
import '../services/simulado_service.dart';
import '../../../features/questoes/models/question.dart';

class SimuladoController extends ChangeNotifier {
  List<Simulado> _simulados = [];
  bool _isLoadingSimulados = false;
  String? _errorSimulados;
  SimuladoExecucao? _execucaoAtual;
  Simulado? _simuladoAtual;
  List<Question> _questoes = [];
  bool _isLoadingExecucao = false;
  String? _errorExecucao;
  Timer? _timer;

  String _filtroBusca = '';
  List<String> _filtroDisciplinas = [];
  String? _filtroBanca;
  int? _filtroAno;
  String? _filtroNivelDificuldade;
  bool? _filtroIsGratuito;
  bool? _filtroIsNovo;

  List<Simulado> get simulados => _simulados;
  bool get isLoadingSimulados => _isLoadingSimulados;
  String? get errorSimulados => _errorSimulados;

  SimuladoExecucao? get execucaoAtual => _execucaoAtual;
  Simulado? get simuladoAtual => _simuladoAtual;
  List<Question> get questoes => _questoes;
  bool get isLoadingExecucao => _isLoadingExecucao;
  String? get errorExecucao => _errorExecucao;

  String get filtroBusca => _filtroBusca;
  List<String> get filtroDisciplinas => _filtroDisciplinas;
  String? get filtroBanca => _filtroBanca;
  int? get filtroAno => _filtroAno;
  String? get filtroNivelDificuldade => _filtroNivelDificuldade;
  bool? get filtroIsGratuito => _filtroIsGratuito;
  bool? get filtroIsNovo => _filtroIsNovo;

  List<Simulado> get simuladosFiltrados {
    return _simulados.where((simulado) {
      if (_filtroBusca.isNotEmpty) {
        if (!simulado.titulo.toLowerCase().contains(
          _filtroBusca.toLowerCase(),
        )) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  bool get temExecucaoAtiva =>
      _execucaoAtual != null && _execucaoAtual!.isEmAndamento;
  bool get temExecucaoPausada =>
      _execucaoAtual != null && _execucaoAtual!.isPausado;
  bool get simuladoConcluido =>
      _execucaoAtual != null && _execucaoAtual!.isConcluido;

  SimuladoController() {
    _carregarSimulados();
  }
  Future<void> _carregarSimulados() async {
    _isLoadingSimulados = true;
    _errorSimulados = null;
    notifyListeners();

    try {
      _simulados = await SimuladoService.getAllSimulados();
    } catch (e) {
      _errorSimulados = 'Erro ao carregar simulados: $e';
    } finally {
      _isLoadingSimulados = false;
      notifyListeners();
    }
  }

  Future<void> aplicarFiltros({
    String? busca,
    List<String>? disciplinas,
    String? banca,
    int? ano,
    String? nivelDificuldade,
    bool? isGratuito,
    bool? isNovo,
  }) async {
    _filtroBusca = busca ?? _filtroBusca;
    _filtroDisciplinas = disciplinas ?? _filtroDisciplinas;
    _filtroBanca = banca ?? _filtroBanca;
    _filtroAno = ano ?? _filtroAno;
    _filtroNivelDificuldade = nivelDificuldade ?? _filtroNivelDificuldade;
    _filtroIsGratuito = isGratuito ?? _filtroIsGratuito;
    _filtroIsNovo = isNovo ?? _filtroIsNovo;

    _isLoadingSimulados = true;
    _errorSimulados = null;
    notifyListeners();

    try {
      _simulados = await SimuladoService.getSimuladosByFilter(
        titulo: _filtroBusca.isNotEmpty ? _filtroBusca : null,
        disciplinas: _filtroDisciplinas.isNotEmpty ? _filtroDisciplinas : null,
        banca: _filtroBanca,
        ano: _filtroAno,
        nivelDificuldade: _filtroNivelDificuldade,
        isGratuito: _filtroIsGratuito,
        isNovo: _filtroIsNovo,
      );
    } catch (e) {
      _errorSimulados = 'Erro ao aplicar filtros: $e';
    } finally {
      _isLoadingSimulados = false;
      notifyListeners();
    }
  }

  void limparFiltros() {
    _filtroBusca = '';
    _filtroDisciplinas = [];
    _filtroBanca = null;
    _filtroAno = null;
    _filtroNivelDificuldade = null;
    _filtroIsGratuito = null;
    _filtroIsNovo = null;
    _carregarSimulados();
  }

  Future<bool> iniciarSimulado(String simuladoId, String userId) async {
    _isLoadingExecucao = true;
    _errorExecucao = null;
    notifyListeners();

    try {
      final temAcesso = await SimuladoService.verificarAcessoSimulado(
        simuladoId,
        userId,
      );
      if (!temAcesso) {
        _errorExecucao = 'Você não tem acesso a este simulado';
        return false;
      }

      _execucaoAtual = await SimuladoService.iniciarSimulado(
        simuladoId,
        userId,
      );
      _simuladoAtual = await SimuladoService.getSimuladoById(simuladoId);

      _questoes = await SimuladoService.gerarQuestoesParaSimulado(simuladoId);

      _iniciarTimer();

      return true;
    } catch (e) {
      _errorExecucao = 'Erro ao iniciar simulado: $e';
      return false;
    } finally {
      _isLoadingExecucao = false;
      notifyListeners();
    }
  }

  Future<void> pausarSimulado() async {
    if (_execucaoAtual == null) return;

    try {
      _execucaoAtual = await SimuladoService.pausarSimulado(_execucaoAtual!.id);
      _pararTimer();
      notifyListeners();
    } catch (e) {
      _errorExecucao = 'Erro ao pausar simulado: $e';
      notifyListeners();
    }
  }

  Future<void> retomarSimulado() async {
    if (_execucaoAtual == null) return;

    try {
      _execucaoAtual = await SimuladoService.retomarSimulado(
        _execucaoAtual!.id,
      );
      _iniciarTimer();
      notifyListeners();
    } catch (e) {
      _errorExecucao = 'Erro ao retomar simulado: $e';
      notifyListeners();
    }
  }

  Future<void> finalizarSimulado() async {
    if (_execucaoAtual == null) return;

    try {
      _execucaoAtual = await SimuladoService.finalizarSimulado(
        _execucaoAtual!.id,
      );
      _pararTimer();
      notifyListeners();
    } catch (e) {
      _errorExecucao = 'Erro ao finalizar simulado: $e';
      notifyListeners();
    }
  }

  Future<void> responderQuestao(int questaoIndex, String resposta) async {
    if (_execucaoAtual == null || questaoIndex >= _questoes.length) return;

    final questao = _questoes[questaoIndex];
    final acertou = resposta == questao.correctAnswer;

    try {
      _execucaoAtual = await SimuladoService.responderQuestao(
        _execucaoAtual!.id,
        questaoIndex,
        resposta,
        acertou,
      );
      notifyListeners();
    } catch (e) {
      _errorExecucao = 'Erro ao responder questão: $e';
      notifyListeners();
    }
  }

  void _iniciarTimer() {
    _pararTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_execucaoAtual != null && _execucaoAtual!.isEmAndamento) {
        if (_execucaoAtual!.tempoRestante > 0) {
          _atualizarTempoRestante(_execucaoAtual!.tempoRestante - 1);
        } else {
          _pararTimer();
          finalizarSimulado();
        }
      }
    });
  }

  void _pararTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _atualizarTempoRestante(int tempoRestante) async {
    if (_execucaoAtual == null) return;

    try {
      _execucaoAtual = await SimuladoService.atualizarTempoRestante(
        _execucaoAtual!.id,
        tempoRestante,
      );
      notifyListeners();
    } catch (e) {
    }
  }

  void irParaQuestao(int index) {
    if (_execucaoAtual != null && index >= 0 && index < _questoes.length) {
      _execucaoAtual = _execucaoAtual!.copyWith(questaoAtual: index);
      notifyListeners();
    }
  }

  void proximaQuestao() {
    if (_execucaoAtual != null &&
        _execucaoAtual!.questaoAtual < _questoes.length - 1) {
      irParaQuestao(_execucaoAtual!.questaoAtual + 1);
    }
  }

  void questaoAnterior() {
    if (_execucaoAtual != null && _execucaoAtual!.questaoAtual > 0) {
      irParaQuestao(_execucaoAtual!.questaoAtual - 1);
    }
  }

  bool questaoRespondida(int index) {
    return _execucaoAtual?.respostas.containsKey(index) ?? false;
  }
  String? obterRespostaQuestao(int index) {
    return _execucaoAtual?.respostas[index];
  }

  bool questaoAcertada(int index) {
    return _execucaoAtual?.acertos[index] ?? false;
  }
  int get totalQuestoes => _questoes.length;
  int get questoesRespondidas => _execucaoAtual?.respostas.length ?? 0;
  int get questoesNaoRespondidas => totalQuestoes - questoesRespondidas;
  int get acertos =>
      _execucaoAtual?.acertos.values.where((acertou) => acertou).length ?? 0;
  int get erros =>
      _execucaoAtual?.acertos.values.where((acertou) => !acertou).length ?? 0;
  double get percentualConcluido =>
      totalQuestoes > 0 ? questoesRespondidas / totalQuestoes : 0.0;
  double get percentualAcertos =>
      questoesRespondidas > 0 ? acertos / questoesRespondidas : 0.0;

  void limparExecucaoAtual() {
    _pararTimer();
    _execucaoAtual = null;
    _simuladoAtual = null;
    _questoes = [];
    _errorExecucao = null;
    notifyListeners();
  }

  Future<void> refreshSimulados() async {
    await _carregarSimulados();
  }

  @override
  void dispose() {
    _pararTimer();
    super.dispose();
  }
}
