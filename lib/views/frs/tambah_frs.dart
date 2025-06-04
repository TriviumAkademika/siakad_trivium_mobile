import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/viewmodels/frs_viewmodel.dart';
import 'package:siakad_trivium/services/frs_service.dart' show JadwalTersedia; // Make sure this is correctly imported
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/frs_add_card.dart'; // Ensure this widget exists

class TambahFrsPage extends StatefulWidget {
  // Add the required parameter here
  final List<JadwalTersedia> availableSchedules;

  const TambahFrsPage({Key? key, required this.availableSchedules}) : super(key: key); // Make it required

  @override
  State<TambahFrsPage> createState() => _TambahFrsPageState();
}

class _TambahFrsPageState extends State<TambahFrsPage> {
  @override
  void initState() {
    super.initState();
    // In TambahFrsPage, you might not need to fetchFrsData again if you're passing
    // availableSchedules from the previous page. If you still want to ensure
    // the latest data or filter here, keep it. For simplicity, if availableSchedules
    // is passed and is sufficient, you could remove this.
    // For now, I'll keep it as it seems you might want to fetch based on current FRS state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FrsViewModel>(context, listen: false).fetchFrsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomNavbar(title: 'Tambah Mata Kuliah FRS'),
      body: Consumer<FrsViewModel>(
        builder: (context, viewModel, child) {
          // You should use widget.availableSchedules if you're passing them,
          // or viewModel.jadwalTersedia if you're fetching them again in this page's initState.
          // Based on your Frs widget, you're passing `availableSchedules` directly.
          // Let's use `widget.availableSchedules` as the primary source for display in TambahFrsPage.
          final List<JadwalTersedia> schedulesToDisplay = widget.availableSchedules;


          if (viewModel.state == FrsViewState.loading && schedulesToDisplay.isEmpty) {
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
                      // This button will refresh the FRS data which also updates availableSchedules
                      onPressed: () => viewModel.fetchFrsData(),
                      child: const Text('Coba Lagi'),
                    )
                  ],
                ),
              ),
            );
          }

          if (schedulesToDisplay.isEmpty && viewModel.state == FrsViewState.loaded) {
            return const Center(child: Text('Tidak ada jadwal mata kuliah yang tersedia untuk ditambahkan.'));
          }
          
          String totalSksInfo = "";
          if (viewModel.frsHeader != null && viewModel.frsHeader!['total_sks'] != null) {
            totalSksInfo = "Total SKS diambil: ${viewModel.frsHeader!['total_sks']}";
          }

          return CustomScrollbar(
            child: RefreshIndicator(
              onRefresh: () => viewModel.fetchFrsData(), // Still useful for refreshing the total SKS info
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
                        itemCount: schedulesToDisplay.length, // Use schedulesToDisplay
                        itemBuilder: (context, index) {
                          final jadwal = schedulesToDisplay[index]; // Use schedulesToDisplay
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
                              // Pop the current page after adding, and send a result back to Frs page
                              Navigator.pop(context, success);
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