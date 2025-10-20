import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/gudang_model.dart';

class GudangRepository {
  final ApiService _apiService;
  GudangRepository(this._apiService);

  Future<List<GudangModel>> getGudangList() async {
    final response = await _apiService.getGudangList();
    return (response as List).map((json) => GudangModel.fromJson(json)).toList();
  }
}