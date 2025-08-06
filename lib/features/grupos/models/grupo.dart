enum GrupoTipo { publico, privado, restrito }

enum GrupoStatus { ativo, inativo, arquivado }

enum MembroTipo { admin, moderador, membro }

enum MembroStatus { ativo, pendente, banido }

class Grupo {
  final String id;
  final String nome;
  final String descricao;
  final String? descricaoCompleta;
  final String? imagemUrl;
  final GrupoTipo tipo;
  final GrupoStatus status;
  final List<String> disciplinas;
  final List<String> tags;
  final int maxMembros;
  final int membrosAtivos;
  final String criadorId;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  final bool permiteMensagens;
  final bool permiteArquivos;
  final bool requerAprovacao;
  final String? regras;
  final Map<String, dynamic>? configuracoes;

  Grupo({
    required this.id,
    required this.nome,
    required this.descricao,
    this.descricaoCompleta,
    this.imagemUrl,
    required this.tipo,
    required this.status,
    required this.disciplinas,
    required this.tags,
    required this.maxMembros,
    required this.membrosAtivos,
    required this.criadorId,
    required this.dataCriacao,
    this.dataAtualizacao,
    required this.permiteMensagens,
    required this.permiteArquivos,
    required this.requerAprovacao,
    this.regras,
    this.configuracoes,
  });

  Grupo copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? descricaoCompleta,
    String? imagemUrl,
    GrupoTipo? tipo,
    GrupoStatus? status,
    List<String>? disciplinas,
    List<String>? tags,
    int? maxMembros,
    int? membrosAtivos,
    String? criadorId,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    bool? permiteMensagens,
    bool? permiteArquivos,
    bool? requerAprovacao,
    String? regras,
    Map<String, dynamic>? configuracoes,
  }) {
    return Grupo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      descricaoCompleta: descricaoCompleta ?? this.descricaoCompleta,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      tipo: tipo ?? this.tipo,
      status: status ?? this.status,
      disciplinas: disciplinas ?? this.disciplinas,
      tags: tags ?? this.tags,
      maxMembros: maxMembros ?? this.maxMembros,
      membrosAtivos: membrosAtivos ?? this.membrosAtivos,
      criadorId: criadorId ?? this.criadorId,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      permiteMensagens: permiteMensagens ?? this.permiteMensagens,
      permiteArquivos: permiteArquivos ?? this.permiteArquivos,
      requerAprovacao: requerAprovacao ?? this.requerAprovacao,
      regras: regras ?? this.regras,
      configuracoes: configuracoes ?? this.configuracoes,
    );
  }
}

class MembroGrupo {
  final String id;
  final String grupoId;
  final String userId;
  final String nomeUsuario;
  final String? avatarUrl;
  final MembroTipo tipo;
  final MembroStatus status;
  final DateTime dataEntrada;
  final DateTime? dataUltimaAtividade;
  final List<String> permissoes;
  final Map<String, dynamic>? metadados;

  MembroGrupo({
    required this.id,
    required this.grupoId,
    required this.userId,
    required this.nomeUsuario,
    this.avatarUrl,
    required this.tipo,
    required this.status,
    required this.dataEntrada,
    this.dataUltimaAtividade,
    required this.permissoes,
    this.metadados,
  });

  MembroGrupo copyWith({
    String? id,
    String? grupoId,
    String? userId,
    String? nomeUsuario,
    String? avatarUrl,
    MembroTipo? tipo,
    MembroStatus? status,
    DateTime? dataEntrada,
    DateTime? dataUltimaAtividade,
    List<String>? permissoes,
    Map<String, dynamic>? metadados,
  }) {
    return MembroGrupo(
      id: id ?? this.id,
      grupoId: grupoId ?? this.grupoId,
      userId: userId ?? this.userId,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tipo: tipo ?? this.tipo,
      status: status ?? this.status,
      dataEntrada: dataEntrada ?? this.dataEntrada,
      dataUltimaAtividade: dataUltimaAtividade ?? this.dataUltimaAtividade,
      permissoes: permissoes ?? this.permissoes,
      metadados: metadados ?? this.metadados,
    );
  }
}

class MensagemGrupo {
  final String id;
  final String grupoId;
  final String autorId;
  final String autorNome;
  final String? autorAvatar;
  final String conteudo;
  final String? tipo; // texto, imagem, arquivo, sistema
  final String? arquivoUrl;
  final String? arquivoNome;
  final DateTime dataEnvio;
  final DateTime? dataEdicao;
  final bool editada;
  final bool removida;
  final List<String> curtidas;
  final List<RespostaMensagem>? respostas;
  final Map<String, dynamic>? metadados;

  MensagemGrupo({
    required this.id,
    required this.grupoId,
    required this.autorId,
    required this.autorNome,
    this.autorAvatar,
    required this.conteudo,
    this.tipo,
    this.arquivoUrl,
    this.arquivoNome,
    required this.dataEnvio,
    this.dataEdicao,
    required this.editada,
    required this.removida,
    required this.curtidas,
    this.respostas,
    this.metadados,
  });

  MensagemGrupo copyWith({
    String? id,
    String? grupoId,
    String? autorId,
    String? autorNome,
    String? autorAvatar,
    String? conteudo,
    String? tipo,
    String? arquivoUrl,
    String? arquivoNome,
    DateTime? dataEnvio,
    DateTime? dataEdicao,
    bool? editada,
    bool? removida,
    List<String>? curtidas,
    List<RespostaMensagem>? respostas,
    Map<String, dynamic>? metadados,
  }) {
    return MensagemGrupo(
      id: id ?? this.id,
      grupoId: grupoId ?? this.grupoId,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      autorAvatar: autorAvatar ?? this.autorAvatar,
      conteudo: conteudo ?? this.conteudo,
      tipo: tipo ?? this.tipo,
      arquivoUrl: arquivoUrl ?? this.arquivoUrl,
      arquivoNome: arquivoNome ?? this.arquivoNome,
      dataEnvio: dataEnvio ?? this.dataEnvio,
      dataEdicao: dataEdicao ?? this.dataEdicao,
      editada: editada ?? this.editada,
      removida: removida ?? this.removida,
      curtidas: curtidas ?? this.curtidas,
      respostas: respostas ?? this.respostas,
      metadados: metadados ?? this.metadados,
    );
  }
}

class RespostaMensagem {
  final String id;
  final String mensagemId;
  final String autorId;
  final String autorNome;
  final String? autorAvatar;
  final String conteudo;
  final DateTime dataEnvio;
  final DateTime? dataEdicao;
  final bool editada;
  final bool removida;

  RespostaMensagem({
    required this.id,
    required this.mensagemId,
    required this.autorId,
    required this.autorNome,
    this.autorAvatar,
    required this.conteudo,
    required this.dataEnvio,
    this.dataEdicao,
    required this.editada,
    required this.removida,
  });
}
