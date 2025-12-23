import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/vehicle_card.dart';
import '../models/vehicle_model.dart'; 
import '../widgets/custom_textfield.dart';
import 'detail_vehicle_screen.dart';
import '../services/api_service.dart'; 

class BrandDetailScreen extends StatefulWidget {
  final String brandName;

  const BrandDetailScreen({super.key, required this.brandName});

  @override
  State<BrandDetailScreen> createState() => _BrandDetailScreenState();
}

class _BrandDetailScreenState extends State<BrandDetailScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  // 0: Semua, 1: Mobil, 2: Motor
  int _selectedCategory = 0;
  final List<String> _filters = ["Semua", "Mobil", "Motor"];

  // List untuk menampung data dari API (Menggunakan class Vehicle baru)
  List<Vehicle> _allVehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _searchController.addListener(() {
      setState(() {}); // Rebuild saat mengetik
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi mengambil data dari API Laravel
  Future<void> _fetchVehicles() async {
    try {
      final vehicles = await _apiService.getVehicles();
      
      if (mounted) {
        setState(() {
          // Filter awal: Hanya ambil kendaraan yang sesuai Brand halaman ini
          _allVehicles = vehicles.where((v) => 
            v.brandName.toLowerCase() == widget.brandName.toLowerCase()
          ).toList();
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  // Logika Filter Ganda (Brand + Kategori + Search)
  List<Vehicle> get _filteredVehicles {
    String query = _searchController.text.toLowerCase();

    // Kita filter dari _allVehicles (data API), bukan dummyVehicles
    return _allVehicles.where((v) {
      
      // 1. Filter Search Bar (Pencarian Nama Kendaraan)
      bool matchesQuery = v.name.toLowerCase().contains(query);

      // 2. Filter Kategori (Mobil/Motor)
      // PERBAIKAN: Menggunakan properti 'category' sesuai Model baru
      bool matchesCategory = true;
      if (_selectedCategory == 1) {
        matchesCategory = v.category == "Mobil"; 
      } else if (_selectedCategory == 2) {
        matchesCategory = v.category == "Motor"; 
      }

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.brandName, // Judul sesuai Brand yang dipilih
          style: const TextStyle(
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

            // 1. SEARCH BAR
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
                  hintText: "Cari di ${widget.brandName}...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. FILTER CHIPS (Semua, Mobil, Motor)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isActive = _selectedCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppPallete.primary
                              : AppPallete.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isActive
                                ? AppPallete.primary
                                : AppPallete.border,
                          ),
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isActive ? Colors.white : AppPallete.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // 3. LIST KENDARAAN (Dari API)
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : AnimatedBuilder(
                    animation: _searchController,
                    builder: (context, child) {
                      final data = _filteredVehicles;

                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.no_crash_outlined,
                                size: 60,
                                color: AppPallete.greyText,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Tidak ada unit ${widget.brandName} \n${_filters[_selectedCategory]}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppPallete.greyText),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          // Pastikan VehicleCard sudah mendukung model 'Vehicle' baru
                          return VehicleCard(
                            vehicle: data[index],
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