// lib/services/profile_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path

class ProfileService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // << GANTI IP JIKA PERLU

  Future<UserProfileResponse> getProfile() async {
    // ... (kode sama seperti sebelumnya)
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 45));

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      await prefs.remove('user_token');
      throw Exception('Sesi Anda telah berakhir. Silakan login ulang (401).');
    } else {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Gagal memuat profil (Status: ${response.statusCode})');
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    // ... (kode sama seperti sebelumnya)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/profile/password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      }),
    ).timeout(const Duration(seconds: 45));

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    } else if (response.statusCode == 401) {
       await prefs.remove('user_token');
       throw Exception('Sesi Anda telah berakhir. Silakan login ulang (401).');
    } else if (response.statusCode == 422) {
      String errorMessage = responseData['message'] ?? 'Data yang dimasukkan tidak valid.';
      if (responseData.containsKey('errors')) {
        Map<String, dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          final firstErrorField = errors.values.first;
          if (firstErrorField is List && firstErrorField.isNotEmpty) {
            errorMessage = firstErrorField.first as String;
          }
        }
      }
      throw Exception(errorMessage);
    }
     else {
      throw Exception(responseData['message'] ?? 'Gagal memperbarui password (Status: ${response.statusCode})');
    }
  }

  // Method logoutAPI() bisa dihapus atau dikomentari jika tidak dipakai lagi
  /*
  Future<void> logoutAPI() async {
    // ... kode lama ...
  }
  */
}