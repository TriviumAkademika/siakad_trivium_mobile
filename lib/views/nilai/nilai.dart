import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/filter_bar.dart';
import 'package:siakad_trivium/views/widgets/search_bar.dart';
import 'package:siakad_trivium/views/widgets/matkul_card.dart';

class Nilai extends StatelessWidget {
  const Nilai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CustomNavbar(title: 'Kartu Hasil Studi'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FilterBar(
                    label: 'Tahun Ajaran',
                    hintText: 'Pilih Tahun Ajaran',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FilterBar(
                    label: 'Semester',
                    hintText: 'Pilih Semester',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomSearchBar(),
            const SizedBox(height: 16),
            MatkulCard(
              jenisMatkul: 'Matakuliah Wajib',
              namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
              nilai: 'B',
            ),
            const SizedBox(height: 16),
            MatkulCard(
              jenisMatkul: 'Matakuliah Wajib',
              namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
              nilai: 'B',
            ),
            const SizedBox(height: 16),
            MatkulCard(
              jenisMatkul: 'Matakuliah Wajib',
              namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
              nilai: 'B',
            ),
            const SizedBox(height: 16),
            MatkulCard(
              jenisMatkul: 'Matakuliah Wajib',
              namaMatkul: 'Workshop Pemrograman Perangkat Bergerak',
              dosen1: 'Fadilah Fahrul Hardiansyah,S.ST., M. Kom ',
              nilai: 'B',
            ),
          ],
        ),
      ),
    );
  }
}
