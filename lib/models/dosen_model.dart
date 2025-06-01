class DosenModel {
  final String namaDosen;
  final String nip;
  final String noHp;
  // Jika kamu butuh id_dosen di Flutter nanti (misalnya untuk navigasi ke detail),
  // kamu bisa tambahkan di sini dan pastikan DosenResource-mu mengirimkannya
  // atau buat nullable jika tidak selalu ada.
  // final int? idDosen;

  DosenModel({
    required this.namaDosen,
    required this.nip,
    required this.noHp,
    // this.idDosen,
  });

  // Factory constructor untuk membuat instance DosenModel dari JSON
  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      // Sesuaikan key di bawah ini ('nama_dosen', 'nip', 'no_hp')
      // dengan key JSON yang dikirim oleh DosenResource-mu.
      namaDosen: json['nama_dosen'] as String,
      nip: json['nip'] as String,
      noHp: json['no_hp'] as String,
      // idDosen: json['id_dosen'] as int?, // Jika ada
    );
  }
}