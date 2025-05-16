import 'package:flutter/material.dart';
import 'package:siakad_trivium/views/auth/login.dart';
import 'package:siakad_trivium/views/homepage/homepage.dart';
import 'package:siakad_trivium/views/profile/profile.dart';
import 'package:siakad_trivium/views/news/news_detail.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(), // Ganti HomePage jadi FrsScreen
    );
  }
}
