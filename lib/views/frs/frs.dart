import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/filter_bar.dart';
// Pastikan ini adalah import yang benar untuk CustomTextfield yang telah dimodifikasi
// Jika nama filenya adalah custom_textfield.dart (sesuai konvensi), maka:
// import 'package:siakad_trivium/views/widgets/custom_textfield.dart';
// Jika masih textfield.dart, pastikan isinya adalah CustomTextfield yang benar.
import 'package:siakad_trivium/views/widgets/custom_textfield.dart'; // Atau custom_textfield.dart

class Frs extends StatelessWidget {
  const Frs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'FRS'),
      body: CustomScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextfield(label: 'Nama', value: 'Rasyidatur Rahma'),
                const SizedBox(height: 16),
                CustomTextfield(
                  label: 'Dosen Wali',
                  value: 'Adam Shidqul Aziz S.ST,M.T',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        label: 'IPK/IPS',
                        value: '3.85/3.91',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextfield(label: 'Total SKS', value: '20'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilterBar(
                        label: 'Tahun Ajaran',
                        hintText: 'Pilih Tahun Ajaran',
                        items: const ['2024/2025', '2025/2026'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilterBar(
                        label: 'Semester',
                        hintText: 'Pilih Semester',
                        items: const ['Ganjil', 'Genap'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}