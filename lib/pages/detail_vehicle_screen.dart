import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../models/vehicle_model.dart';
import '../widgets/custom_button.dart';
import 'payment_screen.dart';

class DetailVehicleScreen extends StatelessWidget {
  final VehicleModel vehicle;

  const DetailVehicleScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: Stack(
        children: [
          // 1. GAMBAR BACKGROUND (ANTI CRASH)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Container(
              color: Colors.grey[200], // Background sementara
              child: Image.network(
                vehicle.imageAsset,
                fit: BoxFit.cover,
                // [SOLUSI] Error Handler
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_rounded,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Gambar Dummy Error",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. TOMBOL BACK & FAVORITE
          Positioned(
            top: 50,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(
                  Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircleIcon(Icons.favorite_border, onTap: () {}),
              ],
            ),
          ),

          // 3. KONTEN DETAIL
          Positioned.fill(
            top: 280,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        vehicle.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Spesifikasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSpecCard(Icons.settings, "Mesin", vehicle.cc),
                        _buildSpecCard(
                          Icons.settings_input_component,
                          "Transmisi",
                          vehicle.transmission,
                        ),
                        _buildSpecCard(
                          Icons.local_gas_station,
                          "Bahan Bakar",
                          "Bensin",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Deskripsi
                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Nikmati perjalanan nyaman dengan ${vehicle.name}. (Data Dummy Slicing).",
                      style: const TextStyle(
                        color: AppPallete.greyText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          // 4. BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(
                          color: AppPallete.greyText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${vehicle.price}/Hari",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: CustomButton(
                      text: "Sewa Sekarang",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentScreen(vehicle: vehicle),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppPallete.black),
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF007CC7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
