import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBar extends StatefulWidget {
  final String label;
  final String hintText;

  const FilterBar({Key? key, required this.label, required this.hintText}) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF000000)),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            hint: Text(
              widget.hintText,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            items:
                ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4']
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
            isExpanded: true,
            underline: const SizedBox(),
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ],
    );
  }
}
