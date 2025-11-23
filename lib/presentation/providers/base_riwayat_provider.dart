import 'package:flutter/material.dart';
import 'package:viotmec_mobile/presentation/providers/gudang_provider.dart';
import 'package:intl/intl.dart';
import 'package:viotmec_mobile/data/models/riwayat_model.dart';
import 'package:viotmec_mobile/data/models/ruangan_model.dart';
import 'package:viotmec_mobile/data/repositories/riwayat_repository.dart';

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
  String? get ruanganId => _ruanganId; // GETTER untuk akses external

  /// String yang digunakan untuk mencari nama ruangan (misal: 'Blanching', 'Fermentasi')
  String get namaRuanganIdentifier;

  /// Tipe ruangan enum untuk memanggil API
  TipeRuanganRiwayat get tipeRuangan;

  /// Dipanggil oleh ProxyProvider ketika GudangProvider update
  void updateGudang(GudangProvider gudangProvider) {
    // Cek jika gudangProvider benar-benar baru atau gudangId-nya berubah
    // Ini mencegah refresh yang tidak perlu
    if (_gudangProvider == null ||
        _gudangProvider?.activeGudangId != gudangProvider.activeGudangId) {
      debugPrint(
          "BaseRiwayatProvider: Gudang berubah ke ${gudangProvider.activeGudangId}");
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
      debugPrint("BaseRiwayatProvider: Ruangan ID ditemukan: $_ruanganId");
      // Setelah ruangan ditemukan, langsung ambil data untuk tanggal hari ini
      await fetchData();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _ruanganId = null;
      _isLoading = false;
      debugPrint("BaseRiwayatProvider: Error _findAndSetRuanganId: $_errorMessage");
      notifyListeners();
    }
  }

  /// Langkah 2: Mengatur tanggal yang dipilih (dipanggil dari UI)
  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;

    // -----------------------------------------------------------------
    // PERBAIKAN: Tambahkan pengecekan di sini.
    // Jika _ruanganId null (karena gagal di langkah 1), jangan panggil
    // fetchData() lagi. Cukup notifyListeners agar tanggal di UI update,
    // tapi pesan error asli (cth: "Ruangan... tidak ditemukan") tetap tampil.
    // -----------------------------------------------------------------
    if (_ruanganId == null) {
      debugPrint(
          "BaseRiwayatProvider: setSelectedDate dibatalkan karena _ruanganId null.");
      // Pastikan pesan error tetap ada jika memang ada
      _errorMessage =
          _errorMessage.isNotEmpty ? _errorMessage : 'Ruangan tidak valid';
      notifyListeners();
      return;
    }

    await fetchData();
  }

  /// Langkah 3: Mengambil data riwayat dari API
  Future<void> fetchData() async {
    if (_ruanganId == null) {
      _errorMessage = 'Ruangan tidak valid';
      debugPrint(
          "BaseRiwayatProvider: fetchData dibatalkan karena _ruanganId null.");
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // ✅ PERBAIKAN: UNCOMMENT dan gunakan format tanggal
      final tgl = DateFormat('yyyy-MM-dd').format(_selectedDate);

      // ✅ PERBAIKAN: Gunakan method repository yang sudah disesuaikan
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

  /// Method untuk refresh data manual
  Future<void> refresh() async {
    // Saat refresh, kita tidak mencari ID ruangan lagi,
    // kita hanya fetch data baru
    await fetchData();
  }

  /// Clear semua data (untuk logout/cleanup)
  void clearData() {
    _data = null;
    _ruanganId = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}