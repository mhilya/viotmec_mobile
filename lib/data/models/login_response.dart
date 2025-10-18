class LoginResponse {
  final bool status;
  final String message;
  final String? accessToken;
  final String? tokenType;
  final Map<String, dynamic>? user; 

  LoginResponse({
    required this.status,
    required this.message,
    this.accessToken,
    this.tokenType,
    this.user, 
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      user: json['user'], 
    );
  }
}