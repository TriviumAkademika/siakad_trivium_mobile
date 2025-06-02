import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Penting untuk initializeDateFormatting

// ViewModels
import 'package:siakad_trivium/viewmodels/login_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/homepage_news_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/news_detail_viewmodel.dart';
import 'package:siakad_trivium/viewmodels/jadwal_viewmodel.dart'; // <-- Tambahkan import ini

// Halaman Awal
import 'package:siakad_trivium/views/auth/auth_check_page.dart';

// Import halaman/widget lain di sini tidak wajib jika tidak digunakan langsung di MyApp
// import 'package:siakad_trivium/views/frs/frs.dart';
// import 'package:siakad_trivium/views/jadwal/jadwal.dart';
// import 'package:siakad_trivium/views/nilai/nilai.dart';
// import 'package:siakad_trivium/views/widgets/jadwal_card.dart';
// import 'package:siakad_trivium/views/widgets/nilai_card.dart'; 

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