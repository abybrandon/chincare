import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL API Firebase Functions kamu
  static const String baseUrl = 'https://beendapps.site';

  // --- FUNGSI LOGIN ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Kita tambahkan status code untuk membantu UI membedakan sukses/gagal
      final Map<String, dynamic> data = jsonDecode(response.body);
      data['status_code'] = response.statusCode; 
      return data;
    } catch (e) {
      return {'message': 'Terjadi kesalahan koneksi: $e', 'status_code': 500};
    }
  }

  // --- FUNGSI REGISTER ---
  Future<Map<String, dynamic>> register(String nama, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      data['status_code'] = response.statusCode;
      return data;
    } catch (e) {
      return {'message': 'Terjadi kesalahan koneksi: $e', 'status_code': 500};
    }
  }
}