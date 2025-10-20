import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/perebusan_model.dart';

class PerebusanRepository {
  final ApiService _apiService;
  PerebusanRepository(this._apiService);

  Future<PerebusanData> getPerebusanData(String? gudangId) async {
    if (gudangId == null) {
      throw Exception('Gudang ID tidak tersedia');
    }
    final response = await _apiService.getDataSuhu(gudangId);
    return PerebusanData.fromJson(response);
  }
}