import 'package:chincare/main.dart';
import 'package:chincare/prrivacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // Untuk API update jika diperlukan

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;
  bool _isLoadingData = true;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Ambil data dari Local Storage
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user_data');
    if (userString != null) {
      setState(() {
        _userData = jsonDecode(userString);
        _nameController.text = _userData['nama'] ?? "User";
        _isLoadingData = false;
      });
    }
  }

  // Fungsi Simpan Nama Baru
  // Fungsi Simpan Nama Baru ke API & Local Storage
  Future<void> _saveName() async {
    setState(() {
      _isEditing = false;
      _isLoadingData = true;
    });

    try {
      // PRINT UID UNTUK PENGECEKAN
      print("DEBUG: _userData content: $_userData");
      final String? currentUid = _userData['uid'];
      print("DEBUG: UID yang akan dikirim: $currentUid");

      if (currentUid == null || currentUid.isEmpty) {
        throw "UID tidak ditemukan di penyimpanan lokal!";
      }

      final response = await http.post(
        Uri.parse(
          'https://beendapps.site/update-profile-name',
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": currentUid,
          "nama": _nameController.text.trim(),
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final Map<String, dynamic> updatedUserData = responseData['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(updatedUserData));

        setState(() {
          _userData = updatedUserData;
          _nameController.text = updatedUserData['nama'];
          _isLoadingData = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully! ✨"),
              backgroundColor: Color(0xFF9AA58F),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        final errorMsg = jsonDecode(response.body)['error'] ?? "Unknown Error";
        throw "Server Error (${response.statusCode}): $errorMsg";
      }
    } catch (e) {
      print("CATCH ERROR: $e");
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

// Fungsi untuk Menghapus Akun Permanen
  Future<void> _functiondelete(BuildContext context) async {
    // 1. Tampilkan Dialog Konfirmasi (Sangat Penting untuk UX & Keamanan)
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun?"),
        content: const Text(
          "Tindakan ini permanen. Semua data Chinchilla Anda akan ikut terhapus dari sistem kami.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    setState(() => _isLoadingData = true);

    try {
      final String? currentUid = _userData['uid'];
      if (currentUid == null) throw "UID tidak ditemukan!";

      final response = await http.delete(
        Uri.parse('https://beendapps.site/delete-account'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"uid": currentUid}),
      );

      if (response.statusCode == 200) {
        // 2. Jika sukses di Backend, bersihkan data Lokal
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (mounted) {
          // 3. Tampilkan Snackback sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Akun Anda telah berhasil dihapus. 👋"),
              backgroundColor: Colors.black87,
            ),
          );

          // 4. Kembali ke Login Page (Reset Navigasi)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } else {
        throw "Gagal menghapus akun: ${response.statusCode}";
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }


  Future<void> _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color softBeige = Color(0xFFF5F0E1);
    const Color deepBrown = Color(0xFF4E342E);

    if (_isLoadingData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String email = _userData['email'] ?? "Email tidak ditemukan";
    String rawDate = _userData['created_at'] ?? DateTime.now().toString();
    String formattedDate = DateFormat(
      'dd MMMM yyyy',
    ).format(DateTime.parse(rawDate));

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "MY PROFILE",
          style: TextStyle(
            color: deepBrown,
            letterSpacing: 2,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- HEADER: FOTO PROFIL ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: softBeige,
                  backgroundImage: NetworkImage(
                    'https://api.dicebear.com/7.x/avataaars/png?seed=${_nameController.text}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- BAGIAN NAMA DENGAN ICON EDIT/SAVE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 40), // Spacer penyeimbang icon di kanan
                  Expanded(
                    child: _isEditing
                        ? TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: deepBrown,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan nama",
                            ),
                          )
                        : Text(
                            _nameController.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: deepBrown,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.check_circle : Icons.edit_note_rounded,
                      color: _isEditing ? Colors.green : deepBrown,
                      size: 28,
                    ),
                    onPressed: () {
                      if (_isEditing) {
                        _saveName();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
                  ),
                ],
              ),
            ),

            const Text(
              "Chinchilla Enthusiast",
              style: TextStyle(color: Colors.grey, letterSpacing: 1),
            ),
            const SizedBox(height: 30),

            // --- INFO CARDS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.person_outline,
                      "Nama Lengkap",
                      _nameController.text,
                    ),
                    const Divider(height: 30, thickness: 0.5),
                    _buildInfoRow(Icons.email_outlined, "Email", email),
                    const Divider(height: 30, thickness: 0.5),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      "Dibuat Pada",
                      formattedDate,
                    ),
                    const Divider(height: 30, thickness: 0.5),
                    _buildInfoRow(
                      Icons.article_outlined,
                      "Status Akun",
                      "Active Member",
                    ),
                    const Divider(height: 30, thickness: 0.5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                      child: _buildInfoRow(
                        Icons.web,
                        " ",
                        "Privacy Policy",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- MENU LAINNYA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _buildMenuButton(Icons.settings_outlined, "Settings", () { ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.upcoming, color: Colors.white),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Upcoming update — fitur ini akan segera hadir',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF9AA58F), // green soft
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );}),
                  _buildMenuButton(Icons.help_outline, "Support Center", () { ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.upcoming, color: Colors.white),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Upcoming update — fitur ini akan segera hadir',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF9AA58F), // green soft
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );}),
                  _buildMenuButton(
                    Icons.logout,
                    "Logout",
                    () => _handleLogout(context),
                  ),
                   _buildMenuButton(
                    Icons.delete,
                    "Delete Account",
                    
                    () => _functiondelete(context),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFBF7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF8D6E63), size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF4E342E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(IconData icon, String title, VoidCallback function) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEFEBE9)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8D6E63)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, color: Color(0xFF4E342E)),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: function,
      ),
    );
  }
}
