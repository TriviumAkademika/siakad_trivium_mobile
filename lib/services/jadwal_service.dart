// lib/services/jadwal_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/models/jadwal_model.dart'; // Sesuaikan path

class JadwalService {
  // Sesuaikan dengan base URL API Anda
  static const String _baseUrl = "http://192.168.96.123:8000/api"; // GANTI JIKA PERLU

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token'); // Pastikan key token Anda benar
  }

  Future<List<JadwalModel>> fetchJadwalMahasiswa({required String hari, String? searchTerm}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    Map<String, String> queryParams = {
      'hari': hari,
    };
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['search'] = searchTerm;
    }
    // Contoh jika ingin mengambil lebih banyak item sekaligus atau semua item (hati-hati jika data sangat besar)
    // queryParams['per_page'] = '100'; 

    // Pastikan endpoint ini benar: /mahasiswa/jadwal atau /jadwal
    final uri = Uri.parse('$_baseUrl/mahasiswa/jadwal').replace(queryParameters: queryParams);
    
    print('Fetching jadwal from: $uri'); // Untuk debugging

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          final List<dynamic> jadwalDataList = responseData['data'] as List<dynamic>;
          if (jadwalDataList.isEmpty) {
            return []; // Kembalikan list kosong jika tidak ada data
          }
          return jadwalDataList.map((jsonItem) => JadwalModel.fromJson(jsonItem as Map<String, dynamic>)).toList();
        } else {
          print('API response for jadwal does not contain "data" field: ${response.body}');
          throw Exception('Format data jadwal tidak sesuai dari API.');
        }
      } catch (e) {
        print('Error parsing jadwal data: $e. Response body: ${response.body}');
        throw Exception('Gagal memproses data jadwal. Respons: ${response.body.substring(0, (response.body.length > 200 ? 200 : response.body.length))}...');
      }
    } else if (response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_token');
      throw Exception('Sesi Anda telah berakhir atau tidak valid (401). Silakan login ulang.');
    } else {
      print('Gagal memuat jadwal. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Gagal memuat jadwal (Status: ${response.statusCode}). Respons: ${response.body.substring(0, (response.body.length > 200 ? 200 : response.body.length))}...');
    }
  }
}