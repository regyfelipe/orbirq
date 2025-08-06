import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:orbirq/features/grupos/models/grupo.dart';
import 'package:orbirq/features/grupos/services/grupo_service.dart';

class GrupoController extends ChangeNotifier {
  // Estado dos grupos
  List<Grupo> _grupos = [];
  List<Grupo> _gruposFiltrados = [];
  Grupo? _grupoAtual;
  bool _isLoadingGrupos = false;
  String? _errorGrupos;

  // Estado dos membros
  List<MembroGrupo> _membros = [];
  bool _isLoadingMembros = false;
  String? _errorMembros;

  // Estado das mensagens
  List<MensagemGrupo> _mensagens = [];
  bool _isLoadingMensagens = false;
  String? _errorMensagens;
  bool _isEnviandoMensagem = false;

  // Estado do usuário atual
  final String _userId = 'user123'; // TODO: Obter do AuthService
  final String _nomeUsuario = 'Usuário Atual'; // TODO: Obter do AuthService

  // Filtros
  String _busca = '';
  List<String> _disciplinasFiltro = [];
  GrupoTipo? _tipoFiltro;
  bool? _requerAprovacaoFiltro;

  // Getters
  List<Grupo> get grupos => _grupos;
  List<Grupo> get gruposFiltrados => _gruposFiltrados;
  Grupo? get grupoAtual => _grupoAtual;
  bool get isLoadingGrupos => _isLoadingGrupos;
  String? get errorGrupos => _errorGrupos;

  List<MembroGrupo> get membros => _membros;
  bool get isLoadingMembros => _isLoadingMembros;
  String? get errorMembros => _errorMembros;

  List<MensagemGrupo> get mensagens => _mensagens;
  bool get isLoadingMensagens => _isLoadingMensagens;
  String? get errorMensagens => _errorMensagens;
  bool get isEnviandoMensagem => _isEnviandoMensagem;

  String get userId => _userId;
  String get nomeUsuario => _nomeUsuario;

  // Filtros
  String get busca => _busca;
  List<String> get disciplinasFiltro => _disciplinasFiltro;
  GrupoTipo? get tipoFiltro => _tipoFiltro;
  bool? get requerAprovacaoFiltro => _requerAprovacaoFiltro;

  // Computed
  bool get temGrupoAtual => _grupoAtual != null;
  bool get isMembroAtual => _membros.any(
    (m) => m.userId == _userId && m.status == MembroStatus.ativo,
  );
  bool get isAdminAtual =>
      _membros.any((m) => m.userId == _userId && m.tipo == MembroTipo.admin);
  bool get isModeradorAtual => _membros.any(
    (m) => m.userId == _userId && m.tipo == MembroTipo.moderador,
  );
  bool get podeEnviarMensagem =>
      isMembroAtual && (_grupoAtual?.permiteMensagens ?? false);

  GrupoController() {
    _carregarGrupos();
  }

  // Métodos para Grupos
  Future<void> _carregarGrupos() async {
    _setLoadingGrupos(true);
    _setErrorGrupos(null);

    try {
      final grupos = await GrupoService.getAllGrupos();
      _grupos = grupos;
      _aplicarFiltros();
    } catch (e) {
      _setErrorGrupos('Erro ao carregar grupos: $e');
    } finally {
      _setLoadingGrupos(false);
    }
  }

  Future<void> refreshGrupos() async {
    await _carregarGrupos();
  }

  Future<void> aplicarFiltros({
    String? busca,
    List<String>? disciplinas,
    GrupoTipo? tipo,
    bool? requerAprovacao,
  }) async {
    _busca = busca ?? _busca;
    _disciplinasFiltro = disciplinas ?? _disciplinasFiltro;
    _tipoFiltro = tipo ?? _tipoFiltro;
    _requerAprovacaoFiltro = requerAprovacao ?? _requerAprovacaoFiltro;

    _setLoadingGrupos(true);

    try {
      final grupos = await GrupoService.getGruposByFilter(
        busca: _busca,
        disciplinas: _disciplinasFiltro,
        tipo: _tipoFiltro,
        requerAprovacao: _requerAprovacaoFiltro,
      );
      _gruposFiltrados = grupos;
    } catch (e) {
      _setErrorGrupos('Erro ao aplicar filtros: $e');
    } finally {
      _setLoadingGrupos(false);
    }
  }

  void limparFiltros() {
    _busca = '';
    _disciplinasFiltro = [];
    _tipoFiltro = null;
    _requerAprovacaoFiltro = null;
    _gruposFiltrados = _grupos;
    notifyListeners();
  }

  Future<bool> entrarGrupo(String grupoId) async {
    try {
      final sucesso = await GrupoService.entrarGrupo(
        grupoId,
        _userId,
        _nomeUsuario,
      );
      if (sucesso) {
        await carregarGrupo(grupoId);
        await _carregarGrupos(); // Atualizar contadores
      }
      return sucesso;
    } catch (e) {
      _setErrorGrupos('Erro ao entrar no grupo: $e');
      return false;
    }
  }

  Future<bool> sairGrupo(String grupoId) async {
    try {
      final sucesso = await GrupoService.sairGrupo(grupoId, _userId);
      if (sucesso) {
        await carregarGrupo(grupoId);
        await _carregarGrupos(); // Atualizar contadores
      }
      return sucesso;
    } catch (e) {
      _setErrorGrupos('Erro ao sair do grupo: $e');
      return false;
    }
  }

  // Métodos para Grupo Atual
  Future<void> carregarGrupo(String grupoId) async {
    _setLoadingGrupos(true);
    _setErrorGrupos(null);

    try {
      final grupo = await GrupoService.getGrupoById(grupoId);
      if (grupo != null) {
        _grupoAtual = grupo;
        await _carregarMembros(grupoId);
        await _carregarMensagens(grupoId);
      } else {
        _setErrorGrupos('Grupo não encontrado');
      }
    } catch (e) {
      _setErrorGrupos('Erro ao carregar grupo: $e');
    } finally {
      _setLoadingGrupos(false);
    }
  }

  void limparGrupoAtual() {
    _grupoAtual = null;
    _membros = [];
    _mensagens = [];
    notifyListeners();
  }

  // Métodos para Membros
  Future<void> _carregarMembros(String grupoId) async {
    _setLoadingMembros(true);
    _setErrorMembros(null);

    try {
      final membros = await GrupoService.getMembrosGrupo(grupoId);
      _membros = membros;
    } catch (e) {
      _setErrorMembros('Erro ao carregar membros: $e');
    } finally {
      _setLoadingMembros(false);
    }
  }

  Future<bool> aprovarMembro(String userId) async {
    if (!isAdminAtual && !isModeradorAtual) return false;

    try {
      final sucesso = await GrupoService.aprovarMembro(_grupoAtual!.id, userId);
      if (sucesso) {
        await _carregarMembros(_grupoAtual!.id);
      }
      return sucesso;
    } catch (e) {
      _setErrorMembros('Erro ao aprovar membro: $e');
      return false;
    }
  }

  // Métodos para Mensagens
  Future<void> _carregarMensagens(String grupoId) async {
    _setLoadingMensagens(true);
    _setErrorMensagens(null);

    try {
      final mensagens = await GrupoService.getMensagensGrupo(grupoId);
      _mensagens = mensagens;
    } catch (e) {
      _setErrorMensagens('Erro ao carregar mensagens: $e');
    } finally {
      _setLoadingMensagens(false);
    }
  }

  Future<bool> enviarMensagem(String conteudo) async {
    if (!podeEnviarMensagem || _grupoAtual == null) return false;

    _setEnviandoMensagem(true);

    try {
      final mensagem = MensagemGrupo(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        grupoId: _grupoAtual!.id,
        autorId: _userId,
        autorNome: _nomeUsuario,
        conteudo: conteudo,
        tipo: 'texto',
        dataEnvio: DateTime.now(),
        editada: false,
        removida: false,
        curtidas: [],
      );

      final mensagemEnviada = await GrupoService.enviarMensagem(mensagem);
      if (mensagemEnviada != null) {
        _mensagens.add(mensagemEnviada);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setErrorMensagens('Erro ao enviar mensagem: $e');
      return false;
    } finally {
      _setEnviandoMensagem(false);
    }
  }

  Future<bool> editarMensagem(String mensagemId, String novoConteudo) async {
    try {
      final sucesso = await GrupoService.editarMensagem(
        mensagemId,
        novoConteudo,
      );
      if (sucesso) {
        final index = _mensagens.indexWhere((m) => m.id == mensagemId);
        if (index != -1) {
          _mensagens[index] = _mensagens[index].copyWith(
            conteudo: novoConteudo,
            dataEdicao: DateTime.now(),
            editada: true,
          );
          notifyListeners();
        }
      }
      return sucesso;
    } catch (e) {
      _setErrorMensagens('Erro ao editar mensagem: $e');
      return false;
    }
  }

  Future<bool> removerMensagem(String mensagemId) async {
    if (!isAdminAtual && !isModeradorAtual) return false;

    try {
      final sucesso = await GrupoService.removerMensagem(mensagemId);
      if (sucesso) {
        final index = _mensagens.indexWhere((m) => m.id == mensagemId);
        if (index != -1) {
          _mensagens[index] = _mensagens[index].copyWith(removida: true);
          notifyListeners();
        }
      }
      return sucesso;
    } catch (e) {
      _setErrorMensagens('Erro ao remover mensagem: $e');
      return false;
    }
  }

  Future<bool> curtirMensagem(String mensagemId) async {
    try {
      final sucesso = await GrupoService.curtirMensagem(mensagemId, _userId);
      if (sucesso) {
        final index = _mensagens.indexWhere((m) => m.id == mensagemId);
        if (index != -1) {
          final curtidas = List<String>.from(_mensagens[index].curtidas);
          if (curtidas.contains(_userId)) {
            curtidas.remove(_userId);
          } else {
            curtidas.add(_userId);
          }
          _mensagens[index] = _mensagens[index].copyWith(curtidas: curtidas);
          notifyListeners();
        }
      }
      return sucesso;
    } catch (e) {
      _setErrorMensagens('Erro ao curtir mensagem: $e');
      return false;
    }
  }

  // Métodos privados para atualizar estado
  void _setLoadingGrupos(bool loading) {
    _isLoadingGrupos = loading;
    notifyListeners();
  }

  void _setErrorGrupos(String? error) {
    _errorGrupos = error;
    notifyListeners();
  }

  void _setLoadingMembros(bool loading) {
    _isLoadingMembros = loading;
    notifyListeners();
  }

  void _setErrorMembros(String? error) {
    _errorMembros = error;
    notifyListeners();
  }

  void _setLoadingMensagens(bool loading) {
    _isLoadingMensagens = loading;
    notifyListeners();
  }

  void _setErrorMensagens(String? error) {
    _errorMensagens = error;
    notifyListeners();
  }

  void _setEnviandoMensagem(bool enviando) {
    _isEnviandoMensagem = enviando;
    notifyListeners();
  }

  void _aplicarFiltros() {
    _gruposFiltrados = _grupos;
    notifyListeners();
  }

}
