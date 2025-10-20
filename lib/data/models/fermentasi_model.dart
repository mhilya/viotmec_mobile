class FermentasiData {
  final bool status;
  final List<double> dataSuhu;
  final List<double> dataKelembaban;
  final List<String> dataWaktuSuhu;
  final List<String> dataWaktuKelembaban;
  final String dataAvgSuhu;
  final String dataAvgKelembaban;
  final String? dataTimer;
  // GANTI: Dibuat nullable karena API tidak selalu mengirimkannya
  final int? statusRuangan; 

  FermentasiData({
    required this.status,
    required this.dataSuhu,
    required this.dataKelembaban,
    required this.dataWaktuSuhu,
    required this.dataWaktuKelembaban,
    required this.dataAvgSuhu,
    required this.dataAvgKelembaban,
    this.dataTimer,
    this.statusRuangan, // Disesuaikan
  });

  factory FermentasiData.fromJson(Map<String, dynamic> json) {
    return FermentasiData(
      status: json['status'] ?? false,
      dataSuhu: List<double>.from(json['dataSuhu']?.map((x) => double.tryParse(x.toString()) ?? 0.0) ?? []),
      dataKelembaban: List<double>.from(json['dataKelembaban']?.map((x) => double.tryParse(x.toString()) ?? 0.0) ?? []),
      dataWaktuSuhu: List<String>.from(json['dataWaktuSuhu'] ?? []),
      dataWaktuKelembaban: List<String>.from(json['dataWaktuKelembaban'] ?? []),
      dataAvgSuhu: json['dataAvgSuhu']?.toString() ?? '0',
      dataAvgKelembaban: json['dataAvgKelembaban']?.toString() ?? '0',
      dataTimer: json['dataTimer']?.toString(),
      // GANTI: Gunakan parser yang aman, karena field ini mungkin tidak ada
      statusRuangan: _parseStatusRuangan(json['statusRuangan']),
    );
  }

  static int? _parseStatusRuangan(dynamic status) {
    if (status == null) return null; // Kembalikan null jika tidak ada
    if (status is int) return status;
    if (status is String) return int.tryParse(status);
    return null;
  }
}
