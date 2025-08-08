class UserUltimoAcesso {
  final int id;
  final String titulo;
  final String disciplina;
  final double progresso;
  final DateTime dataAcesso;

  UserUltimoAcesso({
    required this.id,
    required this.titulo,
    required this.disciplina,
    required this.progresso,
    required this.dataAcesso,
  });

 factory UserUltimoAcesso.fromMap(Map<String, dynamic> map) {
  return UserUltimoAcesso(
    id: map['id'] ?? 0,
    titulo: map['titulo'] ?? 'Sem título',
    disciplina: map['disciplina'] ?? 'N/A',
    progresso: (map['progresso'] != null && (map['progresso'] as num).isFinite)
        ? (map['progresso'] as num).toDouble()
        : 0.0,
    dataAcesso: map['dataAcesso'] != null
        ? DateTime.parse(map['dataAcesso'])
        : DateTime.now(),
  );
}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'disciplina': disciplina,
      'progresso': progresso,
      'dataAcesso': dataAcesso.toIso8601String(),
    };
  }
}
