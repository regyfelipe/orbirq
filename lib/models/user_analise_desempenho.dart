class UserAnaliseDesempenho {
  final String id;
final String titulo;
  final double pontuacaoMedia;
  final int totalQuestoes;
  final int acertos;
  final String disciplina;

  UserAnaliseDesempenho({
    required this.id,
required this.titulo,
    required this.pontuacaoMedia,
    required this.totalQuestoes,
    required this.acertos,
    required this.disciplina,
  });

  factory UserAnaliseDesempenho.fromJson(Map<String, dynamic> json) {
    return UserAnaliseDesempenho(
      id: json['id'].toString(),
      titulo: json['titulo'],
      pontuacaoMedia: (json['pontuacaoMedia'] is int)
          ? (json['pontuacaoMedia'] as int).toDouble()
          : (json['pontuacaoMedia'] ?? 0.0),
      totalQuestoes: json['totalQuestoes'] ?? 0,
      acertos: json['acertos'] ?? 0,
      disciplina: json['disciplina'] ?? '',
    );
  }
}
