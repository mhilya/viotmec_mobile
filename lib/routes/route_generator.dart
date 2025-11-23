import 'package:flutter/material.dart';
import 'package:viotmec_mobile/presentation/pages/dashboard_page.dart';
import 'package:viotmec_mobile/presentation/pages/login_page.dart';
import 'package:viotmec_mobile/presentation/pages/riwayat_page.dart';
import 'package:viotmec_mobile/presentation/pages/splash_screen.dart';
import 'package:viotmec_mobile/routes/app_routes.dart';
import 'package:viotmec_mobile/presentation/pages/laporan_page.dart';
import 'package:viotmec_mobile/presentation/pages/main_page.dart';
import 'package:viotmec_mobile/presentation/pages/profile_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _slideRoute(const SplashScreen(), settings);
      case AppRoutes.login:
        return _slideRoute(const LoginPage(), settings);
      case AppRoutes.dashboard:
        return _slideRoute(const DashboardPage(), settings);
      case AppRoutes.laporan:
        return _slideRoute(const LaporanPage(), settings);
      case AppRoutes.main:
        return _slideRoute(const MainPage(), settings);
      case AppRoutes.profile:
        return _slideRoute(const ProfilePage(), settings);
      case AppRoutes.riwayat:
        return _slideRoute(const RiwayatPage(), settings);
      default:
        return _errorRoute();
    }
  }

  // Custom Slide Transition untuk navigasi utama
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.5,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
              ),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // Custom Fade Transition untuk splash screen
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  // Alternatif: Scale Transition (opsional)
  static PageRouteBuilder _scaleRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutBack,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static PageRouteBuilder _slideTransition(Widget page, RouteSettings settings, {bool fromRight = true}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        final begin = fromRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
        const curve = Curves.easeInOutQuart;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.5,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
              ),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
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

