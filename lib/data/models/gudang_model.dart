class GudangModel {
  final String idGudang;
  final String namaGudang;
  final String lokasiGudang;
  final int statusGudang;

  GudangModel({
    required this.idGudang,
    required this.namaGudang,
    required this.lokasiGudang,
    required this.statusGudang,
  });

  factory GudangModel.fromJson(Map<String, dynamic> json) {
    return GudangModel(
      idGudang: json['id_gudang']?.toString() ?? '',
      namaGudang: json['nama_gudang']?.toString() ?? '',
      lokasiGudang: json['lokasi_gudang']?.toString() ?? '',
      statusGudang: _parseStatusGudang(json['status_gudang']),
    );
  }

  static int _parseStatusGudang(dynamic status) {
    if (status == null) return 0;
    if (status is int) return status;
    if (status is String) return int.tryParse(status) ?? 0;
    return 0;
  }
}