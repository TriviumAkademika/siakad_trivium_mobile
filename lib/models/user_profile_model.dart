// lib/models/user_profile_model.dart

class UserProfileResponse {
  final bool success;
  final String message;
  final ProfileDataContainer data;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProfileDataContainer.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ProfileDataContainer {
  final UserData user;
  final String? role;
  // profileDetails bisa jadi Map<String, dynamic> atau model spesifik
  // Untuk contoh ini, kita akan membuatnya lebih fleksibel terlebih dahulu
  // dan kemudian bisa di-cast ke MahasiswaDetails atau DosenDetails di ViewModel.
  final Map<String, dynamic>? profileDetails;
  MahasiswaDetails? mahasiswaDetails; // Akan diisi jika role = mahasiswa

  ProfileDataContainer({
    required this.user,
    this.role,
    this.profileDetails,
  }) {
    if (role == 'mahasiswa' && profileDetails != null) {
      mahasiswaDetails = MahasiswaDetails.fromJson(profileDetails!);
    }
    // Tambahkan parsing untuk DosenDetails jika ada
  }

  factory ProfileDataContainer.fromJson(Map<String, dynamic> json) {
    return ProfileDataContainer(
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      role: json['role'] as String?,
      profileDetails: json['profile_details'] as Map<String, dynamic>?,
    );
  }
}

class UserData {
  final int idUser;
  final String? name; // name dari API bisa null
  final String email;

  UserData({
    required this.idUser,
    this.name,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUser: json['id_user'] as int,
      name: json['name'] as String?,
      email: json['email'] as String,
    );
  }
}

class MahasiswaDetails {
  final int idMahasiswa;
  final int? idKelas; // Bisa jadi tidak semua mahasiswa punya kelas diawal
  final String nama;
  final String nrp;
  final String? semester;
  final String? gender;
  final String? alamat;
  final String? noHp;
  final String? status;
  final Kelas? kelas; // kelas bisa null jika tidak ada di data

  MahasiswaDetails({
    required this.idMahasiswa,
    this.idKelas,
    required this.nama,
    required this.nrp,
    this.semester,
    this.gender,
    this.alamat,
    this.noHp,
    this.status,
    this.kelas,
  });

  factory MahasiswaDetails.fromJson(Map<String, dynamic> json) {
    return MahasiswaDetails(
      idMahasiswa: json['id_mahasiswa'] as int,
      idKelas: json['id_kelas'] as int?,
      nama: json['nama'] as String,
      nrp: json['nrp'] as String,
      semester: json['semester'] as String?,
      gender: json['gender'] as String?,
      alamat: json['alamat'] as String?,
      noHp: json['no_hp'] as String?,
      status: json['status'] as String?,
      kelas: json['kelas'] != null
          ? Kelas.fromJson(json['kelas'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Kelas {
  final int idKelas;
  final int? idDosen;
  final String? tahunMasuk;
  final String? prodi;
  final String? paralel;
  final String? status;

  Kelas({
    required this.idKelas,
    this.idDosen,
    this.tahunMasuk,
    this.prodi,
    this.paralel,
    this.status,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      idKelas: json['id_kelas'] as int,
      idDosen: json['id_dosen'] as int?,
      tahunMasuk: json['tahun_masuk'] as String?,
      prodi: json['prodi'] as String?,
      paralel: json['paralel'] as String?,
      status: json['status'] as String?,
    );
  }
}

// Anda bisa menambahkan model DosenDetails di sini jika diperlukan
// class DosenDetails { ... }