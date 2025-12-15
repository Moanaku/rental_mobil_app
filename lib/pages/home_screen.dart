import 'package:flutter/material.dart';
// Perbaikan Import: Cukup naik satu folder (..) untuk keluar dari 'pages'
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';

// Perbaikan Import: Langsung ke folder widgets
import '../widgets/brand_item.dart';
import '../widgets/vehicle_card.dart';

// Perbaikan Import: Langsung ke folder models
import '../models/vehicle_model.dart';

// Import halaman tujuan
import 'brand_list_screen.dart';
import 'popular_vehicles_screen.dart';
import 'brand_detail_screen.dart';
import 'detail_vehicle_screen.dart'; // [PENTING] Import halaman detail mobil

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hallo, Zulhida Zacky",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Mau jalan ke mana hari ini?",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppPallete.greyText,
                        ),
                      ),
                    ],
                  ),
                ],
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
                  hintText: "Mau Kemana?",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. TRENDING BRANDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Trending Brands",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BrandListScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Lihat Semua",
                      style: TextStyle(fontSize: 12, color: AppPallete.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // BRAND ITEMS (Navigasi ke Detail Brand)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Honda
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BrandDetailScreen(brandName: "Honda"),
                        ),
                      );
                    },
                    child: const BrandItem(
                      name: "Honda",
                      icon: Icons.commute,
                      isSelected: true,
                    ),
                  ),

                  // Mitsubishi
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BrandDetailScreen(brandName: "Mitsubishi"),
                        ),
                      );
                    },
                    child: const BrandItem(
                      name: "Mitsubishi",
                      icon: Icons.car_repair,
                    ),
                  ),

                  // Suzuki
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BrandDetailScreen(brandName: "Suzuki"),
                        ),
                      );
                    },
                    child: const BrandItem(
                      name: "Suzuki",
                      icon: Icons.electric_car,
                    ),
                  ),

                  // Toyota
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BrandDetailScreen(brandName: "Toyota"),
                        ),
                      );
                    },
                    child: const BrandItem(
                      name: "Toyota",
                      icon: Icons.directions_car,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 4. KENDARAAN POPULER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kendaraan Populer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PopularVehiclesScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Lihat Semua",
                      style: TextStyle(fontSize: 12, color: AppPallete.primary),
                    ),
                  ),
                ],
              ),

              // 5. LIST KENDARAAN (Preview di Home)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyVehicles.length,
                itemBuilder: (context, index) {
                  return VehicleCard(
                    vehicle: dummyVehicles[index],
                    // [UPDATE FINAL] Hubungkan ke halaman detail mobil
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailVehicleScreen(
                            vehicle: dummyVehicles[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
