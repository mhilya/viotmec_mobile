import 'package:flutter/material.dart';
import 'package:viotmec_mobile/data/models/pengeringan_model.dart';
import 'package:viotmec_mobile/data/repositories/pengeringan_repository.dart';

class PengeringanProvider extends ChangeNotifier {
  final PengeringanRepository repository;

  PengeringanProvider(this.repository);

  PengeringanData? _data;
  PengeringanData? get data => _data;

  BlowerStatusModel? _blowerData;
  BlowerStatusModel? get blowerData => _blowerData;

  String? _blowerSensorId;
  String? get blowerSensorId => _blowerSensorId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final Map<String, BlowerStatusModel> _blowersData = {};
  final Map<String, bool> _blowerTogglingStates = {};

  List<BlowerMeta> get availableBlowers => _data?.listBlower ?? [];

  String get currentSuhu => _data?.currentSuhu ?? '0';
  String get currentKelembaban => _data?.currentKelembaban ?? '0';

  double get avgSuhu1 => _data?.avgSuhu1 ?? 0.0;
  double get avgKelembaban1 => _data?.avgKelembaban1 ?? 0.0;
  double get avgSuhu2 => _data?.avgSuhu2 ?? 0.0;
  double get avgKelembaban2 => _data?.avgKelembaban2 ?? 0.0;

  double get latestSuhu1 => _data?.latestSuhu1 ?? 0.0;
  double get latestKelembaban1 => _data?.latestKelembaban1 ?? 0.0;
  double get latestSuhu2 => _data?.latestSuhu2 ?? 0.0;
  double get latestKelembaban2 => _data?.latestKelembaban2 ?? 0.0;

  int get statusRuangan => _data?.statusRuangan ?? 0;

  List<Map<String, dynamic>> get chartDataSensor1 {
    final chartData = _data?.getChartData();
    return chartData?['sensor1'] ?? [];
  }

  List<Map<String, dynamic>> get chartDataSensor2 {
    final chartData = _data?.getChartData();
    return chartData?['sensor2'] ?? [];
  }

  List<Map<String, dynamic>> get allChartData {
    final sensor1 = chartDataSensor1;
    final sensor2 = chartDataSensor2;
    return [...sensor1, ...sensor2];
  }

  List<Map<String, dynamic>> get chartDataSensor11Jam =>
      _getData1Jam(chartDataSensor1);
  List<Map<String, dynamic>> get chartDataSensor21Jam =>
      _getData1Jam(chartDataSensor2);
  List<Map<String, dynamic>> get allChartData1Jam => _getData1Jam(allChartData);

  List<Map<String, dynamic>> _getData1Jam(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return [];
    final now = DateTime.now();
    final satuJamLalu = now.subtract(const Duration(hours: 1));
    return data.where((item) {
      final waktuData = _parseTimeString(item['waktu']?.toString() ?? '');
      return waktuData != null && waktuData.isAfter(satuJamLalu);
    }).toList();
  }

  DateTime? _parseTimeString(String timeStr) {
    try {
      final now = DateTime.now();
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  List<double> getSuhuValues(List<Map<String, dynamic>> chartData) {
    return chartData.map((item) => (item['suhu'] as double? ?? 0.0)).toList();
  }

  List<double> getKelembabanValues(List<Map<String, dynamic>> chartData) {
    return chartData
        .map((item) => (item['kelembaban'] as double? ?? 0.0))
        .toList();
  }

  List<String> getWaktuValues(List<Map<String, dynamic>> chartData) {
    return chartData.map((item) => (item['waktu']?.toString() ?? '')).toList();
  }

  List<String> referenceList(
    List<Map<String, dynamic>> sensor1Data,
    List<Map<String, dynamic>> sensor2Data,
  ) {
    return sensor1Data.length >= sensor2Data.length
        ? getWaktuValues(sensor1Data)
        : getWaktuValues(sensor2Data);
  }

  List<StdDevData> get stddevSuhu1 => _data?.stddevSuhu1 ?? [];
  List<StdDevData> get stddevKelembaban1 => _data?.stddevKelembaban1 ?? [];
  List<StdDevData> get stddevSuhu2 => _data?.stddevSuhu2 ?? [];
  List<StdDevData> get stddevKelembaban2 => _data?.stddevKelembaban2 ?? [];

  List<List<dynamic>> get stddevSuhu1AsList =>
      stddevSuhu1.map((stddev) => stddev.toList()).toList();
  List<List<dynamic>> get stddevKelembaban1AsList =>
      stddevKelembaban1.map((stddev) => stddev.toList()).toList();
  List<List<dynamic>> get stddevSuhu2AsList =>
      stddevSuhu2.map((stddev) => stddev.toList()).toList();
  List<List<dynamic>> get stddevKelembaban2AsList =>
      stddevKelembaban2.map((stddev) => stddev.toList()).toList();

  SensorData? getSensorData(String flag) => _data?.getSensorByFlag(flag);
  WaktuSensorData? getWaktuData(String flag) => _data?.getWaktuByFlag(flag);

  int get totalDataPoints => allChartData.length;
  int get totalDataPoints1Jam => allChartData1Jam.length;

  List<double> get suhu1Values => getSensorData('suhu_1')?.value ?? [];
  List<double> get kelembaban1Values =>
      getSensorData('kelembaban_1')?.value ?? [];
  List<double> get suhu2Values => getSensorData('suhu_2')?.value ?? [];
  List<double> get kelembaban2Values =>
      getSensorData('kelembaban_2')?.value ?? [];

  bool isBlowerActive(String sensorId) {
    return _blowersData[sensorId]?.data?.isActive ?? false;
  }

  bool isBlowerToggling(String sensorId) {
    return _blowerTogglingStates[sensorId] ?? false;
  }

  Future<void> fetchData(String? gudangId) async {
    if (gudangId == null || gudangId.isEmpty) {
      _errorMessage = 'Gudang ID tidak valid';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _data = await repository.getPengeringanData(gudangId);

      if (_data == null) {
        _errorMessage = 'Data tidak ditemukan';
      } else {
        if (_data!.listBlower.isNotEmpty) {
          for (var blower in _data!.listBlower) {
            fetchBlowerData(blower.idSensor);
          }
        }
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _data = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBlowerData(String sensorId) async {
    if (sensorId.isEmpty) return;

    try {
      final result = await repository.getDataStatusBlower(sensorId);

      if (result.status && result.data != null) {
        _blowersData[sensorId] = result;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Mengembalikan Future<bool> agar UI bisa tau sukses/gagal
  Future<bool> toggleBlower(String sensorId) async {
    if (isBlowerToggling(sensorId)) return false;

    _blowerTogglingStates[sensorId] = true;
    notifyListeners();

    bool isSuccess = false;

    try {
      final result = await repository.toggleBlower(sensorId);

      if (result.status) {
        final bool newActiveStatus = result.newValue == '1';

        _blowersData[sensorId] = BlowerStatusModel(
          status: true,
          message: result.message,
          data: BlowerData(
            sensorId: sensorId,
            sensorValue: result.newValue,
            isActive: newActiveStatus,
          ),
        );
        isSuccess = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _blowerTogglingStates[sensorId] = false;
      notifyListeners();
    }
    
    return isSuccess;
  }

  void clearData() {
    _data = null;
    _blowersData.clear();
    _blowerTogglingStates.clear();
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> refreshData(String? gudangId) async {
    if (gudangId == null || gudangId.isEmpty) return;

    try {
      final newData = await repository.getPengeringanData(gudangId);
      if (newData != null) {
        _data = newData;

        if (_data!.listBlower.isNotEmpty) {
          for (var blower in _data!.listBlower) {
            fetchBlowerData(blower.idSensor);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool get hasData => _data != null;
  bool get hasChartData =>
      chartDataSensor1.isNotEmpty || chartDataSensor2.isNotEmpty;
  bool get hasSensor1Data => chartDataSensor1.isNotEmpty;
  bool get hasSensor2Data => chartDataSensor2.isNotEmpty;
}