// lib/viewmodels/frs_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:siakad_trivium/services/frs_service.dart'; // <--- UBAH KE FrsService
import 'dart:async';
import 'package:http/http.dart' as http;

// Impor model JadwalTersedia jika didefinisikan di frs_service.dart atau file model terpisah
// Jika JadwalTersedia ada di frs_service.dart:
// import 'package:siakad_trivium/services/frs_service.dart' show JadwalTersedia;
// Jika Anda membuat file model terpisah misal lib/models/jadwal_model.dart:
// import 'package:siakad_trivium/models/jadwal_model.dart';


enum FrsViewState { initial, loading, loaded, error, submitting }

class FrsViewModel extends ChangeNotifier {
  final FrsService _frsService = FrsService(); // <--- UBAH KE FrsService

  FrsViewState _state = FrsViewState.initial;
  FrsViewState get state => _state;

  List<JadwalTersedia> _jadwalTersedia = [];
  List<JadwalTersedia> get jadwalTersedia => _jadwalTersedia;

  Map<String, dynamic>? _frsHeader;
  Map<String, dynamic>? get frsHeader => _frsHeader;

  String _message = '';
  String get message => _message;

  void _setState(FrsViewState newState, {String msg = ''}) {
    _state = newState;
    _message = msg;
    notifyListeners();
  }

  Future<void> fetchFrsData() async {
    _setState(FrsViewState.loading, msg: 'Memuat jadwal tersedia...');
    try {
      final frsDataResponse = await _frsService.getCurrentFrsData(); // <--- Gunakan _frsService
      _frsHeader = frsDataResponse['frs_header'] as Map<String, dynamic>?; // Ambil frs_header
      
      final List<dynamic> jadwalList = frsDataResponse['jadwal_tersedia'] as List<dynamic>? ?? [];
      _jadwalTersedia = jadwalList
          .map((json) => JadwalTersedia.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Pesan sukses bisa diambil dari API jika ada, atau set default
      _setState(FrsViewState.loaded, msg: 'Data FRS berhasil dimuat.');
    } on TimeoutException catch (e) {
      _setState(FrsViewState.error, msg: 'Koneksi ke server time out.');
      print('FrsViewModel: Fetch FRS Data Error (TimeoutException): $e');
    } on http.ClientException catch (e) {
      _setState(FrsViewState.error, msg: 'Gagal terhubung ke server.');
      print('FrsViewModel: Fetch FRS Data Error (ClientException): ${e.message}');
    } catch (e) {
      _setState(FrsViewState.error, msg: e.toString().replaceFirst('Exception: ', ''));
      print('FrsViewModel: Fetch FRS Data Error (Umum): $e');
    }
  }

  Future<bool> addJadwalToFrs(int jadwalId) async {
    final originalState = _state;
    _setState(FrsViewState.submitting, msg: 'Menambahkan mata kuliah...');
    try {
      final response = await _frsService.addSchedulesToFrs([jadwalId]); // <--- Gunakan _frsService
      _message = response['message'] as String? ?? 'Operasi berhasil.';
      
      await fetchFrsData(); // Refresh data
      if(_state == FrsViewState.loaded){
         _message = response['message'] as String? ?? 'Mata kuliah ditambahkan dan data diperbarui.';
         notifyListeners();
         return true;
      }
      // Jika fetchFrsData gagal setelah add, state akan error dari fetchFrsData
      return false;

    } on TimeoutException catch (e) {
      _setState(originalState, msg: 'Koneksi ke server time out saat menambah.');
      print('FrsViewModel: Add Jadwal Error (TimeoutException): $e');
      return false;
    } on http.ClientException catch (e) {
       _setState(originalState, msg: 'Gagal terhubung ke server saat menambah.');
       print('FrsViewModel: Add Jadwal Error (ClientException): ${e.message}');
       return false;
    } catch (e) {
      _setState(originalState, msg: e.toString().replaceFirst('Exception: ', ''));
      print('FrsViewModel: Add Jadwal Error (Umum): $e');
      return false;
    }
  }

  // Method untuk drop schedule juga akan menggunakan _frsService
  Future<bool> dropJadwalFromFrs(int idDetailFrs) async {
    final originalState = _state;
     _setState(FrsViewState.submitting, msg: 'Menghapus mata kuliah...');
    try {
      final response = await _frsService.dropScheduleFromFrs(idDetailFrs); // <--- Gunakan _frsService
      _message = response['message'] as String? ?? 'Mata kuliah berhasil dihapus.';

      await fetchFrsData(); // Refresh data
      if(_state == FrsViewState.loaded){
         _message = response['message'] as String? ?? 'Mata kuliah dihapus dan data diperbarui.';
         notifyListeners();
         return true;
      }
      return false;

    } on TimeoutException catch (e) {
      _setState(originalState, msg: 'Koneksi ke server time out saat menghapus.');
      return false;
    } on http.ClientException catch (e) {
       _setState(originalState, msg: 'Gagal terhubung ke server saat menghapus.');
       return false;
    } catch (e) {
      _setState(originalState, msg: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }
}