// lib/views/profile_page.dart (atau path yang sesuai)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Import ViewModel
// import 'package:siakad_trivium/models/user_profile_model.dart'; // Import Model // Tidak terpakai secara langsung di sini setelah viewModel mengambil alih
import 'package:siakad_trivium/views/widgets/profile_info_tile.dart';
import 'package:siakad_trivium/views/homepage/homepage.dart';
import 'package:siakad_trivium/views/auth/login.dart';
import 'package:siakad_trivium/views/widgets/custom_app_bar.dart';
import 'package:siakad_trivium/views/widgets/custom_confirmation_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel()..fetchUserProfile(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            extendBodyBehindAppBar: false,
            backgroundColor: const Color(0xFFFDFDFD),
            appBar: CustomAppBar(
              title: 'Profil',
              onBackButtonPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                  (route) => false,
                );
              },
            ),
            body: _buildBody(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileViewModel viewModel) {
    if (viewModel.state == ProfileState.loading && viewModel.userProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.state == ProfileState.error && viewModel.userProfile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gagal memuat profil: ${viewModel.message}', textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => viewModel.fetchUserProfile(),
                child: const Text('Coba Lagi'),
              )
            ],
          ),
        ),
      );
    }

    if (viewModel.userProfile == null) {
      return const Center(child: Text('Data profil tidak tersedia.'));
    }

    final userProfileData = viewModel.userProfile!.data;
    final user = userProfileData.user;
    final role = userProfileData.role;
    final mahasiswaDetails = userProfileData.mahasiswaDetails;

    String displayName = mahasiswaDetails?.nama ?? user.name ?? 'Nama Tidak Tersedia';

    // SingleChildScrollView sekarang membungkus seluruh konten body
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(26), // Padding diterapkan di dalam SingleChildScrollView
        child: Column(
          // Column ini tidak lagi memerlukan Expanded karena tingginya akan ditentukan oleh kontennya
          // dan SingleChildScrollView akan menangani overflow.
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
                      'lib/assets/images/avatar.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 60),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              displayName,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF152556)),
              textAlign: TextAlign.center,
            ),
            Text(
              role?.toUpperCase() ?? 'ROLE TIDAK DIKETAHUI',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Kolom ini berisi semua ProfileInfoTile dan tombol logout
            // Tidak perlu lagi SingleChildScrollView atau Expanded di sini
            Column(
              children: [
                if (role == 'mahasiswa' && mahasiswaDetails != null) ...[
                  ProfileInfoTile(title: "NRP", value: mahasiswaDetails.nrp),
                  Row(
                    children: [
                      Expanded(
                        child: ProfileInfoTile(
                            title: "Semester",
                            value: mahasiswaDetails.semester ?? '-'),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: ProfileInfoTile(
                            title: "Gender",
                            value: mahasiswaDetails.gender ?? '-'),
                      ),
                    ],
                  ),
                  if (mahasiswaDetails.kelas?.prodi != null)
                    ProfileInfoTile(
                        title: "Program Studi",
                        value: "${mahasiswaDetails.kelas!.prodi} - ${mahasiswaDetails.kelas!.paralel ?? ''}"),
                ] else if (role == 'dosen') ...[
                  const Text("Data detail dosen belum diimplementasikan di UI."),
                ],
                ProfileInfoTile(title: "Email", value: user.email),
                if (mahasiswaDetails?.alamat != null && role == 'mahasiswa')
                  ProfileInfoTile(title: "Alamat", value: mahasiswaDetails!.alamat!),
                
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomConfirmationDialog(
                          title: 'Konfirmasi Logout',
                          content: 'Apakah Anda yakin ingin keluar?',
                          confirmButtonText: 'Logout',
                          onConfirm: () async {
                            await viewModel.logout();
                            if (!mounted) return; // Check if the widget is still in the tree
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          },
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
                const SizedBox(height: 20), // Memberi sedikit ruang di bagian bawah jika di-scroll penuh
              ],
            ),
          ],
        ),
      ),
    );
  }
}
