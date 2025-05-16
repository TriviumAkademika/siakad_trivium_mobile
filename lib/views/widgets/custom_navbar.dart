import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomNavbar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/images/avatar.jpg'),
              ),
              /* IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  // Tambahkan aksi dropdown di sini kalau perlu
                },
              ), */
            ],
          ),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
    );
  }
}
