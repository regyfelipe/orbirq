import 'dart:async';
import 'dart:math';
import '../models/simulado.dart';
import '../../../features/questoes/models/question.dart';
import '../../../features/questoes/services/questao_service.dart';

class SimuladoService {
  static final List<Simulado> _simulados = [
    Simulado(
      id: 'simulado1',
      titulo: "Simulado PRF - Física & Legislação",
      descricao: "Foco total em temas quentes da PRF. 20 questões.",
      totalQuestoes: 20,
      tempoMinutos: 25,
      isNovo: true,
      tipo: SimuladoTipo.completo,
      disciplinas: ['Física', 'Legislação'],
      banca: 'CESPE',
      ano: 2024,
      nivelDificuldade: 'Médio',
      pontuacaoMinima: 7.0,
      dataCriacao: DateTime.now().subtract(const Duration(days: 2)),
      isGratuito: true,
    ),
    Simulado(
      id: 'simulado2',
      titulo: "Simulado PF - Constitucional",
      descricao: "Constituição seca + jurisprudência recente.",
      totalQuestoes: 15,
      tempoMinutos: 20,
      isNovo: false,
      tipo: SimuladoTipo.porDisciplina,
      disciplinas: ['Direito Constitucional'],
      banca: 'CESPE',
      ano: 2024,
      nivelDificuldade: 'Difícil',
      pontuacaoMinima: 8.0,
      dataCriacao: DateTime.now().subtract(const Duration(days: 5)),
      isGratuito: true,
    ),
    Simulado(
      id: 'simulado3',
      titulo: "Simulado de Atualidades",
      descricao: "Fatos relevantes do 1º semestre de 2025.",
      totalQuestoes: 10,
      tempoMinutos: 15,
      isNovo: true,
      tipo: SimuladoTipo.porAssunto,
      assuntos: ['Atualidades', 'Política', 'Economia'],
      banca: 'Várias',
      ano: 2025,
      nivelDificuldade: 'Fácil',
      pontuacaoMinima: 6.0,
      dataCriacao: DateTime.now().subtract(const Duration(hours: 12)),
      isGratuito: true,
    ),
    Simulado(
      id: 'simulado4',
      titulo: "Simulado Completo PMCE 2024",
      descricao:
          "Teste seus conhecimentos com questões atualizadas do último concurso da Polícia Militar do Ceará.",
      totalQuestoes: 100,
      tempoMinutos: 180,
      isNovo: false,
      tipo: SimuladoTipo.completo,
      disciplinas: [
        'Português',
        'Matemática',
        'Direito Constitucional',
        'Direito Penal',
        'Atualidades',
      ],
      banca: 'CESPE',
      ano: 2024,
      nivelDificuldade: 'Médio',
      pontuacaoMinima: 7.5,
      dataCriacao: DateTime.now().subtract(const Duration(days: 10)),
      isGratuito: false,
      preco: 29.90,
    ),
    Simulado(
      id: 'simulado5',
      titulo: "Simulado Raciocínio Lógico",
      descricao: "Questões de lógica e matemática para concursos.",
      totalQuestoes: 30,
      tempoMinutos: 45,
      isNovo: true,
      tipo: SimuladoTipo.porDisciplina,
      disciplinas: ['Raciocínio Lógico'],
      banca: 'Várias',
      ano: 2024,
      nivelDificuldade: 'Médio',
      pontuacaoMinima: 7.0,
      dataCriacao: DateTime.now().subtract(const Duration(days: 1)),
      isGratuito: true,
    ),
  ];

  static final Map<String, SimuladoExecucao> _execucoes = {};

  // Buscar todos os simulados
  static Future<List<Simulado>> getAllSimulados() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simular delay de rede
    return _simulados;
  }

  // Buscar simulados por filtros
  static Future<List<Simulado>> getSimuladosByFilter({
    String? titulo,
    List<String>? disciplinas,
    String? banca,
    int? ano,
    String? nivelDificuldade,
    bool? isGratuito,
    bool? isNovo,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _simulados.where((simulado) {
      if (titulo != null && titulo.isNotEmpty) {
        if (!simulado.titulo.toLowerCase().contains(titulo.toLowerCase())) {
          return false;
        }
      }

      if (disciplinas != null && disciplinas.isNotEmpty) {
        if (!disciplinas.any((d) => simulado.disciplinas.contains(d))) {
          return false;
        }
      }

      if (banca != null && banca.isNotEmpty) {
        if (simulado.banca != banca) {
          return false;
        }
      }

      if (ano != null) {
        if (simulado.ano != ano) {
          return false;
        }
      }

      if (nivelDificuldade != null && nivelDificuldade.isNotEmpty) {
        if (simulado.nivelDificuldade != nivelDificuldade) {
          return false;
        }
      }

      if (isGratuito != null) {
        if (simulado.isGratuito != isGratuito) {
          return false;
        }
      }

      if (isNovo != null) {
        if (simulado.isNovo != isNovo) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Buscar simulado por ID
  static Future<Simulado?> getSimuladoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _simulados.firstWhere((simulado) => simulado.id == id);
    } catch (e) {
      return null;
    }
  }

  // Iniciar simulado
  static Future<SimuladoExecucao> iniciarSimulado(
    String simuladoId,
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final simulado = await getSimuladoById(simuladoId);
    if (simulado == null) {
      throw Exception('Simulado não encontrado');
    }

    final execucaoId = 'exec_${DateTime.now().millisecondsSinceEpoch}';
    final execucao = SimuladoExecucao(
      id: execucaoId,
      simuladoId: simuladoId,
      userId: userId,
      dataInicio: DateTime.now(),
      tempoTotal: simulado.tempoMinutos * 60,
      tempoRestante: simulado.tempoMinutos * 60,
      status: SimuladoStatus.emAndamento,
    );

    _execucoes[execucaoId] = execucao;
    return execucao;
  }

  // Pausar simulado
  static Future<SimuladoExecucao> pausarSimulado(String execucaoId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final execucao = _execucoes[execucaoId];
    if (execucao == null) {
      throw Exception('Execução não encontrada');
    }

    final execucaoAtualizada = execucao.copyWith(
      status: SimuladoStatus.pausado,
    );

    _execucoes[execucaoId] = execucaoAtualizada;
    return execucaoAtualizada;
  }

  // Retomar simulado
  static Future<SimuladoExecucao> retomarSimulado(String execucaoId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final execucao = _execucoes[execucaoId];
    if (execucao == null) {
      throw Exception('Execução não encontrada');
    }

    final execucaoAtualizada = execucao.copyWith(
      status: SimuladoStatus.emAndamento,
    );

    _execucoes[execucaoId] = execucaoAtualizada;
    return execucaoAtualizada;
  }

  // Finalizar simulado
  static Future<SimuladoExecucao> finalizarSimulado(String execucaoId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final execucao = _execucoes[execucaoId];
    if (execucao == null) {
      throw Exception('Execução não encontrada');
    }

    final simulado = await getSimuladoById(execucao.simuladoId);
    if (simulado == null) {
      throw Exception('Simulado não encontrado');
    }

    // Calcular estatísticas
    final acertosTotal = execucao.acertos.values
        .where((acertou) => acertou)
        .length;
    final errosTotal = execucao.acertos.values
        .where((acertou) => !acertou)
        .length;
    final questoesNaoRespondidas =
        simulado.totalQuestoes - execucao.respostas.length;
    final pontuacaoFinal = (acertosTotal / simulado.totalQuestoes) * 10;

    final execucaoAtualizada = execucao.copyWith(
      status: SimuladoStatus.concluido,
      dataFim: DateTime.now(),
      tempoRestante: 0,
      pontuacaoFinal: pontuacaoFinal,
      acertosTotal: acertosTotal,
      errosTotal: errosTotal,
      questoesNaoRespondidas: questoesNaoRespondidas,
    );

    _execucoes[execucaoId] = execucaoAtualizada;
    return execucaoAtualizada;
  }

  // Responder questão
  static Future<SimuladoExecucao> responderQuestao(
    String execucaoId,
    int questaoIndex,
    String resposta,
    bool acertou,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final execucao = _execucoes[execucaoId];
    if (execucao == null) {
      throw Exception('Execução não encontrada');
    }

    final novasRespostas = Map<int, String>.from(execucao.respostas);
    final novosAcertos = Map<int, bool>.from(execucao.acertos);

    novasRespostas[questaoIndex] = resposta;
    novosAcertos[questaoIndex] = acertou;

    final execucaoAtualizada = execucao.copyWith(
      respostas: novasRespostas,
      acertos: novosAcertos,
      questaoAtual: questaoIndex + 1,
    );

    _execucoes[execucaoId] = execucaoAtualizada;
    return execucaoAtualizada;
  }

  // Atualizar tempo restante
  static Future<SimuladoExecucao> atualizarTempoRestante(
    String execucaoId,
    int tempoRestante,
  ) async {
    final execucao = _execucoes[execucaoId];
    if (execucao == null) {
      throw Exception('Execução não encontrada');
    }

    final execucaoAtualizada = execucao.copyWith(tempoRestante: tempoRestante);

    _execucoes[execucaoId] = execucaoAtualizada;
    return execucaoAtualizada;
  }

  // Buscar execução por ID
  static Future<SimuladoExecucao?> getExecucaoById(String execucaoId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _execucoes[execucaoId];
  }

  // Buscar execuções do usuário
  static Future<List<SimuladoExecucao>> getExecucoesByUserId(
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _execucoes.values
        .where((execucao) => execucao.userId == userId)
        .toList();
  }

  // Gerar questões para o simulado
  static Future<List<Question>> gerarQuestoesParaSimulado(
    String simuladoId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final simulado = await getSimuladoById(simuladoId);
    if (simulado == null) {
      throw Exception('Simulado não encontrado');
    }

    // Buscar questões baseadas nos critérios do simulado
    List<Question> questoes = [];

    if (simulado.disciplinas.isNotEmpty) {
      for (final disciplina in simulado.disciplinas) {
        final questoesDisciplina = QuestaoService.getQuestionsByDiscipline(
          disciplina,
        );
        questoes.addAll(questoesDisciplina);
      }
    } else if (simulado.assuntos.isNotEmpty) {
      for (final assunto in simulado.assuntos) {
        final questoesAssunto = QuestaoService.getQuestionsBySubject(assunto);
        questoes.addAll(questoesAssunto);
      }
    } else {
      questoes = QuestaoService.getSampleQuestions();
    }

    // Embaralhar e limitar ao número de questões do simulado
    questoes.shuffle(Random());
    if (questoes.length > simulado.totalQuestoes) {
      questoes = questoes.take(simulado.totalQuestoes).toList();
    }

    return questoes;
  }

  // Verificar se usuário pode acessar simulado
  static Future<bool> verificarAcessoSimulado(
    String simuladoId,
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final simulado = await getSimuladoById(simuladoId);
    if (simulado == null) return false;

    // Se é gratuito, sempre pode acessar
    if (simulado.isGratuito) return true;

    // TODO: Implementar verificação de pagamento
    // Por enquanto, simulamos que o usuário tem acesso
    return true;
  }
}
