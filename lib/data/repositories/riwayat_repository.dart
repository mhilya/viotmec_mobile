import 'package:iotmcc_mobile/core/constants/api_constant.dart';
import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/riwayat_model.dart';
import 'package:iotmcc_mobile/data/models/ruangan_model.dart';

// Enum untuk membedakan tipe ruangan saat memanggil API
enum TipeRuanganRiwayat {
  perebusan,
  fermentasi,
  pengeringan,
}

class RiwayatRepository {
  final ApiService _apiService;
  RiwayatRepository(this._apiService);

  /// Mengambil daftar semua ruangan yang terhubung ke satu gudang
  Future<List<RuanganModel>> getRuanganList(String gudangId) async {
    final response = await _apiService.getRuanganByGudang(gudangId);
    return (response as List)
        .map((json) => RuanganModel.fromJson(json))
        .toList();
  }

  /// Mengambil data riwayat berdasarkan Tipe Ruangan, ID Ruangan, dan Tanggal
  Future<RiwayatData> getRiwayatData({
    required TipeRuanganRiwayat tipe,
    required String ruanganId,
    required String tgl, // Format YYYY-MM-DD
  }) async {
    // GUNAKAN METHOD BARU YANG SUDAH DISESUAIKAN
    final response = await _apiService.getRiwayatSensor(ruanganId, tgl);
    return RiwayatData.fromJson(response);
  }

  /// Alternative: Jika ingin tetap membedakan berdasarkan tipe ruangan
  /// untuk keperluan logging atau analytics
  Future<RiwayatData> getRiwayatDataWithType({
    required TipeRuanganRiwayat tipe,
    required String ruanganId,
    required String tgl,
  }) async {
    // GUNAKAN METHOD BARU YANG SUDAH DISESUAIKAN
    final response = await _apiService.getRiwayatSensor(ruanganId, tgl);
    
    final riwayatData = RiwayatData.fromJson(response);
    // Tambahkan informasi tipe ruangan ke response jika diperlukan
    // riwayatData.tipeRuangan = tipe; // Jika model mendukung properti ini
    
    return riwayatData;
  }

  /// Method tambahan untuk mendapatkan data riwayat tanpa tipe ruangan
  /// (lebih sederhana jika tipe ruangan tidak diperlukan)
  Future<RiwayatData> getRiwayatByRuangan({
    required String ruanganId,
    required String tanggal,
  }) async {
    final response = await _apiService.getRiwayatSensor(ruanganId, tanggal);
    return RiwayatData.fromJson(response);
  }
}