class RuanganModel {
  final String id;
  final String namaRuangan;
  final String idGudang;
  final int tipeRuangan;

  RuanganModel({
    required this.id,
    required this.namaRuangan,
    required this.idGudang,
    required this.tipeRuangan,
  });

  factory RuanganModel.fromJson(Map<String, dynamic> json) {
    return RuanganModel(
      id: json['id_ruangan']?.toString() ?? '',
      namaRuangan: json['nama_ruangan']?.toString() ?? '',
      idGudang: json['id_gudang']?.toString() ?? '',
      tipeRuangan: _parseTipe(json['tipe_ruangan']),
    );
  }

  static int _parseTipe(dynamic tipe) {
    if (tipe == null) return 0;
    if (tipe is int) return tipe;
    if (tipe is String) return int.tryParse(tipe) ?? 0;
    return 0;
  }
}
