import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Masih dibutuhkan jika Anda memutuskan untuk menggunakan AnnotatedRegion secara terpisah
import 'package:siakad_trivium/data/dummy/profile_dummy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/views/widgets/profile_info_tile.dart';
import 'package:siakad_trivium/views/homepage/homepage.dart';
import 'package:siakad_trivium/views/auth/login.dart';
import 'package:siakad_trivium/views/widgets/custom_app_bar.dart'; // Impor CustomAppBar
import 'package:siakad_trivium/views/widgets/custom_confirmation_dialog.dart'; // Impor CustomConfirmationDialog

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileData _user = dummyProfile; // Ini akan mengambil dari profile_dummy.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CustomAppBar(
        title: 'Profile',
        onBackButtonPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (route) => false,
          );
        },
        // Anda bisa menambahkan konfigurasi avatar di sini jika suatu saat diperlukan di AppBar ProfilePage
        // showProfileAvatar: true,
        // profileAvatarAssetPath: _user.avatarPath, // jika avatarPath ada di ProfileData
        // onProfileAvatarPressed: () { /* aksi */ },
      ),
      body: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF152556), width: 1),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/images/avatar.jpg', // Pastikan path ini benar atau ambil dari _user jika dinamis
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded( // Menggunakan Expanded agar Column bisa di-scroll jika konten melebihi layar
              child: SingleChildScrollView( // Membuat konten di dalam Column bisa di-scroll
                child: Column(
                  children: [
                    ProfileInfoTile(title: "Nama", value: _user.name),
                    Row(
                      children: [
                        Expanded(
                          child: ProfileInfoTile(
                            title: "Semester",
                            value: _user.semester,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: ProfileInfoTile(
                            title: "Gender",
                            value: _user.gender,
                          ),
                        ),
                      ],
                    ),
                    ProfileInfoTile(title: "NRP", value: _user.nrp),
                    ProfileInfoTile(title: "Email", value: _user.email),
                    ProfileInfoTile(title: "Alamat", value: _user.address),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => CustomConfirmationDialog( // Menggunakan CustomConfirmationDialog di sini
                              title: 'Konfirmasi',
                              content: 'Apakah anda yakin ingin keluar?',
                              confirmButtonText: 'Logout',
                              onConfirm: () {
                                // Aksi yang dijalankan ketika tombol "Logout" (atau confirmButtonText) ditekan.
                                // CustomConfirmationDialog akan menutup dialognya sendiri sebelum memanggil onConfirm.
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              // Anda juga bisa menyediakan onCancel kustom jika diperlukan,
                              // jika tidak, defaultnya adalah Navigator.pop(context)
                              // onCancel: () {
                              //   print("Logout dibatalkan");
                              //   Navigator.pop(context);
                              // }
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5132),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFFDFDFD),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Tambahan padding di bawah tombol logout jika diperlukan
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}