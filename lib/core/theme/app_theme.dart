// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_pallete.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppPallete.primary,
      scaffoldBackgroundColor: AppPallete.scaffoldBackground,
      
      // Mengatur font default aplikasi jadi Poppins
      fontFamily: GoogleFonts.poppins().fontFamily,
      
      // Konfigurasi standar AppBar (Bersih, putih, ikon hitam)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPallete.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppPallete.black),
        titleTextStyle: TextStyle(
          color: AppPallete.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Kita set default style button agar tidak perlu set ulang terus menerus
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.primary,
          foregroundColor: AppPallete.white, // Warna teks
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}