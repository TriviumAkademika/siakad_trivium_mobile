// lib/views/profile_page.dart (atau path yang sesuai)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Import ViewModel
import 'package:siakad_trivium/models/user_profile_model.dart'; // Import Model
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
    // Panggil fetchUserProfile saat halaman pertama kali dimuat
    // Gunakan addPostFrameCallback agar context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cek jika ViewModel sudah di-provide atau buat instance baru jika belum
      // Lebih baik provider di-provide di atas widget ini (misal di MaterialApp atau route)
      // Namun untuk contoh ini, kita bisa akses langsung jika provider ada di atasnya.
      // Jika tidak, Anda perlu memastikan Provider.of dipanggil di tempat yang tepat
      // atau membungkus widget ini dengan ChangeNotifierProvider.
      // Untuk struktur yang lebih baik, ProfileViewModel sebaiknya di-provide di atas ProfilePage.
      // Saya akan asumsikan Anda akan membungkus ProfilePage dengan ChangeNotifierProvider
      // atau sudah ada di atasnya.
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Bungkus Scaffold dengan ChangeNotifierProvider jika belum di-provide di atasnya
    // Jika sudah, Anda bisa langsung menggunakan Consumer.
    // Untuk contoh ini, kita provide di sini agar mandiri.
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel()..fetchUserProfile(), // Langsung fetch saat create
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
      // Bisa jadi state initial atau kasus lain dimana data belum ada tapi tidak error parah
      return const Center(child: Text('Data profil tidak tersedia.'));
    }

    // Data tersedia
    final userProfileData = viewModel.userProfile!.data;
    final user = userProfileData.user;
    final role = userProfileData.role;
    final mahasiswaDetails = userProfileData.mahasiswaDetails; // Sudah diparsing di model

    // Menggunakan nama dari detail mahasiswa jika ada dan nama user null/kosong
    String displayName = mahasiswaDetails?.nama ?? user.name ?? 'Nama Tidak Tersedia';


    return Padding(
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
                    'lib/assets/images/avatar.jpg', // Ganti jika ada path avatar dari API
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 60), // Fallback jika gambar gagal load
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Menampilkan info berdasarkan role
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
                  ]
                  // Tambahkan else if (role == 'dosen' && dosenDetails != null) ...[] untuk dosen
                  else if (role == 'dosen' /* && dosenDetails != null */) ... [
                    // Tampilkan info spesifik dosen jika ada
                    // Contoh: ProfileInfoTile(title: "NIDN", value: dosenDetails.nidn),
                    const Text("Data detail dosen belum diimplementasikan di UI."),
                  ],

                  ProfileInfoTile(title: "Email", value: user.email),
                  if (mahasiswaDetails?.alamat != null && role == 'mahasiswa')
                    ProfileInfoTile(title: "Alamat", value: mahasiswaDetails!.alamat!),
                  // Tambahkan info alamat untuk dosen jika ada fieldnya
                  
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
                              if (!mounted) return;
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