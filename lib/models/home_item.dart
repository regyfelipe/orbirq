class HomeItem {
  final String id;
  final String title;
  final String subtitle;
  final String? imagePath;
  final HomeItemType type;
  final Map<String, dynamic>? data;

  HomeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imagePath,
    required this.type,
    this.data,
  });
}

enum HomeItemType { ultimoAcesso, simulado, analise }

class UltimoAcesso {
  final String id;
  final String titulo;
  final String disciplina;
  final DateTime dataAcesso;
  final int progresso; // 0-100

  UltimoAcesso({
    required this.id,
    required this.titulo,
    required this.disciplina,
    required this.dataAcesso,
    required this.progresso,
  });
}

class Simulado {
  final String id;
  final String titulo;
  final String descricao;
  final int totalQuestoes;
  final int tempoMinutos;
  final bool isNovo;

  Simulado({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.totalQuestoes,
    required this.tempoMinutos,
    this.isNovo = false,
  });
}

class AnaliseDesempenho {
  final String id;
  final String titulo;
  final double pontuacaoMedia;
  final int totalQuestoes;
  final int acertos;
  final String disciplina;

  AnaliseDesempenho({
    required this.id,
    required this.titulo,
    required this.pontuacaoMedia,
    required this.totalQuestoes,
    required this.acertos,
    required this.disciplina,
  });
}
