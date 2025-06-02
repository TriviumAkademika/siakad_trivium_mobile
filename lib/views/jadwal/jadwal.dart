import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/hari_card.dart';
import 'package:siakad_trivium/views/widgets/jadwal_card.dart';
import 'package:siakad_trivium/views/widgets/matkul_card.dart';

class Jadwal extends StatefulWidget {
  const Jadwal({super.key});

  @override
  State<Jadwal> createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0; // Menyimpan index hari yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Jadwal'),
      body: CustomScrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HariCard(
                selectedIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              const SizedBox(height: 16),
              JadwalCard(
                jenis: 'Matakuliah Wajib',
                namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
                dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
                waktu: '13:00-15:30',
              ),
              const SizedBox(height: 16),
              JadwalCard(
                jenis: 'Matakuliah Wajib',
                namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
                dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
                waktu: '13:00-15:30',
              ),
              const SizedBox(height: 16),
              JadwalCard(
                jenis: 'Matakuliah Wajib',
                namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
                dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
                waktu: '13:00-15:30',
              ),
              const SizedBox(height: 16),
              JadwalCard(
                jenis: 'Matakuliah Wajib',
                namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
                dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
                waktu: '13:00-15:30',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
