import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/dosen_card.dart';
import 'package:siakad_trivium/views/widgets/search_bar.dart';

class Dosen extends StatelessWidget {
  const Dosen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Data Dosen'),
      body: CustomScrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(),
              const SizedBox(height: 16),
              DosenCard(
                nip: '3123500055',
                namaDosen: 'Fadilah Fahrul Hardiansyah, S.ST.,M.Kom',
                noHp: '083853501389',
              ),
              const SizedBox(height: 16),
              DosenCard(
                nip: '3123500055',
                namaDosen: 'Fadilah Fahrul Hardiansyah, S.ST.,M.Kom',
                noHp: '083853501389',
              ),
              const SizedBox(height: 16),
              DosenCard(
                nip: '3123500055',
                namaDosen: 'Fadilah Fahrul Hardiansyah, S.ST.,M.Kom',
                noHp: '083853501389',
              ),
              const SizedBox(height: 16),
              DosenCard(
                nip: '3123500055',
                namaDosen: 'Fadilah Fahrul Hardiansyah, S.ST.,M.Kom',
                noHp: '083853501389',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
