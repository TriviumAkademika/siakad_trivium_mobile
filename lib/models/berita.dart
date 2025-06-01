// lib/models/berita.dart
import 'package:flutter/foundation.dart';

class Berita {
  final int id;
  final String? gambar; // URL or path from API
  final String isiBerita;
  final String? judul;
  final DateTime? tanggal;
  final String? penulis;

  // Base URL for images if 'gambar' is a relative path
  // IMPORTANT: Replace with your actual API's base URL for images
  static const String _imageBaseUrl = "http://your.api.domain/storage/"; // Example: "http://localhost:8000/storage/"

  Berita({
    required this.id,
    this.gambar,
    required this.isiBerita,
    this.judul,
    this.tanggal,
    this.penulis,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'] as int,
      gambar: json['gambar'] as String?,
      isiBerita: json['isi_berita'] as String,
      judul: json['judul'] as String?,
      tanggal: json['tanggal'] != null ? DateTime.tryParse(json['tanggal'] as String) : null,
      penulis: json['penulis'] as String?,
    );
  }

  // Helper to get the full image URL
  // It checks if the 'gambar' field is already a full URL or a relative path
  String? get fullImageUrl {
    if (gambar == null || gambar!.isEmpty) {
      return null;
    }
    if (gambar!.startsWith('http://') || gambar!.startsWith('https://')) {
      return gambar; // It's already a full URL
    }
    return _imageBaseUrl + gambar!; // Append base URL for relative paths
  }

  // For debugging purposes
  @override
  String toString() {
    return 'Berita{id: $id, judul: $judul, penulis: $penulis, tanggal: $tanggal, gambar: $gambar, isiBerita: ${isiBerita.substring(0, isiBerita.length > 50 ? 50 : isiBerita.length)}...}';
  }
}
