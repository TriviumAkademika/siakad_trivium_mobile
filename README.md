# 📱 Aplikasi Mobile SIAKAD Trivium

Aplikasi mobile **SIAKAD Trivium** merupakan aplikasi berbasis **Flutter** yang terintegrasi dengan backend Sistem Informasi Akademik (SIAKAD) melalui **REST API**.

---

## 🛠️ Teknologi

- Flutter
- REST API
- HTTP Client (package `http`)
- Token-based authentication (Laravel Sanctum)

---

## 👤 Hak Akses Pengguna

Aplikasi mobile ini **hanya dapat digunakan oleh pengguna dengan role:**

- Mahasiswa

Role lain (Admin dan Dosen) tidak memiliki akses ke aplikasi mobile.

Pembatasan hak akses tetap dilakukan di sisi backend menggunakan mekanisme role dan permission.

---

## 🔐 Autentikasi

Aplikasi mobile menggunakan autentikasi berbasis token.

Alur autentikasi:

1. Mahasiswa melakukan login melalui API
2. Backend mengembalikan token dari Laravel Sanctum
3. Token digunakan pada setiap request API

---

## ✨ Fitur Aplikasi Mobile

Aplikasi mobile menyediakan fitur berikut untuk mahasiswa:

- Melihat jadwal kuliah
- Mengakses FRS (Formulir Rencana Studi)
- Melihat nilai
- Melihat profil dosen

---

## 🔗 Integrasi API

Aplikasi mobile terhubung langsung ke backend SIAKAD menggunakan **REST API**.

Seluruh data yang ditampilkan pada aplikasi mobile berasal dari API yang sama dengan aplikasi web.

---

## ⚠️ Catatan Hak Akses

Akses endpoint API pada aplikasi mobile dibatasi menggunakan:

- middleware autentikasi (`auth:sanctum`)
- role mahasiswa
- permission yang sesuai

Sehingga mahasiswa hanya dapat mengakses endpoint yang telah diizinkan.
