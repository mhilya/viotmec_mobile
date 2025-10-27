class PengeringanData {
  final PengeringanSuhuData suhuData;
  final PengeringanBlowerData blowerData;

  PengeringanData({
    required this.suhuData,
    required this.blowerData,
  });
}

class PengeringanSuhuData {
  final List<dynamic> dataSuhu;
  final List<dynamic> dataKelembaban;
  final List<dynamic> dataWaktuSuhu;
  final List<dynamic> dataWaktuKelembaban;
  final String dataAvgSuhu;
  final String dataAvgKelembaban;
  final int statusRuangan;

  PengeringanSuhuData({
    required this.dataSuhu,
    required this.dataKelembaban,
    required this.dataWaktuSuhu,
    required this.dataWaktuKelembaban,
    required this.dataAvgSuhu,
    required this.dataAvgKelembaban,
    required this.statusRuangan,
  });

  // --- PERBAIKAN DI BAWAH INI ---

  factory PengeringanSuhuData.fromJson(Map<String, dynamic> json) {
    // 1. Ambil data rata-rata global (dari key 'avg')
    final Map<String, dynamic> avg = json['avg'] ?? {};
    
    // 2. Ambil data rata-rata per titik (dari key 'averaged_data')
    final Map<String, dynamic> averagedData = json['averaged_data'] ?? {};
    
    // 3. Ekstrak data suhu dari 'averaged_data'
    final Map<String, dynamic> suhuDataMap = averagedData['suhu'] ?? {};
    
    // 4. Ekstrak data kelembaban dari 'averaged_data'
    final Map<String, dynamic> kelembabanDataMap = averagedData['kelembaban'] ?? {};

    return PengeringanSuhuData(
      // Ambil list 'values' dan 'waktu' dari map suhu
      dataSuhu: _parseList(suhuDataMap['values']),
      dataWaktuSuhu: _parseList(suhuDataMap['waktu']),
      
      // Ambil list 'values' dan 'waktu' dari map kelembaban
      dataKelembaban: _parseList(kelembabanDataMap['values']),
      dataWaktuKelembaban: _parseList(kelembabanDataMap['waktu']),
      
      // Ambil 'avg' dari map avg
      dataAvgSuhu: avg['suhu']?.toString() ?? "0",
      dataAvgKelembaban: avg['kelembaban']?.toString() ?? "0",

      // Ambil status ruangan dari root json
      statusRuangan: _parseInt(json['statusRuangan']),
    );
  }

  // Helper method untuk parsing list dengan aman
  static List<dynamic> _parseList(dynamic data) {
    if (data is List) {
      return data;
    }
    return [];
  }

  // Helper method untuk parsing int dengan aman
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // --- AKHIR DARI PERBAIKAN ---
}

// Model untuk blower tetap sama
class PengeringanBlowerData {
  final int statusRuangan;
  final int statusBlower;
  final int durasiAktif;
  final List<dynamic> dataBlower;
  final List<dynamic> dataWaktuBlower;

  PengeringanBlowerData({
    required this.statusRuangan,
    required this.statusBlower,
    required this.durasiAktif,
    required this.dataBlower,
    required this.dataWaktuBlower,
  });

  factory PengeringanBlowerData.fromJson(Map<String, dynamic> json) {
    return PengeringanBlowerData(
      statusRuangan: _parseInt(json['statusRuangan']),
      statusBlower: _parseInt(json['statusBlower']),
      durasiAktif: _parseInt(json['durasiAktif']),
      dataBlower: json['dataBlower'] is List ? json['dataBlower'] : [],
      dataWaktuBlower:
          json['dataWaktuBlower'] is List ? json['dataWaktuBlower'] : [],
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  PengeringanBlowerData copyWith({
    int? statusRuangan,
    int? statusBlower,
    int? durasiAktif,
    List<dynamic>? dataBlower,
    List<dynamic>? dataWaktuBlower,
  }) {
    return PengeringanBlowerData(
      statusRuangan: statusRuangan ?? this.statusRuangan,
      statusBlower: statusBlower ?? this.statusBlower,
      durasiAktif: durasiAktif ?? this.durasiAktif,
      dataBlower: dataBlower ?? this.dataBlower,
      dataWaktuBlower: dataWaktuBlower ?? this.dataWaktuBlower,
    );
  }
}
