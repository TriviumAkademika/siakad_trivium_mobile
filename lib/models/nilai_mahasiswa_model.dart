import 'dart:convert';

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
        success: json["success"] ?? false, // Ditambahkan ?? false untuk keamanan
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
  int count;

  Data({
    required this.mahasiswa,
    required this.nilaiList,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    try {
      return Data(
        mahasiswa: MahasiswaInfo.fromJson(json["mahasiswa"]),
        nilaiList: List<NilaiItem>.from(
          json["nilai_list"].map((x) => NilaiItem.fromJson(x)),
        ),
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
        nama: json["nama"] ?? "N/A", // Ditambahkan ?? "N/A" untuk keamanan
        nrp: json["nrp"] ?? "N/A",   // Ditambahkan ?? "N/A"
        semester: json["semester"] ?? "N/A", // Ditambahkan ?? "N/A"
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
            json["dosen2"] == null ? null : Dosen.fromJson(json["dosen2"]),
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
        namaMatkul: json["nama_matkul"] ?? "N/A", // Ditambahkan ?? "N/A"
        jenis: json["jenis"] ?? "N/A",           // Ditambahkan ?? "N/A"
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
  String jenis;
  String tahunAjaran;
  String semester;

  NilaiItem({
    required this.matkul,
    required this.sks,
    this.nilaiUts,
    this.nilaiUas,
    required this.jenis,
    required this.tahunAjaran,
    required this.semester,
  });

  factory NilaiItem.fromJson(Map<String, dynamic> json) {
    try {
      return NilaiItem(
        matkul: Matkul.fromJson(json["matkul"]),
        sks: json["sks"],
        nilaiUts: json["nilai_uts"] as String?,
        nilaiUas: json["nilai_uas"] as String?,
        jenis: json["jenis"] ?? "N/A",
        tahunAjaran: json["tahun_ajaran"] ?? "N/A",
        semester: json["semester"] ?? "N/A",
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
        "jenis": jenis,
        "tahun_ajaran": tahunAjaran,
        "semester": semester,
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
        namaDosen: json["nama_dosen"] ?? "N/A", // Ditambahkan ?? "N/A"
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