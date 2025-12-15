import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../core/theme/app_pallete.dart';
import 'check_email_screen.dart'; // Kita akan buat file ini di langkah 2

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppPallete.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Lupa kata sandi ?",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Jangan khawatir, ini terjadi pada kita semua. Masukkan email kamu di bawah untuk memulihkan kata sandi kamu.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppPallete.greyText,
                  height: 1.5, // Line height agar lebih mudah dibaca
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                hintText: 'Masukan email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: "Kirim",
                onPressed: () {
                  // Navigasi ke halaman Cek Email
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckEmailScreen(),
                    ),
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