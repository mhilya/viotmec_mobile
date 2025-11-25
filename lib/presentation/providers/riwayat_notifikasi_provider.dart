import 'package:flutter/material.dart';
import 'package:viotmec_mobile/data/models/riwayat_notifikasi_model.dart';
import 'package:viotmec_mobile/data/repositories/riwayat_notifikasi_repository.dart';

class RiwayatNotifikasiProvider with ChangeNotifier {
  final RiwayatNotifikasiRepository repository;

  RiwayatNotifikasiProvider(this.repository);

  List<RiwayatNotifikasiModel> _listNotifikasi = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RiwayatNotifikasiModel> get listNotifikasi => _listNotifikasi;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNotifikasi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listNotifikasi = await repository.getNotifikasi();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}