// lib/widgets/homepage_menu_item_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomepageMenuItemWidget extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  const HomepageMenuItemWidget({
    super.key,
    required this.imagePath,
    required this.label,
    this.onTap,
  });

  Widget _menuBox(String imagePath, String label) {
    // Logika khusus untuk item "Dosen"
    if (label == 'Dosen') {
      return Container(
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          color: const Color(0xFFBDDCFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -3,
              child: Image.asset( // Path untuk Dosen boy
                'lib/assets/ikon/boy.png', // Asumsi path ini tetap
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              right: -3,
              child: Image.asset( // Path untuk Dosen girl
                'lib/assets/ikon/girl.png', // Asumsi path ini tetap
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
    }

    // Untuk item menu lainnya
    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        color: const Color(0xFFBDDCFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath, // imagePath dari parameter widget
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _menuBox(imagePath, label), // Memanggil _menuBox internal
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}