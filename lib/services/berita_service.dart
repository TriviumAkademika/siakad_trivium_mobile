// lib/services/berita_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
import '../models/berita.dart'; // Pastikan path ini benar

class BeritaService {
  static const String _baseUrl = "http://10.0.2.2:8000/api";

  // Helper untuk mendapatkan token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<Berita> fetchBeritaById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Sesi tidak ditemukan (token null). Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/berita/$id'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Sertakan token
      },
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        if (jsonData != null) {
          return Berita.fromJson(jsonData as Map<String, dynamic>);
        } else {
          throw Exception('API returned null data for news ID: $id. Response body: ${response.body}');
        }
      } catch (e) {
        print('Error parsing news data for ID $id: $e. Response body: ${response.body}');
        throw Exception('Failed to parse news data. Response: ${response.body.substring(0, (response.body.length > 200 ? 200 : response.body.length))}...');
      }
    } else if (response.statusCode == 401) {
      // Mungkin token sudah tidak valid, hapus token dan minta login ulang
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_token');
      throw Exception('Sesi Anda telah berakhir atau tidak valid (401). Silakan login ulang.');
    } else {
      print('Failed to load news for ID $id. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load news. Status Code: ${response.statusCode}. Body: ${response.body.substring(0, (response.body.length > 200 ? 200 : response.body.length))}...');
    }
  }

  Future<List<Berita>> fetchAllBerita() async {
    final token = await _getToken();
    if (token == null) {
      // Jika Anda ingin berita bisa diakses publik (tanpa login), maka bagian ini perlu logika berbeda.
      // Untuk saat ini, kita asumsikan berita butuh login.
      throw Exception('Sesi tidak ditemukan (token null). Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/berita'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Sertakan token
      },
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body) as List<dynamic>;
        return jsonData.map((item) => Berita.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        print('Error parsing all news data: $e. Response body: ${response.body}');
        throw Exception('Failed to parse all news data. Response: ${response.body.substring(0, (response.body.length > 200 ? 200 : response.body.length))}...');
      }
    } else if (response.statusCode == 401) {
      // Token tidak valid atau sesi berakhir
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_token'); // Hapus token yang tidak valid
      throw Exception('Sesi Anda telah berakhir atau tidak valid (401). Silakan login ulang.');
    } else {
      print('Failed to load all news. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load all news. Status Code: ${response.statusCode}. Body: ${response.body.substring(0, (response.body.length > 200 ? 200 : response.body.length))}...');
    }
  }
}