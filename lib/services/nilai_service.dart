import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException
import 'package:http/http.dart' as http;
import 'package:siakad_trivium/models/nilai_mahasiswa_model.dart'; // Sesuaikan path
import 'package:siakad_trivium/utils/shared_pref_helper.dart'; // Untuk mengambil token

class NilaiService {
  final String _baseUrl = 'http://10.0.2.2:8000/api'; // Sesuaikan jika perlu

  Future<List<NilaiMahasiswaModel>> fetchNilaiMahasiswa({
    String? searchQuery,
  }) async {
    String? token = await SharedPrefHelper.getUserToken();
    if (token == null) {
      throw Exception(
        'Sesi Anda telah berakhir atau token tidak ditemukan. Silakan login kembali.',
      );
    }

    // Membangun URI dengan query parameter untuk search jika ada
    var uri = Uri.parse('$_baseUrl/mahasiswa/nilai');
    if (searchQuery != null && searchQuery.isNotEmpty) {
      uri = uri.replace(queryParameters: {'search': searchQuery});
    }

    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true &&
            responseData['data'] != null &&
            responseData['data']['nilai_list'] != null) {
          List<dynamic> nilaiListData = responseData['data']['nilai_list'];
          return nilaiListData
              .map(
                (data) =>
                    NilaiMahasiswaModel.fromJson(data as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw Exception(
            responseData['message'] ?? 'Gagal memproses data nilai.',
          );
        }
      } else if (response.statusCode == 401) {
        await SharedPrefHelper.clearUserToken();
        throw Exception(
          'Autentikasi gagal (401). Sesi Anda mungkin telah berakhir.',
        );
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
          responseData['message'] ??
              'Gagal memuat data nilai (Status: ${response.statusCode})',
        );
      }
    } on TimeoutException {
      throw Exception('Koneksi ke server time out saat mengambil data nilai.');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server. Periksa koneksi Anda.');
    } catch (e) {
      // Tangkap error yang sudah berupa Exception dengan pesan yang jelas
      if (e is Exception && e.toString().startsWith('Exception: ')) {
        throw Exception(e.toString().replaceFirst('Exception: ', ''));
      }
      throw Exception(
        'Terjadi kesalahan tidak diketahui saat mengambil data nilai.',
      );
    }
  }
}