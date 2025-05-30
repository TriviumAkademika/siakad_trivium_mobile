// lib/views/widgets/profile_info_tile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding vertikal untuk memberikan jarak internal konten dari border atas/bawah
      padding: const EdgeInsets.symmetric(vertical: 14.0), 
      // Margin bawah untuk memberikan jarak antar ProfileInfoTile
      margin: const EdgeInsets.only(bottom: 24.0), 
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF152556), // Warna garis bawah sesuai permintaan
            width: 1.0,                     // Ketebalan garis bawah
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Penting untuk alignment jika value multibaris
        children: [
          // Bagian Title (Label)
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black45,       // Warna font untuk title sesuai permintaan
              fontSize: 14,                // Ukuran font untuk title sesuai permintaan
              fontWeight: FontWeight.w600, // Berat font untuk title sesuai permintaan
            ),
          ),
          // Bagian Value
          Expanded(
            child: Padding(
              // Padding kiri agar ada jarak jika title pendek
              padding: const EdgeInsets.only(left: 16.0), 
              child: Text(
                value,
                textAlign: TextAlign.right, // Membuat teks value rata kanan
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black,           // Warna font untuk value sesuai permintaan
                  fontSize: 16,                // Ukuran font untuk value sesuai permintaan
                  fontWeight: FontWeight.w600, // Berat font untuk value sesuai permintaan
                  height: 1.4, // Jarak antar baris untuk teks multibaris (penting untuk alamat)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
