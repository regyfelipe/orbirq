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
