import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_button.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/filter_bar.dart';
// Pastikan ini adalah import yang benar untuk CustomTextfield yang telah dimodifikasi
// Jika nama filenya adalah custom_textfield.dart (sesuai konvensi), maka:
// import 'package:siakad_trivium/views/widgets/custom_textfield.dart';
// Jika masih textfield.dart, pastikan isinya adalah CustomTextfield yang benar.
import 'package:siakad_trivium/views/widgets/custom_textfield.dart';
import 'package:siakad_trivium/views/widgets/frs_add_card.dart';
import 'package:siakad_trivium/views/widgets/frs_card.dart';

class DetailFrs extends StatelessWidget {
  const DetailFrs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Detail FRS'),
      body: CustomScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //   FrsDropCard(
              //     jenis: 'Matakuliah Wajib',
              //     sks: '2',
              //     namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              //     dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom',
              //     onDelete: () {},
              //   ),
              //   const SizedBox(height: 16),
              //   FrsDropCard(
              //     jenis: 'Matakuliah Wajib',
              //     sks: '2',
              //     namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              //     dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom',
              //     onDelete: () {},
              //   ),
              //   const SizedBox(height: 16),
              //   FrsDropCard(
              //     jenis: 'Matakuliah Wajib',
              //     sks: '2',
              //     namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              //     dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom',
              //     onDelete: () {},
              //   ),
              //   const SizedBox(height: 16),
              //   FrsDropCard(
              //     jenis: 'Matakuliah Wajib',
              //     sks: '2',
              //     namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              //     dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom',
              //     onDelete: () {},
              //   ),
              //   const SizedBox(height: 16),
              //   FrsDropCard(
              //     jenis: 'Matakuliah Wajib',
              //     sks: '2',
              //     namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              //     dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom',
              //     onDelete: () {},
              //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
