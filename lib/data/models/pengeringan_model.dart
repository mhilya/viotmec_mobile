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

  PengeringanSuhuData({
    required this.dataSuhu,
    required this.dataKelembaban,
    required this.dataWaktuSuhu,
    required this.dataWaktuKelembaban,
    required this.dataAvgSuhu,
    required this.dataAvgKelembaban,
  });

  // --- PERBAIKAN DI BAWAH INI ---

  factory PengeringanSuhuData.fromJson(Map<String, dynamic> json) {
    // Ambil list sensor dan waktu dari root JSON, pastikan ada
    final List<dynamic> dataSensor = _parseList(json['dataSensor']);
    final List<dynamic> dataWaktu = _parseList(json['dataWaktuSensor']);

    // Cari data spesifik menggunakan helper
    // Kita asumsikan 'dataSuhu' di model merujuk ke 'suhu_1' dari API
    final suhuData = _findSensorData(dataSensor, 'suhu_1'); 
    
    // Kita asumsikan 'dataKelembaban' di model merujuk ke 'kelembaban_1' dari API
    final kelembabanData = _findSensorData(dataSensor, 'kelembaban_1');
    
    // Cari data waktu yang sesuai
    final suhuWaktu = _findSensorData(dataWaktu, 'suhu_1');
    final kelembabanWaktu = _findSensorData(dataWaktu, 'kelembaban_1');

    // (Catatan: Ini akan mengabaikan suhu_2 dan kelembaban_2 untuk saat ini,
    // karena model Anda hanya punya properti untuk satu set data)

    return PengeringanSuhuData(
      // Ambil 'value' dari data yang ditemukan, atau list kosong jika null
      dataSuhu: _parseList(suhuData?['value']),
      dataKelembaban: _parseList(kelembabanData?['value']),
      
      // Ambil 'value' dari waktu yang ditemukan
      dataWaktuSuhu: _parseList(suhuWaktu?['value']),
      dataWaktuKelembaban: _parseList(kelembabanWaktu?['value']),
      
      // Ambil 'avg' dari data yang ditemukan, atau "0" jika null
      dataAvgSuhu: suhuData?['avg']?.toString() ?? "0",
      dataAvgKelembaban: kelembabanData?['avg']?.toString() ?? "0",
    );
  }

  // Helper method untuk parsing list dengan aman
  static List<dynamic> _parseList(dynamic data) {
    if (data is List) {
      return data;
    }
    return [];
  }

  // HELPER BARU: untuk mencari data di dalam list JSON
  static Map<String, dynamic>? _findSensorData(List<dynamic> list, String flag) {
    try {
      // Cari item yang merupakan Map DAN punya flag_sensor yang cocok
      return list.firstWhere(
        (item) => item is Map<String, dynamic> && item['flag_sensor'] == flag,
        orElse: () => null, // Kembalikan null jika tidak ditemukan
      );
    } catch (e) {
      // Tangkap error jika list tidak valid
      return null;
    }
  }

  // --- AKHIR DARI PERBAIKAN ---
}

// Model untuk blower tetap sama (dummy)
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
