import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/vehicle_card.dart';
import '../models/vehicle_model.dart';
import '../models/brand_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart'; 
import 'brand_list_screen.dart';
import 'popular_vehicles_screen.dart';
import 'brand_detail_screen.dart';
import 'detail_vehicle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController searchController = TextEditingController();

  // [DATA] Variable untuk menampung data dari API
  List<Vehicle> _vehicles = [];
  List<Brand> _brands = [];
  bool _isLoadingVehicles = true;
  bool _isLoadingBrands = true;
  
  // Variable untuk User Data
  String _userName = 'User'; 

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _fetchBrands();
    _loadUserData(); 
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Load User Data dari Local Storage
  Future<void> _loadUserData() async {
    try {
      final userData = await AuthService.getUserData();
      if (userData != null && mounted) {
        setState(() {
          _userName = userData['name'] ?? 'User';
        });
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  // Ambil data vehicles dari Laravel
  Future<void> _fetchVehicles() async {
    try {
      final data = await _apiService.getVehicles();
      if (mounted) {
        setState(() {
          _vehicles = data;
          _isLoadingVehicles = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingVehicles = false;
        });
        debugPrint("Error fetching vehicles: $e");
      }
    }
  }

  // Ambil data brands dari Laravel
  Future<void> _fetchBrands() async {
    try {
      final data = await _apiService.getBrands();
      if (mounted) {
        setState(() {
          _brands = data;
          _isLoadingBrands = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBrands = false;
        });
        debugPrint("Error fetching brands: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. HEADER - ✅ Menampilkan nama user dari login
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hallo, $_userName", // ✅ Dynamic name
                        style: const TextStyle(
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

              // ✅ BRAND ITEMS (Dari API dengan Logo)
              _isLoadingBrands
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _brands.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Belum ada brand tersedia"),
                          ),
                        )
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _brands.length > 4 ? 4 : _brands.length,
                            itemBuilder: (context, index) {
                              final brand = _brands[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BrandDetailScreen(
                                        brandName: brand.name,
                                      ),
                                    ),
                                  );
                                },
                                child: _buildBrandCard(
                                  brand.name,
                                  brand.logoUrl,
                                  index == 0,
                                ),
                              );
                            },
                          ),
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

              // 5. LIST KENDARAAN (Dari API)
              _isLoadingVehicles
                  ? const Center(child: CircularProgressIndicator())
                  : _vehicles.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Belum ada kendaraan tersedia"),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _vehicles.length,
                          itemBuilder: (context, index) {
                            return VehicleCard(
                              vehicle: _vehicles[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailVehicleScreen(
                                      vehicle: _vehicles[index],
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

  Widget _buildBrandCard(String name, String logoUrl, bool isSelected) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected 
              ? AppPallete.primary 
              : AppPallete.border.withOpacity(0.5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8),
            child: Image.network(
              logoUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.directions_car,
                  color: AppPallete.greyText.withOpacity(0.5),
                  size: 30,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppPallete.primary : AppPallete.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}