// // class FermentasiData {
// //   final bool status;
// //   final List<double> dataSuhu;
// //   final List<double> dataKelembaban;
// //   final List<String> dataWaktuSuhu;
// //   final List<String> dataWaktuKelembaban;
// //   final String dataAvgSuhu;
// //   final String dataAvgKelembaban;
// //   final String? dataTimer;
// //   // GANTI: Dibuat nullable karena API tidak selalu mengirimkannya
// //   final int? statusRuangan; 

// //   FermentasiData({
// //     required this.status,
// //     required this.dataSuhu,
// //     required this.dataKelembaban,
// //     required this.dataWaktuSuhu,
// //     required this.dataWaktuKelembaban,
// //     required this.dataAvgSuhu,
// //     required this.dataAvgKelembaban,
// //     this.dataTimer,
// //     this.statusRuangan, // Disesuaikan
// //   });

// //   factory FermentasiData.fromJson(Map<String, dynamic> json) {
// //     return FermentasiData(
// //       status: json['status'] ?? false,
// //       dataSuhu: List<double>.from(json['dataSuhu']?.map((x) => double.tryParse(x.toString()) ?? 0.0) ?? []),
// //       dataKelembaban: List<double>.from(json['dataKelembaban']?.map((x) => double.tryParse(x.toString()) ?? 0.0) ?? []),
// //       dataWaktuSuhu: List<String>.from(json['dataWaktuSuhu'] ?? []),
// //       dataWaktuKelembaban: List<String>.from(json['dataWaktuKelembaban'] ?? []),
// //       dataAvgSuhu: json['dataAvgSuhu']?.toString() ?? '0',
// //       dataAvgKelembaban: json['dataAvgKelembaban']?.toString() ?? '0',
// //       dataTimer: json['dataTimer']?.toString(),
// //       // GANTI: Gunakan parser yang aman, karena field ini mungkin tidak ada
// //       statusRuangan: _parseStatusRuangan(json['statusRuangan']),
// //     );
// //   }

// //   static int? _parseStatusRuangan(dynamic status) {
// //     if (status == null) return null; // Kembalikan null jika tidak ada
// //     if (status is int) return status;
// //     if (status is String) return int.tryParse(status);
// //     return null;
// //   }
// // }

// // fermentasi_model.dart
// class FermentasiData {
//   final bool status;
//   final List<SensorData> dataSensor;
//   final List<WaktuSensorData> dataWaktuSensor;
//   final int statusRuangan;

//   FermentasiData({
//     required this.status,
//     required this.dataSensor,
//     required this.dataWaktuSensor,
//     required this.statusRuangan,
//   });

//   factory FermentasiData.fromJson(Map<String, dynamic> json) {
//     return FermentasiData(
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

//     static int _parseStatusRuangan(dynamic status) {
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

// fermentasi_model.dart
class FermentasiData {
  final bool status;
  final List<SensorData> dataSensor;
  final List<WaktuSensorData> dataWaktuSensor;
  final int statusRuangan;

  FermentasiData({
    required this.status,
    required this.dataSensor,
    required this.dataWaktuSensor,
    required this.statusRuangan,
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
    );
  }

  // Helper method untuk mendapatkan data sensor berdasarkan flag
  SensorData? getSensorByFlag(String flag) {
    try {
      // PERUBAHAN: Menggunakan startsWith untuk mencocokkan 'suhu' dengan 'suhu_1'
      return dataSensor.firstWhere((sensor) => sensor.flagSensor.startsWith(flag));
    } catch (e) {
      // Jika tidak ada sensor yang cocok (misal 'suhu_1' tidak ada), kembalikan null
      print('Sensor data not found for flag: $flag');
      return null;
    }
  }

  // Helper method untuk mendapatkan data waktu berdasarkan flag
  WaktuSensorData? getWaktuByFlag(String flag) {
    try {
      // PERUBAHAN: Menggunakan startsWith untuk mencocokkan 'suhu' dengan 'suhu_1'
      return dataWaktuSensor.firstWhere((waktu) => waktu.flagSensor.startsWith(flag));
    } catch (e) {
      // Jika tidak ada data waktu yang cocok, kembalikan null
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
      // PERBAIKAN PARSING: API mengirim 'avg' sebagai string
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
