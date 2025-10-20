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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
