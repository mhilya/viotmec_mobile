import 'package:flutter/material.dart';

class GudangProvider extends ChangeNotifier {
  String _activeGudangId = '1'; // Default ID
  
  String get activeGudangId => _activeGudangId;
  
  void setActiveGudang(String gudangId) {
    _activeGudangId = gudangId;
    notifyListeners();
  }
}