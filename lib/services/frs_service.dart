// lib/services/frs_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException
import 'package:shared_preferences/shared_preferences.dart';
// Anda mungkin perlu model JadwalTersedia di sini jika parsing dilakukan di service
// atau jika FrsViewModel mengembalikan objek model yang sudah diparsing.
// Untuk konsistensi, kita bisa definisikan model JadwalTersedia di file model terpisah atau di sini.
// Saya akan pindahkan definisi JadwalTersedia ke sini untuk sementara agar service ini mandiri.

class JadwalTersedia {
  final int idJadwal;
  final String? kodeMatkul;
  final String? namaMatkul;
  final int sks;
  final String? namaDosen;
  final String? namaDosen2; // Ini perlu diambil dari objek dosen_2 jika ada
  final String? hari;
  final String? jamMulai;
  final String? jamSelesai;
  final String? ruangan;
  final String? kelasJadwal; // Ini perlu diambil dari objek kelas jika ada
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
    // print(" DEBUG: Parsing JadwalTersedia JSON: $json"); // Boleh tetap ada untuk debug

    // Ambil objek nested terlebih dahulu
    final matkulData = json['matkul'] as Map<String, dynamic>?;
    final dosenData = json['dosen'] as Map<String, dynamic>?;
    final waktuData = json['waktu'] as Map<String, dynamic>?;
    final ruanganData = json['ruangan'] as Map<String, dynamic>?;
    
    // Untuk dosen_2 dan kelas_jadwal, kita perlu lihat bagaimana API mengirimkannya.
    // Dari Laravel controller, Anda mengirim 'nama_dosen_2' dan 'kelas_jadwal' secara langsung di mapping.
    // Jadi, kita bisa akses langsung dari 'json'.
    // Jika API mengirim objek 'dosen_kedua' dan 'kelas', maka parsingnya akan beda.
    // Saya akan asumsikan API Anda mengirim field 'nama_dosen_2' dan 'kelas_jadwal'
    // langsung di level atas JSON jadwal_tersedia (sesuai mapping di Laravel).

    return JadwalTersedia(
      idJadwal: json['id_jadwal'] as int,
      
      // Mengambil dari dalam objek 'matkul'
      kodeMatkul: matkulData?['kode_matkul'] as String?,
      namaMatkul: matkulData?['nama_matkul'] as String?,
      sks: matkulData?['sks'] as int? ?? 0,
      jenisMatkul: matkulData?['jenis'] as String? ?? 'Pilihan', // 'jenis' ada di dalam 'matkul'

      // Mengambil dari dalam objek 'dosen'
      namaDosen: dosenData?['nama_dosen'] as String?,
      
      // Mengambil dari objek 'dosen_kedua' jika API mengirimnya sebagai objek
      // Jika API Anda mengirim 'nama_dosen_2' langsung, maka:
      namaDosen2: json['nama_dosen_2'] as String?, // Sesuaikan dengan output API Anda
                                                   // Jika API mengirim objek "dosen_kedua":
                                                   // (json['dosen_kedua'] as Map<String,dynamic>?)?['nama_dosen'] as String?,


      // Mengambil dari dalam objek 'waktu'
      hari: waktuData?['hari'] as String?,
      jamMulai: waktuData?['jam_mulai'] as String?, // Ini sudah string "HH:MM:SS"
      jamSelesai: waktuData?['jam_selesai'] as String?, // Ini sudah string "HH:MM:SS"

      // Mengambil dari dalam objek 'ruangan'
      // Anda bisa pilih mau 'nama_ruangan' atau 'kode_ruangan'
      ruangan: ruanganData?['nama_ruangan'] as String? ?? ruanganData?['kode_ruangan'] as String?,
      
      // Mengambil dari objek 'kelas' jika API mengirimnya sebagai objek
      // Jika API Anda mengirim 'kelas_jadwal' langsung, maka:
      kelasJadwal: json['kelas_jadwal'] as String?, // Sesuaikan dengan output API Anda
                                                    // Jika API mengirim objek "kelas":
                                                    // (json['kelas'] as Map<String,dynamic>?)?['nama_kelas_full'] as String?
                                                    // atau (json['kelas'] as Map<String,dynamic>?)?['nama_kelas'] as String?
    );
  }
}
class FrsService {
  // --- PENTING: SESUAIKAN IP ADDRESS DAN PORT SERVER ANDA ---
  static const String _baseUrl =
      'http://10.0.2.2:8000/api'; // <--- GANTI IP JIKA PERLU

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
          Uri.parse('$_baseUrl/mahasiswa/frs/current/add-schedules'),
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
          // Menggunakan DELETE
          Uri.parse('$_baseUrl/mahasiswa/frs/drop/$idDetailFrs'),
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
