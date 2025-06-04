import 'package:flutter/material.dart';
import 'package:siakad_trivium/models/nilai_mahasiswa_model.dart';
import 'package:siakad_trivium/services/nilai_service.dart';
import 'package:siakad_trivium/style.dart';
import 'package:siakad_trivium/views/widgets/custom_navbar.dart';
import 'package:siakad_trivium/views/widgets/nilai_card.dart';

class Nilai extends StatefulWidget {
  const Nilai({super.key});

  @override
  State<Nilai> createState() => _NilaiState();
}

class _NilaiState extends State<Nilai> {
  final NilaiService _nilaiService = NilaiService();
  Future<NilaiMahasiswaResponse>? _nilaiFuture;

  @override
  void initState() {
    super.initState();
    _loadNilai();
  }

  void _loadNilai() {
    setState(() {
      _nilaiFuture = _nilaiService.getNilaiMahasiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomNavbar(
        title: 'Nilai',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadNilai();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    final List<NilaiItem> originalNilaiList =
                        snapshot.data!.data.nilaiList;

                    if (originalNilaiList.isEmpty) {
                      return const Center(child: Text('Tidak ada data nilai.'));
                    }

                    final List<NilaiItem> displayList =
                        originalNilaiList;

                    if (displayList.isEmpty) {
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

                        if (item.nilaiUts != null && item.nilaiUas != null) {
                          nilaiToShow =
                              "UTS: ${item.nilaiUts} / UAS: ${item.nilaiUas}";
                        } else if (item.nilaiUas != null) {
                          nilaiToShow = "UAS: ${item.nilaiUas!}";
                        } else if (item.nilaiUts != null) {
                          nilaiToShow = "UTS: ${item.nilaiUts!}";
                        }

                        return NilaiCard(
                          jenis: item.jenis,
                          namaMatkul: item.matkul.namaMatkul,
                          dosen1: item.matkul.jadwal?.dosen?.namaDosen ?? 'N/A',
                          dosen2: item.matkul.jadwal?.dosen2?.namaDosen,
                          nilai: nilaiToShow,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
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