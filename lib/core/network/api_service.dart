import 'package:viotmec_mobile/core/constants/api_constant.dart';
import 'package:viotmec_mobile/core/network/dio_client.dart';
import 'package:viotmec_mobile/core/utils/shared_preferences.dart';
import 'package:viotmec_mobile/data/models/login_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  final DioClient _dioClient;
  final SharedPreferencesHelper _prefsHelper;

  ApiService(this._dioClient, this._prefsHelper) {
    _setupAuthInterceptor();
  }

  Exception _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      if (e.response!.data is Map<String, dynamic>) {
        return Exception(e.response!.data['message'] ?? defaultMessage);
      }
      return Exception('$defaultMessage (Error: ${e.response!.statusCode})');
    }
    return Exception("Koneksi ke server gagal");
  }

  void _setupAuthInterceptor() {
    _dioClient.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _prefsHelper.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
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
    try {
      final response = await _dioClient.get(ApiConstants.user);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat profile');
    }
  }

  Future<bool> logout() async {
    try {
      await _dioClient.post(ApiConstants.logout);
      return true;
    } on DioException catch (e) {
      print('Logout error: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>> getDataSensorBlanching(String gudangId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getDataSensorBlanching(gudangId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data perebusan');
    }
  }

  Future<Map<String, dynamic>> getDataTimerBlanching(String gudangId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getDataTimerBlanching(gudangId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data timer');
    }
  }

  Future<Map<String, dynamic>> toggleTimerBlanching(String gudangId) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.toggleTimerBlanching(gudangId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal mengubah status timer');
    }
  }

  Future<Map<String, dynamic>> setLimitTimerBlanching(
    String gudangId,
    int limitTimer,
    String flagSensor,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.setLimitTimerBlanching(gudangId),
        data: {'limit_timer': limitTimer, 'flag_sensor': flagSensor},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal mengatur batas waktu timer');
    }
  }

  Future<Map<String, dynamic>> getDataSensorFermentasi(String gudangId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getDataSensorFermentasi(gudangId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data fermentasi');
    }
  }

  Future<Map<String, dynamic>> getDataSensorPengeringan(String gudangId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getDataSensorPengeringan(gudangId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data suhu & kelembaban');
    }
  }

  Future<Map<String, dynamic>> getDataStatusBlower(String sensorId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getDataStatusBlower(sensorId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat status blower');
    }
  }

  Future<Map<String, dynamic>> toggleBlower(String sensorId) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.toggleBlower(sensorId),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal mengubah status blower');
    }
  }

  Future<List<dynamic>> getGudangList() async {
    try {
      final response = await _dioClient.get(ApiConstants.gudang);
      if (response.data != null && response.data['data'] is List) {
        return response.data['data'];
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data gudang');
    }
  }

  Future<List<dynamic>> getRuanganByGudang(String gudangId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getRuanganByGudang(gudangId),
      );
      if (response.data != null &&
          response.data['status'] == true &&
          response.data['data'] is List) {
        return response.data['data'];
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data ruangan');
    }
  }

  Future<Map<String, dynamic>> getRiwayatSensor(
    String ruanganId,
    String tanggal,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getRiwayatSensor(ruanganId, tanggal),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat data riwayat');
    }
  }

  Future<List<dynamic>> getRiwayatNotifikasi() async {
    try {
      final response = await _dioClient.get(ApiConstants.riwayatNotifikasi);
      
      if (response.data != null &&
          response.data['status'] == true &&
          response.data['data'] is List) {
        return response.data['data'];
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e, 'Gagal memuat riwayat notifikasi');
    }
  }
}
