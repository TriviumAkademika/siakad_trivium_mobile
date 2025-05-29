// lib/viewmodels/login_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/services/auth_service.dart'; // Sesuaikan path jika perlu
import 'dart:async'; // Untuk TimeoutException
import 'package:http/http.dart' as http; // Untuk ClientException (jika AuthService melemparnya langsung)

enum ViewState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String _token = '';
  String get token => _token; // Mungkin tidak perlu diexpose jika hanya untuk internal

  String _message = ''; // Untuk menyimpan pesan sukses atau error
  String get message => _message;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<bool> attemptLogin(String email, String password) async {
    _setState(ViewState.loading);
    _message = ''; // Reset pesan

    try {
      final responseData = await _authService.login(email, password);

      _token = responseData['token'] as String; // Pastikan tipe data benar
      _message = responseData['message'] as String? ?? 'Login berhasil';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', _token);

      _setState(ViewState.success);
      return true;
    } on TimeoutException catch (e) {
      _message = 'Koneksi ke server time out. Silakan coba lagi.';
      print('Login Error (TimeoutException) in ViewModel: $e');
      _setState(ViewState.error);
      return false;
    } on http.ClientException catch (e) { // Termasuk SocketException
      _message = 'Gagal terhubung ke server. Periksa koneksi Anda.';
      print('Login Error (ClientException) in ViewModel: ${e.message}');
      _setState(ViewState.error);
      return false;
    } on FormatException catch (e) {
      _message = 'Format data dari server tidak valid.';
      print('Login Error (FormatException) in ViewModel: $e');
      _setState(ViewState.error);
      return false;
    } catch (e) { // Menangkap Exception umum yang dilempar AuthService (pesan dari API) atau lainnya
      _message = e.toString().replaceFirst('Exception: ', ''); // Membersihkan prefix "Exception: "
      if (_message.isEmpty) {
        _message = 'Terjadi kesalahan yang tidak diketahui.';
      }
      print('Login Error (Umum) in ViewModel: $e');
      _setState(ViewState.error);
      return false;
    }
  }
}