import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/viewmodels/jadwal_viewmodel.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/custom_scrollbar.dart';
import 'package:siakad_trivium/views/widgets/hari_card.dart';
import 'package:siakad_trivium/views/widgets/jadwal_card.dart'; // Menggunakan JadwalCard Anda
import 'package:siakad_trivium/models/jadwal_model.dart'; // Import model untuk casting

// hari_utils.dart tidak lagi secara eksplisit dibutuhkan di sini jika ViewModel yang menanganinya,
// tapi pastikan ViewModel Anda memiliki cara untuk mendapatkan nama hari jika diperlukan untuk UI lain.
// import 'package:siakad_trivium/utils/hari_utils.dart'; 

class Jadwal extends StatefulWidget {
  const Jadwal({super.key});

  @override
  State<Jadwal> createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  final ScrollController _scrollController = ScrollController();
  // selectedIndex dikelola oleh JadwalViewModel

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<JadwalViewModel>(context, listen: false);
      if (viewModel.state == JadwalState.initial) {
        // Memuat jadwal untuk hari default yang ada di ViewModel (misal Senin)
        viewModel.loadJadwalForSelectedDay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jadwalViewModel = context.watch<JadwalViewModel>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(title: 'Jadwal Kuliah'),
      body: CustomScrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HariCard(
                selectedIndex: jadwalViewModel.selectedHariIndex,
                onTap: (index) {
                  jadwalViewModel.changeSelectedDay(index);
                },
              ),
              const SizedBox(height: 20),
              _buildJadwalList(jadwalViewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalList(JadwalViewModel viewModel) {
    if (viewModel.state == JadwalState.loading) {
      return const Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0), // Beri padding agar tidak terlalu mepet
        child: CircularProgressIndicator(),
      ));
    }

    if (viewModel.state == JadwalState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Gagal memuat jadwal: ${viewModel.errorMessage ?? "Terjadi kesalahan"}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700, fontSize: 16),
          ),
        ),
      );
    }

    if (viewModel.jadwalList.isEmpty && viewModel.state == JadwalState.loaded) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0), // Beri padding
          child: Text(
            'Tidak ada jadwal untuk ${viewModel.selectedNamaHari}.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: viewModel.jadwalList.length,
      itemBuilder: (context, index) {
        final JadwalModel jadwalItem = viewModel.jadwalList[index]; // Ini adalah JadwalModel

        // Ekstrak data dari JadwalModel untuk JadwalCard
        String jenis = jadwalItem.matkul?.jenis?.toUpperCase() ?? 'MATKUL';
        String namaMatkul = jadwalItem.matkul?.namaMatkul ?? 'N/A';
        String dosen1 = jadwalItem.dosen?.namaDosen ?? 'N/A';
        String? dosen2 = jadwalItem.dosen2?.namaDosen; // bisa null
        
        String jamMulai = jadwalItem.waktu?.jamMulai?.substring(0,5) ?? '--:--';
        String jamSelesai = jadwalItem.waktu?.jamSelesai?.substring(0,5) ?? '--:--';
        String ruangan = jadwalItem.ruangan?.kodeRuangan ?? '-';
        // String waktuDanRuangan = '$jamMulai - $jamSelesai (${ruangan})';
        // JadwalCard Anda saat ini hanya menerima `waktu` sebagai String tunggal.
        // Kita akan format seperti contoh Anda, yaitu hanya jam.
        // Jika ingin menampilkan ruangan juga, JadwalCard perlu dimodifikasi
        // atau string `waktu` ini bisa berisi gabungan keduanya.
        String waktuFormatted = '$jamMulai - $jamSelesai';
        // Jika ingin menyertakan ruangan di properti waktu:
        // String waktuFormatted = '$jamMulai - $jamSelesai\n($ruangan)'; // Akan jadi 2 baris di JadwalCard

        return JadwalCard(
          jenis: jenis,
          namaMatkul: namaMatkul,
          dosen1: dosen1,
          dosen2: dosen2, // Teruskan null jika memang null
          waktu: waktuFormatted,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}