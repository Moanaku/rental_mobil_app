import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/vehicle_card.dart';
import '../models/vehicle_model.dart'; 
import '../widgets/custom_textfield.dart';
import 'detail_vehicle_screen.dart';
import '../services/api_service.dart'; 

class PopularVehiclesScreen extends StatefulWidget {
  const PopularVehiclesScreen({super.key});

  @override
  State<PopularVehiclesScreen> createState() => _PopularVehiclesScreenState();
}

class _PopularVehiclesScreenState extends State<PopularVehiclesScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  // [DATA] Variable untuk menampung data API
  List<Vehicle> _allVehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    // Rebuild UI setiap kali user mengetik search
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Ambil data dari Server
  Future<void> _fetchVehicles() async {
    try {
      final vehicles = await _apiService.getVehicles();
      if (mounted) {
        setState(() {
          _allVehicles = vehicles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint("Error fetching popular vehicles: $e");
      }
    }
  }

  // [LOGIKA FILTER]
  List<Vehicle> get _filteredVehicles {
    String query = _searchController.text.toLowerCase();
    
    // Jika search kosong, tampilkan semua data dari API
    if (query.isEmpty) return _allVehicles;

    // Filter berdasarkan nama
    return _allVehicles.where((v) {
      return v.name.toLowerCase().contains(query);
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
                  hintText: "Cari Kendaraan...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. LIST KENDARAAN (Dari API)
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