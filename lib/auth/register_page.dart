import 'package:chincare/my_chinchilla/list_chinchilla.dart';
import 'package:chincare/services/auth.dart';
import 'package:flutter/material.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  // Palette warna Chincare
  final Color mainGreen = const Color(0xFF6B8E6B);
  final Color deepBrown = const Color(0xFF4E342E);
  final Color textGreen = const Color(0xFF2D442E);

  // FUNGSI HANDLE REGISTER
  Future<void> _handleRegister() async {
    // 1. Validasi sederhana
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. Panggil AuthService
    final result = await _authService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // 3. Cek hasil (Status 201 = Created di Node.js kamu)
    if (result['status_code'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text("Registrasi Berhasil! Silahkan Login.")),
      );
      // Tunggu sebentar lalu balik ke Login
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      // Tampilkan pesan error dari backend (misal: "Email sudah terdaftar")
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.redAccent, content: Text(result['message'] ?? "Gagal mendaftar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                
                // --- HEADER SECTION ---
                Image.asset(
                  "images/chin.png", // Pastikan path asset benar
                  height: 140,
                  width: 140,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 100, color: Color(0xFF6B8E6B)),
                ),
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Color(0xFF6B8E6B),
                  ),
                ),
                const Text(
                  "Join the Chinchilla community",
                  style: TextStyle(color: Color(0xFF6B8E6B), letterSpacing: 1, fontSize: 12),
                ),
                const SizedBox(height: 40),

                // --- INPUT FIELDS ---
                _buildInputField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                  hint: "Enter your full name",
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _emailController,
                  label: "Email Address",
                  icon: Icons.email_outlined,
                  hint: "Enter your email",
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  hint: "Enter your password",
                ),
                const SizedBox(height: 40),

                // --- BUTTON REGISTER ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      shadowColor: deepBrown.withOpacity(0.3),
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                  ),
                ),

                const SizedBox(height: 25),

                // --- LINK BALIK KE LOGIN ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login Now",
                        style: TextStyle(color: mainGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper Input Field (Sesuai style yang kamu minta)
  Widget _buildInputField({
    required TextEditingController controller, 
    required String label, 
    required IconData icon, 
    bool isPassword = false,
    required String hint
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(fontWeight: FontWeight.w600, color: textGreen)
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
                offset: const Offset(0, 4)
              )
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: mainGreen, size: 20),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}