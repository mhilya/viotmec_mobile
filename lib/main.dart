import 'package:flutter/material.dart';
import 'package:viotmec_mobile/core/network/api_service.dart';
import 'package:viotmec_mobile/core/network/dio_client.dart';
import 'package:viotmec_mobile/core/utils/shared_preferences.dart';
import 'package:viotmec_mobile/data/repositories/auth_repository.dart';
import 'package:viotmec_mobile/data/repositories/blanching_repository.dart';
import 'package:viotmec_mobile/data/repositories/pengeringan_repository.dart';
import 'package:viotmec_mobile/presentation/providers/auth_provider.dart';
import 'package:viotmec_mobile/presentation/providers/gudang_provider.dart';
import 'package:viotmec_mobile/presentation/providers/pengeringan_provider.dart';
import 'package:viotmec_mobile/presentation/providers/blanching_provider.dart';
import 'package:viotmec_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:viotmec_mobile/presentation/providers/riwayat_provider.dart';
import 'package:viotmec_mobile/data/repositories/riwayat_notifikasi_repository.dart';
import 'package:viotmec_mobile/presentation/providers/riwayat_notifikasi_provider.dart';
import 'package:viotmec_mobile/routes/app_routes.dart';
import 'package:viotmec_mobile/routes/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:viotmec_mobile/data/repositories/user_repository.dart';
import 'package:viotmec_mobile/presentation/providers/user_provider.dart';
import 'package:viotmec_mobile/data/repositories/gudang_repository.dart';
import 'package:viotmec_mobile/data/repositories/fermentasi_repository.dart';
import 'package:viotmec_mobile/data/repositories/riwayat_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final dio = Dio();
  final dioClient = DioClient(dio);
  final prefsHelper = SharedPreferencesHelper();
  final apiService = ApiService(dioClient, prefsHelper);
  final authRepository = AuthRepository(apiService, prefsHelper);
  final userRepository = UserRepository(apiService);
  final blanchingRepository = BlanchingRepository(apiService);
  final gudangRepository = GudangRepository(apiService);
  final fermentasiRepository = FermentasiRepository(apiService);
  final pengeringanRepository = PengeringanRepository(apiService);
  final riwayatRepository = RiwayatRepository(apiService);
  final riwayatNotifikasiRepository = RiwayatNotifikasiRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(authRepository, prefsHelper),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(userRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => BlanchingProvider(blanchingRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => GudangProvider(gudangRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => FermentasiProvider(fermentasiRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => PengeringanProvider(pengeringanRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => RiwayatProvider(riwayatRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => RiwayatNotifikasiProvider(riwayatNotifikasiRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF34A853);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viotmec Mobile',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          brightness: Brightness.light,
        ),
        splashColor: primaryColor.withOpacity(0.2),
        highlightColor: primaryColor.withOpacity(0.1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey.shade400,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
