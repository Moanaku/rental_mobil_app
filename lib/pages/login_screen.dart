import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../core/theme/app_pallete.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              
              //FORM INPUT
              CustomTextField(
                controller: _emailController,
                hintText: 'Masukan email',
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _passwordController,
                hintText: 'Masukan kata sandi',
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
              CustomButton(
                text: "Masuk",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainWrapper()),
                    (route) => false,
                  );
                },
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
                          color: AppPallete.black,
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