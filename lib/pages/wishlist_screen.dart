import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/vehicle_card.dart';
import '../services/wishlist_service.dart'; // [IMPORT] Service
import 'detail_vehicle_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Instance Service
  final WishlistService _wishlistService = WishlistService();
  
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil list terbaru
    final favoriteVehicles = _wishlistService.wishlist;

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // HEADER
              const Text(
                "Favorite",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 24),

              // SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: CustomTextField(
                  controller: searchController,
                  hintText: "Cari Favorite?",
                  prefixIcon: const Icon(Icons.search, color: AppPallete.greyText),
                ),
              ),
              const SizedBox(height: 24),

              // LIST KENDARAAN FAVORITE
              Expanded(
                child: favoriteVehicles.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text("Belum ada favorite", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: favoriteVehicles.length,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (context, index) {
                          final vehicle = favoriteVehicles[index];
                          return VehicleCard(
                            vehicle: vehicle,
                            onTap: () async {
                              // Navigasi ke Detail
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailVehicleScreen(vehicle: vehicle),
                                ),
                              );
                              // Refresh halaman saat kembali (jika ada yg dihapus)
                              setState(() {});
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