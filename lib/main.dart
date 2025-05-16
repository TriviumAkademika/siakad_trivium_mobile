import 'package:flutter/material.dart';
import 'package:siakad_trivium/views/frs/frs_screen.dart';
import 'package:siakad_trivium/views/nilai/nilai.dart';
import 'package:siakad_trivium/views/widgets/filter_bar.dart'; // Pastikan path ini benar

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Nilai(), // Ganti HomePage jadi FrsScreen
    );
  }
}
