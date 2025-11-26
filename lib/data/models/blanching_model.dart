import 'package:intl/intl.dart';

class BlanchingData {
  final bool status;
  final List<SensorData> dataSensor;
  final List<WaktuSensor> dataWaktuSensor;
  final String statusRuangan;
  final double rataRataSuhu;

  BlanchingData({
    required this.status,
    required this.dataSensor,
    required this.dataWaktuSensor,
    required this.statusRuangan,
    required this.rataRataSuhu,
  });

  factory BlanchingData.fromJson(Map<String, dynamic> json) {
    return BlanchingData(
      status: json['status'] ?? false,
      dataSensor: List<SensorData>.from(
        (json['dataSensor'] as List? ?? []).map(
          (x) => SensorData.fromJson(x as Map<String, dynamic>),
        ),
      ),
      dataWaktuSensor: List<WaktuSensor>.from(
        (json['dataWaktuSensor'] as List? ?? []).map(
          (x) => WaktuSensor.fromJson(x as Map<String, dynamic>),
        ),
      ),
      statusRuangan: json['statusRuangan']?.toString() ?? '0',
      rataRataSuhu:
          double.tryParse(json['rataRataSuhu']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'dataSensor': dataSensor.map((x) => x.toJson()).toList(),
      'dataWaktuSensor': dataWaktuSensor.map((x) => x.toJson()).toList(),
      'statusRuangan': statusRuangan,
      'rataRataSuhu': rataRataSuhu,
    };
  }

  bool get isRoomActive => statusRuangan == '1';

  SensorData? getSensorByFlag(String flag) {
    try {
      return dataSensor.firstWhere((sensor) => sensor.flagSensor == flag);
    } catch (e) {
      return null;
    }
  }

  WaktuSensor? getTimeByFlag(String flag) {
    try {
      return dataWaktuSensor.firstWhere((time) => time.flagSensor == flag);
    } catch (e) {
      return null;
    }
  }

  Map<String, List<Map<String, dynamic>>> getChartData() {
    final Map<String, List<Map<String, dynamic>>> chartData = {};
    final suhu1 = getSensorByFlag('suhu_1');
    final waktu1 = getTimeByFlag('suhu_1');

    if (suhu1 != null && waktu1 != null) {
      chartData['sensor1'] = _combineSensorData(suhu1, waktu1);
    }

    final suhu2 = getSensorByFlag('suhu_2');
    final waktu2 = getTimeByFlag('suhu_2');
    if (suhu2 != null && waktu2 != null) {
      chartData['sensor2'] = _combineSensorData(suhu2, waktu2);
    }

    return chartData;
  }

  List<Map<String, dynamic>> _combineSensorData(
    SensorData suhu,
    WaktuSensor waktu,
  ) {
    final List<Map<String, dynamic>> combinedData = [];

    final length = waktu.value.length;

    for (int i = 0; i < length; i++) {
      combinedData.add({
        'waktu': waktu.value[i],
        'suhu': (i < suhu.value.length) ? suhu.value[i] : 0.0,
        'stddev_suhu': suhu.stddev.isNotEmpty && i < suhu.stddev.length
            ? suhu.stddev[i]
            : null,
      });
    }

    return combinedData.reversed.toList();
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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'flag_sensor': flagSensor,
      'value': value,
      'avg': avg,
      'stddev': stddev.map((x) => x.toList()).toList(),
    };
  }

  double get latestValue {
    if (value.isEmpty) return 0.0;
    return value.first;
  }

  double get minValue {
    if (value.isEmpty) return 0.0;
    return value.reduce((a, b) => a < b ? a : b);
  }

  double get maxValue {
    if (value.isEmpty) return 0.0;
    return value.reduce((a, b) => a > b ? a : b);
  }

  bool get isTemperatureSensor => flagSensor.toLowerCase().contains('suhu');
}

// --- WAKTU SENSOR ---
class WaktuSensor {
  final String type;
  final String flagSensor;
  final List<String> value;

  WaktuSensor({
    required this.type,
    required this.flagSensor,
    required this.value,
  });

  factory WaktuSensor.fromJson(Map<String, dynamic> json) {
    return WaktuSensor(
      type: json['type'] ?? 'waktu',
      flagSensor: json['flag_sensor'] ?? '',
      value: List<String>.from(
        (json['value'] as List? ?? []).map((x) => x.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'flag_sensor': flagSensor, 'value': value};
  }
}

// --- STD DEV DATA (Baru: Konsisten dengan Fermentasi) ---
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

// --- TIMER DATA (Tidak Berubah) ---
class TimerData {
  final bool status;
  final String statusTimer;
  final double sisaTimer;

  TimerData({
    required this.status,
    required this.statusTimer,
    required this.sisaTimer,
  });

  factory TimerData.fromJson(Map<String, dynamic> json) {
    return TimerData(
      status: json['status'] ?? false,
      statusTimer: json['status_timer'] ?? 'stop',
      sisaTimer: double.tryParse(json['sisa_timer']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_timer': statusTimer,
      'sisa_timer': sisaTimer,
    };
  }

  bool get isRunning => statusTimer == 'start';
}

class TimerDetail {
  final String flagSensor;
  final String flagTimer;
  final String nilaiTimer;
  final String limitTimer;
  double sisaTimer;
  final String updatedAt;

  TimerDetail({
    required this.flagSensor,
    required this.flagTimer,
    required this.nilaiTimer,
    required this.limitTimer,
    required this.sisaTimer,
    required this.updatedAt,
  });

  factory TimerDetail.fromJson(Map<String, dynamic> json) {
    return TimerDetail(
      flagSensor: json['flag_sensor'] ?? '',
      flagTimer: json['flag_timer'] ?? 'stop',
      nilaiTimer: json['nilai_timer']?.toString() ?? '0',
      limitTimer: json['limit_timer']?.toString() ?? '0',
      sisaTimer: double.tryParse(json['sisa_timer']?.toString() ?? '0') ?? 0.0,
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flag_sensor': flagSensor,
      'flag_timer': flagTimer,
      'nilai_timer': nilaiTimer,
      'limit_timer': limitTimer,
      'sisa_timer': sisaTimer,
      'updated_at': updatedAt,
    };
  }

  bool get isRunning => flagTimer == 'start';

  double get limitTimerAsDouble => double.tryParse(limitTimer) ?? 0.0;

  double get progress {
    if (limitTimerAsDouble == 0) return 0.0;
    return (sisaTimer / limitTimerAsDouble).clamp(0.0, 1.0);
  }

  String get formattedRemainingTime {
    final seconds = sisaTimer.toInt();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String get formattedStartTime {
    try {
      double timestampDouble = double.tryParse(nilaiTimer) ?? 0.0;
      int timestamp = timestampDouble.toInt();

      if (timestamp == 0) return '-';

      final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('HH:mm:ss').format(date);
    } catch (e) {
      return '-';
    }
  }

  String get formattedEndTime {
    try {
      double startTsDouble = double.tryParse(nilaiTimer) ?? 0.0;
      double limitDouble = double.tryParse(limitTimer) ?? 0.0;

      int startTs = startTsDouble.toInt();
      int limit = limitDouble.toInt();

      if (startTs == 0 || limit == 0) return '-';

      final date = DateTime.fromMillisecondsSinceEpoch(
        (startTs + limit) * 1000,
      );
      return DateFormat('HH:mm:ss').format(date);
    } catch (e) {
      return '-';
    }
  }
}

class TimerResponse {
  final bool status;
  final List<TimerDetail> dataTimer;

  TimerResponse({required this.status, required this.dataTimer});

  factory TimerResponse.fromJson(Map<String, dynamic> json) {
    return TimerResponse(
      status: json['status'] ?? false,
      dataTimer: List<TimerDetail>.from(
        (json['dataTimer'] as List? ?? []).map((x) => TimerDetail.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'dataTimer': dataTimer.map((x) => x.toJson()).toList(),
    };
  }

  TimerDetail? getTimerByFlag(String flag) {
    try {
      return dataTimer.firstWhere((timer) => timer.flagSensor == flag);
    } catch (e) {
      return null;
    }
  }
}
