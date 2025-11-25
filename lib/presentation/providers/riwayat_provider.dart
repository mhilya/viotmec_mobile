import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viotmec_mobile/data/models/riwayat_model.dart';
import 'package:viotmec_mobile/data/repositories/riwayat_repository.dart';

class RiwayatProvider extends ChangeNotifier {
  final RiwayatRepository _repository;

  RiwayatProvider(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  RiwayatData? _riwayatData;
  
  List<dynamic> _listGudang = [];
  String? _selectedGudangId;
  DateTime _selectedDate = DateTime.now();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RiwayatData? get riwayatData => _riwayatData;
  List<dynamic> get listGudang => _listGudang;
  String? get selectedGudangId => _selectedGudangId;
  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedGudangId(String? id) {
    _selectedGudangId = id;
    _riwayatData = null; 
    notifyListeners();
  }

  Future<void> getGudangList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getGudangList();
      _listGudang = result;
      
      if (_listGudang.isNotEmpty && _selectedGudangId == null) {
        _selectedGudangId = _listGudang[0]['id_gudang'].toString();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRiwayatByGudangAndType(int tipeRuangan) async {
    if (_selectedGudangId == null) return;

    _isLoading = true;
    _errorMessage = null;
    _riwayatData = null;
    notifyListeners();

    try {
      // 1. Ambil daftar ruangan berdasarkan gudang
      final rooms = await _repository.getRuanganByGudang(_selectedGudangId!);
      
      // 2. Cari ruangan yang tipe_ruangan-nya COCOK
      // PERBAIKAN DI SINI: Gunakan toString() untuk membandingkan
      final targetRoom = rooms.firstWhere(
        (room) => room['tipe_ruangan'].toString() == tipeRuangan.toString(),
        orElse: () => null,
      );

      if (targetRoom == null) {
        throw Exception("Ruangan tipe ini tidak ditemukan di gudang yang dipilih.");
      }

      final String ruanganId = targetRoom['id_ruangan'].toString();
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

      // 3. Ambil data sensor
      final result = await _repository.getRiwayatSensor(
        ruanganId,
        formattedDate,
      );
      _riwayatData = result;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _riwayatData = null;
    _errorMessage = null;
    // Kita tidak mereset listGudang agar tidak loading ulang terus menerus
    if (_listGudang.isEmpty) {
        _selectedGudangId = null;
    }
    _selectedDate = DateTime.now();
    notifyListeners();
  }
}