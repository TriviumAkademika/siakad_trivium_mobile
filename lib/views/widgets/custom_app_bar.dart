// File: lib/views/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;
  final bool showProfileAvatar;
  final String? profileAvatarAssetPath; // Path ke aset gambar avatar
  final VoidCallback? onProfileAvatarPressed; // Aksi ketika avatar di tap
  final Color backgroundColor;
  final Color iconColor;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions; // Untuk ikon/aksi tambahan di sebelah kanan

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackButtonPressed,
    this.showProfileAvatar = false,
    this.profileAvatarAssetPath,
    this.onProfileAvatarPressed,
    this.backgroundColor = const Color(0xFFFDFDFD),
    this.iconColor = Colors.black,
    this.titleTextStyle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Logika default untuk tombol kembali jika tidak ada yang disediakan
    final VoidCallback effectiveOnBackButtonPressed = onBackButtonPressed ??
        () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        };

    Widget? leadingWidget;
    // Hanya tampilkan tombol kembali jika ada handler atau bisa pop
    if (onBackButtonPressed != null || Navigator.canPop(context)) {
      leadingWidget = IconButton(
        icon: Icon(Icons.chevron_left, color: iconColor, size: 30), // Perbesar ikon jika perlu
        onPressed: effectiveOnBackButtonPressed,
      );
    }

    List<Widget> effectiveActions = [];
    if (actions != null) {
      effectiveActions.addAll(actions!);
    }

    if (showProfileAvatar) {
      effectiveActions.add(
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: onProfileAvatarPressed,
            child: CircleAvatar(
              radius: 18, // Sesuaikan ukuran avatar
              backgroundColor: Colors.grey[300], // Warna placeholder
              backgroundImage: profileAvatarAssetPath != null
                  ? AssetImage(profileAvatarAssetPath!)
                  : null,
              child: profileAvatarAssetPath == null
                  ? Icon(Icons.person, size: 18, color: Colors.grey[700])
                  : null,
            ),
          ),
        ),
      );
    }

    return AppBar(
      centerTitle: true,
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: leadingWidget,
      title: Text(
        title,
        style: titleTextStyle ??
            GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
      ),
      actions: effectiveActions.isNotEmpty ? effectiveActions : null,
      systemOverlayStyle: const SystemUiOverlayStyle( // Bawa dari AnnotatedRegion untuk konsistensi
        statusBarColor: Colors.blue, // Atau samakan dengan backgroundColor jika mau
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Tinggi standar AppBar
}