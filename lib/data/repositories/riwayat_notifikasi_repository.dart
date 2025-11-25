import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/data/models/riwayat_notifikasi_model.dart';

class RiwayatNotifikasiRepository {
  final ApiService apiService;

  RiwayatNotifikasiRepository(this.apiService);

  Future<List<RiwayatNotifikasiModel>> getNotifikasi() async {
    try {
      final response = await apiService.getRiwayatNotifikasi();

      return response.map((e) => RiwayatNotifikasiModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}