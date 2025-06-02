// lib/viewmodels/news_detail_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/berita.dart';
import '../services/berita_service.dart';

enum NewsDetailState { initial, loading, loaded, error }

class NewsDetailViewModel extends ChangeNotifier {
  final BeritaService _beritaService = BeritaService();

  Berita? _beritaDetail;
  Berita? get beritaDetail => _beritaDetail;

  NewsDetailState _state = NewsDetailState.initial;
  NewsDetailState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadBeritaDetail(int id) async {
    _state = NewsDetailState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _beritaDetail = await _beritaService.fetchBeritaById(id);
      _state = NewsDetailState.loaded;
    } catch (e) {
      print("Error in ViewModel loading news detail: $e");
      _errorMessage = e.toString();
      _state = NewsDetailState.error;
    } finally {
      notifyListeners();
    }
  }
}
