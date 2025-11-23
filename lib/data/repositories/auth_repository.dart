import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/core/utils/shared_preferences.dart';
import 'package:viotmec_mobile/data/models/login_response.dart';

class AuthRepository {
  final ApiService _apiService;
  final SharedPreferencesHelper _prefsHelper;

  AuthRepository(this._apiService, this._prefsHelper);

  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    
    if (response.status && response.accessToken != null) {
      await _prefsHelper.saveToken(response.accessToken!);
    }
    
    return response;
  }

  Future<bool> logout() async {
    try {
      // Coba logout dari server
      await _apiService.logout();
    } catch (e) {
      // Tetap lanjutkan meskipun server logout gagal
      print('Server logout failed: $e');
    }
    
    // Selalu hapus token lokal
    await _prefsHelper.removeToken();
    return true;
  }
}