// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/viewmodels/login_viewmodel.dart'; // Sesuaikan path
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Sesuaikan path
import 'package:siakad_trivium/views/auth/auth_check_page.dart';
import 'package:siakad_trivium/viewmodels/homepage_news_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/news_detail_viewmodel.dart'; // Sesuaikan path
import 'package:intl/date_symbol_data_local.dart';
import 'package:siakad_trivium/views/frs/frs.dart';
import 'package:siakad_trivium/views/nilai/nilai.dart';
import 'package:siakad_trivium/views/widgets/jadwal_card.dart';
import 'package:siakad_trivium/views/widgets/nilai_card.dart'; // Penting untuk initializeDateFormatting

void main() async {
  // Pastikan main adalah async
  WidgetsFlutterBinding.ensureInitialized(); // Penting untuk SharedPreferences dan operasi async lain sebelum runApp

  // Tambahkan baris ini untuk inisialisasi data lokal pemformatan tanggal
  await initializeDateFormatting('id_ID', null);

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
        ChangeNotifierProvider(create: (_) => NewsDetailViewModel()),
        ChangeNotifierProvider(create: (_) => HomepageNewsViewModel()),
        // Tambahkan provider lain jika ada
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Siakad Trivium', // Ganti dengan nama aplikasi Anda
        home: AuthCheckPage(),
      ),
    );
  }
}
