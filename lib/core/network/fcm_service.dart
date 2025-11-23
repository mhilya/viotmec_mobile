import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import '../constants/api_constant.dart';
import '../utils/shared_preferences.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Dio _dio = Dio();
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  Future<void> initNotifications() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');

        if (token != null) {
          await _sendTokenToBackend(token);
        }

        _firebaseMessaging.onTokenRefresh.listen(_sendTokenToBackend);
      }

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
        print('Message also contained a notification: ${message.notification?.title}');
      }
    });
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      String? userToken = await _prefsHelper.getToken();

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

  Future<String?> getCurrentToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      print('FCM token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}