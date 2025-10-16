import 'package:iotmcc_mobile/data/models/user_model.dart';

class LoginResponse {
  final bool status;
  final String message;
  final String? accessToken;
  final UserModel? user;

  LoginResponse({
    required this.status,
    required this.message,
    this.accessToken,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      accessToken: json['access_token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
