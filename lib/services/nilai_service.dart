import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siakad_trivium/models/nilai_mahasiswa_model.dart'; // Sesuaikan path
import 'package:shared_preferences/shared_preferences.dart'; // Untuk ambil token

class NilaiService {
  static const String _apiUrl = 'http://10.0.2.2:8000/api';
  /* static const String _apiUrl = 'http://192.168.96.123:8000/api'; */

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token'); //
  } // Ambil token buat otentikasi ke API setiap kali mau ambil data yang butuh akses user yang sudah login.

  Future<NilaiMahasiswaResponse> getNilaiMahasiswa({
    String? tahunAjaran, // Untuk filter
    String? jenisNilai, // Untuk filter (UTS/UAS)
    String? searchTerm, // Untuk search
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    // Membuat query parameters
    Map<String, String> queryParams = {};
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['search'] = searchTerm;
    }
    // TODO: Implementasi filter tahunAjaran dan jenisNilai di API jika diperlukan
    // Saat ini API belum mendukung filter ini secara langsung, jadi parameter ini belum digunakan di URL
    // Jika sudah didukung, tambahkan ke queryParams

    // Membuat Uri dengan query parameters
    var uri = Uri.parse(
      '$_apiUrl/mahasiswa/nilai',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

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
      // Token mungkin tidak valid atau expired
      throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
    } else {
      // Coba parse error message dari API jika ada
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
