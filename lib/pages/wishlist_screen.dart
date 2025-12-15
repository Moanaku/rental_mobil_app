// lib/pages/wishlist_screen.dart
import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/vehicle_card.dart';
import '../models/vehicle_model.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    // Data simulasi (Hanya mengambil 2 item pertama sebagai contoh favorite)
    final List<VehicleModel> favoriteVehicles = [
      dummyVehicles[0], // Pajero
      dummyVehicles[1], // CBR
    ];

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. HEADER
              const Text(
                "Favorite",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),

              const SizedBox(height: 24),

              // 2. SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomTextField(
                  controller: searchController,
                  hintText: "Car Favorite?", // Sesuai desain
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. LIST KENDARAAN (Expanded agar bisa scroll)
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteVehicles.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    return VehicleCard(
                      vehicle: favoriteVehicles[index],
                      isLiked: true, // [PENTING] Agar hati berwarna merah
                      onTap: () {
                        // Aksi jika card diklik
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
