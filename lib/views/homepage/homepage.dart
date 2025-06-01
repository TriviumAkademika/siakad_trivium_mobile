import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Pastikan provider diimport
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Sesuaikan path jika perlu
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path jika perlu (untuk enum ProfileState)
import 'package:siakad_trivium/views/profile/profile.dart';
import 'package:siakad_trivium/views/news/news_detail.dart';
import 'package:siakad_trivium/views/dosen/dosen.dart';
import 'package:siakad_trivium/views/jadwal/jadwal.dart';
import 'package:siakad_trivium/views/nilai/nilai.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchUserProfile setelah frame pertama jika data belum ada atau belum sedang dimuat.
    // Ini memberi kesempatan ProfileViewModel untuk memuat data jika Homepage adalah layar pertama.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      // Cek apakah userProfile masih null DAN state bukan loading (artinya belum ada upaya fetch atau sudah error)
      // Atau jika state adalah initial (belum pernah fetch sama sekali)
      if ((profileViewModel.userProfile == null &&
              profileViewModel.profileState != ProfileState.loading) ||
          profileViewModel.profileState == ProfileState.initial) {
        profileViewModel.fetchUserProfile();
      }
    });
  }

  Widget _buildUserName(ProfileViewModel viewModel) {
    // Jika sedang loading dan belum ada data user sama sekali
    if (viewModel.profileState == ProfileState.loading && viewModel.userProfile == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20, // Ukuran progress indicator kecil
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF152556)),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Memuat...',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16, // Sedikit lebih kecil agar serasi dengan progress
              fontWeight: FontWeight.w500, // Tidak terlalu bold saat loading
              color: Colors.grey[600],
            ),
          )
        ],
      );
    }

    // Jika sudah ada data user (walaupun mungkin sedang refresh di background)
    // atau jika sudah selesai loading (berhasil atau error tapi data sebelumnya ada)
    if (viewModel.userProfile != null) {
      final userProfileData = viewModel.userProfile!.data;
      final user = userProfileData.user;
      final mahasiswaDetails = userProfileData.mahasiswaDetails;
      // Logika penentuan nama, konsisten dengan ProfilePage
      String displayName = mahasiswaDetails?.nama?.isNotEmpty == true
          ? mahasiswaDetails!.nama!
          : (user.name?.isNotEmpty == true ? user.name! : 'Nama Mahasiswa');

      return Text(
        displayName,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    // Fallback jika error dan tidak ada data user sama sekali, atau state initial tanpa data
    return Text(
      'Nama Mahasiswa',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan context.watch agar widget ini rebuild saat ProfileViewModel berubah
    final profileViewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40), // Untuk status bar spacing
              // ✅ Custom AppBar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto profil
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 27,
                      backgroundImage: AssetImage(
                        'lib/assets/images/avatar.jpg', // Pastikan path ini benar
                      ),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle error jika gambar avatar gagal dimuat
                        // print('Error loading avatar: $exception');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Teks sambutan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selamat Datang👋',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        // Menggunakan widget builder untuk nama pengguna
                        _buildUserName(profileViewModel),
                      ],
                    ),
                  ),
                  // Icon lonceng
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFF152556),
                    ),
                    onPressed: () {
                      // TODO: Implement notification navigation or action
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),
              Text(
                'Semester Genap Tahun Ajaran 2024/2025', // Ini bisa juga dinamis jika perlu
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              // 💬 Kartu Berita (custom card dengan shadow fleksibel)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFBDDCFF),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.15,
                      ),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: const Offset(
                        1,
                        2,
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berita',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewsDetailPage(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xFF152556),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            const Color(0xFFFDFDFD),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Text(
                          "Lihat",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // 📦 Menu grid
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 52,
                  runSpacing: 24,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Nilai(),
                          ),
                        );
                      },
                      child: menuColumn('lib/assets/ikon/chart.png', 'Nilai')),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dosen(),
                          ),
                        );
                      },
                      child: menuColumn('lib/assets/ikon/calendar.png', 'Jadwal')),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dosen(),
                          ),
                        );
                      },
                      child: menuColumn('lib/assets/ikon/boy.png', 'Dosen')),
                    menuColumn('lib/assets/ikon/folder.png', 'FRS'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk menuBox dan menuColumn agar tidak duplikat
  // (Tidak ada perubahan di sini, hanya dipindahkan untuk kerapian jika Anda mau)
  Widget menuBox(String imagePath, String label) {
    if (label == 'Dosen') {
      return Container(
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          color: const Color(0xFFBDDCFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -3,
              child: Image.asset(
                'lib/assets/ikon/boy.png', // Pastikan path ini benar
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              right: -3,
              child: Image.asset(
                'lib/assets/ikon/girl.png', // Pastikan path ini benar
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        color: const Color(0xFFBDDCFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget menuColumn(String imagePath, String label) {
    return Column(
      children: [
        menuBox(imagePath, label),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}