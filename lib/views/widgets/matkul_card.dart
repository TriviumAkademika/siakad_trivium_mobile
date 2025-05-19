import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart';

class MatkulCard extends StatelessWidget {
  final String jenisMatkul;
  final String namaMatkul;
  final String dosen1;
  final String? dosen2;
  final String nilai;

  const MatkulCard({
    Key? key,
    required this.jenisMatkul,
    required this.namaMatkul,
    required this.dosen1,
    this.dosen2,
    required this.nilai,
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
          Text(
            jenisMatkul,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: hitam,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: brand950, width: 2.0),
                    ),
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
                      ),
                      if (dosen2 != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          dosen2!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: hitam,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Nilai atau jam matkul
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: nilai.length <= 2 ? brand100 : brand100,
                    border: Border.all(color: brand950, width: 1.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    nilai,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: nilai.length <= 2 ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: hitam,
                    ),
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
