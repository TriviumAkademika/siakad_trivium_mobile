// lib/views/profile/change_password_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart';
import 'package:siakad_trivium/views/widgets/custom_app_bar.dart'; // Asumsi CustomAppBar bisa dipakai ulang
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitChangePassword(ProfileViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final success = await viewModel.updateUserPassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _confirmPasswordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.passwordChangeMessage)),
      );

      if (success) {
        // Kembali ke halaman profil atau tutup halaman ini
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan ProfileViewModel yang sudah di-provide oleh ProfilePage,
    // atau jika di-provide di atas MaterialApp, akan diambil dari sana.
    // Jika halaman ini dibuka secara independen, perlu di-provide sendiri.
    // Untuk kasus ini, kita navigasi dari ProfilePage, jadi ViewModel harusnya sudah ada.
    final viewModel = Provider.of<ProfileViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CustomAppBar(
        title: 'Ganti Password',
        // onBackButtonPressed akan default pop() jika tidak diset
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Silakan masukkan password lama dan password baru Anda.',
                style: GoogleFonts.plusJakartaSans(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Password Saat Ini
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Password Saat Ini',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrentPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password saat ini tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Baru
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru tidak boleh kosong';
                  }
                  if (value.length < 6) { // Sesuaikan dengan aturan validasi Laravel (min:6)
                    return 'Password baru minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password Baru
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password baru tidak boleh kosong';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Konfirmasi password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: viewModel.passwordChangeState == PasswordChangeState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () => _submitChangePassword(viewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF152556), // Warna primer
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Simpan Password',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}