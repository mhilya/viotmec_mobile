class ApiConstants {
  // Ganti dengan IP address lokal Anda jika testing di device fisik,
  // atau biarkan 127.0.0.1 jika menggunakan emulator Android.
  // static const String baseUrl = 'http://192.168.137.6:8000/api'; 
  static const String baseUrl = 'http://127.0.0.1:8000/api'; 

  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String user = '$baseUrl/user';
  static const String forgotPassword = '$baseUrl/forgot-password';
  static const String ruanganPerebusan = '$baseUrl/ruangan-perebusan';
  static const String ruanganFermentasi = '$baseUrl/ruangan-fermentasi';
  static const String ruangPengeringan = "$baseUrl/ruang-pengeringan";
  static const String gudang = '$baseUrl/gudang';
  static String getDataSensorPerebusan(String gudangId) => '$ruanganPerebusan/data/sensor/sensor/$gudangId';
  // static String getDataSuhu(String gudangId) => '$ruanganPerebusan/data/sensor/suhu/$gudangId';
  static String getDataSensorFermentasi(String gudangId) => '$ruanganFermentasi/data/sensor/sensor/$gudangId';
  static String getDataSuhuPengeringan(String gudangId) => '$ruangPengeringan/data/sensor/suhu/$gudangId';
  static String getDataBlower(String gudangId) => '$ruangPengeringan/data/sensor/blower/$gudangId';
  static String toggleBlower(String gudangId) => '$ruangPengeringan/toggle-blower/$gudangId';
}
