// lib/models/jadwal_model.dart

class KelasModel {
  final int idKelas;
  final String? prodi;
  final String? paralel;
  final String? namaKelas; // Tambahan jika ada di API Anda

  KelasModel({
    required this.idKelas,
    this.prodi,
    this.paralel,
    this.namaKelas,
  });

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      idKelas: json['id_kelas'] as int,
      prodi: json['prodi'] as String?,
      paralel: json['paralel'] as String?,
      namaKelas: json['nama_kelas'] as String?, // Contoh tambahan
    );
  }
}

class MatkulModel {
  final int idMatkul;
  final String? kodeMatkul;
  final String? namaMatkul;
  final int? sks;
  final String? jenis; // Misal: Wajib, Pilihan
  final int? semester;

  MatkulModel({
    required this.idMatkul,
    this.kodeMatkul,
    this.namaMatkul,
    this.sks,
    this.jenis,
    this.semester,
  });

  factory MatkulModel.fromJson(Map<String, dynamic> json) {
    return MatkulModel(
      idMatkul: json['id_matkul'] as int,
      kodeMatkul: json['kode_matkul'] as String?,
      namaMatkul: json['nama_matkul'] as String?,
      sks: json['sks'] as int?,
      jenis: json['jenis'] as String?,
      semester: json['semester'] as int?,
    );
  }
}

class DosenModel {
  final int idDosen;
  final String? nidn;
  final String? namaDosen;
  final String? gelarDepan;
  final String? gelarBelakang;

  DosenModel({
    required this.idDosen,
    this.nidn,
    this.namaDosen,
    this.gelarDepan,
    this.gelarBelakang,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    String namaLengkap = json['nama_dosen'] ?? '';
    if (json['gelar_depan'] != null && (json['gelar_depan'] as String).isNotEmpty) {
      namaLengkap = '${json['gelar_depan']} $namaLengkap';
    }
    if (json['gelar_belakang'] != null && (json['gelar_belakang'] as String).isNotEmpty) {
      namaLengkap = '$namaLengkap, ${json['gelar_belakang']}';
    }

    return DosenModel(
      idDosen: json['id_dosen'] as int,
      nidn: json['nidn'] as String?,
      namaDosen: namaLengkap, // Menggunakan nama lengkap yang sudah diformat
      gelarDepan: json['gelar_depan'] as String?,
      gelarBelakang: json['gelar_belakang'] as String?,
    );
  }
}

class WaktuModel {
  final int idWaktu;
  final String? hari;
  final String? jamMulai; // Format HH:MM:SS dari API
  final String? jamSelesai; // Format HH:MM:SS dari API

  WaktuModel({
    required this.idWaktu,
    this.hari,
    this.jamMulai,
    this.jamSelesai,
  });

  factory WaktuModel.fromJson(Map<String, dynamic> json) {
    return WaktuModel(
      idWaktu: json['id_waktu'] as int,
      hari: json['hari'] as String?,
      jamMulai: json['jam_mulai'] as String?,
      jamSelesai: json['jam_selesai'] as String?,
    );
  }

  String get jamRange {
    if (jamMulai != null && jamSelesai != null) {
      try {
        // Ambil HH:MM dari HH:MM:SS
        final String mulai = jamMulai!.length >= 5 ? jamMulai!.substring(0, 5) : jamMulai!;
        final String selesai = jamSelesai!.length >= 5 ? jamSelesai!.substring(0, 5) : jamSelesai!;
        return '$mulai - $selesai';
      } catch (e) {
        return 'Format Jam Salah';
      }
    }
    return 'N/A';
  }
}

class RuanganModel {
  final int idRuangan;
  final String? kodeRuangan;
  final String? namaRuangan;
  final String? gedung;
  final int? kapasitas;

  RuanganModel({
    required this.idRuangan,
    this.kodeRuangan,
    this.namaRuangan,
    this.gedung,
    this.kapasitas,
  });

  factory RuanganModel.fromJson(Map<String, dynamic> json) {
    return RuanganModel(
      idRuangan: json['id_ruangan'] as int,
      kodeRuangan: json['kode_ruangan'] as String?,
      namaRuangan: json['nama_ruangan'] as String?,
      gedung: json['gedung'] as String?,
      kapasitas: json['kapasitas'] as int?,
    );
  }
}

class JadwalModel {
  final int idJadwal;
  final KelasModel? kelas;
  final MatkulModel? matkul;
  final DosenModel? dosen;
  final DosenModel? dosen2; // Dosen pendamping, bisa null
  final WaktuModel? waktu;
  final RuanganModel? ruangan;

  JadwalModel({
    required this.idJadwal,
    this.kelas,
    this.matkul,
    this.dosen,
    this.dosen2,
    this.waktu,
    this.ruangan,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      idJadwal: json['id_jadwal'] as int,
      kelas: json['kelas'] != null ? KelasModel.fromJson(json['kelas'] as Map<String, dynamic>) : null,
      matkul: json['matkul'] != null ? MatkulModel.fromJson(json['matkul'] as Map<String, dynamic>) : null,
      dosen: json['dosen'] != null ? DosenModel.fromJson(json['dosen'] as Map<String, dynamic>) : null,
      dosen2: json['dosen2'] != null ? DosenModel.fromJson(json['dosen2'] as Map<String, dynamic>) : null,
      waktu: json['waktu'] != null ? WaktuModel.fromJson(json['waktu'] as Map<String, dynamic>) : null,
      ruangan: json['ruangan'] != null ? RuanganModel.fromJson(json['ruangan'] as Map<String, dynamic>) : null,
    );
  }
}