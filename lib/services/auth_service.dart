// lib/services/auth_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException

class AuthService {
  // --- PENTING: SESUAIKAN IP ADDRESS DAN PORT SERVER ANDA ---
  static const String _apiUrl = 'http://192.168.96.123:8000/api/login';
  /* static const String _apiUrl = 'http://192.168.96.123:8000/api/login'; */

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 45)); // Timeout disesuaikan (misal 45 detik)

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseData; // Mengandung token, message, dan data user dasar
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(responseData['message'] ?? 'Email, password, atau role salah.');
    } else {
      throw Exception(responseData['message'] ?? 'Terjadi kesalahan pada server (Status: ${response.statusCode})');
    }
  }
}