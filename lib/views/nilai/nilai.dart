import 'package:flutter/material.dart';
import 'package:siakad_trivium/models/nilai_mahasiswa_model.dart'; // Impor model
import 'package:siakad_trivium/services/nilai_service.dart'; // Impor service
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/filter_bar.dart';
import 'package:siakad_trivium/views/widgets/nilai_card.dart';
import 'package:siakad_trivium/views/widgets/search_bar.dart';

class Nilai extends StatefulWidget {
  const Nilai({super.key});

  @override
  State<Nilai> createState() => _NilaiState();
}

class _NilaiState extends State<Nilai> {
  final NilaiService _nilaiService = NilaiService();

  bool _isLoading = true;
  String? _errorMessage;
  List<NilaiMahasiswaModel> _allNilai = [];
  List<NilaiMahasiswaModel> _filteredNilai = [];

  // Variabel untuk filter (implementasi filter tahun ajaran & semester bisa jadi PR berikutnya)
  // String? _selectedTahunAjaran;
  // String? _selectedSemester;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNilaiData(); // Memuat data awal tanpa search query
  }

  Future<void> _loadNilaiData({String? searchQuery}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchQuery =
          searchQuery ?? _searchQuery; // Update query jika ada yg baru
    });
    try {
      final nilaiList = await _nilaiService.fetchNilaiMahasiswa(
        searchQuery: _searchQuery,
      );
      setState(() {
        _allNilai = nilaiList;
        // Untuk saat ini, filter client-side untuk tahun ajaran & semester belum diimplementasikan
        // Jadi _filteredNilai akan sama dengan hasil dari API (yang mungkin sudah difilter search oleh server)
        _filteredNilai = nilaiList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menangani perubahan pada search bar
  void _onSearchChanged(String query) {
    // Panggil _loadNilaiData dengan query baru untuk pencarian server-side
    // Atau jika ingin client-side setelah data awal dimuat:
    // if (query.isEmpty) {
    //   setState(() {
    //     _filteredNilai = _allNilai;
    //   });
    // } else {
    //   setState(() {
    //     _filteredNilai = _allNilai.where((nilai) {
    //       return nilai.namaMatkul.toLowerCase().contains(query.toLowerCase());
    //     }).toList();
    //   });
    // }
    // Untuk saat ini, kita akan memicu pengambilan data baru dari server dengan search query
    if (_searchQuery != query) {
      // Hanya reload jika query berubah
      _loadNilaiData(searchQuery: query);
    }
  }

  // Fungsi untuk filter (tahun ajaran & semester) - PERLU DIIMPLEMENTASIKAN LEBIH LANJUT
  // void _applyClientSideFilters() {
  //   List<NilaiMahasiswaModel> tempNilai = _allNilai;
  //   if (_selectedTahunAjaran != null) {
  //     tempNilai = tempNilai.where((n) => n.tahunAjaran == _selectedTahunAjaran).toList();
  //   }
  //   if (_selectedSemester != null) {
  //     tempNilai = tempNilai.where((n) => n.semesterDiambil == _selectedSemester).toList();
  //   }
  //   // Tambahkan filter search query di sini jika search-nya client-side
  //   if (_searchQuery.isNotEmpty) {
  //      tempNilai = tempNilai.where((n) => n.namaMatkul.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  //   }
  //   setState(() {
  //     _filteredNilai = tempNilai;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Nilai'),
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
                      label: 'Nilai',
                      hintText: 'Pilih Nilai',
                      items: const ['UTS', 'UAS'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomSearchBar(onChanged: _onSearchChanged),
              const SizedBox(height: 16),
              Expanded(child: _buildNilaiList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNilaiList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _loadNilaiData(searchQuery: _searchQuery),
              child: Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }
    // --- PERBAIKAN DI SINI ---
    // Tentukan apakah ada filter atau search yang aktif
    bool isSearching = _searchQuery.isNotEmpty;
    // bool isFilteringByTahun = _selectedTahunAjaran != null; // Aktifkan jika filter tahun sudah dipakai
    // bool isFilteringBySemester = _selectedSemester != null; // Aktifkan jika filter semester sudah dipakai

    // Gabungkan semua kondisi filter/search yang aktif
    // bool adaFilterAktif = isSearching || isFilteringByTahun || isFilteringBySemester;
    bool adaFilterAktif =
        isSearching; // Untuk saat ini, hanya search yang aktif
    if (_filteredNilai.isEmpty) {
      return Center(
        child: Text(
          adaFilterAktif // Gunakan variabel boolean di sini
              ? 'Tidak ada hasil yang cocok.'
              : 'Belum ada data nilai.',
        ),
      );
    }
    // --- BATAS PERBAIKAN ---

    return ListView.builder(
      itemCount: _filteredNilai.length,
      itemBuilder: (context, index) {
        final nilai = _filteredNilai[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: NilaiCard(
            jenis: nilai.jenisMatkul,
            namaMatkul: nilai.namaMatkul,
            dosen1:
                nilai.namaDosenUtama ??
                'N/A', // Jika ada dosen2, tambahkan logikanya
            nilai:
                nilai
                    .displayGrade, // Menggunakan getter untuk nilai yang ditampilkan
          ),
        );
      },
    );
  }

  // --- Helper untuk filter (opsional, perlu data untuk dropdown) ---
  // List<String> _getTahunAjaranOptions() {
  //   if (_allNilai.isEmpty) return [];
  //   return _allNilai.map((n) => n.tahunAjaran).toSet().toList()..sort((a,b) => b.compareTo(a)); // Sort descending
  // }
  // List<String> _getSemesterOptions() {
  //   if (_allNilai.isEmpty) return [];
  //   // Asumsi semesterDiambil bisa null, jadi filter dulu
  //   return _allNilai.where((n) => n.semesterDiambil != null).map((n) => n.semesterDiambil!).toSet().toList()..sort();
  // }
}
