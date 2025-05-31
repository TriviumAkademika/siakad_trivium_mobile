import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart';

class DosenCard extends StatelessWidget {
  final String nip;
  final String namaDosen;
  final String noHp;

  const DosenCard({
    Key? key,
    required this.nip,
    required this.namaDosen,
    required this.noHp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: brand50, // Menggunakan warna dari style.dart
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NIP
          Text(
            nip,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: hitam, // Menggunakan warna dari style.dart
            ),
          ),
          const SizedBox(height: 8),

          // Content dengan border kiri dan Row untuk nama/HP dan ikon
          Container(
            width: double.infinity, // Memastikan container mengambil full width
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: brand950, width: 2.0),
              ), // Menggunakan warna dari style.dart
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start, // Mengatur alignment vertikal anak-anak
              children: [
                // Bagian kiri: Nama Dosen dan Nomor HP
                Expanded(
                  // Widget ini akan mengambil semua sisa ruang horizontal
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Dosen
                      Text(
                        namaDosen,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: hitam, // Menggunakan warna dari style.dart
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Nomor HP
                      Text(
                        noHp,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: hitam, // Menggunakan warna dari style.dart
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ), // Memberi sedikit jarak antara teks dan ikon
                // Bagian kanan: Ikon Profil Placeholder
                SizedBox(
                  width: 60, // Lebar yang Anda inginkan
                  height: 80, // Tinggi yang Anda inginkan (60 * 4/3 = 80)
                  child: Container(
                    // Tambahkan Container untuk latar belakang dan border radius
                    decoration: BoxDecoration(
                      color:
                          Colors
                              .blueGrey[800], // Warna latar belakang ikon sesuai mockup
                      borderRadius: BorderRadius.circular(8), // Sudut membulat
                    ),
                    child: Center(
                      // Untuk menengahkan ikon di dalam Container
                      child: Icon(
                        Icons.person, // Ikon orang generik
                        size: 48, // Sesuaikan ukuran ikon
                        color: Colors.white, // Warna ikon
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
