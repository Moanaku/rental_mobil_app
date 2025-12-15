import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppPallete.primary, // Default Biru
    this.textColor = AppPallete.white,       // Default Putih
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Agar tombol melebar penuh
      height: 52, // Tinggi standar tombol ergonomis
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Radius konsisten dengan TextField
          ),
          elevation: 0, // Flat design modern
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}