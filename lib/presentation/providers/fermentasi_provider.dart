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

  // Data yang diformat khusus untuk UI
  List<double> get dataSuhu => 
      _data?.getSensorByFlag('suhu')?.value ?? [];
  
  List<double> get dataKelembaban => 
      _data?.getSensorByFlag('kelembaban')?.value ?? [];
  
  List<String> get dataWaktuSuhu => 
      _data?.getWaktuByFlag('suhu')?.value ?? [];
  
  List<String> get dataWaktuKelembaban => 
      _data?.getWaktuByFlag('kelembaban')?.value ?? [];
  
  String get dataAvgSuhu => 
      (_data?.getSensorByFlag('suhu')?.avg.toStringAsFixed(1)) ?? '0';
  
  String get dataAvgKelembaban => 
      (_data?.getSensorByFlag('kelembaban')?.avg.toStringAsFixed(1)) ?? '0';

  int get totalSensors => _data?.dataSensor.length ?? 0;

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
}
