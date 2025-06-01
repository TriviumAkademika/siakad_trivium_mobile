// lib/viewmodels/profile_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path
// import 'package:siakad_trivium/services/profile_service.dart'; // ProfileService tidak lagi dibutuhkan untuk logout
import 'dart:async'; // Untuk TimeoutException (masih relevan untuk fetchProfile & updatePassword)
import 'package:http/http.dart' as http; // Untuk ClientException (masih relevan untuk fetchProfile & updatePassword)

// Import ProfileService jika masih digunakan untuk fetchUserProfile dan updateUserPassword
import 'package:siakad_trivium/services/profile_service.dart';


enum ProfileState { initial, loading, loaded, error }
enum PasswordChangeState { idle, loading, success, error }

class ProfileViewModel extends ChangeNotifier {
  // ProfileService masih dibutuhkan untuk fetchUserProfile dan updateUserPassword
  final ProfileService _profileService = ProfileService();

  ProfileState _profileState = ProfileState.initial;
  ProfileState get profileState => _profileState;

  UserProfileResponse? _userProfile;
  UserProfileResponse? get userProfile => _userProfile;

  String _profileMessage = '';
  String get profileMessage => _profileMessage;

  PasswordChangeState _passwordChangeState = PasswordChangeState.idle;
  PasswordChangeState get passwordChangeState => _passwordChangeState;

  String _passwordChangeMessage = '';
  String get passwordChangeMessage => _passwordChangeMessage;

  void _setProfileState(ProfileState newState, {String message = ''}) {
    _profileState = newState;
    if (message.isNotEmpty || newState == ProfileState.initial || newState == ProfileState.loading) {
      _profileMessage = message;
    }
    notifyListeners();
  }

  void _setPasswordChangeState(PasswordChangeState newState, {String message = ''}) {
    _passwordChangeState = newState;
    _passwordChangeMessage = message;
    notifyListeners();
  }

  void resetStateToInitial() {
    _userProfile = null;
    _setProfileState(ProfileState.initial, message: '');
    _setPasswordChangeState(PasswordChangeState.idle, message: '');
  }

  Future<void> fetchUserProfile() async {
    _setProfileState(ProfileState.loading, message: 'Memuat profil...');
    try {
      _userProfile = await _profileService.getProfile(); // Masih pakai service
      _setProfileState(ProfileState.loaded, message: _userProfile?.message ?? 'Profil berhasil dimuat.');
    } on TimeoutException catch (e) {
      _setProfileState(ProfileState.error, message: 'Koneksi ke server time out. Silakan coba lagi.');
      print('ProfileViewModel: Fetch Profile Error (TimeoutException): $e');
    } on http.ClientException catch (e) {
      _setProfileState(ProfileState.error, message: 'Gagal terhubung ke server. Periksa koneksi Anda.');
      print('ProfileViewModel: Fetch Profile Error (ClientException): ${e.message}');
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (!errorMessage.contains("(401)")) {
         if (errorMessage.isEmpty || errorMessage.toLowerCase().contains("exception")) {
            errorMessage = 'Gagal memuat data profil.';
         }
      }
      _setProfileState(ProfileState.error, message: errorMessage);
      print('ProfileViewModel: Fetch Profile Error (Umum): $e');
    }
  }

  Future<bool> updateUserPassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _setPasswordChangeState(PasswordChangeState.loading, message: 'Memperbarui password...');
    try {
      final response = await _profileService.updatePassword( // Masih pakai service
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      _setPasswordChangeState(PasswordChangeState.success, message: response['message'] ?? 'Password berhasil diperbarui.');
      return true;
    } on TimeoutException catch (e) {
      _setPasswordChangeState(PasswordChangeState.error, message: 'Koneksi ke server time out.');
      print('ProfileViewModel: Update Password Error (TimeoutException): $e');
      return false;
    } on http.ClientException catch (e) {
       _setPasswordChangeState(PasswordChangeState.error, message: 'Gagal terhubung ke server.');
       print('ProfileViewModel: Update Password Error (ClientException): ${e.message}');
       return false;
    } catch (e) {
      _setPasswordChangeState(PasswordChangeState.error, message: e.toString().replaceFirst('Exception: ', ''));
      print('ProfileViewModel: Update Password Error (Umum): $e');
      return false;
    }
  }

  // --- METHOD LOGOUT HANYA CLIENT-SIDE ---
  Future<void> logout() async {
    print("ProfileViewModel: Logout client-side dimulai.");

    // Tidak ada lagi panggilan ke _profileService.logoutAPI();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token'); // Hapus token dari SharedPreferences
    print("ProfileViewModel: Token dihapus dari SharedPreferences.");

    // Reset state internal ViewModel
    _userProfile = null;
    _profileState = ProfileState.initial;
    _passwordChangeState = PasswordChangeState.idle;
    _profileMessage = ''; // Atau set pesan seperti 'Anda telah logout.'
    _passwordChangeMessage = '';

    notifyListeners(); // Beri tahu UI untuk update
    print("ProfileViewModel: State direset dan notifyListeners() dipanggil. Logout client-side selesai.");
  }
  // --- AKHIR METHOD LOGOUT ---
}