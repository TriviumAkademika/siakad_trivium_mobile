// lib/views/widgets/news_section_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Jika Anda ingin mengambil ViewModel di sini, tapi lebih baik dioper
import 'package:siakad_trivium/viewmodels/homepage_news_viewmodel.dart';
import 'package:siakad_trivium/views/widgets/news_carousel_card_widget.dart';
import 'package:siakad_trivium/views/widgets/dots_indicator_widget.dart';

class NewsSectionWidget extends StatelessWidget {
  final HomepageNewsViewModel viewModel;
  final PageController pageController;
  final int currentPageIndex;

  const NewsSectionWidget({
    super.key,
    required this.viewModel,
    required this.pageController,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewModel.state) {
      case HomepageNewsState.loading:
        return Container(
          height: 230, // Sesuaikan tinggi ini agar konsisten
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      case HomepageNewsState.error:
        return Container(
          height: 230,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            'Gagal Memuat Berita: ${viewModel.errorMessage}',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: Colors.red[700]),
          ),
        );
      case HomepageNewsState.loaded:
        if (viewModel.newsItems.isEmpty) {
          return Container(
            height: 230,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              'Tidak ada berita saat ini.',
              style: GoogleFonts.plusJakartaSans(),
            ),
          );
        }
        // Tampilkan PageView dan Indikator Titik
        return Column(
          children: [
            SizedBox(
              height: 230, // Tentukan tinggi untuk PageView (area kartu)
                           // Sesuaikan nilai ini agar kartu berita terlihat baik
              child: PageView.builder(
                controller: pageController, // Gunakan pageController dari parameter
                itemCount: viewModel.newsItems.length,
                itemBuilder: (context, index) {
                  final newsItem = viewModel.newsItems[index];
                  return NewsCarouselCardWidget(newsItem: newsItem);
                },
              ),
            ),
            DotsIndicatorWidget(
              itemCount: viewModel.newsItems.length,
              currentPageIndex: currentPageIndex, // Gunakan currentPageIndex dari parameter
            ),
          ],
        );
      default: // initial state atau state lain yang mungkin ada
        return Container(
            height: 230,
            alignment: Alignment.center,
            child: const Text("Memuat berita..."));
    }
  }
}