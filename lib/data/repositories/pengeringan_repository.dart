import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/pengeringan_model.dart';

class PengeringanRepository {
  final ApiService _apiService;

  PengeringanRepository(this._apiService);

  Future<PengeringanSuhuData> getSuhuData(String gudangId) async {
    try {
      final response = await _apiService.getDataSuhuPengeringan(gudangId);
      return PengeringanSuhuData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PengeringanBlowerData> getBlowerData(String gudangId) async {
    try {
      final response = await _apiService.getDataBlower(gudangId);
      return PengeringanBlowerData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> toggleBlower(String gudangId) async {
    try {
      final response = await _apiService.toggleBlower(gudangId);
      if (response['status'] == true) {
        return response['statusBlower'];
      } else {
        throw Exception(response['message'] ?? 'Gagal mengubah status blower');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Menggabungkan kedua panggilan API untuk kemudahan di provider
  Future<PengeringanData> getPengeringanData(String gudangId) async {
    try {
      // Menjalankan kedua future secara bersamaan
      final results = await Future.wait([
        getSuhuData(gudangId),
        getBlowerData(gudangId),
      ]);

      final suhuData = results[0] as PengeringanSuhuData;
      final blowerData = results[1] as PengeringanBlowerData;

      return PengeringanData(suhuData: suhuData, blowerData: blowerData);
    } catch (e) {
      rethrow;
    }
  }
}
