import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_button.dart';
import 'main_wrapper.dart'; // Untuk kembali ke Home

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Ilustrasi Sukses (Lingkaran Biru dengan Centang/Struk)
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded, // Icon Struk
                  size: 80,
                  color: AppPallete.primary,
                ),
              ),
              
              const SizedBox(height: 40),
              
              const Text(
                "Yeay, Sewa Kendaraan Berhasil",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                "Kamu telah berhasil menyewa kendaraan,\nSilahkan menikmati kendaraan mu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppPallete.greyText,
                  height: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Tombol Kembali ke Beranda
              CustomButton(
                text: "Kembali Beranda",
                onPressed: () {
                  // Hapus semua history navigasi dan kembali ke MainWrapper
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainWrapper()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}