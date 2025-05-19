import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/views/profile/profile.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CustomNavbar(title: 'Berita'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar
            Image.asset(
              'lib/assets/images/news.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 240,
            ),

            // SizedBox negatif (overlap)
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Lorem ipsum dolor sit amet consectetur adipiscing elit. '
                  'Quisque faucibus ex sapien vitae pellentesque sem placerat. '
                  'In id cursus mi pretium tellus duis convallis. Tempus leo eu '
                  'aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus '
                  'nec metus bibendum egestas. Laculis massa nisl malesuada '
                  'lacinia integer nunc posuere. Ut hendrerit semper vel class '
                  'aptent taciti sociosqu. Ad litora torquent per conubia nostra '
                  'inceptos himenaeos.\n\n'
                  'Lorem ipsum dolor sit amet consectetur adipiscing elit. '
                  'Quisque faucibus ex sapien vitae pellentesque sem placerat. '
                  'In id cursus mi pretium tellus duis convallis. Tempus leo eu '
                  'aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus '
                  'nec metus bibendum egestas. Laculis massa nisl malesuada '
                  'lacinia integer nunc posuere. Ut hendrerit semper vel class '
                  'aptent taciti sociosqu. Ad litora torquent per conubia nostra '
                  'inceptos himenaeos.\n\n'
                  'Lorem ipsum dolor sit amet consectetur adipiscing elit. '
                  'Quisque faucibus ex sapien vitae pellentesque sem placerat. '
                  'In id cursus mi pretium tellus duis convallis. Tempus leo eu '
                  'aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus '
                  'nec metus bibendum egestas. Laculis massa nisl malesuada '
                  'lacinia integer nunc posuere. Ut hendrerit semper vel class '
                  'aptent taciti sociosqu. Ad litora torquent per conubia nostra '
                  'inceptos himenaeos.\n\n'
                  'Lorem ipsum dolor sit amet consectetur adipiscing elit. '
                  'Quisque faucibus ex sapien vitae pellentesque sem placerat. '
                  'In id cursus mi pretium tellus duis convallis. Tempus leo eu '
                  'aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus '
                  'nec metus bibendum egestas. Laculis massa nisl malesuada '
                  'lacinia integer nunc posuere. Ut hendrerit semper vel class '
                  'aptent taciti sociosqu. Ad litora torquent per conubia nostra '
                  'inceptos himenaeos.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.6),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
