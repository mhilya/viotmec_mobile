class FermentasiData {
  final bool status;
  final List<SensorData> dataSensor;
  final List<WaktuSensorData> dataWaktuSensor;
  final int statusRuangan;
  final String currentSuhu;
  final String currentKelembaban;

  FermentasiData({
    required this.status,
    required this.dataSensor,
    required this.dataWaktuSensor,
    required this.statusRuangan,
    required this.currentSuhu,
    required this.currentKelembaban,
  });

  factory FermentasiData.fromJson(Map<String, dynamic> json) {
    return FermentasiData(
      status: json['status'] ?? false,
      dataSensor: List<SensorData>.from(
        (json['dataSensor'] as List<dynamic>? ?? [])
            .map((x) => SensorData.fromJson(x as Map<String, dynamic>)),
      ),
      dataWaktuSensor: List<WaktuSensorData>.from(
        (json['dataWaktuSensor'] as List<dynamic>? ?? [])
            .map((x) => WaktuSensorData.fromJson(x as Map<String, dynamic>)),
      ),
      statusRuangan: _parseStatusRuangan(json['statusRuangan']),
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
      SensorData suhu, SensorData kelembaban, WaktuSensorData waktu) {
    final List<Map<String, dynamic>> combinedData = [];

    final minLength = [suhu.value.length, kelembaban.value.length, waktu.value.length]
        .reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < minLength; i++) {
      combinedData.add({
        'waktu': waktu.value[i],
        'suhu': suhu.value[i],
        'kelembaban': kelembaban.value[i],
        'stddev_suhu': suhu.stddev.isNotEmpty && i < suhu.stddev.length 
            ? suhu.stddev[i] 
            : null,
        'stddev_kelembaban': kelembaban.stddev.isNotEmpty && i < kelembaban.stddev.length
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
  List<StdDevData> get stddevKelembaban1 => getSensorByFlag('kelembaban_1')?.stddev ?? [];
  List<StdDevData> get stddevSuhu2 => getSensorByFlag('suhu_2')?.stddev ?? [];
  List<StdDevData> get stddevKelembaban2 => getSensorByFlag('kelembaban_2')?.stddev ?? [];

  double get latestSuhu1 => getSensorByFlag('suhu_1')?.value.first ?? 0.0;
  double get latestKelembaban1 => getSensorByFlag('kelembaban_1')?.value.first ?? 0.0;
  double get latestSuhu2 => getSensorByFlag('suhu_2')?.value.first ?? 0.0;
  double get latestKelembaban2 => getSensorByFlag('kelembaban_2')?.value.first ?? 0.0;

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
        (json['value'] as List<dynamic>? ?? [])
            .map((x) => double.tryParse(x.toString()) ?? 0.0),
      ),
      avg: double.tryParse(json['avg']?.toString() ?? '0') ?? 0.0,
      stddev: List<StdDevData>.from(
        (json['stddev'] as List<dynamic>? ?? [])
            .map((x) => StdDevData.fromJson(x)),
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

  StdDevData({
    required this.timestamp,
    required this.value,
  });

  factory StdDevData.fromJson(dynamic json) {
    if (json is List && json.length >= 2) {
      return StdDevData(
        timestamp: json[0] is int ? json[0] : int.tryParse(json[0].toString()) ?? 0,
        value: double.tryParse(json[1].toString()) ?? 0.0,
      );
    }
    return StdDevData(timestamp: 0, value: 0.0);
  }

  List<dynamic> toList() => [timestamp, value.toString()];
}