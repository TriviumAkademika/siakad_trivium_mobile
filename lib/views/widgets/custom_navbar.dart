import 'package:flutter/material.dart';

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
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.pink),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () {
                // Tambahkan aksi dropdown di sini kalau perlu
              },
            ),
          ],
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
    );
  }
}
