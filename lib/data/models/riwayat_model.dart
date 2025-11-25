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
    if (json['status'] == false) {
      return RiwayatData(
        status: false,
        message: json['message'] ?? 'Data tidak ditemukan',
        dataSensor: [],
        namaRuangan: json['namaRuangan'],
      );
    }

    return RiwayatData(
      status: json['status'] ?? true,
      dataSensor: List<RiwayatSensorData>.from(
        (json['dataSensor'] as List<dynamic>? ?? [])
            .map((x) => RiwayatSensorData.fromJson(x)),
      ),
      namaRuangan: json['namaRuangan'],
    );
  }

  RiwayatSensorData? getSensorByFlag(String keyword) {
    try {
      return dataSensor.firstWhere(
        (sensor) => sensor.flagSensor.toLowerCase().contains(keyword.toLowerCase()),
      );
    } catch (e) {
      return null;
    }
  }

  RiwayatSensorData? getSensorSuhu() => getSensorByFlag('suhu');
  RiwayatSensorData? getSensorKelembaban() => getSensorByFlag('kelembaban');

  bool get hasData => dataSensor.isNotEmpty;
}

class RiwayatSensorData {
  final String type;
  final String flagSensor;
  final List<dynamic> value;
  final String avg;
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

  double get averageValue {
    return double.tryParse(avg) ?? 0.0;
  }

  List<double> get numericValues {
    return value.map((v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }).toList();
  }

  String get displayName {
    String lowerFlag = flagSensor.toLowerCase();
    
    if (lowerFlag.contains('suhu')) {
      return flagSensor.replaceAll('_', ' ').capitalize(); 
    } else if (lowerFlag.contains('kelembaban')) {
      return flagSensor.replaceAll('_', ' ').capitalize();
    } else if (lowerFlag.contains('timer')) {
      return 'Timer';
    }
    
    return flagSensor;
  }

  String get unit {
    String lowerFlag = flagSensor.toLowerCase();

    if (lowerFlag.contains('suhu')) {
      return '°C';
    } else if (lowerFlag.contains('kelembaban')) {
      return '%';
    }
    return '';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}