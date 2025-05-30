import 'package:flutter/material.dart';

class UserData {
  final String email;
  final String password;
  final String role;

  UserData({
    required this.email,
    required this.password,
    required this.role,
  });
}

// Dummy data
List<UserData> dummyUsers = [
  UserData(
    email: 'mahasiswa@example.com',
    password: 'mahasiswa123',
    role: 'mahasiswa',
  ),
  UserData(
    email: 'dosen@example.com',
    password: 'dosen123',
    role: 'dosen',
  ),
  UserData(email: 'selpiichan@example.com', password: 'selpiichan', role: 'mahasiswa'),
  UserData(email: 'syidachan@example.com', password: 'syidachan', role: 'mahasiswa'),
  UserData(email: 'boluchan@example.com', password: 'boluchan', role: 'mahasiswa'),
  UserData(email: 'lecture1@example.com', password: 'lecture1', role: 'dosen'),
];
