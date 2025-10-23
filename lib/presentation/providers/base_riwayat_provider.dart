import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:intl/intl.dart';
import 'package:iotmcc_mobile/data/models/riwayat_model.dart';
import 'package:iotmcc_mobile/data/models/ruangan_model.dart';
import 'package:iotmcc_mobile/data/repositories/riwayat_repository.dart';

/// Provider dasar untuk menangani logika riwayat yang berulang
/// (mencari ruangan, memilih tanggal, fetching data)
abstract class BaseRiwayatProvider extends ChangeNotifier {
  final RiwayatRepository _riwayatRepository;
  GudangProvider? _gudangProvider;

  BaseRiwayatProvider(this._riwayatRepository);

  RiwayatData? _data;
  RiwayatData? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  String? _ruanganId; // ID ruangan yang spesifik (misal: 'Ruang Perebusan')

  /// String yang digunakan untuk mencari nama ruangan (misal: 'Blaching', 'Fermentasi')
  String get namaRuanganIdentifier;

  /// Tipe ruangan enum untuk memanggil API
  TipeRuanganRiwayat get tipeRuangan;

  /// Dipanggil oleh ProxyProvider ketika GudangProvider update
  void updateGudang(GudangProvider gudangProvider) {
    if (_gudangProvider?.activeGudangId != gudangProvider.activeGudangId) {
      _gudangProvider = gudangProvider;
      // Gudang berubah, cari ID ruangan yang baru
      _findAndSetRuanganId(gudangProvider.activeGudangId);
    }
  }

  /// Langkah 1: Mencari ID ruangan yang relevan berdasarkan ID gudang
  Future<void> _findAndSetRuanganId(String? gudangId) async {
    if (gudangId == null) {
      _errorMessage = "Gudang belum dipilih";
      _data = null;
      _ruanganId = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    _data = null;
    notifyListeners();

    try {
      final ruanganList = await _riwayatRepository.getRuanganList(gudangId);
      final ruangan = ruanganList.firstWhere(
        (r) => r.namaRuangan
            .toLowerCase()
            .contains(namaRuanganIdentifier.toLowerCase()),
        orElse: () =>
            throw Exception('Ruangan "$namaRuanganIdentifier" tidak ditemukan'),
      );

      _ruanganId = ruangan.id;
      // Setelah ruangan ditemukan, langsung ambil data untuk tanggal hari ini
      await fetchData();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _ruanganId = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Langkah 2: Mengatur tanggal yang dipilih (dipanggil dari UI)
  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;
    await fetchData();
  }

  /// Langkah 3: Mengambil data riwayat dari API
  Future<void> fetchData() async {
    if (_ruanganId == null) {
      _errorMessage = 'Ruangan tidak valid';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final tgl = DateFormat('yyyy-MM-dd').format(_selectedDate);
      _data = await _riwayatRepository.getRiwayatData(
        tipe: tipeRuangan,
        ruanganId: _ruanganId!,
        tgl: tgl,
      );

      // Cek jika API mengembalikan status:false (misal: data tidak ada)
      if (_data?.status == false) {
        _errorMessage = _data?.message ?? 'Data tidak ditemukan';
        _data = null;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _data = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
