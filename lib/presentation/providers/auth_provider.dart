import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/data/models/login_response.dart';
import 'package:iotmcc_mobile/data/repositories/auth_repository.dart';
import 'package:iotmcc_mobile/core/utils/shared_preferences.dart';

enum AuthState { initial, loading, success, error, logout }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final SharedPreferencesHelper _prefsHelper;

  AuthProvider(this.authRepository, this._prefsHelper);

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isAuthenticated => _prefsHelper.getToken() != null;

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      LoginResponse response = await authRepository.login(email, password);
      
      if (response.status) {
        _state = AuthState.success;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _state = AuthState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      // Panggil repository untuk melakukan logout di server dan lokal
      final success = await authRepository.logout();
      
      if (success) {
        _state = AuthState.logout;
        notifyListeners();
        return true;
      } else {
        // Meskipun repository saat ini selalu return true, 
        // ini adalah praktik yang baik untuk menangani kegagalan
        _errorMessage = 'Gagal melakukan logout.';
        _state = AuthState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat logout: ${e.toString()}';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}