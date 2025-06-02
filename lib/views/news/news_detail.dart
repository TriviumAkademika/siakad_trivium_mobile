// lib/views/news_detail_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting/ Import your custom styles
import 'package:siakad_trivium/views/widgets/custom_app_bar.dart'; // Import your custom navbar
import 'package:siakad_trivium/viewmodels/news_detail_viewmodel.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart'; // Import your custom scrollbar
import 'package:siakad_trivium/models/berita.dart';

// Dummy bgColor if not defined in style.dart for testing
// const Color bgColor = Color(0xFFF5F5F5); // Example

class NewsDetailPage extends StatefulWidget {
  final int newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding.instance.addPostFrameCallback to ensure context is available
    // and to call an async method safely from initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the ViewModel and load data
      // listen: false is important here as we are in initState
      Provider.of<NewsDetailViewModel>(context, listen: false)
          .loadBeritaDetail(widget.newsId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the ViewModel
    final viewModel = Provider.of<NewsDetailViewModel>(context);

    // Determine the title for the CustomNavbar
    String appBarTitle = 'Berita Detail';
    if (viewModel.state == NewsDetailState.loaded && viewModel.beritaDetail?.judul != null) {
      appBarTitle = viewModel.beritaDetail!.judul!;
    }

    return Scaffold(
      backgroundColor: Colors.white, // Use bgColor from your style.dart
      appBar: CustomAppBar(title: appBarTitle),
      body: CustomScrollbar(
        child: _buildBody(context, viewModel),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewsDetailViewModel viewModel) {
    switch (viewModel.state) {
      case NewsDetailState.loading:
      case NewsDetailState.initial:
        return const Center(child: CircularProgressIndicator());
      case NewsDetailState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gagal memuat berita: ${viewModel.errorMessage ?? "Kesalahan tidak diketahui"}',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(fontSize: 16, color: Colors.red),
            ),
          ),
        );
      case NewsDetailState.loaded:
        if (viewModel.beritaDetail == null) {
          return Center(
            child: Text(
              'Berita tidak ditemukan.',
              style: GoogleFonts.plusJakartaSans(fontSize: 16),
            ),
          );
        }
        final berita = viewModel.beritaDetail!;
        // Determine image widget
        Widget imageWidget;
        final String? imageUrl = berita.fullImageUrl; // Use the helper from the model

        if (imageUrl != null && imageUrl.isNotEmpty) {
          imageWidget = Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 240,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: 240,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              print("Error loading network image: $exception");
              // Fallback to asset image if network image fails
              return Image.asset(
                'lib/assets/images/news.png', // Default asset image
                fit: BoxFit.cover,
                width: double.infinity,
                height: 240,
              );
            },
          );
        } else {
          // Use default asset image if no URL is provided
          imageWidget = Image.asset(
            'lib/assets/images/news.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 240,
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              imageWidget,

              // Konten Berita dengan overlap
              Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)), // Increased radius
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Berita
                      if (berita.judul != null && berita.judul!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            berita.judul!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22, // Slightly larger
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                      // Info Penulis dan Tanggal
                      if (berita.penulis != null || berita.tanggal != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              if (berita.penulis != null && berita.penulis!.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    'Oleh: ${berita.penulis}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              if (berita.tanggal != null)
                                Text(
                                  DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(berita.tanggal!), // Format tanggal
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      
                      // Garis pemisah tipis
                      if ((berita.judul != null && berita.judul!.isNotEmpty) || (berita.penulis != null || berita.tanggal != null))
                        Divider(color: Colors.grey[300], height: 20, thickness: 1),


                      // Isi Berita
                      Text(
                        berita.isiBerita,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15, // Slightly larger
                          height: 1.7, // Increased line height for readability
                          color: Colors.black.withOpacity(0.75),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}
