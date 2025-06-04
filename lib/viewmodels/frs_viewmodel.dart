import 'package:flutter/foundation.dart';
import 'package:siakad_trivium/services/frs_service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

// Ensure JadwalTersedia and DetailFrsItem are accessible
import 'package:siakad_trivium/services/frs_service.dart' show JadwalTersedia, DetailFrsItem;

enum FrsViewState { initial, loading, loaded, error, submitting }

class FrsViewModel extends ChangeNotifier {
  final FrsService _frsService = FrsService();

  FrsViewState _state = FrsViewState.initial;
  FrsViewState get state => _state;

  List<JadwalTersedia> _jadwalTersedia = [];
  List<JadwalTersedia> get jadwalTersedia => _jadwalTersedia; // Available schedules

  List<DetailFrsItem> _currentFrsCourses = []; // New list for selected FRS courses
  List<DetailFrsItem> get currentFrsCourses => _currentFrsCourses;

  Map<String, dynamic>? _frsHeader; // This will hold the main FRS data excluding detailFrs now
  Map<String, dynamic>? get frsHeader => _frsHeader;

  String _message = '';
  String get message => _message;

  void _setState(FrsViewState newState, {String msg = ''}) {
    _state = newState;
    _message = msg;
    notifyListeners();
  }

  Future<void> fetchFrsData() async {
    _setState(FrsViewState.loading, msg: 'Memuat data FRS...');
    try {
      final frsDataResponse = await _frsService.getCurrentFrsData();

      _frsHeader = frsDataResponse['frs'] as Map<String, dynamic>?;

      // Parse current FRS courses (detailFrs)
      final List<dynamic> detailFrsList = _frsHeader?['detail_frs'] as List<dynamic>? ?? [];
      _currentFrsCourses = detailFrsList
          .map((json) => DetailFrsItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Parse available schedules (jadwal_tersedia)
      final List<dynamic> jadwalList = frsDataResponse['jadwal_tersedia'] as List<dynamic>? ?? [];
      _jadwalTersedia = jadwalList
          .map((json) => JadwalTersedia.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _setState(FrsViewState.loaded, msg: 'Data FRS berhasil dimuat.');
    } on TimeoutException catch (e) {
      _setState(FrsViewState.error, msg: 'Koneksi ke server time out. Coba lagi.');
      debugPrint('FrsViewModel: Fetch FRS Data Error (TimeoutException): $e');
    } on http.ClientException catch (e) {
      _setState(FrsViewState.error, msg: 'Gagal terhubung ke server. Periksa koneksi internet Anda.');
      debugPrint('FrsViewModel: Fetch FRS Data Error (ClientException): ${e.message}');
    } catch (e) {
      _setState(FrsViewState.error, msg: e.toString().replaceFirst('Exception: ', ''));
      debugPrint('FrsViewModel: Fetch FRS Data Error (Umum): $e');
    }
  }

  Future<bool> addJadwalToFrs(int jadwalId) async {
    final originalState = _state;
    _setState(FrsViewState.submitting, msg: 'Menambahkan mata kuliah...');
    try {
      final response = await _frsService.addSchedulesToFrs([jadwalId]);
      _message = response['message'] as String? ?? 'Operasi berhasil.';
      
      await fetchFrsData(); // Refresh data after successful addition
      if(_state == FrsViewState.loaded){
        _message = response['message'] as String? ?? 'Mata kuliah ditambahkan dan data diperbarui.';
        notifyListeners();
        return true;
      }
      return false;
    } on TimeoutException catch (e) {
      _setState(originalState, msg: 'Koneksi ke server time out saat menambah.');
      debugPrint('FrsViewModel: Add Jadwal Error (TimeoutException): $e');
      return false;
    } on http.ClientException catch (e) {
      _setState(originalState, msg: 'Gagal terhubung ke server saat menambah.');
      debugPrint('FrsViewModel: Add Jadwal Error (ClientException): ${e.message}');
      return false;
    } catch (e) {
      _setState(originalState, msg: e.toString().replaceFirst('Exception: ', ''));
      debugPrint('FrsViewModel: Add Jadwal Error (Umum): $e');
      return false;
    }
  }

  Future<bool> dropJadwalFromFrs(int idDetailFrs) async {
    final originalState = _state;
    _setState(FrsViewState.submitting, msg: 'Menghapus mata kuliah...');
    try {
      final response = await _frsService.dropScheduleFromFrs(idDetailFrs);
      _message = response['message'] as String? ?? 'Mata kuliah berhasil dihapus.';

      await fetchFrsData(); // Refresh data after successful deletion
      if(_state == FrsViewState.loaded){
        _message = response['message'] as String? ?? 'Mata kuliah dihapus dan data diperbarui.';
        notifyListeners();
        return true;
      }
      return false;
    } on TimeoutException catch (e) {
      _setState(originalState, msg: 'Koneksi ke server time out saat menghapus.');
      debugPrint('FrsViewModel: Drop Jadwal Error (TimeoutException): $e');
      return false;
    } on http.ClientException catch (e) {
      _setState(originalState, msg: 'Gagal terhubung ke server saat menghapus.');
      debugPrint('FrsViewModel: Drop Jadwal Error (ClientException): ${e.message}');
      return false;
    } catch (e) {
      _setState(originalState, msg: e.toString().replaceFirst('Exception: ', ''));
      debugPrint('FrsViewModel: Drop Jadwal Error (Umum): $e');
      return false;
    }
  }
}