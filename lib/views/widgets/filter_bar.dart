import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/style.dart'; // Pastikan bgColor, hintText (sebagai Color), dan hitam terdefinisi di sini

class FilterBar extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> items; // Parameter baru untuk daftar item dropdown
  final String? initialValue; // Parameter baru untuk nilai awal (opsional)
  final Function(String?)?
  onChanged; // Callback ketika nilai berubah (opsional)

  const FilterBar({
    Key? key,
    required this.label,
    required this.hintText,
    required this.items, // Wajib diisi
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Set nilai awal jika diberikan dan ada dalam daftar items
    if (widget.initialValue != null &&
        widget.items.contains(widget.initialValue)) {
      selectedValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Asumsi: bgColor, hintText (sebagai Color), dan hitam diimpor dari style.dart
    // Jika 'hintText' dari style.dart bukan Color, ganti 'color: hintText' di bawah
    // dengan warna yang sesuai, misal 'Colors.grey' atau variabel warna dari style.dart.
    // Contoh: final Color myHintTextColor = hintText; (jika hintText adalah Color di style.dart)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:
                hitam, // Menggunakan warna 'hitam' dari style.dart untuk label jika diinginkan
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ), // Penyesuaian padding
          decoration: BoxDecoration(
            color: bgColor, // dari style.dart
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF000000),
            ), // Border lebih soft
          ),
          child: DropdownButtonHideUnderline(
            // Menghilangkan garis bawah default
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                widget.hintText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color:
                      hintText, // Pastikan 'hintText' ini adalah variabel Color dari style.dart
                  // Jika bukan, ganti dengan misal: Colors.grey.shade600
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
                widget.onChanged?.call(value); // Panggil callback jika ada
              },
              items:
                  widget
                      .items // Menggunakan daftar item dari parameter widget
                      .map<DropdownMenuItem<String>>(
                        (String itemValue) => DropdownMenuItem<String>(
                          value: itemValue,
                          child: Text(itemValue),
                        ),
                      )
                      .toList(),
              isExpanded: true,
              // underline: const SizedBox(), // Tidak perlu jika menggunakan DropdownButtonHideUnderline
              style: GoogleFonts.plusJakartaSans(
                color:
                    hitam, // dari style.dart (warna teks item terpilih dan di dropdown)
                fontSize: 16,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black54,
              ), // Warna ikon
              dropdownColor: bgColor, // Warna latar belakang dropdown menu
            ),
          ),
        ),
      ],
    );
  }
}
