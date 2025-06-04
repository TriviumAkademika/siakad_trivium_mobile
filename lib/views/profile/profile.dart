// lib/views/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Sesuaikan path
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/widgets/profile_info_tile.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/homepage/homepage.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/auth/login.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/widgets/custom_app_bar.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/widgets/custom_confirmation_dialog.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/profile/change_password_page.dart'; // Sesuaikan path

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchUserProfile saat halaman pertama kali dimuat,
    // setelah ViewModel di-provide secara global dan context tersedia.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendapatkan instance viewModel dan rebuild saat ada perubahan
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: const Color(0xFFFDFDFD),
          appBar: CustomAppBar(
            title: 'Profil',
            onBackButtonPressed: () {
              // Jika pengguna kembali dari ProfilePage, arahkan ke Homepage
              // dan pastikan tidak ada tumpukan halaman yang aneh.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Homepage()),
                (route) =>
                    false, // Hapus semua rute sebelumnya, Homepage jadi root
              );
            },
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF152556)),
                tooltip: 'Ganti Password',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          // Mengirim context dari builder Consumer ke _buildBody
          // agar operasi yang memerlukan context (seperti showDialog) menggunakan context yang benar.
          body: _buildBody(context, viewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileViewModel viewModel) {
    // Menampilkan loading indicator jika sedang memuat dan belum ada data profil awal
    if (viewModel.profileState == ProfileState.loading &&
        viewModel.userProfile == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF152556)),
        ),
      );
    }

    // Menampilkan pesan error jika gagal memuat dan belum ada data profil awal
    if (viewModel.profileState == ProfileState.error &&
        viewModel.userProfile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                viewModel.profileMessage.isNotEmpty
                    ? viewModel.profileMessage
                    : 'Gagal memuat profil.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF152556),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => viewModel.fetchUserProfile(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // Ini akan menangani kondisi setelah logout, dimana userProfile jadi null dan state jadi initial
    if (viewModel.userProfile == null) {
      // Saat profileState initial dan userProfile null (misal setelah logout),
      // AuthCheckPage seharusnya sudah menghandle navigasi ke LoginPage.
      // Tampilan ini hanya sebagai fallback jika ProfilePage masih terlihat sesaat.
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            // 'Anda telah logout atau sesi tidak valid. Mengarahkan ke halaman login...',
            'Memproses logout...', // Pesan singkat saat transisi
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Jika data profil sudah ada, tampilkan
    final userProfileData = viewModel.userProfile!.data;
    final user = userProfileData.user;
    final role = userProfileData.role;
    final mahasiswaDetails = userProfileData.mahasiswaDetails;
    String displayName =
        mahasiswaDetails?.nama ?? user.name ?? 'Nama Tidak Tersedia';

    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 10, 26, 26),
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
                  border: Border.all(
                    color: const Color(0xFF152556),
                    width: 1.5,
                  ),
                  image: DecorationImage(
                    image: const AssetImage('lib/assets/images/avatar.jpg'),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF152556),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role?.toUpperCase() ?? 'ROLE TIDAK DIKETAHUI',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ... (Kode ProfileInfoTile Anda seperti sebelumnya)
                  if (role == 'mahasiswa' && mahasiswaDetails != null) ...[
                    ProfileInfoTile(title: "NRP", value: mahasiswaDetails.nrp),
                    Row(
                      children: [
                        Expanded(
                          child: ProfileInfoTile(
                            title: "Semester",
                            value: mahasiswaDetails.semester ?? '-',
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: ProfileInfoTile(
                            title: "Gender",
                            value: mahasiswaDetails.gender ?? '-',
                          ),
                        ),
                      ],
                    ),
                    if (mahasiswaDetails.kelas?.prodi != null)
                      ProfileInfoTile(
                        title: "Program Studi",
                        value:
                            "${mahasiswaDetails.kelas!.prodi} ${mahasiswaDetails.kelas!.paralel ?? ''}"
                                .trim(),
                      ),
                  ] else if (role == 'dosen') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Data detail dosen belum diimplementasikan.",
                        style: GoogleFonts.plusJakartaSans(),
                      ),
                    ),
                  ],
                  ProfileInfoTile(title: "Email", value: user.email),
                  if (mahasiswaDetails?.alamat != null && role == 'mahasiswa')
                    ProfileInfoTile(
                      title: "Alamat",
                      value: mahasiswaDetails!.alamat!,
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (dialogContext) => CustomConfirmationDialog(
                                title: 'Konfirmasi Logout',
                                content:
                                    'Apakah Anda yakin ingin keluar dari akun ini?',
                                confirmButtonText: 'Logout',
                                cancelButtonText: 'Batal',
                                onConfirm: () async {
                                  // 1. Tutup dialog terlebih dahulu (opsional, bisa juga setelah logout)
                                  Navigator.of(dialogContext).pop();

                                  // 2. Panggil viewModel.logout() yang sekarang hanya client-side
                                  // viewModel didapat dari Consumer atau Provider.of di build method ProfilePage
                                  await viewModel.logout();

                                  // 3. Pastikan _ProfilePageState masih mounted
                                  if (!mounted) return;

                                  // 4. Navigasi utama ke LoginPage
                                  Navigator.pushAndRemoveUntil(
                                    context, // Menggunakan context dari ProfilePage
                                    MaterialPageRoute(
                                      builder:
                                          (newNavContext) => const LoginPage(),
                                    ),
                                    (route) =>
                                        false, // Hapus semua rute sebelumnya
                                  );
                                },
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5132),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
