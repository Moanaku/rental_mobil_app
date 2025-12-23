import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../core/theme/app_pallete.dart';
import '../services/api_service.dart'; 
import 'login_screen.dart'; 
import 'register_success_screen.dart'; 

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
  bool _isLoading = false; 
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // 1. Validasi Input
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi!")),
      );
      return;
    }

    // Validasi email format
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Format email tidak valid!")),
      );
      return;
    }

    // Validasi password minimal 8 karakter
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 8 karakter!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 2. Panggil API
    final apiService = ApiService();
    final result = await apiService.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _phoneController.text.trim(),
      "-",
    );

    setState(() {
      _isLoading = false;
    });

    // 3. Handle Result
    if (!mounted) return;

    if (result['success'] == true) {
      // Registrasi Berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterSuccessScreen()),
      );
    } else {
      // Registrasi Gagal
      // Parse error message untuk tampilan lebih user-friendly
      String errorMessage = result['message'] ?? 'Registrasi gagal';
      
      // Jika ada detail error dari Laravel validation
      if (result['errors'] != null) {
        final errors = result['errors'] as Map<String, dynamic>;
        
        // Ambil error pertama yang muncul
        if (errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError[0].toString();
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
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
                prefixIcon: const Icon(Icons.person_outline, color: AppPallete.greyText),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                hintText: 'Alamat Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, color: AppPallete.greyText),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                hintText: 'Password (min. 8 karakter)',
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
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                hintText: 'No. Hp',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined, color: AppPallete.greyText),
              ),

              const SizedBox(height: 32),

              // 3. BUTTON
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: "Daftar",
                    onPressed: _register,
                  ),

              const SizedBox(height: 24),

              // 4. LOGIN LINK
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
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
                            color: AppPallete.primary,
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