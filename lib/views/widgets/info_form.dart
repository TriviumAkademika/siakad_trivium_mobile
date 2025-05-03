import 'package:flutter/material.dart';

class InfoForm extends StatelessWidget {
  const InfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: const [
          InfoField(label: 'Nama', value: 'Salsabila Nurhalimah'),
          InfoField(label: 'Semester', value: 'Genap'),
          InfoField(label: 'Tahun Ajaran', value: '2024/2025'),
          InfoField(label: 'Dosen Wali', value: 'Adam Shidqul Aziz S.ST, M.T'),
          InfoField(label: 'IPK/IPS', value: '3.85/3.91'),
          InfoField(label: 'Total SKS', value: '14'),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
