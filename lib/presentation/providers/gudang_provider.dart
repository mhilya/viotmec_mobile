import 'package:flutter/material.dart';
import 'package:viotmec_mobile/data/models/gudang_model.dart';
import 'package:viotmec_mobile/data/repositories/gudang_repository.dart';

class GudangProvider extends ChangeNotifier {
  String? _activeGudangId;
  List<GudangModel> _gudangList = [];
  final GudangRepository? _repository;
  
  GudangProvider(this._repository);
  
  String? get activeGudangId => _activeGudangId;
  List<GudangModel> get gudangList => _gudangList;
  
  GudangModel? get activeGudang {
    if (_activeGudangId == null) return null;
    try {
      return _gudangList.firstWhere(
        (gudang) => gudang.idGudang == _activeGudangId,
      );
    } catch (e) {
      return null;
    }
  }
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
Future<void> loadGudangList() async {
  if (_repository == null) return;
  
  _isLoading = true;
  _errorMessage = '';
  notifyListeners();
  
  try {
    final gudangList = await _repository!.getGudangList();
    _gudangList = gudangList;
    
    // Debug print
    print('=== DEBUG GUDANG DATA ===');
    print('Jumlah gudang: ${_gudangList.length}');
    print('Active gudang ID: $_activeGudangId');
    for (var gudang in _gudangList) {
      print('Gudang: ${gudang.namaGudang}, ID: ${gudang.idGudang}, Status: ${gudang.statusGudang}');
    }
    print('========================');
    
    // Set gudang aktif pertama kali jika belum ada
    if (_gudangList.isNotEmpty && _activeGudangId == null) {
      _activeGudangId = _gudangList.first.idGudang;
      print('Set active gudang to: $_activeGudangId');
    }
  } catch (e) {
    _errorMessage = e.toString();
    print('Error loading gudang: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
  
  void setActiveGudang(String gudangId) {
    _activeGudangId = gudangId;
    notifyListeners();
  }
  
  bool get hasActiveGudang => _activeGudangId != null && _gudangList.isNotEmpty;
}

