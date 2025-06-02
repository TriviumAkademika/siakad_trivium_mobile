class NilaiMahasiswaModel {
  final int idMatkul;
  final String kodeMatkul;
  final String namaMatkul;
  final int sks;
  final int? semesterMatkul; // Semester reguler matkul
  final String? nilaiUts;
  final String? nilaiUas;
  final String tahunAjaran;
  final String? semesterDiambil; // Semester saat FRS diambil
  final String jenisMatkul; // Misal: "Wajib" atau "Pilihan"
  final String? namaDosenUtama; // Nama dosen pengampu utama

  NilaiMahasiswaModel({
    required this.idMatkul,
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.sks,
    this.semesterMatkul,
    this.nilaiUts,
    this.nilaiUas,
    required this.tahunAjaran,
    this.semesterDiambil,
    required this.jenisMatkul,
    this.namaDosenUtama,
  });

  // Fungsi untuk menentukan label nilai yang akan ditampilkan di card
  String get displayGrade {
    if (nilaiUas != null && nilaiUas!.isNotEmpty) return nilaiUas!;
    if (nilaiUts != null && nilaiUts!.isNotEmpty) return nilaiUts!;
    return '-'; // Default jika tidak ada nilai
  }

  factory NilaiMahasiswaModel.fromJson(Map<String, dynamic> json) {
    // Asumsi struktur 'matkul' dari API adalah objek
    Map<String, dynamic> matkulData = json['matkul'] as Map<String, dynamic>;

    // Asumsi nama dosen ada di dalam matkulData['dosen']['nama_dosen']
    // Ini mungkin perlu disesuaikan berdasarkan struktur API Laravel-mu yang sebenarnya
    // Jika 'dosen' adalah list, ambil dosen pertama. Jika objek, langsung akses.
    String? dosenName;
    if (matkulData['dosen'] != null) {
      // Contoh jika 'dosen' adalah objek
      dosenName = matkulData['dosen']['nama_dosen'] as String?;
    }
    // Atau jika dosen ada di jadwal:
    // if (json['jadwal'] != null && json['jadwal']['dosen'] != null) {
    //   dosenName = json['jadwal']['dosen']['nama_dosen'] as String?;
    // }

    return NilaiMahasiswaModel(
      idMatkul: matkulData['id_matkul'] as int,
      kodeMatkul: matkulData['kode_matkul'] as String? ?? '-',
      namaMatkul:
          matkulData['nama_matkul'] as String? ?? 'Nama Matkul Tidak Tersedia',
      sks: matkulData['sks'] as int? ?? 0,
      semesterMatkul: matkulData['semester'] as int?,
      nilaiUts: json['nilai_uts'] as String?,
      nilaiUas: json['nilai_uas'] as String?,
      tahunAjaran: json['tahun_ajaran'] as String? ?? '-',
      semesterDiambil: json['semester_diambil'] as String?,
      // Asumsi 'jenis' ada di matkulData dan bisa jadi 'Wajib' atau 'Pilihan'
      jenisMatkul:
          (matkulData['jenis'] as String? ?? 'Pilihan').toLowerCase() == 'wajib'
              ? 'Matakuliah Wajib'
              : 'Matakuliah Pilihan',
      namaDosenUtama: dosenName ?? 'Dosen Tidak Tersedia',
    );
  }
}