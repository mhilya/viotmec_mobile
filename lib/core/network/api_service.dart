// import 'package:iotmcc_mobile/core/constants/api_constant.dart';
// import 'package:iotmcc_mobile/core/network/dio_client.dart';
// import 'package:iotmcc_mobile/core/utils/shared_preferences.dart';
// import 'package:iotmcc_mobile/data/models/login_response.dart';
// import 'package:dio/dio.dart';

// class ApiService {
//   final DioClient _dioClient;
//   final SharedPreferencesHelper _prefsHelper;

//   ApiService(this._dioClient, this._prefsHelper) {
//     // IMPROVEMENT: Setup auth interceptor hanya sekali saat class diinisialisasi.
//     // Ini lebih efisien dan menghindari penambahan interceptor berulang kali.
//     _setupAuthInterceptor();
//   }

//   // Setup auth interceptor
//   void _setupAuthInterceptor() {
//     _dioClient.dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final token = await _prefsHelper.getToken();
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//     ));
//   }

//   Future<LoginResponse> login(String email, String password) async {
//     try {
//       final response = await _dioClient.post(
//         ApiConstants.login,
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );
//       return LoginResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         return LoginResponse.fromJson(e.response!.data);
//       }
//       return LoginResponse(status: false, message: "Koneksi ke server gagal");
//     }
//   }

//   Future<Map<String, dynamic>> getUserProfile() async {
//     // Tidak perlu memanggil _setupAuthInterceptor() lagi
//     try {
//       final response = await _dioClient.get(ApiConstants.user);
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response!.data['message'] ?? 'Gagal memuat profile');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }

//   // Tambahkan method untuk logout
//   Future<bool> logout() async {
//     // Tidak perlu memanggil _setupAuthInterceptor() lagi
//     try {
//       await _dioClient.post(ApiConstants.logout);
//       return true;
//     } on DioException catch (e) {
//       // Even if server logout fails, we still clear local token
//       print('Logout error: ${e.message}');
//       return false;
//     }
//   }

//   Future<Map<String, dynamic>> getDataSuhu(String gudangId) async {
//     // Tidak perlu memanggil _setupAuthInterceptor() lagi
//     try {
//       final response = await _dioClient.get(ApiConstants.getDataSuhu(gudangId));
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response!.data['message'] ?? 'Gagal memuat data perebusan');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }

//   Future<Map<String, dynamic>> getDataSensorFermentasi(String gudangId) async {
//     try {
//       final response = await _dioClient.get(ApiConstants.getDataSensorFermentasi(gudangId));
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         // ✅ BENAR: Ganti dengan message yang sesuai
//         throw Exception(e.response!.data['message'] ?? 'Gagal memuat data fermentasi');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }

//   Future<List<dynamic>> getGudangList() async {
//     // Tidak perlu memanggil _setupAuthInterceptor() lagi
//     try {
//       final response = await _dioClient.get(ApiConstants.gudang);
//       // FIX: Ekstrak list dari dalam key 'data' pada response JSON.
//       // Ini akan menyelesaikan error TypeError.
//       if (response.data != null && response.data['data'] is List) {
//         return response.data['data'];
//       }
//       return []; // Return list kosong jika data tidak sesuai format
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response!.data['message'] ?? 'Gagal memuat data gudang');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }

//   Future<Map<String, dynamic>> getDataSuhuPengeringan(String gudangId) async {
//     try {
//       final response = await _dioClient.get(ApiConstants.getDataSuhuPengeringan(gudangId));
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response!.data['message'] ?? 'Gagal memuat data suhu & kelembaban');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }

//   Future<Map<String, dynamic>> getDataBlower(String gudangId) async {
//     try {
//       final response = await _dioClient.get(ApiConstants.getDataBlower(gudangId));
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response!.data['message'] ?? 'Gagal memuat data blower');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }

//   Future<Map<String, dynamic>> toggleBlower(String gudangId) async {
//     try {
//       final response = await _dioClient.post(ApiConstants.toggleBlower(gudangId));
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response!.data['message'] ?? 'Gagal mengubah status blower');
//       }
//       throw Exception("Koneksi ke server gagal");
//     }
//   }
// }

import 'package:iotmcc_mobile/core/constants/api_constant.dart';
import 'package:iotmcc_mobile/core/network/dio_client.dart';
import 'package:iotmcc_mobile/core/utils/shared_preferences.dart';
import 'package:iotmcc_mobile/data/models/login_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  final DioClient _dioClient;
  final SharedPreferencesHelper _prefsHelper;

  ApiService(this._dioClient, this._prefsHelper) {
    _setupAuthInterceptor();
  }

  // Helper baru untuk menangani DioException dengan aman
  Exception _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      // PERBAIKAN: Cek dulu apakah response.data adalah Map (JSON)
      if (e.response!.data is Map<String, dynamic>) {
        return Exception(e.response!.data['message'] ?? defaultMessage);
      }
      // Jika bukan JSON (misalnya HTML dari error 500), kembalikan pesan default
      // Ini mencegah crash "TypeError"
      return Exception(
          '$defaultMessage (Error: ${e.response!.statusCode})');
    }
    // Jika tidak ada response (masalah koneksi/timeout)
    return Exception("Koneksi ke server gagal");
  }

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
      // LoginResponse punya logikanya sendiri, jadi kita biarkan
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
      // Menggunakan helper
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

  Future<Map<String, dynamic>> getDataSuhu(String gudangId) async {
    try {
      final response = await _dioClient.get(ApiConstants.getDataSuhu(gudangId));
      return response.data;
    } on DioException catch (e) {
      // Menggunakan helper
      throw _handleDioError(e, 'Gagal memuat data perebusan');
    }
  }

  Future<Map<String, dynamic>> getDataSensorFermentasi(String gudangId) async {
    try {
      final response =
          await _dioClient.get(ApiConstants.getDataSensorFermentasi(gudangId));
      return response.data;
    } on DioException catch (e) {
      // Menggunakan helper
      throw _handleDioError(e, 'Gagal memuat data fermentasi');
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
      // Menggunakan helper
      throw _handleDioError(e, 'Gagal memuat data gudang');
    }
  }

  Future<Map<String, dynamic>> getDataSuhuPengeringan(String gudangId) async {
    try {
      final response =
          await _dioClient.get(ApiConstants.getDataSuhuPengeringan(gudangId));
      return response.data;
    } on DioException catch (e) {
      // Menggunakan helper
      throw _handleDioError(e, 'Gagal memuat data suhu & kelembaban');
    }
  }

  Future<Map<String, dynamic>> getDataBlower(String gudangId) async {
    // Langsung kembalikan data dummy tanpa memanggil API
    await Future.delayed(const Duration(milliseconds: 300)); // Pura-pura loading
    return {
      "status": true,
      "statusRuangan": 1, // 1 = Aktif (agar header card & info card benar)
      "statusBlower": 1, // 1 = Menyala (dummy)
      "durasiAktif": 120, // (dummy)
      "dataBlower": [], // List kosong (dummy)
      "dataWaktuBlower": [] // List kosong (dummy)
    };
  }

  Future<Map<String, dynamic>> toggleBlower(String gudangId) async {
    // Langsung kembalikan data dummy tanpa memanggil API
    await Future.delayed(const Duration(milliseconds: 300)); // Pura-pura loading
    return {
      "status": true,
      "message": "Status blower berhasil diubah (Dummy)",
      "statusBlower": 0 // Kembalikan status baru (dummy)
    };
  }
}