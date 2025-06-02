import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/filter_bar.dart';

class Frs extends StatelessWidget {
  const Frs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'FRS'),
      body: CustomScrollbar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilterBar(
                      label: 'Tahun Ajaran',
                      hintText: 'Pilih Tahun Ajaran',
                      items: const ['2024/2025', '2025/2026'],
                    ),
                  ),
                  SizedBox(width: 16),
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
    );
  }
}
