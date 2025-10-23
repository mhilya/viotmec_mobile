class RuanganModel {
  final String id;
  final String namaRuangan;
  final String idGudang;

  RuanganModel({
    required this.id,
    required this.namaRuangan,
    required this.idGudang,
  });

  factory RuanganModel.fromJson(Map<String, dynamic> json) {
    return RuanganModel(
      // Asumsi API mengembalikan 'id' dan 'nama_ruangan'
      id: json['id']?.toString() ?? '',
      namaRuangan: json['nama_ruangan']?.toString() ?? '',
      idGudang: json['id_gudang']?.toString() ?? '',
    );
  }
}