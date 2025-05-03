import 'package:flutter/material.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/info_form.dart';
import 'package:siakad_trivium/views/widgets/frs_card.dart'; // pastikan ini di-import

class FrsScreen extends StatelessWidget {
  const FrsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbar(title: 'Pengajuan FRS'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoForm(),
          const SizedBox(height: 16),
          FRSCard(
            matkul: 'Workshop Desain Pengalaman Pengguna',
            sksDosen: '2 sks | Desy Intan Permatasari',
            status: 'Belum Disetujui',
            onDelete: () {
              print("Mata kuliah dihapus");
            },
          ),
        ],
      ),
    );
  }
}
