// class PerebusanData {
//   final bool status;
//   final List<SensorData> dataSensor;
//   final List<WaktuSensorData> dataWaktuSensor;
//   final int statusRuangan;

//   PerebusanData({
//     required this.status,
//     required this.dataSensor,
//     required this.dataWaktuSensor,
//     required this.statusRuangan,
//   });

//   factory PerebusanData.fromJson(Map<String, dynamic> json) {
//     return PerebusanData(
//       status: json['status'] ?? false,
//       dataSensor: List<SensorData>.from(
//         (json['dataSensor'] as List<dynamic>? ?? []).map((x) => SensorData.fromJson(x)),
//       ),
//       dataWaktuSensor: List<WaktuSensorData>.from(
//         (json['dataWaktuSensor'] as List<dynamic>? ?? []).map((x) => WaktuSensorData.fromJson(x)),
//       ),
//       statusRuangan: _parseStatusRuangan(json['statusRuangan']),
//     );
//   }

//   // Helper method untuk mendapatkan data sensor berdasarkan flag
//   SensorData? getSensorByFlag(String flag) {
//     try {
//       return dataSensor.firstWhere((sensor) => sensor.flagSensor == flag);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Helper method untuk mendapatkan data waktu berdasarkan flag
//   WaktuSensorData? getWaktuByFlag(String flag) {
//     try {
//       return dataWaktuSensor.firstWhere((waktu) => waktu.flagSensor == flag);
//     } catch (e) {
//       return null;
//     }
//   }

//   static int _parseStatusRuangan(dynamic status) {
//     if (status == null) return 0;
//     if (status is int) return status;
//     if (status is String) return int.tryParse(status) ?? 0;
//     return 0;
//   }
// }

// class SensorData {
//   final String type;
//   final String flagSensor;
//   final List<double> value;
//   final double avg;

//   SensorData({
//     required this.type,
//     required this.flagSensor,
//     required this.value,
//     required this.avg,
//   });

//   factory SensorData.fromJson(Map<String, dynamic> json) {
//     return SensorData(
//       type: json['type'] ?? 'sensor',
//       flagSensor: json['flag_sensor'] ?? '',
//       value: List<double>.from(
//         (json['value'] as List<dynamic>? ?? []).map((x) => double.tryParse(x.toString()) ?? 0.0),
//       ),
//       avg: double.tryParse(json['avg']?.toString() ?? '0') ?? 0.0,
//     );
//   }
// }

// class WaktuSensorData {
//   final String type;
//   final String flagSensor;
//   final List<String> value;

//   WaktuSensorData({
//     required this.type,
//     required this.flagSensor,
//     required this.value,
//   });

//   factory WaktuSensorData.fromJson(Map<String, dynamic> json) {
//     return WaktuSensorData(
//       type: json['type'] ?? 'waktu',
//       flagSensor: json['flag_sensor'] ?? '',
//       value: List<String>.from(json['value'] ?? []),
//     );
//   }
// }

class PerebusanData {
  final bool status;
  final List<SensorData> dataSensor;
  final List<WaktuSensorData> dataWaktuSensor;
  final int statusRuangan;

  PerebusanData({
    required this.status,
    required this.dataSensor,
    required this.dataWaktuSensor,
    required this.statusRuangan,
  });

  factory PerebusanData.fromJson(Map<String, dynamic> json) {
    return PerebusanData(
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
    );
  }

  // Helper method untuk mendapatkan data sensor berdasarkan flag
  SensorData? getSensorByFlag(String flag) {
    try {
      // --- PERBAIKAN ---
      // Menggunakan startsWith agar 'suhu' bisa cocok dengan 'suhu_1'
      return dataSensor
          .firstWhere((sensor) => sensor.flagSensor.startsWith(flag));
    } catch (e) {
      // Tambahkan print untuk debugging jika Anda mau
      print('Sensor data not found for flag: $flag');
      return null;
    }
  }

  // Helper method untuk mendapatkan data waktu berdasarkan flag
  WaktuSensorData? getWaktuByFlag(String flag) {
    try {
      return dataWaktuSensor
          .firstWhere((waktu) => waktu.flagSensor.startsWith(flag));
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