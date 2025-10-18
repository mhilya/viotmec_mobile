import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/data/models/user_model.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<UserModel> getUserProfile() async {
    final response = await _apiService.getUserProfile();
    return UserModel.fromJson(response);
  }
}