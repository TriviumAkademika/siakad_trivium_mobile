import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart';

class CustomTextfield extends StatelessWidget {
  final String label;
  final String value;

  const CustomTextfield({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Asumsi: bgColor dan hitam diimpor dari style.dart
    // Estimasi padding vertikal untuk mencocokkan tinggi FilterBar (DropdownButton)
    // Anda mungkin perlu sedikit menyesuaikan nilai 'vertical: 16' ini
    // untuk kesesuaian visual yang sempurna dengan tinggi DropdownButton.
    const double verticalPadding = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: hitam, // Menggunakan warna 'hitam' dari style.dart
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity, // 1. Membuat container mengambil lebar penuh
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: verticalPadding, // 2. Menambahkan padding vertikal
          ),
          decoration: BoxDecoration(
            color: bgColor, // dari style.dart
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF000000), // 3. Menyamakan style border
            ),
          ),
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w500, // Bobot font untuk value
              color: hitam, // Menggunakan warna 'hitam' dari style.dart
            ),
          ),
        ),
      ],
    );
  }
}