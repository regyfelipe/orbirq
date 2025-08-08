class UserSimulado {
  final String id;
  final String titulo;
  final String descricao;
  final int totalQuestoes;
  final int tempoMinutos;
  final bool isNovo;

  UserSimulado({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.totalQuestoes,
    required this.tempoMinutos,
    this.isNovo = false,
  });

  factory UserSimulado.fromJson(Map<String, dynamic> json) {
    return UserSimulado(
      id: json['id'].toString(),
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'],
      totalQuestoes: json['totalQuestoes'] ?? 0,
      tempoMinutos: json['tempoMinutos'] ?? 0,
      isNovo: json['isNovo'] ?? false,
    );
  }
}
