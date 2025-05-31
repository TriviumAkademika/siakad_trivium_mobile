// lib/viewmodels/profile_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path
import 'package:siakad_trivium/services/profile_service.dart'; // Sesuaikan path
import 'dart:async'; // Untuk TimeoutException
import 'package:http/http.dart' as http; // Untuk ClientException

enum ProfileState { initial, loading, loaded, error }

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  ProfileState _state = ProfileState.initial;
  ProfileState get state => _state;

  UserProfileResponse? _userProfile;
  UserProfileResponse? get userProfile => _userProfile;

  String _message = '';
  String get message => _message;

  void _setState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    _setState(ProfileState.loading);
    _message = '';

    try {
      _userProfile = await _profileService.getProfile();
      _message = _userProfile?.message ?? 'Profil berhasil dimuat';
      _setState(ProfileState.loaded);
    } on TimeoutException catch (e) {
      _message = 'Koneksi ke server time out. Silakan coba lagi.';
      print('Fetch Profile Error (TimeoutException): $e');
      _setState(ProfileState.error);
    } on http.ClientException catch (e) {
      _message = 'Gagal terhubung ke server. Periksa koneksi Anda.';
      print('Fetch Profile Error (ClientException): ${e.message}');
      _setState(ProfileState.error);
    } catch (e) {
      _message = e.toString().replaceFirst('Exception: ', '');
      if (_message.isEmpty || _message.toLowerCase().contains("exception")) {
         _message = 'Gagal memuat data profil.';
      }
      print('Fetch Profile Error (Umum): $e');
      _setState(ProfileState.error);
    }
  }

  Future<void> logout() async {
    // Di sini Anda bisa memanggil _profileService.logoutAPI() jika ada endpoint API logout
    // Untuk sekarang, kita hanya hapus token lokal
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    // Anda mungkin ingin membersihkan _userProfile juga atau mengubah state khusus logout
    _userProfile = null;
    _setState(ProfileState.initial); // Atau state lain yang menandakan logout
    notifyListeners();
  }
}