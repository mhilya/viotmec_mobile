import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/data/models/perebusan_model.dart';
import 'package:iotmcc_mobile/data/repositories/perebusan_repository.dart';

// class PerebusanProvider extends ChangeNotifier {
//   final PerebusanRepository repository;
//   PerebusanProvider(this.repository);

//   PerebusanData? _data;
//   PerebusanData? get data => _data;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String _errorMessage = '';
//   String get errorMessage => _errorMessage;

//   Future<void> fetchData(String? gudangId) async {
//     if (gudangId == null) {
//       _errorMessage = 'Gudang ID tidak tersedia';
//       _isLoading = false;
//       notifyListeners();
//       return;
//     }

//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();
    
//     try {
//       _data = await repository.getPerebusanData(gudangId);
//     } catch (e) {
//       _errorMessage = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

class PerebusanProvider extends ChangeNotifier {
  final PerebusanRepository repository;
  PerebusanProvider(this.repository);

  PerebusanData? _data;
  PerebusanData? get data => _data;

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

  Future<void> fetchData(String? gudangId) async {
    if (gudangId == null) {
      _errorMessage = 'Gudang ID tidak tersedia';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _data = await repository.getPerebusanData(gudangId);
    } catch (e) {
      _errorMessage = e.toString();
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