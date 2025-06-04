import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart'; // Make sure style.dart is imported

class FrsCard extends StatelessWidget {
  final int idDetailFrs;
  final String jenis;
  final String sks;
  final String namaMatkul;
  final String dosen1;
  final String? dosen2;
  final VoidCallback? onDelete;
  final bool isApproved; // New parameter for FRS status

  const FrsCard({
    Key? key,
    required this.idDetailFrs,
    required this.jenis,
    required this.sks,
    required this.namaMatkul,
    required this.dosen1,
    this.dosen2,
    this.onDelete,
    this.isApproved = false, // Default to false if not provided
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
              const Text(' - '),
              Text(
                '$sks SKS',
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
                        maxLines: 1,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
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
                  child: isApproved
                      ? Icon(
                          Icons.check_circle, // Checklist icon
                          color: hijau, // Green color for approved
                          size: 30, // Adjust size as needed
                        )
                      : IconButton(
                          onPressed: onDelete,
                          icon: Icon(Icons.delete, color: merah), // Delete icon
                          tooltip: "Drop FRS",
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