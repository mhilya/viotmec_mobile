import 'package:flutter/material.dart';
// import 'package:iotmcc_mobile/presentation/pages/dashboard_page.dart';
// import 'package:iotmcc_mobile/presentation/pages/forgot_password_page.dart';
import 'package:iotmcc_mobile/presentation/pages/login_page.dart';
import 'package:iotmcc_mobile/presentation/pages/splash_screen.dart';
import 'package:iotmcc_mobile/routes/app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      // case AppRoutes.forgotPassword:
      //   return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(builder: (_) => const DashboardPage());
      
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Halaman tidak ditemukan')),
      );
    });
  }
}