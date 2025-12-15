import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/vehicle_card.dart';
import '../models/vehicle_model.dart';
import '../widgets/custom_textfield.dart';
import 'detail_vehicle_screen.dart'; // [PENTING] Import halaman detail

class PopularVehiclesScreen extends StatefulWidget {
  const PopularVehiclesScreen({super.key});

  @override
  State<PopularVehiclesScreen> createState() => _PopularVehiclesScreenState();
}

class _PopularVehiclesScreenState extends State<PopularVehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Logika Filter: Hanya berdasarkan Search Bar
  List<VehicleModel> get _currentVehicles {
    // Kita duplikasi data agar list terlihat panjang untuk demo
    List<VehicleModel> allData = [...dummyVehicles, ...dummyVehicles];

    String query = _searchController.text.toLowerCase();

    // Jika search bar kosong, tampilkan semua
    if (query.isEmpty) return allData;

    // Filter berdasarkan nama kendaraan
    return allData.where((v) {
      return v.name.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Kendaraan Populer",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppPallete.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppPallete.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. SEARCH BAR (Fokus Utama)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
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
                  controller: _searchController,
                  hintText: "Cari Kendaraan?", // Sesuai desain Figma
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. LIST KENDARAAN
            Expanded(
              // AnimatedBuilder akan me-rebuild list setiap kali user mengetik
              child: AnimatedBuilder(
                animation: _searchController,
                builder: (context, child) {
                  final data = _currentVehicles;

                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: AppPallete.greyText,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Kendaraan tidak ditemukan",
                            style: TextStyle(color: AppPallete.greyText),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return VehicleCard(
                        vehicle: data[index],
                        // [PERBAIKAN] Navigasi ke DetailVehicleScreen
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailVehicleScreen(vehicle: data[index]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
