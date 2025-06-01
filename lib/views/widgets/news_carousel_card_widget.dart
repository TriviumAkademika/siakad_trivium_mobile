// lib/views/widgets/news_carousel_card_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/models/berita.dart'; // Sesuaikan path jika perlu
import 'package:siakad_trivium/views/news/news_detail.dart'; // Sesuaikan path ke NewsDetailPage Anda

class NewsCarouselCardWidget extends StatelessWidget {
  final Berita newsItem;

  const NewsCarouselCardWidget({
    super.key,
    required this.newsItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin diubah menjadi 24.0 secara horizontal
      margin: const EdgeInsets.symmetric(horizontal: 24.0), 
      decoration: BoxDecoration(
        color: const Color(0xFFBDDCFF), // Warna latar kartu
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.judul ?? 'Berita',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsItem.isiBerita,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10),
                    maxLines: 7, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8), 
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(newsId: newsItem.id),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF152556)),
                foregroundColor: MaterialStateProperty.all(const Color(0xFFFDFDFD)),
                minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              ),
              child: Text(
                "Lihat",
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}