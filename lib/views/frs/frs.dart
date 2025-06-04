import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/services/frs_service.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_button.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart'; // Pastikan import ini benar jika berbeda
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/custom_textfield.dart';
import 'package:siakad_trivium/views/widgets/frs_card.dart';
import 'package:siakad_trivium/views/frs/tambah_frs.dart';
import 'package:siakad_trivium/viewmodels/frs_viewmodel.dart';

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
      backgroundColor: bgColor, // Assuming bgColor is defined in style.dart
      appBar: const CustomNavbar(title: 'FRS'),
      body: Consumer<FrsViewModel>(
        builder: (context, frsViewModel, child) {
          if (frsViewModel.state == FrsViewState.loading || frsViewModel.state == FrsViewState.initial || frsViewModel.state == FrsViewState.submitting) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(frsViewModel.message.isNotEmpty ? frsViewModel.message : 'Memuat data...'),
              ],
            ));
          } else if (frsViewModel.state == FrsViewState.error) {
            return RefreshIndicator(
              onRefresh: _refreshFrsData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
            // LANGSUNG GUNAKAN frsViewModel.currentFrsCourses
            final List<DetailFrsItem> currentFrsCourses = frsViewModel.currentFrsCourses;

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
                        // CustomTextfield(
                        //   label: 'Nama',
                        //   value: frsHeader?['mahasiswa']?['nama_mahasiswa'] ?? 'N/A',
                        // ),
                        // const SizedBox(height: 16),
                        // CustomTextfield(
                        //   label: 'Dosen Wali',
                        //   value: frsHeader?['mahasiswa']?['dosen_wali']?['nama_dosen'] ?? 'N/A',
                        // ),
                        // const SizedBox(height: 16),
                        Row(
                          children: [
                            // Expanded(
                            //   child: CustomTextfield(
                            //     label: 'IPK/IPS',
                            //     value: '${frsHeader?['ipk'] ?? 'N/A'}/${frsHeader?['ips'] ?? 'N/A'}',
                            //   ),
                            // ),
                            // const SizedBox(width: 16),
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
                              child: CustomTextfield(
                                label: 'Tahun Ajaran',
                                value: frsHeader?['tahun_ajaran'] ?? 'N/A',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextfield(
                                label: 'Semester',
                                value: frsHeader?['semester'] ?? 'N/A',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox( // Menggunakan SizedBox untuk memberikan tinggi agar Expanded di dalamnya tidak error
                          width: double.infinity, // Memastikan CustomButton mengambil lebar penuh
                          child: CustomButton(
                            label: 'Tambah FRS',
                            icon: Icons.add,
                            onPressed: () async {
                              final bool? added = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TambahFrsPage(
                                    availableSchedules: availableSchedules,
                                  ),
                                ),
                              );
                              if (added == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Mata kuliah berhasil ditambahkan!')),
                                );
                                // fetchFrsData akan dipanggil oleh addJadwalToFrs di TambahFrsPage
                                // atau Anda bisa memanggilnya secara eksplisit di sini jika TambahFrsPage tidak memicu refresh
                                // await _frsViewModel.fetchFrsData();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Displaying FRS details from the current FRS
                        if (currentFrsCourses.isEmpty) // Menggunakan currentFrsCourses
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
                          ...currentFrsCourses.map((course) { // Iterasi langsung pada objek DetailFrsItem
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: FrsCard(
                                idDetailFrs: course.idDetailFrs,
                                jenis: course.jenis,
                                sks: course.sks.toString(),
                                namaMatkul: course.namaMatkul,
                                dosen1: course.dosen1,
                                dosen2: course.dosen2,
                                isApproved: course.status, // <--- INI ADALAH PERBAIKAN UTAMA
                                onDelete: course.status // Hanya izinkan penghapusan jika belum disetujui
                                    ? null
                                    : () async {
                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return AlertDialog(
                                              title: const Text('Konfirmasi Hapus'),
                                              content: Text('Anda yakin ingin menghapus "${course.namaMatkul}" dari FRS?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(dialogContext).pop(false),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(dialogContext).pop(true),
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          bool success = await frsViewModel.dropJadwalFromFrs(course.idDetailFrs);
                                          if (success) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(frsViewModel.message)),
                                            );
                                          } else {
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
