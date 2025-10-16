import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/data/models/login_response.dart';
import 'package:iotmcc_mobile/data/repositories/auth_repository.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

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
}
