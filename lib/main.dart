import 'package:flutter/material.dart';
import 'package:siakad_trivium/views/auth/login.dart';
import 'package:siakad_trivium/views/dosen/dosen.dart';
import 'package:siakad_trivium/views/jadwal/jadwal.dart';
import 'package:siakad_trivium/views/news/news_detail.dart';
import 'package:siakad_trivium/views/nilai/nilai.dart';// Pastikan path ini benar

// Tidak perlu import supabase_flutter lagi
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async { // Ubah menjadi async jika ada inisialisasi yang membutuhkan await di masa depan
  // Pastikan Flutter binding diinisialisasi jika ada plugin yang membutuhkannya sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Tidak ada lagi inisialisasi Supabase di sini
  // await Supabase.initialize(
  //   url: 'https://qgiaqdvvtzpgzagimdqj.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnaWFxZHZ2dHpwZ3phZ2ltZHFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDcyNzYsImV4cCI6MjA2MzMyMzI3Nn0.WZPwJagwBlXm-SEG34RCMqEz1LK8H8r3QDW6ln5-jLo',
  // );

  runApp(const MainApp()); // Ganti MainApp() menjadi const MainApp() jika tidak ada state
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dosen(), // Langsung ke LoginPage
    );
  }
}