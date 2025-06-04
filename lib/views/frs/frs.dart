import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:siakad_trivium/services/frs_service.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_button.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/custom_textfield.dart';
import 'package:siakad_trivium/views/widgets/frs_card.dart';
import 'package:siakad_trivium/views/frs/tambah_frs.dart';
import 'package:siakad_trivium/viewmodels/frs_viewmodel.dart'; // Import your ViewModel

class Frs extends StatefulWidget {
  const Frs({super.key});

  @override
  State<Frs> createState() => _FrsState();
}

class _FrsState extends State<Frs> {
  late FrsViewModel _frsViewModel;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to delay fetching data until after the build cycle
    // This is good practice when calling async operations in initState
    Future.microtask(() {
      _frsViewModel = Provider.of<FrsViewModel>(context, listen: false);
      _frsViewModel.fetchFrsData();
    });
  }

  Future<void> _refreshFrsData() async {
    await _frsViewModel.fetchFrsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomNavbar(title: 'FRS'),
      body: Consumer<FrsViewModel>(
        builder: (context, frsViewModel, child) {
          if (frsViewModel.state == FrsViewState.loading || frsViewModel.state == FrsViewState.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (frsViewModel.state == FrsViewState.error) {
            return RefreshIndicator(
              onRefresh: _refreshFrsData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // Allows pull-to-refresh even if content is small
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error: ${frsViewModel.message}\nTap to retry or pull to refresh.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Data is loaded, display it
            final frsHeader = frsViewModel.frsHeader;
            final frsDetails = frsHeader?['detail_frs'] as List<dynamic>? ?? [];

            // Extract available schedules (jadwal_tersedia) for TambahFrsPage
            final List<JadwalTersedia> availableSchedules = frsViewModel.jadwalTersedia;


            return RefreshIndicator(
              onRefresh: _refreshFrsData,
              child: CustomScrollbar(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextfield(
                          label: 'Nama',
                          value: frsHeader?['mahasiswa']?['nama_mahasiswa'] ?? 'N/A',
                        ),
                        const SizedBox(height: 16),
                        CustomTextfield(
                          label: 'Dosen Wali',
                          value: frsHeader?['mahasiswa']?['dosen_wali']?['nama_dosen'] ?? 'N/A',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextfield(
                                label: 'IPK/IPS',
                                value: '${frsHeader?['ipk'] ?? 'N/A'}/${frsHeader?['ips'] ?? 'N/A'}',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextfield(
                                label: 'Total SKS',
                                value: frsHeader?['total_sks']?.toString() ?? '0',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextfield( // Changed from FilterBar to CustomTextfield for static display
                                label: 'Tahun Ajaran',
                                value: frsHeader?['tahun_ajaran'] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextfield( // Changed from FilterBar to CustomTextfield for static display
                                label: 'Semester',
                                value: frsHeader?['semester'] ?? 'N/A',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Expanded(
                            //   child: CustomButton(
                            //     label: 'Lihat Semua',
                            //     icon: Icons.remove_red_eye_outlined,
                            //     onPressed: () {
                            //       // This button navigates to DetailFrs, which might not be needed
                            //       // if all details are shown on this page.
                            //       // If 'DetailFrs' page shows something else, keep it.
                            //       // For now, it's commented out as per typical FRS flow.
                            //       // Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailFrs()));
                            //     },
                            //   ),
                            // ),
                            // const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                label: 'Tambah FRS',
                                icon: Icons.add,
                                onPressed: () async {
                                  // Pass available schedules to TambahFrsPage
                                  final bool? added = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TambahFrsPage(
                                        availableSchedules: availableSchedules,
                                      ),
                                    ),
                                  );
                                  if (added == true) {
                                    // Optionally show a success message after return
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Mata kuliah berhasil ditambahkan!')),
                                    );
                                    // Data will be refreshed by fetchFrsData in addJadwalToFrs
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Displaying FRS details from the current FRS
                        if (frsDetails.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: Text(
                                'Belum ada mata kuliah yang diambil untuk FRS ini.',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ...frsDetails.map((detail) {
                            final jadwal = detail['jadwal'];
                            if (jadwal == null) return const SizedBox.shrink(); // Handle null jadwal
                            final matkul = jadwal['matkul'];
                            final dosen1 = jadwal['dosen'];
                            final dosen2 = jadwal['dosen_2']; // Assuming dosen_2 is directly available in jadwal

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: FrsCard(
                                idDetailFrs: detail['id_detail_frs'], // Pass id_detail_frs
                                jenis: matkul?['jenis'] ?? 'N/A',
                                sks: (matkul?['sks'] ?? 0).toString(),
                                namaMatkul: matkul?['nama_matkul'] ?? 'N/A',
                                dosen1: dosen1?['nama_dosen'] ?? 'N/A',
                                dosen2: dosen2?['nama_dosen'], // Pass dosen2 if available
                                onDelete: () async {
                                  // Show confirmation dialog before dropping
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: Text('Anda yakin ingin menghapus mata kuliah "${matkul?['nama_matkul'] ?? 'N/A'}" dari FRS?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    await frsViewModel.dropJadwalFromFrs(detail['id_detail_frs']);
                                    if (frsViewModel.state == FrsViewState.loaded) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(frsViewModel.message)),
                                      );
                                    } else if (frsViewModel.state == FrsViewState.error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Gagal menghapus: ${frsViewModel.message}')),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}