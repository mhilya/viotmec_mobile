class PerebusanData {
  final bool status;
  final List<double> dataSuhu;
  final List<double> dataKelembaban;
  final List<String> dataWaktuSuhu;
  final List<String> dataWaktuKelembaban;
  final String dataAvgSuhu;
  final String dataAvgKelembaban;
  final String? dataTimer;
  final int statusRuangan;

  PerebusanData({
    required this.status,
    required this.dataSuhu,
    required this.dataKelembaban,
    required this.dataWaktuSuhu,
    required this.dataWaktuKelembaban,
    required this.dataAvgSuhu,
    required this.dataAvgKelembaban,
    this.dataTimer,
    required this.statusRuangan,
  });

  factory PerebusanData.fromJson(Map<String, dynamic> json) {
    return PerebusanData(
      status: json['status'] ?? false,
      dataSuhu: List<double>.from(json['dataSuhu']?.map((x) => double.tryParse(x.toString()) ?? 0.0) ?? []),
      dataKelembaban: List<double>.from(json['dataKelembaban']?.map((x) => double.tryParse(x.toString()) ?? 0.0) ?? []),
      dataWaktuSuhu: List<String>.from(json['dataWaktuSuhu'] ?? []),
      dataWaktuKelembaban: List<String>.from(json['dataWaktuKelembaban'] ?? []),
      dataAvgSuhu: json['dataAvgSuhu']?.toString() ?? '0',
      dataAvgKelembaban: json['dataAvgKelembaban']?.toString() ?? '0',
      dataTimer: json['dataTimer']?.toString(),
      statusRuangan: json['statusRuangan'] ?? 0,
    );
  }
}