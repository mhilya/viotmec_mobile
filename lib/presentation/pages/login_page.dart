import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viotmec_mobile/presentation/providers/auth_provider.dart';
import 'package:viotmec_mobile/routes/app_routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani aksi login
  void _handleLogin() async {
    // Ambil AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    // Panggil fungsi login dari provider
    bool success = await authProvider.login(email, password);

    // Cek hasil login
    if (mounted) {
      // Pastikan widget masih ada di tree
      if (success) {
        // Jika sukses, navigasi ke dashboard
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        // Jika gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tonton state dari provider
    final authProvider = context.watch<AuthProvider>();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Akses akun anda dengan menggunakan\nemail dan password anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 327,
                    height: 40,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        hintText: 'Alamat Email',
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 327,
                    height: 40,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 327,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: authProvider.state == AuthState.loading
                          ? null // Nonaktifkan tombol saat loading
                          : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: authProvider.state == AuthState.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins'),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontFamily: 'Poppins'),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Dengan mengklik Login, Anda setuju dengan '),
                        TextSpan(
                          text: 'Syarat dan Ketentuan',
                          style: TextStyle(
                              color: Color(0xFF388E3C),
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' serta '),
                        TextSpan(
                          text: 'Kebijakan Privasi kami',
                          style: TextStyle(
                              color: Color(0xFF388E3C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}