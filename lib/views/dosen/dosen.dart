import 'package:flutter/material.dart';
import 'package:siakad_trivium/models/dosen_model.dart';
import 'package:siakad_trivium/services/dosen_service.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/dosen_card.dart';
import 'package:siakad_trivium/views/widgets/search_bar.dart';

class Dosen extends StatefulWidget {
  const Dosen({super.key});

  @override
  State<Dosen> createState() => _DosenState();
}

class _DosenState extends State<Dosen> {
  final DosenService _dosenService = DosenService();

  bool _isLoading = true; // Untuk status loading awal
  String? _errorMessage; // Untuk pesan error

  List<DosenModel> _allDosen = []; // Menyimpan semua data dosen dari API
  List<DosenModel> _filteredDosen =
      []; // Menyimpan data dosen yang akan ditampilkan dari hasil filter

  @override
  void initState() {
    super.initState();
    _loadDosenData();
  }

  Future<void> _loadDosenData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final dosenList = await _dosenService.fetchDosenList();
      setState(() {
        _allDosen = dosenList;
        _filteredDosen =
            dosenList; // Awalnya, daftar filter sama dengan daftar semua
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // FUNGSI UNTUK FILTER DATA DOSEN
  void _filterDosen(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredDosen = _allDosen; // Jika query kosong, tampilkan semua
      });
    } else {
      setState(() {
        _filteredDosen =
            _allDosen.where((dosen) {
              final namaDosenLower = dosen.namaDosen.toLowerCase();
              // Kamu bisa tambahkan field lain untuk dicari
              // final nipLower = dosen.nip.toLowerCase();
              // final noHpLower = dosen.noHp.toLowerCase();
              final queryLower = query.toLowerCase();

              return namaDosenLower.contains(queryLower);
              // nipLower.contains(queryLower);
              // || noHpLower.contains(queryLower);
            }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Data Dosen'),
      body: CustomScrollbar(
        child: Padding(
          // Pindahkan Padding ke sini agar scrollbar tidak ikut ter-padding
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                onChanged: (query) {
                  _filterDosen(
                    query,
                  ); // Panggil fungsi filter saat teks berubah
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                // Gunakan Expanded agar ListView mengambil sisa ruang di Column
                child: _buildDosenList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun tampilan list, loading, atau error
  Widget _buildDosenList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      // Kamu bisa tambahkan tombol refresh di sini
      return Center(child: Text('Error: $_errorMessage'));
    }
    if (_filteredDosen.isEmpty) {
      // Tampil jika setelah filter tidak ada hasil, atau jika _allDosen memang kosong
      return Center(
        child: Text(
          _allDosen.isEmpty
              ? 'Tidak ada data dosen.'
              : 'Tidak ada hasil pencarian.',
        ),
      );
    }

    // Tampilkan daftar dosen yang sudah difilter
    // Karena sudah di dalam Column + Expanded, ListView.builder aman digunakan
    return ListView.builder(
      itemCount: _filteredDosen.length,
      itemBuilder: (context, index) {
        final dosen = _filteredDosen[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DosenCard(
            nip: dosen.nip,
            namaDosen: dosen.namaDosen,
            noHp: dosen.noHp,
          ),
        );
      },
    );
  }
}
