class RiwayatData {
  final bool status;
  final String namaRuangan;
  final int statusRuangan;
  final List<RiwayatSensorData> dataSensor;
  final String? message; // Untuk pesan error 'Data tidak ditemukan'

  RiwayatData({
    required this.status,
    required this.namaRuangan,
    required this.statusRuangan,
    required this.dataSensor,
    this.message,
  });

  factory RiwayatData.fromJson(Map<String, dynamic> json) {
    // Cek jika status false, kemungkinan besar itu pesan error
    if (json['status'] == false) {
      return RiwayatData(
        status: false,
        namaRuangan: '',
        statusRuangan: 0,
        dataSensor: [],
        message: json['msg'] ?? 'Data tidak ditemukan',
      );
    }

    return RiwayatData(
      status: json['status'] ?? false,
      namaRuangan: json['namaRuangan'] ?? '',
      statusRuangan: _parseStatusRuangan(json['statusRuangan']),
      dataSensor: List<RiwayatSensorData>.from(
        (json['dataSensor'] as List<dynamic>? ?? [])
            .map((x) => RiwayatSensorData.fromJson(x)),
      ),
    );
  }

  // Helper untuk mencari sensor berdasarkan flag
  RiwayatSensorData? getSensorByFlag(String flag) {
    try {
      return dataSensor
          .firstWhere((sensor) => sensor.flagSensor.startsWith(flag));
    } catch (e) {
      return null;
    }
  }

  static int _parseStatusRuangan(dynamic status) {
    if (status == null) return 0;
    if (status is int) return status;
    if (status is String) return int.tryParse(status) ?? 0;
    return 0;
  }
}

class RiwayatSensorData {
  final String type;
  final String flagSensor;
  final List<double> value;
  final double avg;
  final List<String> timeLabel; // Sumbu X untuk chart

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
      // Konversi list 'value' dari String ke Double
      value: List<double>.from(
        (json['value'] as List<dynamic>? ?? [])
            .map((x) => double.tryParse(x.toString()) ?? 0.0),
      ),
      // Konversi 'avg' dari String ke Double
      avg: double.tryParse(json['avg']?.toString() ?? '0') ?? 0.0,
      // 'time_label' sudah benar sebagai List<String>
      timeLabel: List<String>.from(json['time_label'] ?? []),
    );
  }
}