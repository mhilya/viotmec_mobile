class ApiConstants {
  // Ganti dengan IP address lokal Anda jika testing di device fisik,
  // atau biarkan 127.0.0.1 jika menggunakan emulator Android.
  // static const String baseUrl = 'http://192.168.137.6:8000/api'; 
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String baseUrl = 'https://viotmec.com/api'; 

  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String user = '$baseUrl/user';
  static const String forgotPassword = '$baseUrl/forgot-password';
  static const String ruanganPerebusan = '$baseUrl/api-ruangan-perebusan';
  static const String ruanganFermentasi = '$baseUrl/api-ruangan-fermentasi';
  static const String ruanganPengeringan = "$baseUrl/api-ruangan-pengeringan";
  static const String riwayat = '$baseUrl/api-riwayat-data';
  static const String gudang = '$baseUrl/gudang';
  static String getDataSensorPerebusan(String gudangId) => '$ruanganPerebusan/data/sensor/sensor/$gudangId';
  // static String getDataSuhu(String gudangId) => '$ruanganPerebusan/data/sensor/suhu/$gudangId';
  static String getDataSensorFermentasi(String gudangId) => '$ruanganFermentasi/data/sensor/sensor/$gudangId';
  static String getDataSensorPengeringan(String gudangId) => '$ruanganPengeringan/data/sensor/sensor/$gudangId';
  static String getDataBlower(String gudangId) => '$ruanganPengeringan/data/sensor/blower/$gudangId';
  static String toggleBlower(String gudangId) => '$ruanganPengeringan/toggle-blower/$gudangId';

  static String getRuanganByGudang(String gudangId) =>
      '$riwayat/get-ruangan/$gudangId';
  static String getRiwayatBlanching(String ruanganId, String tgl) =>
      '$riwayat/blanching/data/sensor/$ruanganId/$tgl';
  static String getRiwayatFermentasi(String ruanganId, String tgl) =>
      '$riwayat/fermentasi/data/sensor/$ruanganId/$tgl';
  static String getRiwayatPengeringan(String ruanganId, String tgl) =>
      '$riwayat/pengeringan/data/sensor/$ruanganId/$tgl';
}
