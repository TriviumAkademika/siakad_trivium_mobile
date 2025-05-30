// lib/views/widgets/custom_confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final String cancelButtonText;
  final VoidCallback? onCancel; // Opsional, defaultnya akan menutup dialog
  final Color confirmButtonColor;
  final Color confirmButtonPressedColor;
  final Color dialogBackgroundColor;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmButtonText,
    required this.onConfirm,
    this.cancelButtonText = "Batal",
    this.onCancel,
    this.confirmButtonColor = const Color(0xFFFF5132),
    this.confirmButtonPressedColor = const Color(0xFF882614),
    this.dialogBackgroundColor = const Color(0xFFFDFDFD),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: dialogBackgroundColor,
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: Text(
            cancelButtonText,
            style: GoogleFonts.plusJakartaSans(color: Colors.grey[700]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Tutup dialog sebelum menjalankan aksi konfirmasi
            // agar jika aksi konfirmasi melibatkan navigasi, tidak ada error.
            Navigator.pop(context);
            onConfirm();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return confirmButtonPressedColor;
                }
                return confirmButtonColor;
              },
            ),
            foregroundColor: MaterialStateProperty.all(
              const Color(0xFFFDFDFD),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Text(
            confirmButtonText,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}