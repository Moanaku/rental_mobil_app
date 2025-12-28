import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../core/theme/app_pallete.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart'; 
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'main_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. Validasi Input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiService = ApiService();
    
    // 2. Panggil API Login (Sekarang return Map)
    final result = await apiService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    // 3. Cek Hasil
    if (result['success'] == true) {
      // Simpan token dan user data
      await AuthService.saveToken(result['token'] ?? '');
      await AuthService.saveUserData(result['data']);

      // Navigate ke Main Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login Berhasil'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      //  Login Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login Gagal'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              
              const SizedBox(height: 40),
              
              Text(
                "Masuk ke akun kamu menggunakan email yang terdaftar",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppPallete.greyText,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // FORM INPUT
              CustomTextField(
                controller: _emailController,
                hintText: 'Masukan email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, color: AppPallete.greyText),
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _passwordController,
                hintText: 'Masukan kata sandi',
                isObscure: _isPasswordObscure,
                prefixIcon: const Icon(Icons.lock_outline, color: AppPallete.greyText),
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
              
              const SizedBox(height: 12),
              
              // LUPA PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Lupa Kata Sandi?",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppPallete.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // BUTTON LOGIN
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: "Masuk",
                    onPressed: _login,
                  ),
              
              const SizedBox(height: 24),
              
              // REGISTER LINK
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Belum Memiliki Akun? ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppPallete.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Daftar disini",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppPallete.primary,
                        ),
                      ),
                    ],
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