import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/core/utils/shared_preferences.dart';
import 'package:iotmcc_mobile/data/models/login_response.dart';

class AuthRepository {
  final ApiService _apiService;
  final SharedPreferencesHelper _prefsHelper;

  AuthRepository(this._apiService, this._prefsHelper);

  Future<LoginResponse> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    
    // Jika login sukses, simpan token
    if (response.status && response.accessToken != null) {
      await _prefsHelper.saveToken(response.accessToken!);
    }
    
    return response;
  }
}
