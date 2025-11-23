import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/data/models/blanching_model.dart';

class BlanchingRepository {
  final ApiService _apiService;

  BlanchingRepository(this._apiService);

  Future<BlanchingData> getBlanchingData(String gudangId) async {
    try {
      final response = await _apiService.getDataSensorBlanching(gudangId);
      return BlanchingData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<TimerResponse> getTimerData(String gudangId) async {
    try {
      final response = await _apiService.getDataTimerBlanching(gudangId);
      return TimerResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<TimerData> toggleTimer(String gudangId) async {
    try {
      final response = await _apiService.toggleTimerBlanching(gudangId);
      
      if (response['status'] == true && response['data'] != null) {
        return TimerData.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal mengubah status timer');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setLimitTimer(String gudangId, int limit, String flagSensor) async {
    try {
      final response = await _apiService.setLimitTimerBlanching(
        gudangId,
        limit,
        flagSensor,
      );

      if (response['status'] == true) {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Gagal mengatur limit timer');
      }
    } catch (e) {
      rethrow;
    }
  }
}