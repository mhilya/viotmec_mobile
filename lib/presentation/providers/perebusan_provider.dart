import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/data/models/perebusan_model.dart';
import 'package:iotmcc_mobile/data/repositories/perebusan_repository.dart';

class PerebusanProvider extends ChangeNotifier {
  final PerebusanRepository repository;
  PerebusanProvider(this.repository);

  PerebusanData? _data;
  PerebusanData? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}