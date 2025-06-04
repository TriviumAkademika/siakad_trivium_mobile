// lib/viewmodels/jadwal_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:siakad_trivium/models/jadwal_model.dart';
import 'package:siakad_trivium/services/jadwal_service.dart';
import 'package:siakad_trivium/utils/hari_utils.dart'; // Pastikan path ini benar

enum JadwalState { initial, loading, loaded, error }

class JadwalViewModel extends ChangeNotifier {
  final JadwalService _jadwalService = JadwalService();

  List<JadwalModel> _jadwalList = [];
  List<JadwalModel> get jadwalList => _jadwalList;

  JadwalState _state = JadwalState.initial;
  JadwalState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _selectedHariIndex = 0; // Default ke hari pertama (misal Senin, index 0)
  int get selectedHariIndex => _selectedHariIndex;

  String get selectedNamaHari => getNamaHariByIndex(_selectedHariIndex);

  // Tidak perlu memuat otomatis di constructor, biarkan View yang trigger di initState
  // JadwalViewModel() {
  //   loadJadwalForSelectedDay();
  // }

  Future<void> loadJadwalForSelectedDay({String? searchTerm}) async {
    _state = JadwalState.loading;
    _errorMessage = null;
    // Penting untuk notifyListeners di awal agar UI update ke state loading
    notifyListeners(); 

    try {
      _jadwalList = await _jadwalService.fetchJadwalMahasiswa(
        hari: selectedNamaHari, // Menggunakan nama hari dari index yang terpilih
        searchTerm: searchTerm,
      );
      _state = JadwalState.loaded;
    } catch (e) {
      print("Error in JadwalViewModel loading jadwal: $e");
      _errorMessage = e.toString();
      _state = JadwalState.error;
      _jadwalList = []; // Pastikan list kosong jika terjadi error
    } finally {
      notifyListeners();
    }
  }

  void changeSelectedDay(int index) {
    if (_selectedHariIndex != index) {
      _selectedHariIndex = index;
      notifyListeners(); // Update UI untuk selectedHariIndex (misal di HariCard)
      loadJadwalForSelectedDay(); // Muat data untuk hari yang baru dipilih
    } else {
      // Jika hari yang sama dipilih lagi, mungkin lakukan refresh atau tidak sama sekali
      // Untuk saat ini, kita bisa abaikan atau panggil loadJadwalForSelectedDay() jika ingin refresh
      // loadJadwalForSelectedDay(); 
    }
  }

  void searchJadwal(String searchTerm) {
    // Panggil loadJadwalForSelectedDay dengan searchTerm yang baru
    // Hari yang terpilih akan tetap sama
    loadJadwalForSelectedDay(searchTerm: searchTerm.trim());
  }
}