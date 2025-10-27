class FermentasiData {
  final bool status;
  final List<SensorData> dataSensor;
  final List<WaktuSensorData> dataWaktuSensor;
  final int statusRuangan;
  final Map<String, dynamic> avg;
  final Map<String, dynamic> averagedData; // DATA YANG SUDAH DI-AVERAGE
  final Map<String, dynamic> sensorInfo;

  FermentasiData({
    required this.status,
    required this.dataSensor,
    required this.dataWaktuSensor,
    required this.statusRuangan,
    required this.avg,
    required this.averagedData,
    required this.sensorInfo,
  });

  factory FermentasiData.fromJson(Map<String, dynamic> json) {
    return FermentasiData(
      status: json['status'] ?? false,
      dataSensor: List<SensorData>.from(
        (json['dataSensor'] as List<dynamic>? ?? [])
            .map((x) => SensorData.fromJson(x)),
      ),
      dataWaktuSensor: List<WaktuSensorData>.from(
        (json['dataWaktuSensor'] as List<dynamic>? ?? [])
            .map((x) => WaktuSensorData.fromJson(x)),
      ),
      statusRuangan: _parseStatusRuangan(json['statusRuangan']),
      avg: Map<String, dynamic>.from(json['avg'] ?? {}),
      averagedData: Map<String, dynamic>.from(json['averaged_data'] ?? {}),
      sensorInfo: Map<String, dynamic>.from(json['sensor_info'] ?? {}),
    );
  }

  // GETTER UNTUK DATA YANG SUDAH DI-AVERAGE
  List<double> get averagedSuhu {
    final suhuData = averagedData['suhu'];
    if (suhuData != null && suhuData['values'] != null) {
      return List<double>.from(
        (suhuData['values'] as List<dynamic>)
            .map((x) => double.tryParse(x.toString()) ?? 0.0),
      );
    }
    return [];
  }

  List<double> get averagedKelembaban {
    final kelembabanData = averagedData['kelembaban'];
    if (kelembabanData != null && kelembabanData['values'] != null) {
      return List<double>.from(
        (kelembabanData['values'] as List<dynamic>)
            .map((x) => double.tryParse(x.toString()) ?? 0.0),
      );
    }
    return [];
  }

  List<String> get averagedWaktuSuhu {
    final suhuData = averagedData['suhu'];
    if (suhuData != null && suhuData['waktu'] != null) {
      return List<String>.from(suhuData['waktu'] ?? []);
    }
    return [];
  }

  List<String> get averagedWaktuKelembaban {
    final kelembabanData = averagedData['kelembaban'];
    if (kelembabanData != null && kelembabanData['waktu'] != null) {
      return List<String>.from(kelembabanData['waktu'] ?? []);
    }
    return [];
  }

  // GETTER UNTUK RATA-RATA GLOBAL
  String get avgSuhu => avg['suhu']?.toString() ?? '0';
  String get avgKelembaban => avg['kelembaban']?.toString() ?? '0';

  // Helper methods untuk sensor individual (jika masih diperlukan)
  SensorData? getSensorByFlag(String flag) {
    try {
      return dataSensor.firstWhere((sensor) => sensor.flagSensor.startsWith(flag));
    } catch (e) {
      print('Sensor data not found for flag: $flag');
      return null;
    }
  }

  WaktuSensorData? getWaktuByFlag(String flag) {
    try {
      return dataWaktuSensor.firstWhere((waktu) => waktu.flagSensor.startsWith(flag));
    } catch (e) {
      print('Sensor time not found for flag: $flag');
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

class SensorData {
  final String type;
  final String flagSensor;
  final List<double> value;
  final double avg;

  SensorData({
    required this.type,
    required this.flagSensor,
    required this.value,
    required this.avg,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      type: json['type'] ?? 'sensor',
      flagSensor: json['flag_sensor'] ?? '',
      value: List<double>.from(
        (json['value'] as List<dynamic>? ?? [])
            .map((x) => double.tryParse(x.toString()) ?? 0.0),
      ),
      avg: double.tryParse(json['avg']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class WaktuSensorData {
  final String type;
  final String flagSensor;
  final List<String> value;

  WaktuSensorData({
    required this.type,
    required this.flagSensor,
    required this.value,
  });

  factory WaktuSensorData.fromJson(Map<String, dynamic> json) {
    return WaktuSensorData(
      type: json['type'] ?? 'waktu',
      flagSensor: json['flag_sensor'] ?? '',
      value: List<String>.from(json['value'] ?? []),
    );
  }
}