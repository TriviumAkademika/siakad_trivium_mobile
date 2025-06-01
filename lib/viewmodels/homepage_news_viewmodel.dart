// lib/viewmodels/homepage_news_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/berita.dart';
import '../services/berita_service.dart'; // Pastikan service ini sudah mengirim token jika diperlukan

enum HomepageNewsState { initial, loading, loaded, error }

class HomepageNewsViewModel extends ChangeNotifier {
  final BeritaService _beritaService = BeritaService();

  List<Berita> _newsItems = []; // Diubah dari Berita? menjadi List<Berita>
  List<Berita> get newsItems => _newsItems;

  HomepageNewsState _state = HomepageNewsState.initial;
  HomepageNewsState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadNewsItems() async { // Nama method diubah agar lebih sesuai
    _state = HomepageNewsState.loading;
    _errorMessage = null;
    _newsItems = []; // Kosongkan item sebelumnya
    notifyListeners();

    try {
      // fetchAllBerita() harusnya sudah diupdate untuk mengirim token jika diperlukan
      final List<Berita> allNews = await _beritaService.fetchAllBerita();
      _newsItems = allNews;
      // Batasi jumlah berita yang ditampilkan di carousel jika terlalu banyak, misal 5 berita pertama
      // if (allNews.length > 5) {
      //   _newsItems = allNews.sublist(0, 5);
      // } else {
      //   _newsItems = allNews;
      // }
      _state = HomepageNewsState.loaded;
    } catch (e) {
      print("Error in HomepageNewsViewModel loading news items: $e");
      _errorMessage = e.toString();
      _state = HomepageNewsState.error;
    } finally {
      notifyListeners();
    }
  }
}