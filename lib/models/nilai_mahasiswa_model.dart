import 'dart:convert';

// Fungsi untuk parsing JSON dari API
NilaiMahasiswaResponse nilaiMahasiswaResponseFromJson(String str) {
  try {
    return NilaiMahasiswaResponse.fromJson(json.decode(str));
  } catch (e, stack) {
    print("Error parsing JSON string: $e");
    print(stack);
    rethrow;
  }
}

String nilaiMahasiswaResponseToJson(NilaiMahasiswaResponse data) =>
    json.encode(data.toJson());

class NilaiMahasiswaResponse {
  bool success;
  Data data;

  NilaiMahasiswaResponse({required this.success, required this.data});

  factory NilaiMahasiswaResponse.fromJson(Map<String, dynamic> json) {
    try {
      return NilaiMahasiswaResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );
    } catch (e, stack) {
      print("Error in NilaiMahasiswaResponse.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  MahasiswaInfo mahasiswa;
  List<NilaiItem> nilaiList;
  String? search;
  int count;

  Data({
    required this.mahasiswa,
    required this.nilaiList,
    this.search,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    try {
      return Data(
        mahasiswa: MahasiswaInfo.fromJson(json["mahasiswa"]),
        nilaiList: List<NilaiItem>.from(
          json["nilai_list"].map((x) => NilaiItem.fromJson(x)),
        ),
        search: json["search"] as String?,
        count: json["count"],
      );
    } catch (e, stack) {
      print("Error in Data.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "mahasiswa": mahasiswa.toJson(),
        "nilai_list": List<dynamic>.from(nilaiList.map((x) => x.toJson())),
        "search": search,
        "count": count,
      };
}

class MahasiswaInfo {
  int idMahasiswa;
  String nama;
  String nrp;
  String semester;

  MahasiswaInfo({
    required this.idMahasiswa,
    required this.nama,
    required this.nrp,
    required this.semester,
  });

  factory MahasiswaInfo.fromJson(Map<String, dynamic> json) {
    try {
      return MahasiswaInfo(
        idMahasiswa: json["id_mahasiswa"],
        nama: json["nama"],
        nrp: json["nrp"],
        semester: json["semester"],
      );
    } catch (e, stack) {
      print("Error in MahasiswaInfo.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id_mahasiswa": idMahasiswa,
        "nama": nama,
        "nrp": nrp,
        "semester": semester,
      };
}

class Jadwal {
  int idJadwal;
  int idKelas;
  int idMatkul;
  Dosen? dosen;
  Dosen? dosen2;
  int idWaktu;
  int idRuangan;

  Jadwal({
    required this.idJadwal,
    required this.idKelas,
    required this.idMatkul,
    this.dosen,
    this.dosen2,
    required this.idWaktu,
    required this.idRuangan,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    try {
      return Jadwal(
        idJadwal: json["id_jadwal"],
        idKelas: json["id_kelas"],
        idMatkul: json["id_matkul"],
        dosen: json["dosen"] == null ? null : Dosen.fromJson(json["dosen"]),
        dosen2:
            json["dosen_2"] == null ? null : Dosen.fromJson(json["dosen_2"]),
        idWaktu: json["id_waktu"],
        idRuangan: json["id_ruangan"],
      );
    } catch (e, stack) {
      print("Error in Jadwal.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id_jadwal": idJadwal,
        "id_kelas": idKelas,
        "id_matkul": idMatkul,
        "dosen": dosen?.toJson(),
        "dosen_2": dosen2?.toJson(),
        "id_waktu": idWaktu,
        "id_ruangan": idRuangan,
      };
}

class Matkul {
  int idMatkul;
  String namaMatkul;
  String jenis;
  int sks;
  Jadwal? jadwal;

  Matkul({
    required this.idMatkul,
    required this.namaMatkul,
    required this.jenis,
    required this.sks,
    this.jadwal,
  });

  factory Matkul.fromJson(Map<String, dynamic> json) {
    try {
      return Matkul(
        idMatkul: json["id_matkul"],
        namaMatkul: json["nama_matkul"],
        jenis: json["jenis"],
        sks: json["sks"],
        jadwal:
            json["jadwal"] == null ? null : Jadwal.fromJson(json["jadwal"]),
      );
    } catch (e, stack) {
      print("Error in Matkul.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id_matkul": idMatkul,
        "nama_matkul": namaMatkul,
        "jenis": jenis,
        "sks": sks,
        "jadwal": jadwal?.toJson(),
      };
}

class NilaiItem {
  Matkul matkul;
  int sks;
  String? nilaiUts;
  String? nilaiUas;
  bool isWajib;
  String tahunAjaran;
  String semesterDiambil;

  NilaiItem({
    required this.matkul,
    required this.sks,
    this.nilaiUts,
    this.nilaiUas,
    required this.isWajib,
    required this.tahunAjaran,
    required this.semesterDiambil,
  });

  factory NilaiItem.fromJson(Map<String, dynamic> json) {
    try {
      return NilaiItem(
        matkul: Matkul.fromJson(json["matkul"]),
        sks: json["sks"],
        nilaiUts: json["nilai_uts"] as String?,
        nilaiUas: json["nilai_uas"] as String?,
        isWajib: json["is_wajib"],
        tahunAjaran: json["tahun_ajaran"],
        semesterDiambil: json["semester_diambil"],
      );
    } catch (e, stack) {
      print("Error in NilaiItem.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "matkul": matkul.toJson(),
        "sks": sks,
        "nilai_uts": nilaiUts,
        "nilai_uas": nilaiUas,
        "is_wajib": isWajib,
        "tahun_ajaran": tahunAjaran,
        "semester_diambil": semesterDiambil,
      };
}

class Dosen {
  int idDosen;
  String namaDosen;

  Dosen({required this.idDosen, required this.namaDosen});

  factory Dosen.fromJson(Map<String, dynamic> json) {
    try {
      return Dosen(
        idDosen: json["id_dosen"],
        namaDosen: json["nama_dosen"],
      );
    } catch (e, stack) {
      print("Error in Dosen.fromJson: $e");
      print(stack);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id_dosen": idDosen,
        "nama_dosen": namaDosen,
      };
}
