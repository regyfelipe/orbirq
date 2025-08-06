enum SimuladoStatus { naoIniciado, emAndamento, pausado, concluido, cancelado }

enum SimuladoTipo { completo, porDisciplina, porAssunto, personalizado }

class Simulado {
  final String id;
  final String titulo;
  final String descricao;
  final int totalQuestoes;
  final int tempoMinutos;
  final bool isNovo;
  final SimuladoTipo tipo;
  final List<String> disciplinas;
  final List<String> assuntos;
  final String? banca;
  final int? ano;
  final String? nivelDificuldade;
  final double? pontuacaoMinima;
  final DateTime? dataCriacao;
  final DateTime? dataExpiracao;
  final bool isGratuito;
  final double? preco;

  Simulado({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.totalQuestoes,
    required this.tempoMinutos,
    this.isNovo = false,
    this.tipo = SimuladoTipo.completo,
    this.disciplinas = const [],
    this.assuntos = const [],
    this.banca,
    this.ano,
    this.nivelDificuldade,
    this.pontuacaoMinima,
    this.dataCriacao,
    this.dataExpiracao,
    this.isGratuito = true,
    this.preco,
  });

  Simulado copyWith({
    String? id,
    String? titulo,
    String? descricao,
    int? totalQuestoes,
    int? tempoMinutos,
    bool? isNovo,
    SimuladoTipo? tipo,
    List<String>? disciplinas,
    List<String>? assuntos,
    String? banca,
    int? ano,
    String? nivelDificuldade,
    double? pontuacaoMinima,
    DateTime? dataCriacao,
    DateTime? dataExpiracao,
    bool? isGratuito,
    double? preco,
  }) {
    return Simulado(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      totalQuestoes: totalQuestoes ?? this.totalQuestoes,
      tempoMinutos: tempoMinutos ?? this.tempoMinutos,
      isNovo: isNovo ?? this.isNovo,
      tipo: tipo ?? this.tipo,
      disciplinas: disciplinas ?? this.disciplinas,
      assuntos: assuntos ?? this.assuntos,
      banca: banca ?? this.banca,
      ano: ano ?? this.ano,
      nivelDificuldade: nivelDificuldade ?? this.nivelDificuldade,
      pontuacaoMinima: pontuacaoMinima ?? this.pontuacaoMinima,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataExpiracao: dataExpiracao ?? this.dataExpiracao,
      isGratuito: isGratuito ?? this.isGratuito,
      preco: preco ?? this.preco,
    );
  }
}

class SimuladoExecucao {
  final String id;
  final String simuladoId;
  final String userId;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final int tempoTotal; // em segundos
  final int tempoRestante; // em segundos
  final SimuladoStatus status;
  final int questaoAtual;
  final Map<int, String> respostas; // questaoIndex -> resposta
  final Map<int, bool> acertos; // questaoIndex -> acertou
  final double? pontuacaoFinal;
  final int? acertosTotal;
  final int? errosTotal;
  final int? questoesNaoRespondidas;

  SimuladoExecucao({
    required this.id,
    required this.simuladoId,
    required this.userId,
    required this.dataInicio,
    this.dataFim,
    required this.tempoTotal,
    required this.tempoRestante,
    this.status = SimuladoStatus.naoIniciado,
    this.questaoAtual = 0,
    this.respostas = const {},
    this.acertos = const {},
    this.pontuacaoFinal,
    this.acertosTotal,
    this.errosTotal,
    this.questoesNaoRespondidas,
  });

  SimuladoExecucao copyWith({
    String? id,
    String? simuladoId,
    String? userId,
    DateTime? dataInicio,
    DateTime? dataFim,
    int? tempoTotal,
    int? tempoRestante,
    SimuladoStatus? status,
    int? questaoAtual,
    Map<int, String>? respostas,
    Map<int, bool>? acertos,
    double? pontuacaoFinal,
    int? acertosTotal,
    int? errosTotal,
    int? questoesNaoRespondidas,
  }) {
    return SimuladoExecucao(
      id: id ?? this.id,
      simuladoId: simuladoId ?? this.simuladoId,
      userId: userId ?? this.userId,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      tempoTotal: tempoTotal ?? this.tempoTotal,
      tempoRestante: tempoRestante ?? this.tempoRestante,
      status: status ?? this.status,
      questaoAtual: questaoAtual ?? this.questaoAtual,
      respostas: respostas ?? this.respostas,
      acertos: acertos ?? this.acertos,
      pontuacaoFinal: pontuacaoFinal ?? this.pontuacaoFinal,
      acertosTotal: acertosTotal ?? this.acertosTotal,
      errosTotal: errosTotal ?? this.errosTotal,
      questoesNaoRespondidas:
          questoesNaoRespondidas ?? this.questoesNaoRespondidas,
    );
  }

  bool get isEmAndamento => status == SimuladoStatus.emAndamento;
  bool get isConcluido => status == SimuladoStatus.concluido;
  bool get isPausado => status == SimuladoStatus.pausado;
  bool get isCancelado => status == SimuladoStatus.cancelado;

  double get percentualConcluido => respostas.length / tempoTotal;
  double get percentualTempoRestante => tempoRestante / tempoTotal;

  String get tempoRestanteFormatado {
    final minutos = tempoRestante ~/ 60;
    final segundos = tempoRestante % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }
}
