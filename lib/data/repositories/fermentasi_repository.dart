import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/data/models/fermentasi_model.dart';

class FermentasiRepository {
  final ApiService _apiService;
  
  FermentasiRepository(this._apiService);

  Future<FermentasiData> getFermentasiData(String? gudangId) async {
    try {
      if (gudangId == null || gudangId.isEmpty) {
        throw ArgumentError('Gudang ID tidak valid');
      }

      final response = await _apiService.getDataSensorFermentasi(gudangId);

      if (response.isEmpty) {
        throw Exception('Data fermentasi tidak ditemukan untuk gudang $gudangId');
      }

      return FermentasiData.fromJson(response);
      
    } on ArgumentError {
      rethrow;
    } catch (e) {
      throw Exception('Gagal mengambil data fermentasi: ${e.toString()}');
    }
  }
}