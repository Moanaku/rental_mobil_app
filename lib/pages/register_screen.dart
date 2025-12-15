import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../core/theme/app_pallete.dart';
import 'register_success_screen.dart'; // [NEW] Import halaman sukses

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      // AppBar transparan untuk tombol back
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppPallete.black,
            size: 20,
          ),
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

              // 1. HEADER
              Text(
                "Daftar",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Lengkapi data kamu",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppPallete.greyText,
                ),
              ),

              const SizedBox(height: 32),

              // 2. FORM
              CustomTextField(
                controller: _nameController,
                hintText: 'Nama Lengkap',
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                hintText: 'Alamat Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                isObscure: _isPasswordObscure,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppPallete.greyText,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                hintText: 'No. Hp',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 32),

              // 3. BUTTON (UPDATED)
              CustomButton(
                text: "Daftar",
                onPressed: () {
                  // [UPDATED] Pindah ke halaman Sukses dan hapus history back
                  // agar user tidak bisa kembali ke form register
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterSuccessScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // 4. LOGIN LINK
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: "Sudah Memiliki Akun? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppPallete.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Masuk",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: AppPallete.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
