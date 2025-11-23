import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import '../constants/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Dio _dio = Dio();
  
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  Future<void> initNotifications() async {
    try {
      // 1. Request Permission (Wajib buat Android 13+)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('Notification permission status: ${settings.authorizationStatus}');

      // 2. Ambil Token
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // 3. Kirim ke Backend jika user sudah login
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      // 4. Setup foreground message handling
      _setupForegroundMessages();

    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _setupForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('auth_token');

      if (userToken != null && userToken.isNotEmpty) {
        await _dio.post(
          ApiConstants.updateFcmToken,
          data: {'fcm_token': token},
          options: Options(
            headers: {
              'Authorization': 'Bearer $userToken',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );
        print("Token FCM berhasil dikirim ke server");
      } else {
        print("User belum login, token FCM tidak dikirim ke server");
      }
    } catch (e) {
      print("Gagal kirim token ke server: $e");
    }
  }

  // Method untuk refresh token jika diperlukan
  Future<void> refreshFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }
    } catch (e) {
      print('Error refreshing FCM token: $e');
    }
  }

  // Method untuk mendapatkan token saat ini
  Future<String?> getCurrentToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Method untuk menghapus token (saat logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      print('FCM token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}