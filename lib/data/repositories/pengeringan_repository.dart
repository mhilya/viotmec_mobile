import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/data/models/pengeringan_model.dart';

class PengeringanRepository {
  final ApiService _apiService;

  PengeringanRepository(this._apiService);

  Future<PengeringanData> getPengeringanData(String gudangId) async {
    try {
      final response = await _apiService.getDataSensorPengeringan(gudangId);
      return PengeringanData.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memuat data pengeringan: ${e.toString()}');
    }
  }

  Future<BlowerStatusModel> getDataStatusBlower(String sensorId) async {
    try {
      final response = await _apiService.getDataStatusBlower(sensorId);
      return BlowerStatusModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memuat status blower: ${e.toString()}');
    }
  }

  Future<BlowerToggleModel> toggleBlower(String sensorId) async {
    try {
      final response = await _apiService.toggleBlower(sensorId);
      return BlowerToggleModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengubah status blower: ${e.toString()}');
    }
  }
}