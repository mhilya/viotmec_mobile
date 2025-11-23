import 'package:flutter/material.dart';
import 'package:viotmec_mobile/data/models/user_model.dart';
import 'package:viotmec_mobile/data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;

  UserProvider(this.userRepository);

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> getUserProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await userRepository.getUserProfile();
    } catch (e) {
      _errorMessage = 'Gagal memuat data user: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}