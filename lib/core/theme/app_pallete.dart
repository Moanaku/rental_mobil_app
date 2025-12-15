  // lib/core/theme/app_pallete.dart
import 'package:flutter/material.dart';

class AppPallete {
  // Warna Utama (Biru cerah sesuai tombol "Cari Mobil" dan "Login")
  static const Color primary = Color(0xFF007BFF); 
  
  // Warna Background (Sesuai background abu-abu tipis di desain)
  static const Color scaffoldBackground = Color(0xFFFBFBFB);
  
  // Warna Netral
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1A1A1A); // Hitam tidak pekat (lebih elegan)
  static const Color greyText = Color(0xFF9E9E9E); // Untuk hint text / caption
  static const Color border = Color(0xFFE0E0E0); // Garis tipis pada textfield
  
  // Warna Fungsional
  static const Color redError = Color(0xFFFF3B30); // Untuk validasi
  static const Color greenSuccess = Color(0xFF34C759);
}