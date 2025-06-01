// lib/views/auth/auth_check_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Digunakan untuk validasi token
import 'package:siakad_trivium/views/auth/login.dart';       // Sesuaikan path
import 'package:siakad_trivium/views/homepage/homepage.dart';     // Sesuaikan path

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndNavigate();
  }

  Future<void> _checkLoginStatusAndNavigate() async {
    // Sedikit delay untuk UX, bisa juga untuk inisialisasi lain jika ada
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token == null || token.isEmpty) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    // Ada token, coba validasi dengan mengambil profil
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    
    // Reset state profil sebelum fetch, untuk memastikan tidak ada sisa data dari sesi sebelumnya
    // jika fetchUserProfile tidak meresetnya secara internal pada kondisi tertentu.
    // Sebenarnya, fetchUserProfile di ViewModel sudah handle set _profileState = ProfileState.loading
    // jadi ini mungkin tidak wajib, tapi bisa untuk keamanan.
    // profileViewModel.resetStateToInitial(); // Anda bisa buat method ini di ViewModel jika perlu

    await profileViewModel.fetchUserProfile();

    if (!mounted) return;

    if (profileViewModel.profileState == ProfileState.loaded && profileViewModel.userProfile != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      // Jika fetchProfile gagal (termasuk _profileService.getProfile() melempar 401 dan menghapus token)
      // atau kondisi lain yang membuat profil tidak termuat.
      print("AuthCheckPage: Gagal validasi token atau memuat profil. Pesan: ${profileViewModel.profileMessage}");
      // Token lokal mungkin sudah dihapus oleh service jika error 401.
      // Jika belum (error jaringan dll), kita bisa hapus di sini untuk memastikan.
      // Namun, lebih baik serahkan pada service untuk menghapus token jika 401.
      // await prefs.remove('user_token'); // Hapus jika ingin lebih agresif
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDFDFD), // Atau warna splash screen Anda
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF152556)),
            ),
            SizedBox(height: 20),
            Text(
              "Memeriksa sesi Anda...",
              style: TextStyle(fontSize: 16, color: Color(0xFF152556)),
            ),
          ],
        ),
      ),
    );
  }
}