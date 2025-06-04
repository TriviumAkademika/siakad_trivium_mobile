// lib/views/frs/tambah_frs.dart (atau path Anda saat ini)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/viewmodels/frs_viewmodel.dart';
// Jika JadwalTersedia ada di frs_service.dart:
import 'package:siakad_trivium/services/frs_service.dart' show JadwalTersedia;
// Jika JadwalTersedia ada di file model terpisah misal lib/models/jadwal_model.dart:
// import 'package:siakad_trivium/models/jadwal_model.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/frs_add_card.dart';


class TambahFrsPage extends StatefulWidget {
  const TambahFrsPage({super.key});

  @override
  State<TambahFrsPage> createState() => _TambahFrsPageState();
}

class _TambahFrsPageState extends State<TambahFrsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FrsViewModel>(context, listen: false).fetchFrsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Tambah Mata Kuliah FRS'),
      body: Consumer<FrsViewModel>(
        builder: (context, viewModel, child) {
          // ... (UI logic sama seperti sebelumnya, menggunakan viewModel dari FrsViewModel) ...
          // ... (Pastikan semua referensi ke model JadwalTersedia benar) ...
          if (viewModel.state == FrsViewState.loading && viewModel.jadwalTersedia.isEmpty) {
            return const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF152556)),
            ));
          }

          if (viewModel.state == FrsViewState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(viewModel.message.isNotEmpty ? viewModel.message : 'Gagal memuat data.', textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => viewModel.fetchFrsData(),
                      child: const Text('Coba Lagi'),
                    )
                  ],
                ),
              ),
            );
          }

          if (viewModel.jadwalTersedia.isEmpty && viewModel.state == FrsViewState.loaded) {
            return const Center(child: Text('Tidak ada jadwal mata kuliah yang tersedia untuk ditambahkan.'));
          }
          
          String totalSksInfo = "";
          if (viewModel.frsHeader != null && viewModel.frsHeader!['total_sks'] != null) {
            totalSksInfo = "Total SKS diambil: ${viewModel.frsHeader!['total_sks']}";
          }

          return CustomScrollbar(
            child: RefreshIndicator(
              onRefresh: () => viewModel.fetchFrsData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       if (totalSksInfo.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(totalSksInfo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                      if (viewModel.state == FrsViewState.submitting)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(child: Text(viewModel.message.isNotEmpty ? viewModel.message : "Memproses...")),
                        ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.jadwalTersedia.length,
                        itemBuilder: (context, index) {
                          final jadwal = viewModel.jadwalTersedia[index];
                          return FrsAddCard(
                            jenis: jadwal.jenisMatkul ?? "Mata Kuliah",
                            sks: jadwal.sks.toString(),
                            namaMatkul: jadwal.namaMatkul ?? 'N/A',
                            dosen1: jadwal.namaDosen ?? 'N/A',
                            dosen2: jadwal.namaDosen2,
                            onAdd: viewModel.state == FrsViewState.submitting ? null : () async {
                              bool success = await viewModel.addJadwalToFrs(jadwal.idJadwal);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.message), // Pesan dari ViewModel setelah add
                                  backgroundColor: success ? Colors.green : Colors.red,
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}