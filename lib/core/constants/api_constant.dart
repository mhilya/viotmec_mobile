class ApiConstants {
  // Ganti dengan IP address lokal Anda jika testing di device fisik,
  // atau biarkan 127.0.0.1 jika menggunakan emulator Android.
  static const String baseUrl = 'http://10.10.6.25:8000/api'; 
  
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String user = '$baseUrl/user';
  static const String forgotPassword = '$baseUrl/forgot-password';
}
