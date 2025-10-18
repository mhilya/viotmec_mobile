

import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/perebusan_model.dart';

class PerebusanRepository {
  final ApiService _apiService;
  PerebusanRepository(this._apiService);

  Future<PerebusanData> getPerebusanData(String gudangId) async {
    final response = await _apiService.getPerebusanData(gudangId);
    return PerebusanData.fromJson(response);
  }
}