import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/homepage_news_viewmodel.dart';
import 'package:siakad_trivium/views/profile/profile.dart';
import 'package:siakad_trivium/views/dosen/dosen.dart';
import 'package:siakad_trivium/views/jadwal/jadwal.dart';
import 'package:siakad_trivium/views/nilai/nilai.dart';
import 'package:siakad_trivium/views/frs/frs.dart';
import 'package:siakad_trivium/views/widgets/user_greeting_widget.dart';
import 'package:siakad_trivium/views/widgets/homepage_menu_item_widget.dart';
import 'package:siakad_trivium/views/widgets/news_section_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPageIndex) {
        if (mounted) {
          setState(() {
            _currentPageIndex = _pageController.page!.round();
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      if (profileViewModel.userProfile == null && profileViewModel.profileState != ProfileState.loading && profileViewModel.profileState != ProfileState.error) {
        profileViewModel.fetchUserProfile();
      }

      final homepageNewsViewModel = Provider.of<HomepageNewsViewModel>(context, listen: false);
      if (homepageNewsViewModel.state == HomepageNewsState.initial) {
        homepageNewsViewModel.loadNewsItems();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final homepageNewsViewModel = context.watch<HomepageNewsViewModel>();

    // Padding horizontal default untuk sebagian besar section
    const EdgeInsets sectionHorizontalPadding = EdgeInsets.symmetric(horizontal: 24.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SingleChildScrollView(
        child: Column( // Tidak ada Padding global di sini
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40 + 24.0), // Kombinasi top spacing & vertical padding awal

            // Header Section dengan padding
            Padding(
              padding: sectionHorizontalPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      backgroundImage: const AssetImage(
                        'lib/assets/images/avatar.jpg',
                      ),
                      onBackgroundImageError: (exception, stackTrace) {
                        // print('Error loading avatar: $exception');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Selamat Datang👋',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        UserGreetingWidget(viewModel: profileViewModel),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(
                  //     Icons.notifications_active_outlined,
                  //     color: Color(0xFF152556),
                  //   ),
                  //   onPressed: () {
                  //     // TODO: Implement notification navigation or action
                  //   },
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Semester Text dengan padding
            Padding(
              padding: sectionHorizontalPadding,
              child: Text(
                'Semester Genap Tahun Ajaran 2024/2025',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Bagian Berita Carousel - TANPA padding horizontal tambahan di sini
            // NewsSectionWidget akan mengambil lebar penuh yang tersedia dari Column induknya
            NewsSectionWidget(
              viewModel: homepageNewsViewModel,
              pageController: _pageController,
              currentPageIndex: _currentPageIndex,
            ),

            const SizedBox(height: 24),

            // Menu Grid dengan padding
            Padding(
              padding: sectionHorizontalPadding,
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 52,
                  runSpacing: 24,
                  children: [
                    HomepageMenuItemWidget(
                      imagePath: 'lib/assets/ikon/chart.png',
                      label: 'Nilai',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Nilai()));
                      },
                    ),
                    HomepageMenuItemWidget(
                      imagePath: 'lib/assets/ikon/calendar.png',
                      label: 'Jadwal',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Jadwal()));
                      },
                    ),
                    HomepageMenuItemWidget(
                      imagePath: 'lib/assets/ikon/boy.png',
                      label: 'Dosen',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Dosen()));
                      },
                    ),
                    HomepageMenuItemWidget(
                      imagePath: 'lib/assets/ikon/folder.png',
                      label: 'FRS',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Frs()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0), // Bottom padding
          ],
        ),
      ),
    );
  }
}