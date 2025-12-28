import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../core/theme/app_pallete.dart';
import 'login_screen.dart'; 

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

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
              // Placeholder untuk Ilustrasi Email
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppPallete.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined, // Icon bawaan Flutter yang mirip
                  size: 50,
                  color: AppPallete.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Cek Email Kamu",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Kami telah mengirimkan tautan untuk mengatur ulang kata sandi ke email Anda. Mohon periksa folder spam atau junk",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppPallete.greyText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "example@gmail.com", // Bisa dibuat dinamis 
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: "Kembali ke Login",
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