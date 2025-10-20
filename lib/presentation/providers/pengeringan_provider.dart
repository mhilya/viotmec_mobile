import 'package:flutter/foundation.dart';
import 'package:iotmcc_mobile/data/models/pengeringan_model.dart';
import 'package:iotmcc_mobile/data/repositories/pengeringan_repository.dart';

// Menggunakan ChangeNotifier (dari package provider)
class PengeringanProvider extends ChangeNotifier {
  final PengeringanRepository _repository;

  PengeringanProvider(this._repository);

  // State variables
  PengeringanData? _data;
  PengeringanData? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isTogglingBlower = false;
  bool get isTogglingBlower => _isTogglingBlower;

  // Method untuk fetch data, memerlukan gudangId (dipanggil dari UI)
  Future<void> fetchData(String gudangId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.getPengeringanData(gudangId);
      _data = data;
    } catch (e) {
      _errorMessage = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  // Method untuk toggle blower
  Future<void> toggleBlower(String gudangId) async {
    // Hanya jalankan jika data sudah ada dan tidak sedang dalam proses toggle
    if (_data == null || _isTogglingBlower) return;

    final currentData = _data!;
    final currentBlowerData = currentData.blowerData;

    // Optimistic UI: Perbarui UI secara instan
    final newBlowerStatus = currentBlowerData.statusBlower == 1 ? 0 : 1;
    _data = PengeringanData(
      suhuData: currentData.suhuData,
      blowerData: currentBlowerData.copyWith(statusBlower: newBlowerStatus),
    );
    _isTogglingBlower = true;
    notifyListeners();

    try {
      // Panggil API
      await _repository.toggleBlower(gudangId);
      
      // Setelah berhasil, muat ulang data dari server untuk memastikan konsistensi
      // (Ini sesuai dengan logic Riverpod Anda sebelumnya)
      await fetchData(gudangId);

    } catch (e) {
      // Jika gagal, kembalikan state ke data sebelum toggle (Rollback)
      _data = currentData; 
      _errorMessage = "Gagal mengubah status blower: ${e.toString()}";
    }

    _isTogglingBlower = false;
    notifyListeners();
  }
}