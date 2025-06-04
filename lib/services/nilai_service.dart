// nilai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siakad_trivium/models/nilai_mahasiswa_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk ambil token

class NilaiService {
  static const String _apiUrl = 'http://10.0.2.2:8000/api';
  /* static const String _apiUrl = 'http://192.168.96.123:8000/api'; */

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<NilaiMahasiswaResponse> getNilaiMahasiswa() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    var uri = Uri.parse(
      '$_apiUrl/mahasiswa/nilai',
    );

    print('Requesting: ${uri.toString()}'); // Untuk debugging

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}'); // Untuk debugging
    print('Response body: ${response.body}'); // Untuk debugging

    if (response.statusCode == 200) {
      return nilaiMahasiswaResponseFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal memuat data nilai';
        throw Exception(errorMessage);
      } catch (e) {
        throw Exception(
          'Gagal memuat data nilai. Status: ${response.statusCode}',
        );
      }
    }
  }
}