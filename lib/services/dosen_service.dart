import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siakad_trivium/models/dosen_model.dart';
import 'package:siakad_trivium/utils/shared_pref_helper.dart';

class DosenService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  // Menggunakan SharedPrefHelper untuk mengambil token
  Future<String?> _getToken() async {
    return await SharedPrefHelper.getUserToken();
  }

  Future<List<DosenModel>> fetchDosenList() async {
    String? token = await _getToken();
    print("Token yang digunakan untuk fetchDosenList: $token"); // Debugging

    if (token == null) {
      print("Token tidak ditemukan, request dibatalkan.");
      // Kamu bisa melempar error spesifik atau mengarahkan ke halaman login jika perlu
      throw Exception(
        'Sesi Anda telah berakhir atau token tidak ditemukan. Silakan login kembali.',
      );
    }

    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/dosen'), // Endpoint untuk daftar dosen
            headers: {
              'Accept': 'application/json',
              'Authorization':
                  'Bearer $token', // Menggunakan token yang diambil
            },
          )
          .timeout(const Duration(seconds: 30)); // Sesuaikan timeout

      print("Status Code Dosen List: ${response.statusCode}");
      print("Response Body Dosen List: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> dosenData = jsonResponse['data'];
        List<DosenModel> dosenList =
            dosenData
                .map(
                  (data) => DosenModel.fromJson(data as Map<String, dynamic>),
                )
                .toList();
        return dosenList;
      } else if (response.statusCode == 401) {
        // Token tidak valid atau kadaluwarsa, mungkin perlu hapus token lokal dan arahkan ke login
        await SharedPrefHelper.clearUserToken(); // Hapus token yang salah
        throw Exception(
          'Autentikasi gagal (401). Sesi Anda mungkin telah berakhir. Silakan login kembali.',
        );
      } else {
        // Tangani error server lainnya
        final responseData = jsonDecode(response.body);
        throw Exception(
          responseData['message'] ??
              'Gagal memuat data dosen (Status: ${response.statusCode})',
        );
      }
    } on TimeoutException {
      throw Exception('Koneksi ke server time out saat mengambil data dosen.');
    } on http.ClientException catch (e) {
      // Termasuk SocketException
      throw Exception(
        'Gagal terhubung ke server saat mengambil data dosen. Periksa koneksi Anda.',
      );
    } catch (e) {
      print("Error di fetchDosenList: $e");
      // Jika errornya sudah string dari Exception sebelumnya, jangan di-wrap lagi
      if (e is Exception && e.toString().startsWith('Exception: ')) {
        throw Exception(e.toString().replaceFirst('Exception: ', ''));
      }
      throw Exception(
        'Terjadi kesalahan tidak diketahui saat mengambil data dosen.',
      );
    }
  }
}
