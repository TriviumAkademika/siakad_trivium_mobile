import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart'; // Pastikan style.dart ada dan berisi brand50, hitam, brand950, brand100

class FrsAddCard extends StatelessWidget {
  final String jenis;
  final String sks;
  final String namaMatkul;
  final String dosen1;
  final String? dosen2;
  final VoidCallback? onAdd;

  const FrsAddCard({
    Key? key,
    required this.jenis,
    required this.sks,
    required this.namaMatkul,
    required this.dosen1,
    this.dosen2,
    this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: brand50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                jenis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: hitam,
                ),
              ),
              Text(' - '),
              Text(
                sks,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: hitam,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded Matkul + Dosen
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: brand950, width: 4),
                    ), // Anda mengubah width jadi 4
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaMatkul,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: hitam,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dosen1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: hitam,
                        ),
                        maxLines: 1, // Tambahkan ini agar konsisten
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (dosen2 != null && dosen2!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          dosen2!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: hitam,
                          ),
                          maxLines: 1, // Tambahkan ini agar konsisten
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8), // Jarak antar expanded
              // Container icon
              Expanded(
                flex: 1, // Sesuaikan flex agar proporsional
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: brand100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    onPressed: onAdd,
                    icon: Icon(Icons.add, color: brand700),
                    tooltip: "Tambah FRS",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
