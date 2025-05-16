// lib/data/dummy/profile_dummy.dart

class ProfileData {
  final String name;
  final String semester;
  final String gender;
  final String nrp;
  final String email;
  final String address;

  ProfileData({
    required this.name,
    required this.semester,
    required this.gender,
    required this.nrp,
    required this.email,
    required this.address,
  });
}

final dummyProfile = ProfileData(
  name: "Selvi Riska Nisa",
  semester: "4",
  gender: "Perempuan",
  nrp: "3123500054",
  email: "selvi@student.id",
  address: "Jl. Mawar No. 45, Surabaya",
);
