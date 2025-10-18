import 'package:iotmcc_mobile/core/constants/api_constant.dart';
import 'package:iotmcc_mobile/core/network/dio_client.dart';
import 'package:iotmcc_mobile/core/utils/shared_preferences.dart';
import 'package:iotmcc_mobile/data/models/login_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  final DioClient _dioClient;
  final SharedPreferencesHelper _prefsHelper;

  ApiService(this._dioClient, this._prefsHelper);

  // Setup auth interceptor
  void _setupAuthInterceptor() {
    _dioClient.dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _prefsHelper.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

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
      if (e.response != null) {
        return LoginResponse.fromJson(e.response!.data);
      }
      return LoginResponse(status: false, message: "Koneksi ke server gagal");
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    _setupAuthInterceptor();
    try {
      final response = await _dioClient.get(ApiConstants.user);
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Gagal memuat profile');
      }
      throw Exception("Koneksi ke server gagal");
    }
  }

  // Tambahkan method untuk logout
  Future<bool> logout() async {
    _setupAuthInterceptor();
    try {
      await _dioClient.post(ApiConstants.logout);
      return true;
    } on DioException catch (e) {
      // Even if server logout fails, we still clear local token
      print('Logout error: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>> getPerebusanData(String gudangId) async {
    _setupAuthInterceptor();
    try {
      final response = await _dioClient.get('${ApiConstants.perebusan}/$gudangId');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Gagal memuat data perebusan');
      }
      throw Exception("Koneksi ke server gagal");
    }
  }
}