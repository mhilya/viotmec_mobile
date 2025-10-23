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
    String apiUrl;
    switch (tipe) {
      case TipeRuanganRiwayat.perebusan:
        apiUrl = ApiConstants.getRiwayatBlanching(ruanganId, tgl);
        break;
      case TipeRuanganRiwayat.fermentasi:
        apiUrl = ApiConstants.getRiwayatFermentasi(ruanganId, tgl);
        break;
      case TipeRuanganRiwayat.pengeringan:
        apiUrl = ApiConstants.getRiwayatPengeringan(ruanganId, tgl);
        break;
    }
    final response = await _apiService.getRiwayatData(apiUrl);
    return RiwayatData.fromJson(response);
  }
}
