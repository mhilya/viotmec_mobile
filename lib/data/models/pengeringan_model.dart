class PengeringanData {
  final bool status;
  final List<SensorData> dataSensor;
  final List<WaktuSensorData> dataWaktuSensor;
  final int statusRuangan;
  final List<BlowerMeta> listBlower;
  final String currentSuhu;
  final String currentKelembaban;

  PengeringanData({
    required this.status,
    required this.dataSensor,
    required this.dataWaktuSensor,
    required this.statusRuangan,
    required this.listBlower,
    required this.currentSuhu,
    required this.currentKelembaban,
  });

  factory PengeringanData.fromJson(Map<String, dynamic> json) {
    return PengeringanData(
      status: json['status'] ?? false,
      dataSensor: List<SensorData>.from(
        (json['dataSensor'] as List<dynamic>? ?? []).map(
          (x) => SensorData.fromJson(x as Map<String, dynamic>),
        ),
      ),
      dataWaktuSensor: List<WaktuSensorData>.from(
        (json['dataWaktuSensor'] as List<dynamic>? ?? []).map(
          (x) => WaktuSensorData.fromJson(x as Map<String, dynamic>),
        ),
      ),
      statusRuangan: _parseStatusRuangan(json['statusRuangan']),
      listBlower: List<BlowerMeta>.from(
        (json['listBlower'] as List<dynamic>? ?? []).map(
          (x) => BlowerMeta.fromJson(x),
        ),
      ),
      currentSuhu: json['currentSuhu']?.toString() ?? '0',
      currentKelembaban: json['currentKelembaban']?.toString() ?? '0',
    );
  }

  SensorData? getSensorByFlag(String flag) {
    try {
      return dataSensor.firstWhere((sensor) => sensor.flagSensor == flag);
    } catch (e) {
      return null;
    }
  }

  WaktuSensorData? getWaktuByFlag(String flag) {
    try {
      return dataWaktuSensor.firstWhere((waktu) => waktu.flagSensor == flag);
    } catch (e) {
      return null;
    }
  }

  Map<String, List<Map<String, dynamic>>> getChartData() {
    final Map<String, List<Map<String, dynamic>>> chartData = {};

    final suhu1 = getSensorByFlag('suhu_1');
    final kelembaban1 = getSensorByFlag('kelembaban_1');
    final waktu1 = getWaktuByFlag('suhu_1');

    if (suhu1 != null && kelembaban1 != null && waktu1 != null) {
      chartData['sensor1'] = _combineSensorData(suhu1, kelembaban1, waktu1);
    }

    final suhu2 = getSensorByFlag('suhu_2');
    final kelembaban2 = getSensorByFlag('kelembaban_2');
    final waktu2 = getWaktuByFlag('suhu_2');

    if (suhu2 != null && kelembaban2 != null && waktu2 != null) {
      chartData['sensor2'] = _combineSensorData(suhu2, kelembaban2, waktu2);
    }

    return chartData;
  }

  List<Map<String, dynamic>> _combineSensorData(
    SensorData suhu,
    SensorData kelembaban,
    WaktuSensorData waktu,
  ) {
    final List<Map<String, dynamic>> combinedData = [];

    final minLength = [
      suhu.value.length,
      kelembaban.value.length,
      waktu.value.length,
    ].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < minLength; i++) {
      combinedData.add({
        'waktu': waktu.value[i],
        'suhu': suhu.value[i],
        'kelembaban': kelembaban.value[i],
        'stddev_suhu': suhu.stddev.isNotEmpty && i < suhu.stddev.length
            ? suhu.stddev[i]
            : null,
        'stddev_kelembaban':
            kelembaban.stddev.isNotEmpty && i < kelembaban.stddev.length
            ? kelembaban.stddev[i]
            : null,
      });
    }

    return combinedData.reversed.toList();
  }

  double get avgSuhu1 => getSensorByFlag('suhu_1')?.avg ?? 0.0;
  double get avgKelembaban1 => getSensorByFlag('kelembaban_1')?.avg ?? 0.0;
  double get avgSuhu2 => getSensorByFlag('suhu_2')?.avg ?? 0.0;
  double get avgKelembaban2 => getSensorByFlag('kelembaban_2')?.avg ?? 0.0;

  List<StdDevData> get stddevSuhu1 => getSensorByFlag('suhu_1')?.stddev ?? [];
  List<StdDevData> get stddevKelembaban1 =>
      getSensorByFlag('kelembaban_1')?.stddev ?? [];
  List<StdDevData> get stddevSuhu2 => getSensorByFlag('suhu_2')?.stddev ?? [];
  List<StdDevData> get stddevKelembaban2 =>
      getSensorByFlag('kelembaban_2')?.stddev ?? [];

  double get latestSuhu1 {
    final sensor = getSensorByFlag('suhu_1');
    return (sensor != null && sensor.value.isNotEmpty)
        ? sensor.value.first
        : 0.0;
  }

  double get latestKelembaban1 {
    final sensor = getSensorByFlag('kelembaban_1');
    return (sensor != null && sensor.value.isNotEmpty)
        ? sensor.value.first
        : 0.0;
  }

  double get latestSuhu2 {
    final sensor = getSensorByFlag('suhu_2');
    return (sensor != null && sensor.value.isNotEmpty)
        ? sensor.value.first
        : 0.0;
  }

  double get latestKelembaban2 {
    final sensor = getSensorByFlag('kelembaban_2');
    return (sensor != null && sensor.value.isNotEmpty)
        ? sensor.value.first
        : 0.0;
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
  final List<StdDevData> stddev;

  SensorData({
    required this.type,
    required this.flagSensor,
    required this.value,
    required this.avg,
    required this.stddev,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      type: json['type'] ?? 'sensor',
      flagSensor: json['flag_sensor'] ?? '',
      value: List<double>.from(
        (json['value'] as List<dynamic>? ?? []).map(
          (x) => double.tryParse(x.toString()) ?? 0.0,
        ),
      ),
      avg: double.tryParse(json['avg']?.toString() ?? '0') ?? 0.0,
      stddev: List<StdDevData>.from(
        (json['stddev'] as List<dynamic>? ?? []).map(
          (x) => StdDevData.fromJson(x),
        ),
      ),
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

class StdDevData {
  final int timestamp;
  final double value;

  StdDevData({required this.timestamp, required this.value});

  factory StdDevData.fromJson(dynamic json) {
    if (json is List && json.length >= 2) {
      return StdDevData(
        timestamp: json[0] is int
            ? json[0]
            : int.tryParse(json[0].toString()) ?? 0,
        value: double.tryParse(json[1].toString()) ?? 0.0,
      );
    }
    return StdDevData(timestamp: 0, value: 0.0);
  }

  List<dynamic> toList() => [timestamp, value.toString()];
}

class BlowerMeta {
  final String idSensor;
  final String flagSensor;

  BlowerMeta({required this.idSensor, required this.flagSensor});

  factory BlowerMeta.fromJson(Map<String, dynamic> json) {
    return BlowerMeta(
      idSensor: json['id_sensor']?.toString() ?? '',
      flagSensor: json['flag_sensor']?.toString() ?? '',
    );
  }
}

class BlowerStatusModel {
  final bool status;
  final String message;
  final BlowerData? data;

  BlowerStatusModel({required this.status, required this.message, this.data});

  factory BlowerStatusModel.fromJson(Map<String, dynamic> json) {
    return BlowerStatusModel(
      status: json['status'] ?? false,
      message: json['msg'] ?? '',
      data: json['data'] != null ? BlowerData.fromJson(json['data']) : null,
    );
  }
}

// Untuk toggleBlower
class BlowerToggleModel {
  final bool status;
  final String message;
  final String newValue;

  BlowerToggleModel({
    required this.status,
    required this.message,
    required this.newValue,
  });

  factory BlowerToggleModel.fromJson(Map<String, dynamic> json) {
    return BlowerToggleModel(
      status: json['status'] ?? false,
      message: json['msg'] ?? '',
      newValue: json['nilai_baru']?.toString() ?? '0',
    );
  }
}

class BlowerData {
  final String sensorId;
  final String sensorValue;
  final bool isActive;

  BlowerData({
    required this.sensorId,
    required this.sensorValue,
    required this.isActive,
  });

  factory BlowerData.fromJson(Map<String, dynamic> json) {
    return BlowerData(
      sensorId: json['id_sensor']?.toString() ?? "",
      sensorValue: json['nilai_sensor']?.toString() ?? "0",
      isActive: json['is_active'] ?? false,
    );
  }
}
