import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException
import 'package:shared_preferences/shared_preferences.dart';

// Model for available schedules (unchanged, still needed for adding courses)
class JadwalTersedia {
  final int idJadwal;
  final String? kodeMatkul;
  final String? namaMatkul;
  final int sks;
  final String? namaDosen;
  final String? namaDosen2;
  final String? hari;
  final String? jamMulai;
  final String? jamSelesai;
  final String? ruangan;
  final String? kelasJadwal;
  final String? jenisMatkul;

  JadwalTersedia({
    required this.idJadwal,
    this.kodeMatkul,
    this.namaMatkul,
    required this.sks,
    this.namaDosen,
    this.namaDosen2,
    this.hari,
    this.jamMulai,
    this.jamSelesai,
    this.ruangan,
    this.kelasJadwal,
    this.jenisMatkul,
  });

  factory JadwalTersedia.fromJson(Map<String, dynamic> json) {
    final matkulData = json['matkul'] as Map<String, dynamic>?;
    final dosenData = json['dosen'] as Map<String, dynamic>?;
    final waktuData = json['waktu'] as Map<String, dynamic>?;
    final ruanganData = json['ruangan'] as Map<String, dynamic>?;

    return JadwalTersedia(
      idJadwal: json['id_jadwal'] as int,
      kodeMatkul: matkulData?['kode_matkul'] as String?,
      namaMatkul: matkulData?['nama_matkul'] as String?,
      sks: matkulData?['sks'] as int? ?? 0,
      jenisMatkul: matkulData?['jenis'] as String? ?? 'Pilihan',
      namaDosen: dosenData?['nama_dosen'] as String?,
      namaDosen2: json['nama_dosen_2'] as String?,
      hari: waktuData?['hari'] as String?,
      jamMulai: waktuData?['jam_mulai'] as String?,
      jamSelesai: waktuData?['jam_selesai'] as String?,
      ruangan: ruanganData?['nama_ruangan'] as String? ?? ruanganData?['kode_ruangan'] as String?,
      kelasJadwal: json['kelas_jadwal'] as String?,
    );
  }
}

// Model NEW: Represents a course selected in the FRS, including its status
class DetailFrsItem {
  final int idDetailFrs;
  final int idFrs;
  final int idJadwal;
  final bool status; // The approval status of this FRS detail entry
  final String jenis;
  final int sks;
  final String namaMatkul;
  final String dosen1;
  final String? dosen2;
  final String? hari;
  final String? jamMulai;
  final String? jamSelesai;
  final String? ruangan;
  final String? kelasJadwal;

  DetailFrsItem({
    required this.idDetailFrs,
    required this.idFrs,
    required this.idJadwal,
    required this.status,
    required this.jenis,
    required this.sks,
    required this.namaMatkul,
    required this.dosen1,
    this.dosen2,
    this.hari,
    this.jamMulai,
    this.jamSelesai,
    this.ruangan,
    this.kelasJadwal,
  });

  factory DetailFrsItem.fromJson(Map<String, dynamic> json) {
    final jadwalData = json['jadwal'] as Map<String, dynamic>?;
    final matkulData = jadwalData?['matkul'] as Map<String, dynamic>?;
    final dosenData = jadwalData?['dosen'] as Map<String, dynamic>?;
    final waktuData = jadwalData?['waktu'] as Map<String, dynamic>?;
    final ruanganData = jadwalData?['ruangan'] as Map<String, dynamic>?;

    // Perubahan di sini: Mengonversi integer (0/1) menjadi boolean
    final int? statusInt = json['status'] as int?;
    final bool parsedStatus = statusInt == 1; // Jika 1 maka true, selain itu false

    return DetailFrsItem(
      idDetailFrs: json['id_detail_frs'] as int,
      idFrs: json['id_frs'] as int,
      idJadwal: json['id_jadwal'] as int,
      status: parsedStatus, // Menggunakan nilai boolean yang sudah di-parse
      jenis: matkulData?['jenis'] as String? ?? 'Pilihan',
      sks: matkulData?['sks'] as int? ?? 0,
      namaMatkul: matkulData?['nama_matkul'] as String? ?? 'Nama Mata Kuliah Tidak Diketahui',
      dosen1: dosenData?['nama_dosen'] as String? ?? 'Dosen Tidak Diketahui',
      dosen2: jadwalData?['nama_dosen_2'] as String?,
      hari: waktuData?['hari'] as String?,
      jamMulai: waktuData?['jam_mulai'] as String?,
      jamSelesai: waktuData?['jam_selesai'] as String?,
      ruangan: ruanganData?['nama_ruangan'] as String?,
      kelasJadwal: jadwalData?['kelas_jadwal'] as String?,
    );
  }
}

class FrsService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // <--- GANTI IP JIKA PERLU

  Future<Map<String, dynamic>> getCurrentFrsData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http
        .get(
          Uri.parse('$_baseUrl/mahasiswa/frs'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 30));

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData['data'] as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      await prefs.remove('user_token');
      throw Exception(
        responseData['message'] ?? 'Sesi Anda telah berakhir (401).',
      );
    } else {
      throw Exception(
        responseData['message'] ??
            'Gagal memuat data FRS (Status: ${response.statusCode})',
      );
    }
  }

  Future<Map<String, dynamic>> addSchedulesToFrs(List<int> jadwalIds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http
        .post(
          Uri.parse('$_baseUrl/mahasiswa/frs/courses'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{'jadwal_ids': jadwalIds}),
        )
        .timeout(const Duration(seconds: 30));

    final responseData = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        responseData['success'] == true) {
      return responseData;
    } else if (response.statusCode == 401) {
      await prefs.remove('user_token');
      throw Exception(
        responseData['message'] ?? 'Sesi Anda telah berakhir (401).',
      );
    } else if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 409 ||
        response.statusCode == 422) {
      throw Exception(responseData['message'] ?? 'Gagal menambah jadwal.');
    } else {
      throw Exception(
        responseData['message'] ??
            'Gagal menambah jadwal ke FRS (Status: ${response.statusCode})',
      );
    }
  }

  Future<Map<String, dynamic>> dropScheduleFromFrs(int idDetailFrs) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null) {
      throw Exception('Sesi tidak ditemukan. Silakan login kembali.');
    }

    final response = await http
        .delete(
          Uri.parse('$_baseUrl/mahasiswa/frs/courses/$idDetailFrs'),
          headers: <String, String>{
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 30));

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      return responseData;
    } else if (response.statusCode == 401) {
      await prefs.remove('user_token');
      throw Exception(
        responseData['message'] ?? 'Sesi Anda telah berakhir (401).',
      );
    } else if (response.statusCode == 403 || response.statusCode == 404) {
      throw Exception(responseData['message'] ?? 'Gagal menghapus jadwal.');
    } else {
      throw Exception(
        responseData['message'] ??
            'Gagal menghapus jadwal dari FRS (Status: ${response.statusCode})',
      );
    }
  }
}
