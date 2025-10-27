import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/data/models/fermentasi_model.dart';
import 'package:iotmcc_mobile/data/repositories/fermentasi_repository.dart';

class FermentasiProvider extends ChangeNotifier {
  final FermentasiRepository repository;
  FermentasiProvider(this.repository);

  FermentasiData? _data;
  FermentasiData? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // GUNAKAN DATA YANG SUDAH DI-AVERAGE DARI API
  List<double> get dataSuhu => _data?.averagedSuhu ?? [];
  List<double> get dataKelembaban => _data?.averagedKelembaban ?? [];
  List<String> get dataWaktuSuhu => _data?.averagedWaktuSuhu ?? [];
  List<String> get dataWaktuKelembaban => _data?.averagedWaktuKelembaban ?? [];
  
  // RATA-RATA GLOBAL DARI API - SUDAH BENAR
  String get dataAvgSuhu => _data?.avgSuhu ?? '0';
  String get dataAvgKelembaban => _data?.avgKelembaban ?? '0';

  // DATA UNTUK GRAFIK 1 JAM TERAKHIR
  List<double> get dataSuhu1Jam => _getData1Jam(dataSuhu, dataWaktuSuhu);
  List<double> get dataKelembaban1Jam => _getData1Jam(dataKelembaban, dataWaktuKelembaban);
  List<String> get dataWaktu1Jam => _getWaktu1Jam(dataWaktuSuhu);

  // METHOD UNTUK FILTER DATA 1 JAM TERAKHIR
  List<double> _getData1Jam(List<double> data, List<String> waktu) {
    if (data.isEmpty || waktu.isEmpty) return [];
    
    final now = DateTime.now();
    final satuJamLalu = now.subtract(const Duration(hours: 1));
    
    List<double> result = [];
    
    for (int i = 0; i < waktu.length; i++) {
      final waktuData = _parseTimeString(waktu[i]);
      if (waktuData != null && waktuData.isAfter(satuJamLalu)) {
        result.add(data[i]);
      }
    }
    
    return result;
  }

  List<String> _getWaktu1Jam(List<String> waktu) {
    if (waktu.isEmpty) return [];
    
    final now = DateTime.now();
    final satuJamLalu = now.subtract(const Duration(hours: 1));
    
    List<String> result = [];
    
    for (int i = 0; i < waktu.length; i++) {
      final waktuData = _parseTimeString(waktu[i]);
      if (waktuData != null && waktuData.isAfter(satuJamLalu)) {
        result.add(waktu[i]);
      }
    }
    
    return result;
  }

  DateTime? _parseTimeString(String timeStr) {
    try {
      final now = DateTime.now();
      final parts = timeStr.split(':');
      if (parts.length == 3) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final second = int.parse(parts[2]);
        
        return DateTime(now.year, now.month, now.day, hour, minute, second);
      }
    } catch (e) {
      print('Error parsing time: $timeStr');
    }
    return null;
  }

  // INFO SENSOR
  int get totalSensors => _data?.sensorInfo['total_sensors'] ?? 0;

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
      } else {
        // Debug info
        print('Data suhu averaged: ${_data!.averagedSuhu}');
        print('Data kelembaban averaged: ${_data!.averagedKelembaban}');
        print('Waktu suhu: ${_data!.averagedWaktuSuhu}');
        print('Rata-rata suhu: ${_data!.avgSuhu}');
        print('Rata-rata kelembaban: ${_data!.avgKelembaban}');
        print('Data 1 jam - Suhu: ${dataSuhu1Jam.length} data');
        print('Data 1 jam - Kelembaban: ${dataKelembaban1Jam.length} data');
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
}