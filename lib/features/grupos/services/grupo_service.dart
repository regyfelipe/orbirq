import 'dart:async';
import 'package:orbirq/features/grupos/models/grupo.dart';

class GrupoService {
  // Dados mockados para demonstração
  static final List<Grupo> _grupos = [
    Grupo(
      id: 'grupo1',
      nome: 'Concurseiros PF 2027',
      descricao: 'Grupo focado em dicas e materiais para PF.',
      descricaoCompleta:
          'Grupo dedicado aos candidatos que estão se preparando para o concurso da Polícia Federal 2027. Compartilhamos materiais, dicas, simulados e experiências.',
      tipo: GrupoTipo.publico,
      status: GrupoStatus.ativo,
      disciplinas: [
        'Direito Constitucional',
        'Direito Penal',
        'Direito Processual Penal',
      ],
      tags: ['PF', 'concurso', 'direito', 'estudo'],
      maxMembros: 500,
      membrosAtivos: 120,
      criadorId: 'admin1',
      dataCriacao: DateTime.now().subtract(const Duration(days: 30)),
      permiteMensagens: true,
      permiteArquivos: true,
      requerAprovacao: false,
      regras:
          '1. Respeite todos os membros\n2. Não compartilhe conteúdo inadequado\n3. Mantenha o foco nos estudos',
    ),
    Grupo(
      id: 'grupo2',
      nome: 'Estudos PRF Intensivo',
      descricao: 'Discussões e simulados da PRF.',
      descricaoCompleta:
          'Grupo intensivo para candidatos da PRF. Foco em simulados, resolução de questões e troca de experiências.',
      tipo: GrupoTipo.publico,
      status: GrupoStatus.ativo,
      disciplinas: ['Física', 'Legislação', 'Português'],
      tags: ['PRF', 'física', 'legislação'],
      maxMembros: 300,
      membrosAtivos: 85,
      criadorId: 'admin2',
      dataCriacao: DateTime.now().subtract(const Duration(days: 45)),
      permiteMensagens: true,
      permiteArquivos: true,
      requerAprovacao: true,
    ),
    Grupo(
      id: 'grupo3',
      nome: 'Redação e Atualidades',
      descricao: 'Ajuda e troca de ideias para redação.',
      descricaoCompleta:
          'Grupo especializado em redação para concursos. Compartilhamos temas, correções e dicas de atualidades.',
      tipo: GrupoTipo.publico,
      status: GrupoStatus.ativo,
      disciplinas: ['Redação', 'Atualidades', 'Português'],
      tags: ['redação', 'atualidades', 'português'],
      maxMembros: 200,
      membrosAtivos: 55,
      criadorId: 'admin3',
      dataCriacao: DateTime.now().subtract(const Duration(days: 15)),
      permiteMensagens: true,
      permiteArquivos: false,
      requerAprovacao: false,
    ),
  ];

  static final Map<String, List<MembroGrupo>> _membros = {
    'grupo1': [
      MembroGrupo(
        id: 'membro1',
        grupoId: 'grupo1',
        userId: 'admin1',
        nomeUsuario: 'João Silva',
        tipo: MembroTipo.admin,
        status: MembroStatus.ativo,
        dataEntrada: DateTime.now().subtract(const Duration(days: 30)),
        permissoes: ['admin', 'moderar', 'remover_mensagens'],
      ),
      MembroGrupo(
        id: 'membro2',
        grupoId: 'grupo1',
        userId: 'user1',
        nomeUsuario: 'Maria Santos',
        tipo: MembroTipo.membro,
        status: MembroStatus.ativo,
        dataEntrada: DateTime.now().subtract(const Duration(days: 25)),
        permissoes: ['enviar_mensagens'],
      ),
    ],
  };

  static final Map<String, List<MensagemGrupo>> _mensagens = {
    'grupo1': [
      MensagemGrupo(
        id: 'msg1',
        grupoId: 'grupo1',
        autorId: 'admin1',
        autorNome: 'João Silva',
        conteudo:
            'Bem-vindos ao grupo! Aqui compartilharemos materiais e dicas para o concurso da PF.',
        tipo: 'texto',
        dataEnvio: DateTime.now().subtract(const Duration(days: 30)),
        editada: false,
        removida: false,
        curtidas: ['user1', 'user2'],
      ),
      MensagemGrupo(
        id: 'msg2',
        grupoId: 'grupo1',
        autorId: 'user1',
        autorNome: 'Maria Santos',
        conteudo: 'Alguém tem material sobre Direito Constitucional?',
        tipo: 'texto',
        dataEnvio: DateTime.now().subtract(const Duration(hours: 2)),
        editada: false,
        removida: false,
        curtidas: [],
      ),
    ],
  };

  // Métodos para Grupos
  static Future<List<Grupo>> getAllGrupos() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simular delay
    return _grupos.where((g) => g.status == GrupoStatus.ativo).toList();
  }

  static Future<List<Grupo>> getGruposByFilter({
    String? busca,
    List<String>? disciplinas,
    GrupoTipo? tipo,
    bool? requerAprovacao,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var grupos = _grupos.where((g) => g.status == GrupoStatus.ativo);

    if (busca != null && busca.isNotEmpty) {
      grupos = grupos.where(
        (g) =>
            g.nome.toLowerCase().contains(busca.toLowerCase()) ||
            g.descricao.toLowerCase().contains(busca.toLowerCase()) ||
            g.tags.any(
              (tag) => tag.toLowerCase().contains(busca.toLowerCase()),
            ),
      );
    }

    if (disciplinas != null && disciplinas.isNotEmpty) {
      grupos = grupos.where(
        (g) => disciplinas.any((d) => g.disciplinas.contains(d)),
      );
    }

    if (tipo != null) {
      grupos = grupos.where((g) => g.tipo == tipo);
    }

    if (requerAprovacao != null) {
      grupos = grupos.where((g) => g.requerAprovacao == requerAprovacao);
    }

    return grupos.toList();
  }

  static Future<Grupo?> getGrupoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _grupos.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> criarGrupo(Grupo grupo) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _grupos.add(grupo);
    return true;
  }

  static Future<bool> atualizarGrupo(Grupo grupo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _grupos.indexWhere((g) => g.id == grupo.id);
    if (index != -1) {
      _grupos[index] = grupo;
      return true;
    }
    return false;
  }

  static Future<bool> deletarGrupo(String grupoId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _grupos.indexWhere((g) => g.id == grupoId);
    if (index != -1) {
      _grupos[index] = _grupos[index].copyWith(status: GrupoStatus.arquivado);
      return true;
    }
    return false;
  }

  // Métodos para Membros
  static Future<List<MembroGrupo>> getMembrosGrupo(String grupoId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _membros[grupoId] ?? [];
  }

  static Future<bool> entrarGrupo(
    String grupoId,
    String userId,
    String nomeUsuario,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final grupo = await getGrupoById(grupoId);
    if (grupo == null) return false;

    final membros = _membros[grupoId] ?? [];
    if (membros.length >= grupo.maxMembros) return false;

    final novoMembro = MembroGrupo(
      id: 'membro_${DateTime.now().millisecondsSinceEpoch}',
      grupoId: grupoId,
      userId: userId,
      nomeUsuario: nomeUsuario,
      tipo: MembroTipo.membro,
      status: grupo.requerAprovacao
          ? MembroStatus.pendente
          : MembroStatus.ativo,
      dataEntrada: DateTime.now(),
      permissoes: grupo.requerAprovacao ? [] : ['enviar_mensagens'],
    );

    _membros[grupoId] = [...membros, novoMembro];

    // Atualizar contador de membros
    final index = _grupos.indexWhere((g) => g.id == grupoId);
    if (index != -1) {
      _grupos[index] = _grupos[index].copyWith(
        membrosAtivos: _grupos[index].membrosAtivos + 1,
      );
    }

    return true;
  }

  static Future<bool> sairGrupo(String grupoId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final membros = _membros[grupoId] ?? [];
    final index = membros.indexWhere((m) => m.userId == userId);

    if (index != -1) {
      membros.removeAt(index);
      _membros[grupoId] = membros;

      // Atualizar contador de membros
      final grupoIndex = _grupos.indexWhere((g) => g.id == grupoId);
      if (grupoIndex != -1) {
        _grupos[grupoIndex] = _grupos[grupoIndex].copyWith(
          membrosAtivos: _grupos[grupoIndex].membrosAtivos - 1,
        );
      }

      return true;
    }

    return false;
  }

  static Future<bool> aprovarMembro(String grupoId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final membros = _membros[grupoId] ?? [];
    final index = membros.indexWhere((m) => m.userId == userId);

    if (index != -1) {
      membros[index] = membros[index].copyWith(
        status: MembroStatus.ativo,
        permissoes: ['enviar_mensagens'],
      );
      _membros[grupoId] = membros;
      return true;
    }

    return false;
  }

  // Métodos para Mensagens
  static Future<List<MensagemGrupo>> getMensagensGrupo(
    String grupoId, {
    int limit = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final mensagens = _mensagens[grupoId] ?? [];
    return mensagens.take(limit).toList();
  }

  static Future<MensagemGrupo?> enviarMensagem(MensagemGrupo mensagem) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final mensagens = _mensagens[mensagem.grupoId] ?? [];
    mensagens.add(mensagem);
    _mensagens[mensagem.grupoId] = mensagens;

    return mensagem;
  }

  static Future<bool> editarMensagem(
    String mensagemId,
    String novoConteudo,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    for (final grupoId in _mensagens.keys) {
      final mensagens = _mensagens[grupoId]!;
      final index = mensagens.indexWhere((m) => m.id == mensagemId);

      if (index != -1) {
        mensagens[index] = mensagens[index].copyWith(
          conteudo: novoConteudo,
          dataEdicao: DateTime.now(),
          editada: true,
        );
        return true;
      }
    }

    return false;
  }

  static Future<bool> removerMensagem(String mensagemId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    for (final grupoId in _mensagens.keys) {
      final mensagens = _mensagens[grupoId]!;
      final index = mensagens.indexWhere((m) => m.id == mensagemId);

      if (index != -1) {
        mensagens[index] = mensagens[index].copyWith(removida: true);
        return true;
      }
    }

    return false;
  }

  static Future<bool> curtirMensagem(String mensagemId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    for (final grupoId in _mensagens.keys) {
      final mensagens = _mensagens[grupoId]!;
      final index = mensagens.indexWhere((m) => m.id == mensagemId);

      if (index != -1) {
        final curtidas = List<String>.from(mensagens[index].curtidas);
        if (curtidas.contains(userId)) {
          curtidas.remove(userId);
        } else {
          curtidas.add(userId);
        }

        mensagens[index] = mensagens[index].copyWith(curtidas: curtidas);
        return true;
      }
    }

    return false;
  }

  // Verificações de permissão
  static Future<bool> verificarPermissao(
    String grupoId,
    String userId,
    String permissao,
  ) async {
    final membros = await getMembrosGrupo(grupoId);
    final membro = membros.firstWhere(
      (m) => m.userId == userId && m.status == MembroStatus.ativo,
      orElse: () => MembroGrupo(
        id: '',
        grupoId: grupoId,
        userId: userId,
        nomeUsuario: '',
        tipo: MembroTipo.membro,
        status: MembroStatus.banido,
        dataEntrada: DateTime.now(),
        permissoes: [],
      ),
    );

    return membro.permissoes.contains(permissao) ||
        membro.tipo == MembroTipo.admin ||
        membro.tipo == MembroTipo.moderador;
  }

  static Future<bool> isMembro(String grupoId, String userId) async {
    final membros = await getMembrosGrupo(grupoId);
    return membros.any(
      (m) => m.userId == userId && m.status == MembroStatus.ativo,
    );
  }
}
