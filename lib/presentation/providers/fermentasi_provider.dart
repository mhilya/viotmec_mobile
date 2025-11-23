import 'package:flutter/material.dart';
import 'package:viotmec_mobile/data/models/fermentasi_model.dart';
import 'package:viotmec_mobile/data/repositories/fermentasi_repository.dart';

class FermentasiProvider extends ChangeNotifier {
  final FermentasiRepository repository;
  FermentasiProvider(this.repository);

  FermentasiData? _data;
  FermentasiData? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

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
    final chartData = _data?.getChartData();
    final sensor1 = chartData?['sensor1'] ?? [];
    final sensor2 = chartData?['sensor2'] ?? [];
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
      print('Error parsing time: $timeStr, error: $e');
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

  Future<void> fetchData(String? gudangId) async {
    if (gudangId == null || gudangId.isEmpty) {
      _errorMessage = 'Gudang ID tidak valid';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _data = await repository.getFermentasiData(gudangId);
      if (_data == null) {
        _errorMessage = 'Data tidak ditemukan';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _data = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _data = null;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> refreshData(String? gudangId) async {
    await fetchData(gudangId);
  }

  bool get hasData => _data != null;
  bool get hasChartData =>
      chartDataSensor1.isNotEmpty || chartDataSensor2.isNotEmpty;
  bool get hasSensor1Data => chartDataSensor1.isNotEmpty;
  bool get hasSensor2Data => chartDataSensor2.isNotEmpty;
}
