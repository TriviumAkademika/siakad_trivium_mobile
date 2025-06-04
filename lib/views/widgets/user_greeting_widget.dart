// lib/widgets/user_greeting_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siakad_trivium/models/user_profile_model.dart'; // Sesuaikan path jika perlu
import 'package:siakad_trivium/viewmodels/profile_viewmodel.dart'; // Sesuaikan path jika perlu

class UserGreetingWidget extends StatelessWidget {
  final ProfileViewModel viewModel;

  const UserGreetingWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.profileState == ProfileState.loading && viewModel.userProfile == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF152556)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Memuat...',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          )
        ],
      );
    }

    if (viewModel.userProfile != null) {
      final userProfileData = viewModel.userProfile!.data;
      final user = userProfileData.user;
      final mahasiswaDetails = userProfileData.mahasiswaDetails;
      String displayName = mahasiswaDetails?.nama?.isNotEmpty == true
          ? mahasiswaDetails!.nama!
          : (user.name?.isNotEmpty == true ? user.name! : 'Mahasiswa'); // Default name

      return Text(
        displayName,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    // Fallback default name
    return Text(
      'Mahasiswa',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}