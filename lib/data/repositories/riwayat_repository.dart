import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/data/models/riwayat_model.dart';

class RiwayatRepository {
  final ApiService _apiService;

  RiwayatRepository(this._apiService);

  Future<List<dynamic>> getGudangList() async {
    try {
      final response = await _apiService.getGudangList();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getRuanganByGudang(String gudangId) async {
    try {
      final response = await _apiService.getRuanganByGudang(gudangId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<RiwayatData> getRiwayatSensor(String ruanganId, String tanggal) async {
    try {
      final response = await _apiService.getRiwayatSensor(ruanganId, tanggal);
      return RiwayatData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}