class ApiConstants {
  // Ganti dengan IP address lokal Anda jika testing di device fisik,
  // atau biarkan 127.0.0.1 jika menggunakan emulator Android.
  static const String baseUrl = 'http://192.168.1.4:8000/api';
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  // static const String baseUrl = 'https://viotmec.com/api';

  static const String user = '$baseUrl/user';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String forgotPassword = '$baseUrl/forgot-password';
  static const String updateFcmToken = '$baseUrl/update-fcm-token';

  static const String gudang = '$baseUrl/gudang';
  static String getRuanganByGudang(String gudangId) =>
      '$riwayat/gudang/$gudangId/ruangan';

  static const String dataBlanching = '$baseUrl/v1/data-blanching';
  static String getDataSensorBlanching(String gudangId) =>
      '$dataBlanching/$gudangId/data-sensor';
  static String getDataTimerBlanching(String gudangId) =>
      '$dataBlanching/$gudangId/timer';
  static String toggleTimerBlanching(String gudangId) =>
      '$dataBlanching/$gudangId/toggle-timer';
  static String setLimitTimerBlanching(String gudangId) =>
      '$dataBlanching/$gudangId/limit-timer';

  static const String dataFermentasi = '$baseUrl/v1/data-fermentasi';
  static String getDataSensorFermentasi(String gudangId) =>
      '$dataFermentasi/$gudangId/data-sensor';

  static const String dataPengeringan = '$baseUrl/v1/data-pengeringan';
  static String getDataSensorPengeringan(String gudangId) =>
      '$dataPengeringan/$gudangId/data-sensor';
  static String getDataStatusBlower(String sensorId) =>
      '$dataPengeringan/$sensorId/data-blower';
  static String toggleBlower(String sensorId) =>
      '$dataPengeringan/$sensorId/toggle-blower';

  static const String riwayat = '$baseUrl/api-riwayat-data';
  static String getRiwayatSensor(String ruanganId, String tgl) =>
      '$riwayat/ruangan/$ruanganId/sensor/$tgl';
}
