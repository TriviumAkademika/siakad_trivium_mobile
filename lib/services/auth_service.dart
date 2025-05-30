// lib/services/auth_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException

class AuthService {
  // PASTIKAN URL INI BENAR SESUAI CARA ANDA MENJALANKAN APLIKASI & SERVER:
  // Emulator Android: 'http://10.0.2.2:8000/api/login'
  // Device Fisik: 'http://IP_LOKAL_KOMPUTER_ANDA:8000/api/login' (dan server Laravel --host=0.0.0.0)
  // Web (Chrome): 'http://127.0.0.1:8000/api/login'
  static const String _apiUrl = 'http://10.0.2.2:8000/api/login'; // Default untuk emulator

  Future<Map<String, dynamic>> login(String email, String password) async {
    // TimeoutException, http.ClientException (SocketException), FormatException akan di-throw dari sini
    // dan ditangkap oleh ViewModel
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
    ).timeout(const Duration(seconds: 20)); // Timeout request 20 detik

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Berhasil, kembalikan data (token dan message)
      return responseData;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Gagal autentikasi atau otorisasi, lempar error dengan pesan dari API
      throw Exception(responseData['message'] ?? 'Autentikasi atau otorisasi gagal');
    } else {
      // Error server lainnya
      throw Exception(responseData['message'] ?? 'Terjadi kesalahan pada server (Status: ${response.statusCode})');
    }
  }
}