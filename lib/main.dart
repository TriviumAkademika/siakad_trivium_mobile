// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/viewmodels/login_viewmodel.dart';    // Sesuaikan path
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/auth/auth_check_page.dart';
import 'package:siakad_trivium/views/frs/frs.dart'; // Sesuaikan path

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Penting untuk SharedPreferences sebelum runApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        // Tambahkan provider lain jika ada
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Siakad Trivium', // Ganti dengan nama aplikasi Anda
        home: Frs(), // Halaman awal aplikasi
      ),
    );
  }
}