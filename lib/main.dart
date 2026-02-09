// import 'package:chincare/home/dashboard_page.dart';
// import 'package:chincare/services/auth.dart';
import 'dart:convert';
import 'dart:io';

import 'package:chincare/app_theme.dart';
import 'package:chincare/auth/register_page.dart';
import 'package:chincare/home/chinchilla_list_screen.dart';
import 'package:chincare/home/dashboard_page.dart';
import 'package:chincare/my_chinchilla/list_chinchilla.dart';
import 'package:chincare/prrivacy_policy.dart';
import 'package:chincare/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';

// --- MAIN WRAPPER ---
void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await SharedPreferences.getInstance();

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          // DashboardPage(name: '',uid: '',)
          LoginPage(),
    );
  }
}

// --- LOGIN PAGE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
Future<void> _handleLogin() async {
  // 1. Pastikan keyboard ketutup biar gak ganggu UI pas pindah halaman
  FocusScope.of(context).unfocus();
  
  setState(() => _isLoading = true);

  try {
    // 2. Panggil API Login
    final result = await AuthService().login(
      _emailController.text,
      _passwordController.text,
    );

    print('Log: Result dari API -> $result');

    // 3. Cek Status Code
    if (result['status_code'].toString() == "200") {
      
      // 4. Inisialisasi Shared Preferences (Panggil saat dibutuhkan)
      // Ini solusi buat error PlatformException(channel-error) tadi
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('token', result['token'] ?? '');
      await prefs.setString('user_data', jsonEncode(result['user']));

      final userData = result['user'];

      // Berhenti loading sebelum pindah
      setState(() => _isLoading = false);

      // 5. Pindah ke Dashboard
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            uid: userData['uid'],
            name: userData['nama'],
          ),
        ),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome, ${userData['nama']}!"),
          backgroundColor: const Color(0xFF6B8E6B),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() => _isLoading = false);
      // Tampilkan error mentah di halaman debug jika status bukan 200
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => DebugErrorPage(
          errorContent: "Server Error (Status ${result['status_code']}):\n${result.toString()}"
        )
      ));
    }
  } on SocketException catch (e) {
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => DebugErrorPage(errorContent: "Masalah Koneksi/DNS:\n$e")
    ));
  } catch (e) {
    setState(() => _isLoading = false);
    print("Detail Error: $e");
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => DebugErrorPage(errorContent: "Exception Terdeteksi (Cek SharedPrefs/Type):\n$e")
    ));
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Chinchilla Care",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // AREA IMAGE (Ganti ke placeholder jika belum ada asset)
              Image.asset("images/chin.png", height: 140, width: 140),
              const SizedBox(height: 10),
              const Text(
                "Smart Living for Your Chinchilla",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D442E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              _buildInput(
                controller: _emailController,
                label: "Email",
                icon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 20),
              _buildInput(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline_rounded,
                isPass: true,
              ),

              const SizedBox(height: 40),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B8E6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
              // Di dalam LoginPage, pada bagian teks bawah:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF6B8E6B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D442E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPass,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF6B8E6B), size: 20),
              border: InputBorder.none,
              hintText: "Enter your $label",
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
class DebugErrorPage extends StatelessWidget {
  final String errorContent;
  const DebugErrorPage({super.key, required this.errorContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Raw Debug Info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText( // Pake SelectableText biar bisa di-copy errornya
          errorContent,
          style: const TextStyle(fontFamily: 'monospace', color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }
}