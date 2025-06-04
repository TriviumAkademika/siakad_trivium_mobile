import 'package:flutter/material.dart';
import 'package:siakad_trivium/models/nilai_mahasiswa_model.dart'; // Sesuaikan path
import 'package:siakad_trivium/services/nilai_service.dart'; // Sesuaikan path
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
// import 'package:siakad_trivium/views/widgets/filter_bar.dart'; // Jika Anda memiliki widget ini
// import 'package:siakad_trivium/views/widgets/search_bar.dart'; // Jika Anda memiliki widget ini
import 'package:siakad_trivium/views/widgets/nilai_card.dart';

class Nilai extends StatefulWidget {
  const Nilai({super.key});

  @override
  State<Nilai> createState() => _NilaiState();
}

class _NilaiState extends State<Nilai> {
  final NilaiService _nilaiService = NilaiService();
  Future<NilaiMahasiswaResponse>? _nilaiFuture;

  String? _selectedTahunAjaran;
  String? _selectedJenisNilai;
  String _searchTerm = "";

  final List<String> _tahunAjaranItems = ['Semua', '2024/2025', '2023/2024'];
  final List<String> _jenisNilaiItems = ['Semua', 'UTS', 'UAS'];

  @override
  void initState() {
    super.initState();
    _loadNilai();
  }

  void _loadNilai() {
    setState(() {
      _nilaiFuture = _nilaiService.getNilaiMahasiswa(
        searchTerm: _searchTerm,
        // Jika backend mendukung filter:
        // tahunAjaran: _selectedTahunAjaran == 'Semua' ? null : _selectedTahunAjaran,
        // jenisNilai: _selectedJenisNilai == 'Semua' ? null : _selectedJenisNilai,
      );
    });
  }

  void _onSearchChanged(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _loadNilai();
    });
  }

  void _onTahunAjaranChanged(String? newValue) {
    setState(() {
      _selectedTahunAjaran =
          newValue; // newValue sudah bisa null jika 'Semua' tidak dipilih atau dropdown mengizinkan null
      // Saat ini filter client-side, jika backend siap, panggil _loadNilai()
      // _loadNilai();
    });
  }

  void _onJenisNilaiChanged(String? newValue) {
    setState(() {
      _selectedJenisNilai = newValue;
      // Saat ini filter client-side, jika backend siap, panggil _loadNilai()
      // _loadNilai();
    });
  }

  List<NilaiItem> _filterNilaiList(List<NilaiItem> originalList) {
    List<NilaiItem> filteredList = List.from(originalList);

    // Filter berdasarkan tahun ajaran (client-side)
    // Pastikan _selectedTahunAjaran tidak 'Semua' sebelum memfilter
    if (_selectedTahunAjaran != null && _selectedTahunAjaran != 'Semua') {
      filteredList =
          filteredList
              .where(
                (item) => item.tahunAjaran == _selectedTahunAjaran,
              ) // Menggunakan item.tahunAjaran (camelCase)
              .toList();
    }

    // Filter berdasarkan jenis nilai (client-side, hanya jika salah satu dipilih selain 'Semua')
    // Logika ini akan menyembunyikan item jika jenis nilai yang dipilih tidak ada nilainya.
    if (_selectedJenisNilai != null && _selectedJenisNilai != 'Semua') {
      if (_selectedJenisNilai == 'UTS') {
        filteredList =
            filteredList
                .where(
                  (item) => item.nilaiUts != null && item.nilaiUts!.isNotEmpty,
                )
                .toList();
      } else if (_selectedJenisNilai == 'UAS') {
        filteredList =
            filteredList
                .where(
                  (item) => item.nilaiUas != null && item.nilaiUas!.isNotEmpty,
                )
                .toList();
      }
    }
    // Jika jenis nilai 'Semua', tidak ada filter tambahan berdasarkan jenis nilai di sini,
    // tampilan nilai di NilaiCard akan menanganinya.

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor, // Pastikan bgColor terdefinisi di style.dart
      appBar: CustomNavbar(title: 'Nilai'),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadNilai();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: Tambahkan CustomSearchBar dan FilterBar di sini jika ada
              // Contoh:
              // CustomSearchBar(onChanged: _onSearchChanged),
              // FilterBar(
              //   tahunAjaranItems: _tahunAjaranItems,
              //   selectedTahunAjaran: _selectedTahunAjaran ?? 'Semua',
              //   onTahunAjaranChanged: _onTahunAjaranChanged,
              //   jenisNilaiItems: _jenisNilaiItems,
              //   selectedJenisNilai: _selectedJenisNilai ?? 'Semua',
              //   onJenisNilaiChanged: _onJenisNilaiChanged,
              // ),
              // const SizedBox(height: 16),
              FutureBuilder<NilaiMahasiswaResponse>(
                future: _nilaiFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.success) {
                    // Menggunakan nilaiList dari model (camelCase)
                    if (snapshot.data!.data.nilaiList.isEmpty) {
                      return const Center(child: Text('Tidak ada data nilai.'));
                    }

                    final List<NilaiItem> displayList = _filterNilaiList(
                      snapshot.data!.data.nilaiList,
                    ); // Menggunakan nilaiList (camelCase)

                    if (displayList.isEmpty) {
                      // Cek apakah original list ada isinya tapi filtered list kosong
                      if (snapshot.data!.data.nilaiList.isNotEmpty) {
                        return const Center(
                          child: Text(
                            'Tidak ada mata kuliah yang sesuai dengan filter.',
                          ),
                        );
                      }
                      return const Center(
                        child: Text('Tidak ada data nilai untuk ditampilkan.'),
                      );
                    }

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];
                        String nilaiToShow = '-';

                        if (_selectedJenisNilai == 'UTS') {
                          nilaiToShow =
                              item.nilaiUts ??
                              '-'; // Menggunakan item.nilaiUts (camelCase)
                        } else if (_selectedJenisNilai == 'UAS') {
                          nilaiToShow =
                              item.nilaiUas ??
                              '-'; // Menggunakan item.nilaiUas (camelCase)
                        } else {
                          // 'Semua' atau null
                          if (item.nilaiUts != null && item.nilaiUas != null) {
                            // Menggunakan camelCase
                            nilaiToShow =
                                "UTS: ${item.nilaiUts} / UAS: ${item.nilaiUas}";
                          } else if (item.nilaiUas != null) {
                            // Menggunakan camelCase
                            nilaiToShow = "UAS: ${item.nilaiUas!}";
                          } else if (item.nilaiUts != null) {
                            // Menggunakan camelCase
                            nilaiToShow = "UTS: ${item.nilaiUts!}";
                          }
                        }

                        return NilaiCard(
                          // Menggunakan item.isWajib (camelCase)
                          jenis:
                              item.isWajib
                                  ? 'Matakuliah Wajib'
                                  : 'Matakuliah Pilihan',
                          // Menggunakan item.matkul.namaMatkul (camelCase)
                          namaMatkul: item.matkul.namaMatkul,
                          // Menggunakan camelCase untuk akses field model
                          dosen1: item.matkul.jadwal?.dosen?.namaDosen ?? 'N/A',
                          dosen2:
                              item
                                  .matkul
                                  .jadwal
                                  ?.dosen2
                                  ?.namaDosen, // dosen2 bisa null
                          nilai: nilaiToShow,
                        );
                      },
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                    );
                  } else {
                    return Center(
                      child: Text(
                        snapshot.data?.data.toString() ??
                            'Gagal memuat data atau data tidak valid.',
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
