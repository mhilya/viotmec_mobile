class RiwayatData {
  final bool status;
  final String? message;
  final List<RiwayatSensorData> dataSensor;
  final String? namaRuangan;

  RiwayatData({
    required this.status,
    this.message,
    required this.dataSensor,
    this.namaRuangan,
  });

  factory RiwayatData.fromJson(Map<String, dynamic> json) {
    // Handle error response
    if (json['status'] == false) {
      return RiwayatData(
        status: false,
        message: json['message'] ?? 'Data tidak ditemukan',
        dataSensor: [],
        namaRuangan: json['namaRuangan'],
      );
    }

    // Handle success response
    return RiwayatData(
      status: json['status'] ?? true,
      dataSensor: List<RiwayatSensorData>.from(
        (json['dataSensor'] as List<dynamic>? ?? [])
            .map((x) => RiwayatSensorData.fromJson(x)),
      ),
      namaRuangan: json['namaRuangan'],
    );
  }

  // Helper untuk mencari sensor berdasarkan flag
  RiwayatSensorData? getSensorByFlag(String flag) {
    try {
      return dataSensor.firstWhere(
        (sensor) => sensor.flagSensor.toLowerCase().contains(flag.toLowerCase()),
      );
    } catch (e) {
      return null;
    }
  }

  // Helper untuk mendapatkan sensor suhu
  RiwayatSensorData? getSensorSuhu() => getSensorByFlag('suhu');

  // Helper untuk mendapatkan sensor kelembaban
  RiwayatSensorData? getSensorKelembaban() => getSensorByFlag('kelembaban');

  // Helper untuk mendapatkan semua jenis sensor yang tersedia
  List<String> getAvailableSensorTypes() {
    return dataSensor.map((sensor) => sensor.flagSensor).toList();
  }

  // Cek apakah ada data
  bool get hasData => dataSensor.isNotEmpty;
}

class RiwayatSensorData {
  final String type;
  final String flagSensor;
  final List<dynamic> value; // Bisa double atau string
  final String avg; // Dari Laravel berupa string yang diformat
  final List<String> timeLabel;

  RiwayatSensorData({
    required this.type,
    required this.flagSensor,
    required this.value,
    required this.avg,
    required this.timeLabel,
  });

  factory RiwayatSensorData.fromJson(Map<String, dynamic> json) {
    return RiwayatSensorData(
      type: json['type'] ?? 'sensor',
      flagSensor: json['flag_sensor'] ?? '',
      value: List<dynamic>.from(json['value'] ?? []),
      avg: json['avg']?.toString() ?? '0',
      timeLabel: List<String>.from(json['time_label'] ?? []),
    );
  }

  // Getter untuk nilai rata-rata sebagai double
  double get averageValue {
    return double.tryParse(avg) ?? 0.0;
  }

  // Getter untuk nilai sebagai list double
  List<double> get numericValues {
    return value.map((v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }).toList();
  }

  // Getter untuk nama sensor yang lebih user-friendly
  String get displayName {
    switch (flagSensor.toLowerCase()) {
      case 'suhu':
        return 'Suhu';
      case 'kelembaban':
        return 'Kelembaban';
      case 'suhu_ruang':
        return 'Suhu Ruang';
      case 'kelembaban_ruang':
        return 'Kelembaban Ruang';
      default:
        return flagSensor;
    }
  }

  // Getter untuk unit satuan
  String get unit {
    switch (flagSensor.toLowerCase()) {
      case 'suhu':
      case 'suhu_ruang':
        return '°C';
      case 'kelembaban':
      case 'kelembaban_ruang':
        return '%';
      default:
        return '';
    }
  }
}