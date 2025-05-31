// lib/services/profile_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path jika perlu

class ProfileService {
  // Sesuaikan dengan URL API Anda
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // Default untuk emulator

  Future<UserProfileResponse> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      // Token mungkin tidak valid atau kedaluwarsa
      await prefs.remove('user_token'); // Hapus token yang tidak valid
      throw Exception('Sesi Anda telah berakhir. Silakan login ulang. (401)');
    } else {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Gagal memuat profil (Status: ${response.statusCode})');
    }
  }

  // Anda bisa menambahkan method untuk logout API di sini jika ada
  // Future<void> logout() async { ... }
}