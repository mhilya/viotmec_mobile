import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/core/network/api_service.dart';
import 'package:iotmcc_mobile/core/network/dio_client.dart';
import 'package:iotmcc_mobile/core/utils/shared_preferences.dart';
import 'package:iotmcc_mobile/data/repositories/auth_repository.dart';
import 'package:iotmcc_mobile/data/repositories/pengeringan_repository.dart';
import 'package:iotmcc_mobile/presentation/providers/auth_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/gudang_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/pengeringan_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/perebusan_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/fermentasi_provider.dart';
import 'package:iotmcc_mobile/routes/app_routes.dart';
import 'package:iotmcc_mobile/routes/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:iotmcc_mobile/data/repositories/user_repository.dart';
import 'package:iotmcc_mobile/data/repositories/perebusan_repository.dart';
import 'package:iotmcc_mobile/presentation/providers/user_provider.dart';
import 'package:iotmcc_mobile/data/repositories/gudang_repository.dart';
import 'package:iotmcc_mobile/data/repositories/fermentasi_repository.dart';
import 'package:iotmcc_mobile/data/repositories/riwayat_repository.dart';
import 'package:iotmcc_mobile/presentation/providers/riwayat_perebusan_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/riwayat_fermentasi_provider.dart';
import 'package:iotmcc_mobile/presentation/providers/riwayat_pengeringan_provider.dart';

void main() {
  // Setup Dependencies
  final dio = Dio();
  final dioClient = DioClient(dio);
  final prefsHelper = SharedPreferencesHelper();
  final apiService = ApiService(dioClient, prefsHelper);
  final authRepository = AuthRepository(apiService, prefsHelper);
  final userRepository = UserRepository(apiService);
  final perebusanRepository = PerebusanRepository(apiService);
  final gudangRepository = GudangRepository(apiService);
  final fermentasiRepository = FermentasiRepository(apiService);
  final pengeringanRepository = PengeringanRepository(apiService);
  final riwayatRepository = RiwayatRepository(apiService);

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
          create: (context) => PerebusanProvider(perebusanRepository),
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
        ChangeNotifierProxyProvider<GudangProvider, RiwayatPerebusanProvider>(
          create: (context) => RiwayatPerebusanProvider(riwayatRepository),
          update: (context, gudangProvider, riwayatProvider) {
            // Panggil method updateGudang setiap kali GudangProvider berubah
            riwayatProvider?.updateGudang(gudangProvider);
            return riwayatProvider!;
          },
        ),
        ChangeNotifierProxyProvider<GudangProvider, RiwayatFermentasiProvider>(
          create: (context) => RiwayatFermentasiProvider(riwayatRepository),
          update: (context, gudangProvider, riwayatProvider) {
            riwayatProvider?.updateGudang(gudangProvider);
            return riwayatProvider!;
          },
        ),
        ChangeNotifierProxyProvider<GudangProvider, RiwayatPengeringanProvider>(
          create: (context) => RiwayatPengeringanProvider(riwayatRepository),
          update: (context, gudangProvider, riwayatProvider) {
            riwayatProvider?.updateGudang(gudangProvider);
            return riwayatProvider!;
          },
        ),
        // ... providers lainnya
      ],
      child: MyApp(),
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
      title: 'IoTMCC Mobile',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          brightness: Brightness.light,
        ),
        splashColor: primaryColor.withOpacity(
          0.2,
        ), // Warna efek riak saat disentuh
        highlightColor: primaryColor.withOpacity(
          0.1,
        ), // Warna highlight saat ditekan
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
