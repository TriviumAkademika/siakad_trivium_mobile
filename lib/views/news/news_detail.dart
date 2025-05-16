import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/views/profile/profile.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        centerTitle: true,
        title: Text(
          'Berita',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                backgroundImage: AssetImage('lib/assets/images/avatar.jpg'),
              ),
            ),
          ),
        ],
      ),
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
