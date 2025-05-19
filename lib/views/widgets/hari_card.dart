import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart';

class HariCard extends StatelessWidget {
  HariCard({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final Function(int) onTap;

  final List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(hari.length, (index) {
        final bool isSelected = index == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == hari.length - 1 ? 0 : 4,
              ),
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? brand950 : bgColor,
                border:
                    isSelected ? null : Border.all(color: brand950, width: 1.5),
              ),
              child: Text(
                hari[index],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? putih : brand950,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}