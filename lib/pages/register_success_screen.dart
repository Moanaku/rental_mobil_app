import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../core/theme/app_pallete.dart';
import 'login_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder untuk Ilustrasi Awan
              Container(
                padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1), // Warna awan tipis
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_done_rounded, // Icon Awan Sukses
                  size: 80,
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Yeayy!!, Daftar Sukses",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Akun kamu telah berhasil dibuat. Silakan masuk untuk melanjutkan.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppPallete.greyText,
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: "Kembali Login",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}