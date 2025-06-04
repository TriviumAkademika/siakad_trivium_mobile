import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Penting untuk initializeDateFormatting

// ViewModels
import 'package:siakad_trivium/viewmodels/login_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/homepage_news_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/news_detail_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/jadwal_viewmodel.dart'; // <-- Tambahkan import ini
import 'package:siakad_trivium/viewmodels/frs_viewmodel.dart';

// Halaman Awal
import 'package:siakad_trivium/views/auth/auth_check_page.dart';
import 'package:siakad_trivium/views/frs/frs.dart';
import 'package:siakad_trivium/views/nilai/nilai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => JadwalViewModel()), // <-- Tambahkan provider ini
        ChangeNotifierProvider(create: (_) => FrsViewModel()),
        // Tambahkan provider lain jika ada di masa depan
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Siakad Trivium',
        home: AuthCheckPage(), // Halaman awal aplikasi
        // Anda bisa menambahkan tema global di sini jika mau
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   // font keluarga default, dll.
        // ),
      ),
    );
  }
}