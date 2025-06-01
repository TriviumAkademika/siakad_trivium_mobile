import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/profile/profile.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomNavbar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      // Icon back
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // Title Appbar
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: hitam
        ),
      ),
      // Avatar
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: CircleAvatar(
              backgroundColor: bgColor,
              radius: 18,
              backgroundImage: AssetImage('lib/assets/images/avatar.jpg'),
            ),
          ),
        ),
      ],
    );
  }
}
