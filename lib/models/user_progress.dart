class UserProgress {
  final int totalQuestoes;
  final int acertos;
  final double mediaGeral;
  final int diasEstudo;

  UserProgress({
    required this.totalQuestoes,
    required this.acertos,
    required this.mediaGeral,
    required this.diasEstudo,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalQuestoes: json['totalQuestoes'] ?? 0,
      acertos: json['acertos'] ?? 0,
      mediaGeral: (json['mediaGeral'] is int)
          ? (json['mediaGeral'] as int).toDouble()
          : (json['mediaGeral'] ?? 0.0),
      diasEstudo: json['diasEstudo'] ?? 0,
    );
  }
}
