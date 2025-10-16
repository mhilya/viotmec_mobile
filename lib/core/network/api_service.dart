import 'package:iotmcc_mobile/core/constants/api_constant.dart';
import 'package:iotmcc_mobile/core/network/dio_client.dart';
import 'package:iotmcc_mobile/data/models/login_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Jika server memberikan response error (misal: 401 Unauthorized)
      if (e.response != null) {
        return LoginResponse.fromJson(e.response!.data);
      }
      // Jika terjadi error koneksi
      return LoginResponse(status: false, message: "Koneksi ke server gagal");
    }
  }
}
