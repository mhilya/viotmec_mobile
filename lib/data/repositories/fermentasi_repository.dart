import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/fermentasi_model.dart';

class FermentasiRepository {
  final ApiService _apiService;
  FermentasiRepository(this._apiService);

  Future<FermentasiData> getFermentasiData(String? gudangId) async {
    if (gudangId == null || gudangId.isEmpty) {
      throw Exception('Gudang ID tidak valid');
    }
    final response = await _apiService.getDataSensorFermentasi(gudangId);
    
    // Validasi response
    if (response.isEmpty) {
      throw Exception('Data fermentasi tidak ditemukan');
    }
    
    return FermentasiData.fromJson(response);
  }
}
