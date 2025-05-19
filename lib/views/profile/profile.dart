import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siakad_trivium/data/dummy/profile_dummy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/views/widgets/profile_info_tile.dart';
import 'package:siakad_trivium/views/homepage/homepage.dart';
import 'package:siakad_trivium/views/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileData _user = dummyProfile;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xFFFDFDFD),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFFDFDFD),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Homepage()),
                (route) => false,
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                'Profile',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                      border: Border.all(color: Color(0xFF152556), width: 1),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/images/avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
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
                          builder:
                              (_) => AlertDialog(
                                backgroundColor: Color(0xFFFDFDFD),
                                title: Text(
                                  'Konfirmasi',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                content: Text(
                                  'Apakah anda yakin ingin keluar?',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Tutup dialog
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const LoginPage(),
                                        ),
                                        (route) => false,
                                      );
                                    },

                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith((
                                            states,
                                          ) {
                                            if (states.contains(
                                              MaterialState.pressed,
                                            )) {
                                              return const Color(
                                                0xFF882614,
                                              ); // Warna lebih gelap saat disentuh
                                            }
                                            return const Color(
                                              0xFFFF5132,
                                            ); // Warna normal
                                          }),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                            Color(0xFFFDFDFD),
                                          ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Logout',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5132),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.plusJakartaSans(
                          color: Color(0xFFFDFDFD),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
