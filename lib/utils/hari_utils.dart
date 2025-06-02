// lib/utils/hari_utils.dart

// Daftar hari sesuai urutan di HariCard Anda (asumsi)
// Pastikan urutan ini konsisten dengan bagaimana HariCard Anda menampilkan dan mengembalikan index
const List<String> daftarNamaHari = [
  "Senin",
  "Selasa",
  "Rabu",
  "Kamis",
  "Jumat",
  "Sabtu",
  "Minggu", 
];

String getNamaHariByIndex(int index) {
  if (index >= 0 && index < daftarNamaHari.length) {
    return daftarNamaHari[index];
  }
  // Default ke hari pertama jika index tidak valid, atau throw error
  print("Index hari tidak valid: $index, menggunakan default Senin.");
  return daftarNamaHari[0]; 
}