import 'package:flutter/material.dart';
import 'package:iotmcc_mobile/routes/app_routes.dart';
import 'package:iotmcc_mobile/routes/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghapus 'const' dari MaterialApp agar bisa menggunakan ThemeData
    return MaterialApp(
      // 1. Menghilangkan banner "DEBUG"
      debugShowCheckedModeBanner: false,

      title: 'Flutter App',

      // 2. Menambahkan tema terpusat untuk seluruh aplikasi
      theme: ThemeData(
        // Mengatur font default menjadi Poppins
        fontFamily: 'Poppins',

        // Mengatur skema warna utama aplikasi
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Warna utama dari tombol login
          primary: const Color(0xFF4CAF50),
        ),

        // Mengatur warna latar belakang default untuk semua Scaffold (halaman)
        scaffoldBackgroundColor: const Color(0xFFE6F8E8),

        // Mengatur tema default untuk semua ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50), // Warna tombol
            foregroundColor: Colors.white, // Warna teks di dalam tombol
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

        // Mengatur tema default untuk semua TextField
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // Hilangkan border default
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),

        useMaterial3: true,
      ),

      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}