class RiwayatNotifikasiModel {
  final int id;
  final String title;
  final String body;
  final String kategori;
  final String createdAt;

  RiwayatNotifikasiModel({
    required this.id,
    required this.title,
    required this.body,
    required this.kategori,
    required this.createdAt,
  });

  factory RiwayatNotifikasiModel.fromJson(Map<String, dynamic> json) {
    return RiwayatNotifikasiModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      kategori: json['kategori'] ?? 'info',
      createdAt: json['created_at'],
    );
  }
}